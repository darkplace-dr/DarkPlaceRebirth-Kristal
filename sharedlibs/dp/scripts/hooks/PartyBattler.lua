---@class PartyBattler : PartyBattler
local PartyBattler, super = Utils.hookScript(PartyBattler)

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

function PartyBattler:removeHealthBroken(amount)
    if Game.battle.superpower then return end
    return super.removeHealthBroken(self, amount)
end

--- Removes max health from the character
--- TODO: Make this just use a negative statbuff
---@param amount number
function PartyBattler:removeMaxHealth(amount, pierce)
	if Game.battle.superpower then return end
    if (self.chara:getStat("health") <= 0) then
        self.chara:setMaxHealthDamage(self.chara:getStat("health_def"))
        self.chara:setHealth(-999)
    else
        if not pierce then
            if self.shield < amount then
                amount = amount - self.shield
                self.shield = 0
            else
                self.shield = self.shield - amount
                amount = 0
            end
        end
        self.chara:dealMaxHealthDamage(amount)
        if (self.chara:getStat("health") <= 0) then
            self.chara:setMaxHealthDamage(self.chara:getStat("health_def"))
            self.chara:setHealth(-999)
        end
    end
    self:checkHealth()
end

function PartyBattler:hurt(amount, exact, color, options)
    options = options or {}

    if self.chara.reflectNext then
        -- ok, remove the reflect thingy
        self.chara.reflectNext = false
        -- calculate the amount
        amount = self:calculateDamage(amount)
        -- pick a random one
        -- I would do the attacker but like god am I lazy and I hate the process for this mechanic so much for some reason
        -- like a disproportionate amount
        -- so im picking a random one instead of any other bullshit
        local attackedEnemy = Utils.pick(Game.battle.enemies)
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

    if love.math.random(1,100) < self.guard_chance then
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
            self:noel_damage(amount)
        elseif self.chara.equipped["weapon"].last_stand then
            if (self.chara:getHealth() - amount) <= 0 and not self.last_stood then
                local neardeath = self.chara:getHealth() - 1
                self:removeHealth(neardeath)
                self.last_stood = true
            else
                self:removeHealth(amount)
            end
        else
            self:removeHealth(amount)
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
            self:noel_damage(amount) -- Use a seprate function for a secret character that nobody will ever find on a regular playthrough.
        else
            self:removeHealthBroken(amount) -- Use a separate function for cleanliness
        end
    end

    if (self.chara:getHealth() <= 0) then
        self:statusMessage("msg", "down", color, true)
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

function PartyBattler:mhp_hurt(amount, exact, color, options)
    options = options or {}

    if love.math.random(1,100) < self.guard_chance then
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
            self:noel_damage(amount) -- lore reasons
        else
            self:removeMaxHealth(amount)
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
            self:noel_damage(amount)
        else
            self:removeMaxHealth(amount) -- Use a separate function for cleanliness
        end
    end

    if (self.chara:getHealth() <= 0) then
        self:statusMessage("msg", "fallen", color, true)
    else
        if self.chara.id == "noel" then
        -- Logic is done in noel's damage function         
        else
            self:statusMessage("deadly", amount, color, true)
        end
    end

    self.hurt_timer = 0
    Game.battle:shakeCamera(4)

    self:doOverlay()
end

function PartyBattler:removeHealth(amount, pierce)
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
        amount = Utils.round(amount / 4)
        self.chara:setHealth(self.chara:getHealth() - amount)
    else
        self.chara:setHealth(self.chara:getHealth() - amount)
        if (self.chara:getHealth() <= 0) then
            amount = math.abs((self.chara:getHealth() - (self.chara:getStat("health") / 2)))
            self.chara:setHealth(Utils.round(((-self.chara:getStat("health")) / 2)))
        end
    end
    self:checkHealth()
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
    if self.chara and ((self.chara:getHealth() <= (self.chara:getStat("health") / 4)) or (self.chara:getStat("health") <= (self.chara:getStat("health_def") / 4))) and animation == "battle/idle" and self.chara.actor:getAnimation("battle/low_health") then
        return self:setAnimation("battle/low_health", callback)
    end
    return self.sprite:setAnimation(animation, callback)
end

function PartyBattler:pierce(amount, exact, color, options)
    if not Game.battle.superpower then
        if love.math.random(1,100) < self.guard_chance then
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

function PartyBattler:mhp_pierce(amount, exact, color, options)
    if not Game.battle.superpower then
        if love.math.random(1,100) < self.guard_chance then
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

            self:removeMaxHealth(amount, true)
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

                self:removeMaxHealth(amount, true) -- Use a separate function for cleanliness
            end
        end

        if (self.chara:getStat("health") <= 0) then
            self:statusMessage("msg", "fallen", color, true)
        else
            self:statusMessage("deadly", amount, color, true)
        end

        self.sprite.x = -10
        self.hurt_timer = 4
        Game.battle:shakeCamera(4)

        self:doOverlay()
    end
end

function PartyBattler:noel_damage(amount) -- DO NOT QUESTION MY CHOICES
    local meth = love.math.random(1, 3) --random number for hit chance
    if meth == 1 then -- haha, funny noel/null damage joke thingy
        Assets.playSound("awkward")
        Assets.playSound("voice/noel-#")
        self:removeHealth(0)
        self:statusMessage("msg", "null", {0.9,0.9,0.9}, true)
    else-- haha, 10 times the pain and funny noise
        Assets.playSound("voice/noel-#")
        self:removeHealth(amount * 10)
        self:statusMessage("damage", amount * 10, color, true)
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

function PartyBattler:restoreMaxHealth(health)
    Assets.stopAndPlaySound("power")

    self.chara:restoreMaxHealth(health)
    self:checkHealth()
    self:flash()

    self:statusMessage("msg", "revive")

    self:sparkle(unpack(sparkle_color or {}))
end

return PartyBattler