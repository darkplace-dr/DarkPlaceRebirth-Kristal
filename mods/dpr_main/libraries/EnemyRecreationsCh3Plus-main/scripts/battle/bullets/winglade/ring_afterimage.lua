local RingAfterimage, super = Class(Bullet)

function RingAfterimage:init(x, y, dir, speed, alpha)
    super.init(self, x, y, "bullets/winglade/ring")

    self:setScale(1, 1)
    self.alpha = alpha
    self.physics.direction = dir
    self.physics.speed = speed
    self.collider.collidable = false
end

function RingAfterimage:update()
    super.update(self)
end

return RingAfterimage