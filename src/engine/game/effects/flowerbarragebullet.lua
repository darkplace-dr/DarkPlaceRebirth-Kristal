---@class FlowerBarrageBullet : Sprite
---@overload fun(...) : FlowerBarrageBullet
local FlowerBarrageBullet, super = Class(Sprite)

function FlowerBarrageBullet:init(target, speed, dir, after)
    super.init(self, "effects/spells/ceroba/flower", 0, 0)

    self:setOrigin(0.5, 0.5)
    self:setScale(1)

    self:play(1 / 6, true)

    self.alpha = 0

    self.target = target
    self.after_func = after

    local tx, ty = self.target:getRelativePos(self.target.width / 2, self.target.height / 2, Game.battle)

    self.state = 0
    self.attack_distance = 80
    self.attack_distance_max = self.attack_distance + 32
    self.attack_dir = dir or 90
    self.attack_target_x = tx
    self.attack_target_y = ty
    self.bullet_speed = speed or 6
    self.homing_speed = 0
end

function FlowerBarrageBullet:update()
    local tx, ty = self.target:getRelativePos(self.target.width / 2, self.target.height / 2, Game.battle)
    self.attack_target_x = tx + self.target:getActiveSprite().x
    self.attack_target_y = ty + self.target:getActiveSprite().y
    self.x = self.attack_target_x + MathUtils.lengthDirX(self.attack_distance, math.rad(self.attack_dir))
    self.y = self.attack_target_y + MathUtils.lengthDirY(self.attack_distance, math.rad(self.attack_dir))
    if self.state == 0 then
        if self.alpha < 1 then
            self.alpha = self.alpha + 0.2 * DTMULT
            if self.alpha > 1 then
                self.alpha = 1
            end
        end
        if self.attack_dir < 360 then
            self.attack_dir = self.attack_dir + self.bullet_speed * DTMULT
        else
            self.attack_dir = self.bullet_speed
        end
    elseif self.state == 1 then
        if self.attack_dir < 360 then
            self.attack_dir = self.attack_dir + self.bullet_speed * DTMULT
        else
            self.attack_dir = self.bullet_speed
        end
        self.bullet_speed = MathUtils.lerp(self.bullet_speed, 0, 0.75 * DTMULT)
        if MathUtils.round(self.bullet_speed) == 0 then
            self.state = 2
        end
    elseif self.state == 2 then
        self.attack_distance = MathUtils.lerp(self.attack_distance, self.attack_distance_max, 0.5 * DTMULT)
        if MathUtils.round(self.attack_distance) == self.attack_distance_max then
            self.state = 3
            Assets.playSound("ceroba_swoosh")
        end
    elseif self.state == 3 then
        if self.attack_distance > 0 then
            self.attack_distance = self.attack_distance - self.homing_speed * DTMULT
        else
            if self.after_func then self.after_func() end
            self:remove()
        end
        self.homing_speed = self.homing_speed + DTMULT
    end

    super.update(self)
end

return FlowerBarrageBullet
