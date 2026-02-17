local DarkBullet, super = Class(Bullet)

function DarkBullet:init(x, y, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/len/dark")
    self.sprite:play(0.2, false)
    self.timer = 0

    self:setHitbox(-999999, 0, 0, 0)

    -- Top-center origin point (will be rotated around it)
    self:setOrigin(0.5, 0)

    -- Don't destroy this bullet when it damages the player
    self.destroy_on_hit = false
end

function DarkBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    self.timer = self.timer + 10 * DT
    if self.timer > 4.5 and self.timer < 5 then
        -- The hitbox where the player will be damaged by the bullet (affected by scale and rotation)
        self:setHitbox(4, 4, 12, 12)
    elseif self.timer > 5 then
        self:remove()
    end

    super.update(self)
end

return DarkBullet