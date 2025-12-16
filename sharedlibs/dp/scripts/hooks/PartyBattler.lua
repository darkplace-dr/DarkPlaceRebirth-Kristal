---@class PartyBattler : PartyBattler
local PartyBattler, super = HookSystem.hookScript(PartyBattler)

function PartyBattler:init(chara,x,y)
    super.init(self,chara,x,y)

    self.shield = 0
    
    self.guard_chance = 0 -- out of 100
    for _,equipment in ipairs(self.chara:getEquipment()) do
        self.guard_chance = self.guard_chance + (equipment.bonuses.guard_chance or 0)
    end
    self.guard_mult = self.chara.guard_mult or 0.8
    
    self.super_flash = 0

end

function PartyBattler:removeHealthBroken(amount, swoon)
    if Game.battle.superpower then return end
    return super.removeHealthBroken(self, amount, swoon)
end

function PartyBattler:hurt(amount, exact, color, options)
    options = options or {}

    local swoon = options["swoon"]

    if self.chara.reflectNext then
        -- ok, remove the reflect thingy
        self.chara.reflectNext = false
        -- calculate the amount
        amount = self:calculateDamage(amount)
        -- pick a random one
        -- I would do the attacker but like god am I lazy and I hate the process for this mechanic so much for some reason
        -- like a disproportionate amount
        -- so im picking a random one instead of any other bullshit
        local attackedEnemy = TableUtils.pick(Game.battle.enemies)
        -- if the damage is over the character's max HP, set it to that
        if amount > self.chara:getHealth() then
            amount = self.chara:getHealth()
        end
        -- also, the damage can never kill the enemy outright (for da pacifists)
        --   ...and also kinda so cheese isn't as possible
        if amount >= attackedEnemy.health then
            amount = attackedEnemy.health-1
        end
        -- hurt em'
        attackedEnemy:hurt(amount, self)
        return
    end

    if MathUtils.random(1,101) < self.guard_chance then
        self:statusMessage("msg", "guard")
        amount = math.ceil(amount * self.guard_mult)
    end

    if not options["all"] then
        Assets.playSound("hurt")
        if not exact then
            amount = self:calculateDamage(amount)
            if self.defending then
                amount = math.ceil((2 * amount) / 3)
            end
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))
        end

        if self.chara.id == "noel" then
            self:noel_damage(amount, swoon)
        elseif self.chara.equipped["weapon"] and self.chara.equipped["weapon"].last_stand then
            if (self.chara:getHealth() - amount) <= 0 and not self.last_stood then
                local neardeath = self.chara:getHealth() - 1
                self:removeHealth(neardeath)
                self.last_stood = true
            else
                self:removeHealth(amount, swoon)
            end
        else
            self:removeHealth(amount, swoon)
        end
    else
        -- We're targeting everyone.
        if not exact then
            amount = self:calculateDamage(amount)
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))

            if self.defending then
                amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
            end
        end

        if self.chara.id == "noel" then
            self:noel_damage(amount, swoon) -- Use a seprate function for a secret character that nobody will ever find on a regular playthrough.
        else
            self:removeHealthBroken(amount, swoon) -- Use a separate function for cleanliness
        end
    end

    if (self.chara:getHealth() <= 0) then
        self:statusMessage("msg", swoon and "swoon" or "down", color, true)
    else
        if self.chara.id == "noel" then
        -- Logic is done in noel's damage function         
        else
            self:statusMessage("damage", amount, color, true)
        end
    end

    self.hurt_timer = 0
    Game.battle:shakeCamera(4)

    self:doOverlay()
end

function PartyBattler:heal(amount, sparkle_color, show_up)
    if self.chara:getStat("health") <= 0 then
        self:statusMessage("msg", "miss")
        return
    end
    return super.heal(self, amount, sparkle_color, show_up)
end

function PartyBattler:update()
    if self.jumping then
        self:processJump()
    end

    super.update(self)
    if Game.battle.superpower then
        if (self.super_flash - (DT * 30))%30 > self.super_flash%30 then
            self:sparkle(unpack({1, 1, 1}))
        end
        
        self.super_flash = self.super_flash + DT * 30
    end
end

function PartyBattler:getHeadIcon()
    if self.is_down then
        return "head_down"
    elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
        return "head_low"
    end
    return super.getHeadIcon(self)
end


function PartyBattler:doOverlay()
    if (not self.defending) and (not self.is_down) then
        self.sleeping = false
        self.hurting = true
        self:toggleOverlay(true)
        self.overlay_sprite:setAnimation("battle/hurt", function()
            if self.hurting then
                self.hurting = false
                self:toggleOverlay(false)
            end
            
            if (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) and self.chara.actor:getAnimation("battle/low_health") then
                self:setAnimation("battle/low_health")
            end
        end)
        if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
            Game.battle.timer:after(0.5, function()
                if self.hurting then
                    self.hurting = false
                    self:toggleOverlay(false)
                end
            end)
        end
    end
end

function PartyBattler:removeHealth(amount, swoon, pierce)
    if Game.battle.superpower then return end
    if not pierce then
        if self.shield < amount then
            amount = amount - self.shield
            self.shield = 0
        else
            self.shield = self.shield - amount
            amount = 0
        end
    end
    if (self.chara:getHealth() <= 0) then
        amount = MathUtils.round(amount / 4)
        self.chara:setHealth(self.chara:getHealth() - amount)
    else
        self.chara:setHealth(self.chara:getHealth() - amount)
        if (self.chara:getHealth() <= 0) then
            if swoon then
                self.chara:setHealth(-999)
            else
                amount = math.abs((self.chara:getHealth() - (self.chara:getStat("health") / 2)))
                self.chara:setHealth(MathUtils.round(((-self.chara:getStat("health")) / 2)))
            end
        end
    end
    self:checkHealth(swoon)
end

function PartyBattler:addShield(amount)
    Assets.stopAndPlaySound("metal")

    amount = math.floor(amount)

    self.shield = self.shield + amount

    local was_down = self.is_down
    self:checkHealth()

    self:flash()

    if self.shield >= self.chara:getMaxShield() then
        self.shield = self.chara:getMaxShield()
    else
        self:statusMessage("heal", amount, {128/255, 128/255, 128/255})
    end
end

function PartyBattler:breakShield()
    Assets.stopAndPlaySound("hurt")

    self.shield = 0
    
    self:setAnimation("battle/hurt")
    
    self:statusMessage("msg", "break")
end

function PartyBattler:setAnimation(animation, callback)
    if self.chara and (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) and animation == "battle/idle" and self.chara.actor:getAnimation("battle/low_health") then
        return self:setAnimation("battle/low_health", callback)
    end
    return self.sprite:setAnimation(animation, callback)
end

function PartyBattler:pierce(amount, exact, color, options)
    if not Game.battle.superpower then
        if MathUtils.random(1,101) < self.guard_chance then
            self:statusMessage("msg", "guard")
            amount = math.ceil(amount * self.guard_mult)
        end
        options = options or {}

        if not options["all"] then
            Assets.playSound("hurt")
            if not exact then
                amount = self:calculateDamage(amount)
                if self.defending then
                    amount = math.ceil((2 * amount) / 3)
                end
                -- we don't have elements right now
                local element = 0
                amount = math.ceil((amount * self:getElementReduction(element)))
            end

            self:removeHealth(amount, true)
        else
            -- We're targeting everyone.
            if not exact then
                amount = self:calculateDamage(amount)
                -- we don't have elements right now
                local element = 0
                amount = math.ceil((amount * self:getElementReduction(element)))

                if self.defending then
                    amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
                end

                self:removeHealth(amount, true) -- Use a separate function for cleanliness
            end
        end

        if (self.chara:getHealth() <= 0) then
            self:statusMessage("msg", "down", color, true)
        else
            self:statusMessage("damage", amount, color, true)
        end

        self.sprite.x = -10
        self.hurt_timer = 4
        Game.battle:shakeCamera(4)

        self:doOverlay()
    end
end

function PartyBattler:noel_damage(amount, swoon) -- DO NOT QUESTION MY CHOICES
    local meth = MathUtils.random(1, 4) --random number for hit chance
    if meth == 1 then -- haha, funny noel/null damage joke thingy
        Assets.playSound("awkward")
        Assets.playSound("voice/noel-#")
        self:removeHealth(0)
        self:statusMessage("msg", "null", {0.9,0.9,0.9}, true)
    else -- haha, 10 times the pain and funny noise
        Assets.playSound("voice/noel-#")
        self:removeHealth(amount * 10, swoon)
        if self.chara:getHealth() > 0 then -- check so that it wouldn't appear with Down/Swoon
            self:statusMessage("damage", amount * 10, nil, true)
        end
    end
    if self.noel_hit_counter and self.noel_hit_counter > 5 and self.chara.health >= 1 then -- for if noel decides you fucking suck at dodging
        self:setAnimation("stop")
        Assets.playSound("voice/stop_getting_hit")
        Assets.playSound("grab")
        Assets.playSound("alert")
        Assets.playSound("impact")
        Assets.playSound("jump")
        Assets.playSound("locker")
        Assets.playSound("petrify")
        Assets.playSound("ominous")
        Assets.playSound("rudebuster_hit")
        Assets.playSound("rudebuster_swing")
        love.window.setTitle("STOP GETTING HIT")
        self.noel_hit_counter = -1
    elseif self.noel_hit_counter then
        self.noel_hit_counter = self.noel_hit_counter + 1
    else
        self.noel_hit_counter = 1
    end
end

function PartyBattler:onDefeatFatal(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("deathnoise")

    local sprite = self:getActiveSprite()

    sprite.visible = false
    sprite:stopShake()

    local death_x, death_y = sprite:getRelativePos(0, 0, self)
    local death = FatalEffect(sprite:getTexture(), death_x, death_y, function() self:remove() end)
    death:setColor(sprite:getDrawColor())
    death:setScale(sprite:getScale())
    self:addChild(death)

    local num = 0
    for _,party in ipairs(Game.battle.party) do
        num = num + 1
        if self == Game.battle.party[num] then
            Game.battle.party[num] = nil
            Game.battle.battle_ui.action_boxes[num]:remove()
            Game.party[num] = nil
        end
    end
end

function PartyBattler:jumpTo(x, y, speed, time, jump_sprite, land_sprite)
    if type(x) == "string" then
        land_sprite = jump_sprite
        jump_sprite = time
        time = speed
        speed = y
        x, y = self.world.map:getMarker(x)
    end
    self.jump_start_x = self.x
    self.jump_start_y = self.y
    self.jump_x = x
    self.jump_y = y
    self.jump_speed = speed or 0
    self.jump_time = time or 1
    self.jump_sprite = jump_sprite
    self.land_sprite = land_sprite
    self.fake_gravity = 0
    self.jump_arc_y = 0
    self.jump_timer = 0
    self.real_y = 0
    self.drawshadow = false
    --dark = (global.darkzone + 1)
    self.jump_use_sprites = false
    self.jump_sprite_timer = 0
    self.jump_progress = 0
    self.init = false

    if (jump_sprite ~= nil) then
        self.jump_use_sprites = true
    end
    self.drawshadow = false

    self.jumping = true
end

function PartyBattler:processJump()
    if (not self.init) then
        self.fake_gravity = (self.jump_speed / ((self.jump_time*30) * 0.5))
        self.init = true

        self.false_end_x = self.jump_x
        self.false_end_y = self.jump_y
        if (self.jump_use_sprites) then
            self.sprite:set(self.land_sprite)
            self.jump_progress = 1
        else
            self.jump_progress = 2
        end
    end
    if (self.jump_progress == 1) then
        self.jump_sprite_timer = self.jump_sprite_timer + DT
        if (self.jump_sprite_timer >= 5/30) then
            self.sprite:set(self.jump_sprite)
            self.jump_progress = 2
        end
    end
    if (self.jump_progress == 2) then
        self.jump_timer = self.jump_timer + DT
        self.jump_speed = self.jump_speed - (self.fake_gravity * DTMULT)
        self.jump_arc_y = self.jump_arc_y - (self.jump_speed * DTMULT)
        self.x = MathUtils.lerp(self.jump_start_x, self.false_end_x, (self.jump_timer / self.jump_time))
        self.real_y = MathUtils.lerp(self.jump_start_y, self.false_end_y, (self.jump_timer / self.jump_time))

        self.x = self.x
        self.y = self.real_y + self.jump_arc_y

        if (self.jump_timer >= self.jump_time) then
            self.x = self.jump_x
            self.y = self.jump_y

            self.jump_progress = 3
            self.jump_sprite_timer = 0
        end
    end
    if (self.jump_progress == 3) then
        if (self.jump_use_sprites) then
            self.sprite:set(self.land_sprite)
            self.jump_sprite_timer = self.jump_sprite_timer + DT
        else
            self.jump_sprite_timer = 10/30
        end
        if (self.jump_sprite_timer >= 5/30) then
            self.sprite:setAnimation("battle/idle")
            self.jumping = false
        end
    end
end

return PartyBattler