local LightSoul, super = Class(Object)

function LightSoul:init(x, y, color)
    super.init(self, x, y)

    if color then
        self:setColor(color)
    else
        self:setColor(1, 0, 0)
    end

    self.layer = LIGHT_BATTLE_LAYERS["soul"]

    self.sprite = Sprite("player/heart_light")
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.inherit_color = true
    self:addChild(self.sprite)

    self.debug_rect = {-8, -8, 16, 16}

    self.width = self.sprite.width
    self.height = self.sprite.height

    self.collider = CircleCollider(self, 0, 0, 8)

    self.graze_tp_factor   = 1
    self.graze_time_factor = 1
    self.graze_size_factor = 1
    for _,party in ipairs(Game.party) do
        self.graze_tp_factor   = math.min(3, self.graze_tp_factor   + party:getStat("graze_tp"))
        self.graze_time_factor = math.min(3, self.graze_time_factor + party:getStat("graze_time"))
        self.graze_size_factor = math.min(3, self.graze_size_factor + party:getStat("graze_size"))
    end

    self.graze_sprite = GrazeSprite()
    self.graze_sprite:setOrigin(0.5, 0.5)
    self.graze_sprite.inherit_color = true
    self.graze_sprite.graze_scale = self.graze_size_factor
    self:addChild(self.graze_sprite)

    self.graze_collider = CircleCollider(self, 0, 0, 25 * self.graze_size_factor)

	self.sprite_focus = Sprite("player/heart_dodge_focus")
    self.sprite_focus:setOrigin(0.5, 0.5)
    self.sprite_focus.inherit_color = false
	self.sprite_focus.alpha = 0
    self.sprite_focus.debug_select = false
    self:addChild(self.sprite_focus)

    self.original_x = x
    self.original_y = y
    self.target_x = x
    self.target_y = y
    self.timer = 0
    self.transitioning = false
    self.speed = 4 + Game.battle.soul_speed_bonus

    self.inv_timer = 0
    self.inv_flash_timer = 0

    -- 1px movement increments
    self.partial_x = (self.x % 1)
    self.partial_y = (self.y % 1)

    self.last_collided_x = false
    self.last_collided_y = false

    self.x = math.floor(self.x)
    self.y = math.floor(self.y)

    self.moving_x = 0
    self.moving_y = 0

    self.noclip = false
    self.slope_correction = true

    self.transition_destroy = false

    self.shard_x_table = {-2, 0, 2, 8, 10, 12}
    self.shard_y_table = {0, 3, 6}

    self.can_move = true
    self.allow_focus = true
	
	-- Taunt/parry variables start here
	self.force_taunt = nil -- Forces taunting in battle on or off, regardless of if the PizzaToque is equipped.

	self.parry_timer = 0
    self.cooldown_timer = 0
    self.parry_inv = 0
    self.taunt_timer = 0
	
    -- hi -sam
    self.parry_lock_movement = 0

    if Game:isSpecialMode "PEPPINO" then
        self.parry_sfx = Assets.getSound("sugarcoat")
    else
        self.parry_sfx = Assets.getSound("taunt")
    end
    self.parried_sfx = Assets.getSound("parry")
    self.parried_loop_sfx = nil

    -- Making sure it only parries once per Z press.
    self.did_parry = false

    self.taunt_length = 10

    -- Customizable stuff. Timing is in frames at 30 FPS.
    self.can_parry = true       -- Determines if you can parry at all.
    self.parry_window = 5       -- How large of a window you have to parry a bullet.
    self.parry_length = 30      -- Invincibility length after a successful parry.
    self.parry_cap = 60         -- Maximum duration for parry invincibility, in the event that multiple bullets are parried in quick succession.
    self.cooldown = 30          -- Recovery time between one parry and the next, assuming the first one failed.
    self.special_only = false   -- If set to true, only bullets with the variable "self.special_parry" set to true can be parried.

	-- Taunt variables end here

	-- Timeslow ("Focus" Placebo) variables start here; outline is created above.	
	self.force_timeslow = nil -- Forces the Focus ability on or off, regardless of if the placebo is equipped.
	
	--self.outline = Sprite("player/heart_slow")
    --self.outline:setOrigin(0.5, 0.5)
    --self.outline.alpha = 0
    --self:addChild(self.outline)

    self.timeslow_sfx = Assets.getSound("concentrating")
    self.timeslow_sfx:setLooping(true)

    self.afterimage_delay = 5
    self.drain_rate = 3        -- Number of frames to wait before losing TP
    self.drain_timer = 0


    self.focus_holder = nil
    for _,party in ipairs(Game.battle.party) do
        if self.force_timeslow then self.focus_holder = Game.battle.party[1]     
        elseif Game.party[_]:checkArmor("focus") then self.focus_holder = party
        end
    end
    self.outlinefx = BattleOutlineFX()
    self.outlinefx:setAlpha(0)

    if self.focus_holder then
        if self.focus_holder:getFX("outlinefx") then
            self.focus_holder:removeFX("outlinefx")
        end
    end
    if Game.stage:getFX("timeslowvhs") then
        Game.stage:removeFX("timeslowvhs")
    end

    -- Apply outlinefx to whoever has Focus equipped, or the leader if force_timeslow is true
    if self.focus_holder then self.focus_holder:addFX(self.outlinefx, "outlinefx") end
    self.vhsfx = Game.stage:addFX(VHSFilterFX(), "timeslowvhs")
    self.vhsfx.timescale = 2 -- I dunno if this even works.
    self.vhsfx.active = false
    self.concentratebg = ConcentrateBG({1, 1, 1})
    self.concentratebg.alpha_fx = self.concentratebg:addFX(AlphaFX())
    self.concentratebg.alpha_fx.alpha = 0
    Game.battle:addChild(self.concentratebg)


    --Game.battle.music.basepitch = Game.battle.music.pitch

	-- Timeslow ("Focus" Placebo) variables end here

end

function LightSoul:onRemove(parent)
    super.onRemove(self, parent)

    if parent == Game.battle and Game.battle.soul == self then
        Game.battle.soul = nil
    end
	
    -- Taunt
    if self.parried_loop_sfx then
        self.parried_loop_sfx:stop()
        self.parried_loop_sfx = nil
    end

    -- Timeslow
    Game.stage.timescale = 1
    Game.battle.music.pitch = Game.battle.music.basepitch
    self.vhsfx.active = false
    self.outlinefx.active = false
    self.concentratebg:remove()
    if self.timeslow_sfx then self.timeslow_sfx:stop() end
    Input.clear("focus_placebo")
end

function LightSoul:onWaveStart() end
function LightSoul:onMenuWaveStart() end

function LightSoul:shatter(count)
    Assets.playSound("break2")

    local shard_count = count or 6

    self.shards = {}
    for i = 1, shard_count do
        local x_pos = self.shard_x_table[((i - 1) % #self.shard_x_table) + 1]
        local y_pos = self.shard_y_table[((i - 1) % #self.shard_y_table) + 1]
        local shard = Sprite("player/heart_shard", self.x + x_pos, self.y + y_pos)
        shard:setColor(self:getColor())
        shard.physics.direction = math.rad(Utils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = self.layer
        shard:play(5/30)
        table.insert(self.shards, shard)
        self.stage:addChild(shard)
    end

    self:remove()
    Game.battle.soul = nil
end

function LightSoul:transitionTo(x, y, should_destroy)
    if self.graze_sprite then
        self.graze_sprite.timer = 0
        self.graze_sprite.visible = false
    end
    self.transitioning = true
    self.original_x = self.x
    self.original_y = self.y
    self.target_x = x
    self.target_y = y
    self.timer = 0
    if should_destroy ~= nil then
        self.transition_destroy = should_destroy
    else
        self.transition_destroy = false
    end

	--Focus placebo stuff
	Game.stage.timescale = 1
	Game.battle.music.pitch = Game.battle.music.basepitch
    self.vhsfx.active = false
	self.outlinefx.active = false
    if should_destroy == true then
        self.concentratebg:remove()
        self.timeslow_sfx:stop()
    end
	Input.clear("focus_placebo")
end

function LightSoul:isMoving()
    return self.moving_x ~= 0 or self.moving_y ~= 0
end

function LightSoul:getExactPosition(x, y)
    return self.x + self.partial_x, self.y + self.partial_y
end

function LightSoul:setExactPosition(x, y)
    self.x = math.floor(x)
    self.partial_x = x - self.x
    self.y = math.floor(y)
    self.partial_y = y - self.y
end

function LightSoul:move(x, y, speed)
    local movex, movey = x * (speed or 1), y * (speed or 1)

    local mxa, mxb = self:moveX(movex, movey)
    local mya, myb = self:moveY(movey, movex)

    local moved = (mxa and not mxb) or (mya and not myb)
    local collided = (not mxa and not mxb) or (not mya and not myb)

    return moved, collided
end

function LightSoul:moveX(amount, move_y)
    local last_collided = self.last_collided_x and (Utils.sign(amount) == self.last_collided_x)

    if amount == 0 then
        return not last_collided, true
    end

    self.partial_x = self.partial_x + amount

    local move = math.floor(self.partial_x)
    self.partial_x = self.partial_x % 1

    if move ~= 0 then
        local moved = self:moveXExact(move, move_y)
        return moved
    else
        return not last_collided
    end
end

function LightSoul:moveY(amount, move_x)
    local last_collided = self.last_collided_y and (Utils.sign(amount) == self.last_collided_y)

    if amount == 0 then
        return not last_collided, true
    end

    self.partial_y = self.partial_y + amount

    local move = math.floor(self.partial_y)
    self.partial_y = self.partial_y % 1

    if move ~= 0 then
        local moved = self:moveYExact(move, move_x)
        return moved
    else
        return not last_collided
    end
end

function LightSoul:moveXExact(amount, move_y)
    local sign = Utils.sign(amount)
    for i = sign, amount, sign do
        local last_x = self.x
        local last_y = self.y

        self.x = self.x + sign

        if not self.noclip then
            Object.uncache(self)
            Object.startCache()
            local collided, target = Game.battle:checkSolidCollision(self)
            if self.slope_correction then
                if collided and not (move_y > 0) then
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.y = self.y - 1
                        collided, target = Game.battle:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
                if collided and not (move_y < 0) then
                    self.y = last_y
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.y = self.y + 1
                        collided, target = Game.battle:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
            end
            Object.endCache()

            if collided then
                self.x = last_x
                self.y = last_y

                if target and target.onCollide then
                    target:onCollide(self)
                end

                self.last_collided_x = sign
                return false, target
            end
        end
    end
    self.last_collided_x = 0
    return true
end

function LightSoul:moveYExact(amount, move_x)
    local sign = Utils.sign(amount)
    for i = sign, amount, sign do
        local last_x = self.x
        local last_y = self.y

        self.y = self.y + sign

        if not self.noclip then
            Object.uncache(self)
            Object.startCache()
            local collided, target = Game.battle:checkSolidCollision(self)
            if self.slope_correction then
                if collided and not (move_x > 0) then
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.x = self.x - 1
                        collided, target = Game.battle:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
                if collided and not (move_x < 0) then
                    self.x = last_x
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.x = self.x + 1
                        collided, target = Game.battle:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
            end
            Object.endCache()

            if collided then
                self.x = last_x
                self.y = last_y

                if target and target.onCollide then
                    target:onCollide(self)
                end

                self.last_collided_y = sign
                return i ~= sign, target
            end
        end
    end
    self.last_collided_y = 0
    return true
end

function LightSoul:onDamage(bullet, amount, battlers)
    local best_amount
    for _,battler in ipairs(battlers) do
        local equip_amount = 0
        for _,equip in ipairs(battler.chara:getEquipment()) do
            if equip.getInvBonus then
                equip_amount = equip_amount + equip:getInvBonus()
            end
        end
        if not best_amount or equip_amount > best_amount then
            best_amount = equip_amount
        end
    end
    self.inv_timer = self.inv_timer + (best_amount or 0)
end

function LightSoul:onCollide(bullet)
    if self:isParrying() and not self.did_parry and ((self.special_only and bullet.special_parry) or (not self.special_only)) then

        local burst = HeartBurst(-9, -9, {Game.battle.encounter:getSoulColor()})
        self:addChild(burst)

        self.physics.direction = (Utils.angle(self.x, self.y, bullet:getRelativePos(bullet.collider.width / 2, bullet.collider.height/2))) - math.pi
        self.physics.speed = 3.3
        self.physics.friction = 0.4

        self.parried_sfx:stop()
        self.parried_sfx:play()
        self.parry_inv = self.parry_inv + self.parry_length
        if self.parry_inv > self.parry_cap then
            self.parry_inv = self.parry_cap
        end
        self.did_parry = true
        self.cooldown_timer = 0             -- You can chain parries as long as you keep timing them.

    end
    if bullet.damage then
        --[[if Game.battle.phasearmor >= 1 then
            local burst = HeartBurst(-9, -9, {Game.battle.encounter:getSoulColor()})
            self:addChild(burst)
            Assets.stopAndPlaySound("celestial_hit")
            -- Also I have no idea how to make the bullet not do any damage
            Game.battle.phasearmor = Game.battle.phasearmor - 1
            if Game.battle.phasearmor <= 0 then
                self:removeFX("phaseoutline")
                self.phaseoutline = false
            end
        elseif bullet.damage ~= 0 then
            bullet.parrydmg_old = bullet.damage
        end]]
        if bullet.damage ~= 0 then bullet.parrydmg_old = bullet.damage end
    end
    if self.parry_inv > 0 then
        bullet.damage = 0
    else
        if bullet.parrydmg_old then
            bullet.damage = bullet.parrydmg_old
        else
            bullet.damage = bullet:getDamage()
        end
    end
	
    -- Handles damage
    bullet:onCollide(self)
end

function LightSoul:onSquished(solid)
    -- Called when the soul is squished by a solid
    solid:onSquished(self)
end

function LightSoul:onGraze(bullet, old_graze) end

function LightSoul:doMovement()
    local speed = self.speed

    -- Do speed calculations here if required.

    if self.allow_focus then
        if Input.down("cancel") then speed = speed / 2 end -- Focus mode.
    end

    local move_x, move_y = 0, 0

    -- Keyboard input:
    if Input.down("left")  then move_x = move_x - 1 end
    if Input.down("right") then move_x = move_x + 1 end
    if Input.down("up")    then move_y = move_y - 1 end
    if Input.down("down")  then move_y = move_y + 1 end

    self.moving_x = move_x
    self.moving_y = move_y

    if move_x ~= 0 or move_y ~= 0 then
        if not self:move(move_x, move_y, speed * DTMULT) then
            self.moving_x = 0
            self.moving_y = 0
        end
    end
end

-- Why is this not a default function?
function LightSoul:flash(sprite)
    local sprite_to_use = sprite or self.sprite
    local flash = FlashFade(sprite_to_use.texture, -10, -10)
    flash.flash_speed = 1.5
    flash.layer = 100
    self:addChild(flash)
    return flash
end

function LightSoul:canParry()
    -- Conditions for parrying:
    -- Not already parrying
    -- Cooldown is over
    -- Parrying is enabled
    -- Not in the middle of damage i-frames
    if self.parry_timer == 0 and self.cooldown_timer == 0 and self.can_parry == true and self.inv_timer == 0 then
        return true
    else
        return false
    end
end

function LightSoul:isParrying()
    if self.can_parry and (self.parry_timer > 0) then
        return true
    else
        return false
    end
end

function LightSoul:update()
    self.graze_collider.collidable = Game.battle.tension

    -- Input movement
    if self.can_move then
        self:doMovement()
    end

    -- Bullet collision !!! Yay
    if self.inv_timer > 0 then
        self.inv_timer = Utils.approach(self.inv_timer, 0, DT)
    end

    local collided_bullets = {}
    Object.startCache()
    for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
        if bullet:collidesWith(self.collider) then
            -- Store collided bullets to a table before calling onCollide
            -- to avoid issues with cacheing inside onCollide
            table.insert(collided_bullets, bullet)
        end
        if self.inv_timer == 0 and Game.battle:getState() == "DEFENDING" then
            if bullet:canGraze() and bullet:collidesWith(self.graze_collider) then
                local old_graze = bullet.grazed
                if bullet.grazed then
                    Game:giveTension(bullet:getGrazeTension() * DT * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1 / 3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + (bullet.time_bonus * (DT / 30) * self.graze_time_factor)
                    end
                    if self.graze_sprite.timer < 0.1 then
                        self.graze_sprite.timer = 0.1
                    end
                    bullet:onGraze(false)
                else
                    Assets.playSound("graze")
                    Game:giveTension(bullet:getGrazeTension() * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1/3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + ((bullet.time_bonus / 30) * self.graze_time_factor)
                    end
                    self.graze_sprite.timer = 1 / 3
                    bullet.grazed = true
                    bullet:onGraze(true)
                end
                self:onGraze(bullet, old_graze)
            end
        end
    end
    Object.endCache()
    for _,bullet in ipairs(collided_bullets) do
        self:onCollide(bullet)
    end

    if self.inv_timer > 0 then
        self.inv_flash_timer = self.inv_flash_timer + DT
        local amt = math.floor(self.inv_flash_timer / (2/30)) -- flashing is faster in ut
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.inv_flash_timer = 0
        self.sprite:setColor(1, 1, 1)
    end

    super.update(self)
	
    ---@diagnostic disable-next-line: undefined-field
	if (Input.down("cancel") and not self.blue) and Game.battle:getState() == "DEFENDING" then -- Reduced hitbox size can get you stuck in collision with the blue soul, so it can't use this.
		self.collider.radius = 4
		self.sprite_focus.alpha = 1
	else
		self.collider.radius = 8
		self.sprite_focus.alpha = 0
	end

    local focus_equipped = false
    for _,party in ipairs(Game.party) do
        if party:checkArmor("focus") then focus_equipped = true end
    end
	
	-- Taunt code starts here
	if self.force_taunt ~= false then
	if Game:isTauntingAvaliable() or self.force_taunt == true then
	if self.transitioning then
        if self.parried_loop_sfx then
            self.parried_loop_sfx:stop()
            self.parried_loop_sfx = nil
        end
        return
    end
    
    self.can_move = true
    if self.parry_lock_movement > 0 then
        self.parry_lock_movement = self.parry_lock_movement - DTMULT
        self.can_move = false
    end

    if self.parry_inv == 0 and self.did_parry then
        self.did_parry = false
    end
    --
    if not self.parried_loop_sfx then
        self.parried_loop_sfx = Assets.getSound("chargeshot_charge")
        self.parried_loop_sfx:setLooping(true)
        self.parried_loop_sfx:setPitch(0.1)
        self.parried_loop_sfx:setVolume(0)
        self.parried_loop_sfx:play()
    end

    self.parried_loop_sfx:setPitch( Utils.clampMap(self.parry_inv, 0, self.parry_length / 2, 0.1, 1))
    self.parried_loop_sfx:setVolume(Utils.clampMap(self.parry_inv, 0, self.parry_length / 4, 0,   0.5))
    --]]

    if (Input.pressed("taunt", false) and self:canParry()) and Game.battle:getState() == "DEFENDING" then
        self.parry_lock_movement = 8

        self:flash()
        self.parry_sfx:stop()
        self.parry_sfx:play()

        -- the shine effect
        local effect = Sprite("effects/taunt", 0, 0)
        effect:setOrigin(0.5)
        effect:setScale(0.5)
        effect.layer = self.layer - 1
        effect:play(1/30, false, function()
            effect:remove()
        end)
        self:addChild(effect)

        self.parry_timer = self.parry_window
        self.cooldown_timer = self.cooldown
        self.did_parry = false
        self.once = false
    end

    if self.parry_timer > 0 then self.parry_timer = Utils.approach(self.parry_timer, 0, DTMULT) end
    if self.cooldown_timer > 0 then self.cooldown_timer = Utils.approach(self.cooldown_timer, 0, DTMULT) end
    if self.parry_inv > 0 then self.parry_inv = Utils.approach(self.parry_inv, 0, DTMULT) end
	end
	end
	-- Taunt code ends here
	
	-- Focus code starts here
	if self.force_timeslow ~= false then
	if focus_equipped or self.force_timeslow == true then
	if not self.transitioning then
        self.outlinefx.active = true
    end
    -- Cut timescale in half when holding A and not out of TP
    if not self.transitioning and Input.down("focus_placebo") and Game:getTension() > 0 then
        -- Make sure the game pauses when object selection and selection slowdown is active.
        if not (Kristal.DebugSystem.state == "SELECTION" and Kristal.Config["objectSelectionSlowdown"]) then
        Game.stage.timescale = Utils.approach(Game.stage.timescale, 0.5, DTMULT / 4)
        end
        Game.battle.music.pitch = Utils.approach(Game.battle.music.pitch, Game.battle.music.basepitch/2, DTMULT / 4)
        self.timescale = Utils.approach(self.timescale, 2, DTMULT / 4)
        self.vhsfx.active = true
        if self.timeslow_sfx then self.timeslow_sfx:play() end
	else
        -- Make sure the game pauses when object selection and selection slowdown is active.
        if not (Kristal.DebugSystem.state == "SELECTION" and Kristal.Config["objectSelectionSlowdown"]) then
        Game.stage.timescale = Utils.approach(Game.stage.timescale, 1, DTMULT / 4)
        end
        Game.battle.music.pitch = Utils.approach(Game.battle.music.pitch, Game.battle.music.basepitch, DTMULT / 4)
        self.timescale = Utils.approach(self.timescale, 1, DTMULT / 4)
        self.vhsfx.active = false
        if self.timeslow_sfx then self.timeslow_sfx:stop() end
    end

    -- Remove 1 TP for every drain_rate frames of slowdown active
    if not self.transitioning and Input.down("focus_placebo") and Game:getTension() > 0 then
        if self.drain_timer >= self.drain_rate then
            Game:removeTension(DTMULT*1.3) -- Should keep the drain rate roughly the same, regardless of framerate? Hopefully? Kinda looks like it does but I can't be sure?
            self.drain_timer = 0
        else
            self.drain_timer = self.drain_timer + 1
        end
    end

    -- Error sound if trying to use slowdown when out of TP
    if Input.pressed("focus_placebo") and Game:getTension() <= 0 then
        Assets.playSound("ui_cant_select", 2)
    end

    -- Soul VFX
    if not self.transitioning and Input.down("focus_placebo") and Game:getTension() > 0 then
    self.outline.alpha = Utils.approach(self.outline.alpha, 1, DTMULT / 4)
	if Game:isLight() then
        self.concentratebg.alpha = Utils.approach(self.concentratebg.alpha, 1, DTMULT / 10)
    end
    self.concentratebg.alpha_fx.alpha = 1
    if self.afterimage_delay >= 5 then
        local afterimage = AfterImage(self.outline, 0.5)
        afterimage.debug_select = false
        self:addChild(afterimage)
        self.afterimage_delay = 0
    else
        self.afterimage_delay = self.afterimage_delay + DTMULT
    end
    else
    self.outline.alpha = Utils.approach(self.outline.alpha, 0, DTMULT / 4)
    self.concentratebg.alpha_fx.alpha = Utils.approach(self.concentratebg.alpha_fx.alpha, 0, DTMULT / 4)
	if Game:isLight() then
        self.concentratebg.alpha = Utils.approach(self.concentratebg.alpha, 0, DTMULT / 10)
    end
    end
    if self.focus_holder then self.outlinefx:setAlpha(self.outline.alpha - 0.2) end
	end
	end
	-- Focus code ends here
end

--[[function LightSoul:setFacing(face)
    if self.sprite then
        if face then
            self.sprite:setSprite("player/"..face.."/heart_dodge")
        else
            self.sprite:setSprite("player/heart_dodge")
        end
    end
    if self.graze_sprite then
        if face then
            self.graze_sprite.texture = Assets.getTexture("player/"..face.."/graze")
        else
            self.graze_sprite.texture = Assets.getTexture("player/graze")
        end
    end
end]]

function LightSoul:draw()
    local r,g,b,a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    local charge_timer = self.parry_inv
    if charge_timer > 0 then
        local scale = math.abs(math.sin(charge_timer / 10)) + 1
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)

        scale = math.abs(math.sin(charge_timer / 14)) + 1.2
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)
    end

    -- Soul brightens when invincible
    if charge_timer > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        self.color = Utils.clampMap(self.parry_inv, 0, self.parry_cap / 2, {r,g,b},{1,1,1})
    end

    -- Soul darkens when on cooldown
    if self.cooldown_timer > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        self.color = Utils.clampMap(self.cooldown_timer, 0, self.cooldown / 2, {r,g,b},{(r * 0.5),(g * 0.5),(b * 0.5)})
    end
	
    super.draw(self)

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
        if self.graze_collider.collidable then
            self.graze_collider:draw(1, 1, 1, 0.33)
        end
    end
end

return LightSoul