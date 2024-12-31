--- The Soul is the object the player controls in battle. \
--- The `Soul` global stores the default (red) soul. Custom soul types can be created by extending this class in a new global (using a file in `scripts/objects/` or `scripts/globals/`).
--- The soul being used in battle is determined by [`Encounter:createSoul`](lua://Encounter.createSoul), and can be altered after the first DEFENDING stage with [`Battle:swapSoul()`](lua://Battle.swapSoul).
---
---@class Soul : Object
---
---@field graze_tp_factor   number          A multiplier for the TP earned from grazing by the soul (Defaults to `1`, plus the sum of all party members effective `graze_tp` stats, capped at `3`)
---@field graze_time_factor number          A multiplier for the wave time depleted from grazing by the soul (Defaults to `1`, plus the sum of all party members effective `graze_time` stats, capped at `3`)
---@field grze_size_factor  number          A multiplier for the size of the soul's graze hitbox (Defaults to `1`, plus the sum of all party members effective `graze_size` stats, capped at `3`)
---
---@field sprite            Sprite          The Soul's `Sprite` objcet instance
---@field graze_sprite      GrazeSprite     The Soul's `GrazeSprite` object instance
---
---@field width             number          The width of the soul, in pixels
---@field height            number          The height of the soul, in pixels
---
---@field collider          CircleCollider  The Soul's collider, defaulting to a circle with an 8 pixel radius
---@field graze_collider    CircleCollider  The Soul's collider for grazing, defaulting to a circle with a 25 pixel radius (before being altered by `graze_size_factor`)
---
---@field original_x        number?         *(Used internally)* The x-coordinate of the soul at the start of a transition
---@field original_y        number?         *(Used internally)* The y-coordinate of the soul at the start of a transition
---@field target_x          number?         *(Used internally)* The x-coordinate the soul is transitioning towards
---@field target_y          number?         *(Used internally)* The y-coordinate the soul is transitioning towards
---
---@field timer             number          *(Used internally)* A timer variable for the soul transition
---@field transitioning     boolean         Whether the soul is currently in a transition
---
---@field speed             number          The speed of the soul, in pixels per frame at 30FPS (defaults to `4`)
---
---@field inv_timer         number          The remaining invulnerability time for the soul
---@field inv_flash_timer   number          *(Used internally)* A timer for the flashing of the soul when invulnerable
---
---@field partial_x         number          *(Used internally)* Stores the fractional part of the soul's x-coordinate
---@field partial_y         number          *(Used internally)* Stores the fractional part of the soul's y-coordinate
---
---@field last_collided_x   boolean|number  The direction `(+/-)` the soul moved and collided with an object last frame on the x-axis (`false` when the soul has not moved, `0` when there is no collision)
---@field last_collided_y   boolean|number  The direction `(+/-)` the soul moved and collided with an object last frame on the y-axis (`false` when the soul has not moved, `0` when there is no collision)
---
---@field x                 integer         The soul's truncated (whole) x-coordinate. Its fractional part is in [`partial_x`](lua://Soul.x). 
---@field y                 integer         The soul's truncated (whole) y-coordinate. Its fractional part is in [`partial_y`](lua://Soul.y).
---
---@field moving_x          number          The `x` value the soul is moving by
---@field moving_y          number          The `y` value the soul is moving by
---
---@field noclip            boolean         Whether the solid has noclip (collision bypass)
---@field slope_correction  boolean         Whether the soul should push up and down slopes when colliding with them
---
---@field transition_destroy    boolean     *(Used internally)* Whether the soul should be removed by an upcoming transition
---
---@field can_move          boolean         Whether the player is able to move the soul
---@field allow_focus       boolean         Whether the player is able to focus with the soul (hold Cancel key for 1/2 speed)
---
---@field target_alpha      number?         The target alpha of the soul
---
---@overload fun(x?:number, y?:number, color?: table) : Soul
local Soul, super = Class(Object)

---@param x?        number
---@param y?        number
---@param color?    table
function Soul:init(x, y, color)
    super.init(self, x, y)

    if color then
        self:setColor(color)
    else
        self:setColor(1, 0, 0)
    end

    self.layer = BATTLE_LAYERS["soul"]

    self.graze_tp_factor   = 1
    self.graze_time_factor = 1
    self.graze_size_factor = 1
    for _,party in ipairs(Game.party) do
        self.graze_tp_factor   = math.min(3, self.graze_tp_factor   + party:getStat("graze_tp"))
        self.graze_time_factor = math.min(3, self.graze_time_factor + party:getStat("graze_time"))
        self.graze_size_factor = math.min(3, self.graze_size_factor + party:getStat("graze_size"))
    end

    self.sprite = Sprite("player/heart_dodge")
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.inherit_color = true
    self:addChild(self.sprite)

    self.graze_sprite = GrazeSprite()
    self.graze_sprite:setOrigin(0.5, 0.5)
    self.graze_sprite.inherit_color = true
    self.graze_sprite.graze_scale = self.graze_size_factor
    self:addChild(self.graze_sprite)
	
	self.outline = Sprite("player/heart_invert") -- Creating this first so sprite_focus will be on top of it
    self.outline:setOrigin(0.5, 0.5)
    self.outline.alpha = 0
    self.outline.color = {0, 1, 1}
    self.outline.debug_select = false
    self:addChild(self.outline)

	self.sprite_focus = Sprite("player/heart_dodge_focus")
    self.sprite_focus:setOrigin(0.5, 0.5)
    self.sprite_focus.inherit_color = false
	self.sprite_focus.alpha = 0
    self.sprite_focus.debug_select = false
    self:addChild(self.sprite_focus)

    self.width = self.sprite.width
    self.height = self.sprite.height

    self.debug_rect = {-8, -8, 16, 16}

    self.collider = CircleCollider(self, 0, 0, 8)

    self.graze_collider = CircleCollider(self, 0, 0, 25 * self.graze_size_factor)

    self.original_x = x
    self.original_y = y
    self.target_x = x
    self.target_y = y
    self.timer = 0
    self.transitioning = false
    self.speed = 4

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

    self.target_alpha = nil
	
	-- Taunt/parry variables start here
	self.force_taunt = nil -- Forces taunting in battle on or off, regardless of if the PizzaToque is equipped.

	self.parry_timer = 0
    self.cooldown_timer = 0
    self.parry_inv = 0
    self.taunt_timer = 0
	
    -- hi -sam
    self.parry_lock_movement = 0

    if Game.save_name:upper() == "PEPPINO" then
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

    -- for monster souls
    self.priority_chara = Game:getSoulPartyMember()
    if self.priority_chara.monster then
        self:setScale(-1, -1)
        self.sprite_focus:setColor(1, 0, 0)
    end
end

---@param parent Object
function Soul:onRemove(parent)
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

--- *(Override)* Called when waves are started
function Soul:onWaveStart() end

--- Shatters the soul into several shards \
--- The position of the shards are controlled by [`shard_x_table`](lua://Soul.shard_x_table) and [`shard_y_table`](lua://Soul.shard_y_table)
---@param count integer The number of shards that the soul should shatter into.
function Soul:shatter(count)
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

---@param x                 number  x-coordinate of the end point of the transition
---@param y                 number  y-coordinate of the end point of the transition
---@param should_destroy?   boolean Whether the soul should be removed during this transition
function Soul:transitionTo(x, y, should_destroy)
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

---@return boolean
function Soul:isMoving()
    return self.moving_x ~= 0 or self.moving_y ~= 0
end

--- Gets the soul's exact position (including the fractional part) \
--- *The soul's `x` and `y` values are truncated so this must be used for the soul's exact position*
---@param x number
---@param y number
---@return number exact_x
---@return number exact_y
function Soul:getExactPosition(x, y)
    return self.x + self.partial_x, self.y + self.partial_y
end

--- Sets the soul's exact position (including a fractional part)
---@param x number
---@param y number
function Soul:setExactPosition(x, y)
    self.x = math.floor(x)
    self.partial_x = x - self.x
    self.y = math.floor(y)
    self.partial_y = y - self.y
end

--- Moves the soul by `x` and `y`, accounting for collision in the soul's movement path
---@param x?     number 
---@param y?     number 
---@param speed? number An optional multiplier to the amount of `x` and `y` that the soul moves by.
---@return boolean  moved       Whether the soul moved from its previous position
---@return boolean  collided    Whether the soul collided with something on its movement path
function Soul:move(x, y, speed)
    local movex, movey = x * (speed or 1), y * (speed or 1)

    local mxa, mxb = self:moveX(movex, movey)
    local mya, myb = self:moveY(movey, movex)

    local moved = (mxa and not mxb) or (mya and not myb)
    local collided = (not mxa and not mxb) or (not mya and not myb)

    return moved, collided
end

--- *(Used internally)* Performs collision abiding movement of the soul along the x-axis
---@param amount number
---@param move_y number
---@return boolean
---@return boolean?
function Soul:moveX(amount, move_y)
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

--- *(Used internally)* Performs collision abiding movement of the soul along the y-axis
---@param amount number
---@param move_x number
---@return boolean
---@return boolean?
function Soul:moveY(amount, move_x)
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

--- *(Used internally)* Performs collision abiding movement of the soul on the x-axis
---@param amount number
---@param move_y number
---@return boolean
---@return Arena|nil
function Soul:moveXExact(amount, move_y)
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

--- *(Used internally)* Performs collision abiding movment of the soul on the y-axis
---@param amount number
---@param move_x number
---@return boolean
---@return Arena|nil
function Soul:moveYExact(amount, move_x)
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

--- *(Override)* Called when the soul takes damage
---@param bullet Bullet
---@param amount integer
function Soul:onDamage(bullet, amount, mhp)
    -- Can be overridden, called when the soul actually takes damage from a bullet
end

--- *(Override)* Called when the soul collides with a bullet and before taking damage \
--- By default, this function is responsible for calling the bullet's collision check, [`Bullet:onCollide()`](lua://Bullet.onCollide)
---@param bullet Bullet
function Soul:onCollide(bullet)
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

--- *(Override)* Called when the soul is squished between two solids \
--- By default, this function is responsible for calling the solid's [`Solid:onSquished`](lua:///Solid.onSquished)
---@param solid Solid
function Soul:onSquished(solid)
    -- Called when the soul is squished by a solid
    solid:onSquished(self)
end

--- *(Override)* Called when the soul grazes something.
---@param bullet Bullet
---@param old_graze boolean
function Soul:onGraze(bullet, old_graze) end

--- Called every frame from within [`Soul:update()`](lua://Soul.update) if the soul is able to move. \
--- Movement for the soul based on player input should be controlled within this method.
function Soul:doMovement()
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
function Soul:flash(sprite)
    local sprite_to_use = sprite or self.sprite
    local flash = FlashFade(sprite_to_use.texture, -10, -10)
    flash.flash_speed = 1.5
    flash.layer = 100
    self:addChild(flash)
    return flash
end

function Soul:canParry()
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

function Soul:isParrying()
    if self.can_parry and (self.parry_timer > 0) then
        return true
    else
        return false
    end
end

function Soul:update()
    if self.transitioning then
        if self.timer >= 7 then
            Input.clear("cancel")
            self.timer = 0
            if self.transition_destroy then
                Game.battle:addChild(HeartBurst(self.target_x, self.target_y, {Game:getSoulColor()}))
                self:remove()
            else
                self.transitioning = false
                self:setExactPosition(self.target_x, self.target_y)
            end
        else
            self:setExactPosition(
                Utils.lerp(self.original_x, self.target_x, self.timer / 7),
                Utils.lerp(self.original_y, self.target_y, self.timer / 7)
            )
            self.alpha = Utils.lerp(0, self.target_alpha or 1, self.timer / 3)
            self.sprite:setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            self.timer = self.timer + (1 * DTMULT)
        end
        return
    end

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
        if self.inv_timer == 0 then
            if bullet.tp ~= 0 and bullet:collidesWith(self.graze_collider) then
                local old_graze = bullet.grazed
                if bullet.grazed then
                    Game:giveTension(bullet.tp * DT * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1/3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + (bullet.time_bonus * (DT / 30) * self.graze_time_factor)
                    end
                    if self.graze_sprite.timer < 0.1 then
                        self.graze_sprite.timer = 0.1
                    end
                else
                    Assets.playSound("graze")
                    Game:giveTension(bullet.tp * self.graze_tp_factor)
                    if Game.battle.wave_timer < Game.battle.wave_length - (1/3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + ((bullet.time_bonus / 30) * self.graze_time_factor)
                    end
                    self.graze_sprite.timer = 1/3
                    bullet.grazed = true
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
        local amt = math.floor(self.inv_flash_timer / (4/30))
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
	if Input.down("cancel") and not self.blue then -- Reduced hitbox size can get you stuck in collision with the blue soul, so it can't use this.
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

    if Input.pressed("taunt", false) and self:canParry() then
        self.parry_lock_movement = 8

        self:flash()
        self.parry_sfx:stop()
        self.parry_sfx:play()

        for _,chara in pairs(Game.battle.stage:getObjects(PartyBattler)) do
            if not chara.actor or chara.is_down then goto continue end

            -- workaround due of actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            chara:toggleOverlay(true)
            chara.overlay_sprite:setSprite(Utils.pick(sprites))

            -- the shine effect
            local effect = Sprite("effects/taunt", 10, 15)
            effect:setOrigin(0.5)
            effect:setScale(0.5)
            effect.layer = -1
            effect:play(1/30, false, function()
                effect:remove()
                chara:toggleOverlay(false)
            end)
            chara:addChild(effect)

            ::continue::
        end

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
    end
    if self.focus_holder then self.outlinefx:setAlpha(self.outline.alpha - 0.2) end
	end
	end
	-- Focus code ends here
end

function Soul:draw()
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
	
    self.color = {r,g,b}

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
        self.graze_collider:draw(1, 1, 1, 0.33)
    end
end

return Soul
