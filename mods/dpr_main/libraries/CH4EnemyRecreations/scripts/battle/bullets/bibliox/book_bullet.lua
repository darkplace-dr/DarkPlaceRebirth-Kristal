local BookBullet, super = Class(Bullet)

function BookBullet:init(x, y)
    self.sprite_index = "no_mask"
    super.init(self, x, y, "battle/bullets/bibliox/magic_book/" .. self.sprite_index)
    self.sprite:stop()
    self.image_index = 0
    self.image_speed = 1

    self:setScale(1)
    self.alpha = 1
    self.damage = 80
    self.tp = 1.2
    self.remove_offscreen = false

    self.spin = false
    self.spinspeed = 0
    self.bottomfade = 0
    self.wall_destroy = true
    self.insidebox = 0
end

function BookBullet:update()
    super.update(self)

    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
    if remaining_time < (1/30) then
        self:remove()
    end

    if self.wall_destroy == false then
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
    self:setSprite("battle/bullets/bibliox/magic_book/" .. self.sprite_index)
    self.sprite:setFrame(1 + math.floor(self.image_index))

    if Game.battle.arena then
        local arena = Game.battle.arena

        if (self.x >= (arena.x - 75) and self.x <= (arena.x + 75)) and (self.y >= (arena.y - 75) and self.y <= (arena.y + 75)) then
            self.insidebox = self.insidebox + DTMULT

        elseif (self.insidebox > 14 or (self.insidebox > 0 and self.sprite_index ~= "fire")) then
            self.alpha = self.alpha - (0.1 * DTMULT)
        
            if (self.sprite_index == "fire") then
                self.alpha = self.alpha - (0.1 * DTMULT)
            end

            if self.alpha <= 0 then
                self:remove()
            end
        end
    else
        self:remove()
    end
end

return BookBullet
