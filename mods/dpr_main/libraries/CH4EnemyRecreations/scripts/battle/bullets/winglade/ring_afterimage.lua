local RingAfterimage, super = Class(Bullet)

function RingAfterimage:init(x, y, dir, speed, alpha)
    super.init(self, x, y, "battle/bullets/winglade/ring")

    self:setScale(1, 1)
    self.alpha = alpha
    self.physics.direction = dir
    self.physics.speed = speed
    self.collidable = false
    self.collider = CircleCollider(self, self.width / 2, self.height / 2, 13)
end

function RingAfterimage:update()
    super.update(self)
end

return RingAfterimage