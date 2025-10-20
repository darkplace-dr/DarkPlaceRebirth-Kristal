local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed, dx)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/annabelle/annihilate")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.dx = dx
    self.inv_timer = (1/4)
    self:setScale(10)
    self.destroy_on_hit = false
end

function SmallBullet:update()

    super.update(self)
end

return SmallBullet