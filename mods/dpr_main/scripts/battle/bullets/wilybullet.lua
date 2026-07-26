local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/smallbullet")

    self.physics.direction = dir
    self.physics.speed = speed

	self.supertimer = 0
end

function SmallBullet:update()
	self.x = self.x + math.cos(self.supertimer / 2) * self.physics.speed * 0.3
	self.y = self.y + math.sin(self.supertimer / 2) * self.physics.speed * 0.3

	self.supertimer = self.supertimer + DTMULT

	self.physics.speed = self.physics.speed * 1.05 ^ DTMULT

    super.update(self)
end

return SmallBullet