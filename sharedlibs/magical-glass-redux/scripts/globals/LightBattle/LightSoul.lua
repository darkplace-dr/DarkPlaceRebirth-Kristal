local LightSoul, super = Class(Object)

function LightSoul:init(x, y, color)
    super.init(self, x, y)

    if color then
        self:setColor(color)
    else
        self:setColor(Game.battle.encounter:getSoulColor())
    end

    self.layer = LIGHT_BATTLE_LAYERS["soul"]

    self.sprite = Sprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_light")
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
    for _, party in ipairs(Game.party) do
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

    self.original_x = x
    self.original_y = y
    self.target_x = x
    self.target_y = y
    self.timer = 0
    self.transitioning = Game.battle:getState() ~= "DEFENDING" or not self.visible
    self.speed = Game.battle.soul_speed

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

    self.shard_x_table = {-2, 0, 2, 8, 10, 12}
    self.shard_y_table = {0, 3, 6}

    self.can_move = true
    self.allow_focus = true
    
    self.graze_collider.collidable = Game.battle.tension

    -- Diamond shield variables start here
    self.glow_texture = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_light")
    self.glow_alpha = 0
    self.glow_alpha_increase = 0.1
    -- Diamond shield variables end here
end

function LightSoul:onRemove(parent)
    super.onRemove(self, parent)

    if parent == Game.battle and Game.battle.soul == self then
        Game.battle.soul = nil
    end
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
        shard.physics.direction = math.rad(MathUtils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = LIGHT_BATTLE_LAYERS["above_arena_border"] + 5
        shard:play(5/30)
        table.insert(self.shards, shard)
        self.stage:addChild(shard)
    end

    self:remove()
    Game.battle.soul = nil
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
    local last_collided = self.last_collided_x and (MathUtils.sign(amount) == self.last_collided_x)

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
    local last_collided = self.last_collided_y and (MathUtils.sign(amount) == self.last_collided_y)

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
    local sign = MathUtils.sign(amount)
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
    local sign = MathUtils.sign(amount)
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

function LightSoul:onDamage(bullet, amount)
    -- Can be overridden, called when the soul actually takes damage from a bullet
end

function LightSoul:onCollide(bullet)
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

function LightSoul:update()
    self.speed = Game.battle.soul_speed
    self.transitioning = Game.battle:getState() ~= "DEFENDING" or not self.visible
    
    -- Input movement
    if self.can_move then
        self:doMovement()
    end

    -- Bullet collision !!! Yay
    if self.inv_timer > 0 then
        self.inv_timer = MathUtils.approach(self.inv_timer, 0, DT)
    end

    local collided_bullets = {}
    Object.startCache()
    for _, bullet in ipairs(Game.stage:getObjects(Bullet)) do
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
    for _, bullet in ipairs(collided_bullets) do
        self:onCollide(bullet)
    end

    if self.inv_timer > 0 then
        self.inv_flash_timer = self.inv_flash_timer + DT
        local amt = math.floor(self.inv_flash_timer / (2 / 30)) -- flashing is faster in ut
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.inv_flash_timer = 0
        self.sprite:setColor(1, 1, 1)
    end

    -- Diamond shield code starts here
    local when_should_glow = {"ENEMYDIALOGUE", "DEFENDINGBEGIN", "DEFENDING"}
    local not_in_battle_menu = true
    if Game.battle then not_in_battle_menu = TableUtils.contains(when_should_glow, Game.battle.state) end
    if self.inv_timer == 0 and Game.pp > 0 and not_in_battle_menu then
        self.glow_alpha = self.glow_alpha + self.glow_alpha_increase * DTMULT
        if self.glow_alpha >= 1 then
            self.glow_alpha = 1
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
        if self.glow_alpha <= 0 then
            self.glow_alpha = 0
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
    else
        self.glow_alpha = 0
        self.glow_alpha_increase = math.abs(self.glow_alpha_increase)
    end
    -- Diamond shield code ends here

    super.update(self)
end

function LightSoul:draw()
    super.draw(self)

    local glow_w, glow_h = self.glow_texture:getWidth(), self.glow_texture:getHeight()
    local scale_x, scale_y = self.sprite.scale_x, self.sprite.scale_y
    love.graphics.setColor(1, 1, 1, self.glow_alpha)
    love.graphics.draw(self.glow_texture, -glow_w/2 * scale_x, -glow_h/2 * scale_y, 0, scale_x, scale_y)
    love.graphics.setColor(1, 1, 1, 1)

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
        if self.graze_collider.collidable then
            self.graze_collider:draw(1, 1, 1, 0.33)
        end
    end
end

function LightSoul:setMonsterSoul(value)
    if self.sprite then
        if value == true then
            self.sprite:setSprite("player/monster/heart_light")
        elseif value == false then
            self.sprite:setSprite("!player/heart_light")
        else
            self.sprite:setSprite("player/heart_light")
        end
    end
    if self.graze_sprite then
        if value == true then
            self.graze_sprite.texture = Assets.getTexture("player/monster/graze")
        elseif value == false then
            self.graze_sprite.texture = Assets.getTexture("!player/graze")
        else
            self.graze_sprite.texture = Assets.getTexture("player/graze")
        end
    end
end

return LightSoul