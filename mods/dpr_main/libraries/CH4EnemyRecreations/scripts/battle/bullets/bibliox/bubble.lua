local Bubble, super = Class(Bullet)

function Bubble:init(x, y)
    self.sprite_index = "bubble"
    super.init(self, x, y, "battle/bullets/bibliox/magic_book/" .. self.sprite_index)
    self.sprite:stop()
    self.image_index = 0
    self.image_speed = 1/6

    self:setScale(1)
    self.alpha = 1
    self.collider = CircleCollider(self, self.width/2, self.height/2, 9)
    self.destroy_on_hit = false
    self.damage = 80
    self.tp = 1.2
    self.remove_offscreen = false

    self.spin = false
    self.spinspeed = 0
    self.bottomfade = 0
    self.wall_destroy = 1
    self.insidebox = 0

    self.dir = 0
end

function Bubble:update()
    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
    if remaining_time < (1/30) then
        self:remove()
    end

    if self.sprite_index == "bubble_split" and self.image_index >= 3.6666666666666665 then
        local pop = self.wave:spawnBullet("bibliox/book_bullet", self.x, self.y)
        pop.sprite_index = "pop"
        pop.collider = nil
        pop.image_speed = 0.5
        pop:setSpeed(self.physics.speed_x, self.physics.speed_y)
        Game.battle.timer:after(4/30, function() pop:remove() end)

        self:destroy()
    end

    if self.wall_destroy == 1 then
        if self.x < -80 then
            self:remove()
        elseif self.x > 760 then
            self:remove()
        elseif self.y < -80 then
            self:remove()
        elseif self.y > 580 then
            self:remove()
        end
    end

    if self.updateimageangle then
        self.rotation = self.physics.direction
    end

    if self.spin == true then
        self.rotation = self.rotation + -math.rad(self.spinspeed) * DTMULT
    end

    if self.bottomfade ~= 0 then
        if self.y > self.bottomfade then
            self.alpha = self.alpha * (0.8 ^ DTMULT)
        end
    end

    self.image_index = self.image_index + self.image_speed * DTMULT
    self:setSprite("battle/bullets/bibliox/magic_book/"..self.sprite_index)
    self.sprite:setFrame(1 + math.floor(self.image_index))

    super.update(self)
end

function Bubble:destroy()
    if Game.battle.soul then
        self.dir = (self.rotation + 360) % 120
    
        while (self.dir < 360) do
            local smol_bubble = self.wave:spawnBullet("bibliox/book_bullet", self.x, self.y)
            smol_bubble.collider = CircleCollider(smol_bubble, 18, 18, 8)
            smol_bubble.physics.direction = -math.rad(self.dir)
            smol_bubble:setSpeed(3.5)
            Game.battle.timer:lerpVar(smol_bubble.physics, "speed", smol_bubble.physics.speed, 2, 20)

            smol_bubble.sprite_index = "bubble_smol"
            Game.battle.timer:lerpVar(smol_bubble, "image_speed", smol_bubble.image_speed, 0.125, 30)

            self.dir = self.dir + 120
        end
    end

    self:remove()
end

return Bubble
