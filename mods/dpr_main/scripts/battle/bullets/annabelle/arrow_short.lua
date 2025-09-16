local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, dx)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/arrow_short")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.dx = dx
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.dx < self.y then
        self.y = self.y - (4 * DTMULT)
    end
    if self.dx > self.y then
        self.y = self.y + (4 * DTMULT)
    end

    super.update(self)
end

return SmallBullet