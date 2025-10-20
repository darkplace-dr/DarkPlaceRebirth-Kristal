local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, dx, speedup)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/arrow_long")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.dx = dx
    self.speedup = speedup
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.dx < self.y then
        self.y = self.y - (4 * DTMULT)
    end
    if self.dx > self.y then
        self.y = self.y + (4 * DTMULT)
    end
    self.physics.speed = self.physics.speed + (DTMULT * 0.5)
    if self.physics.speed > 0 then
        self.physics.speed = self.physics.speed + (DTMULT * self.speedup * 0.5)
    end

    super.update(self)
end

return SmallBullet