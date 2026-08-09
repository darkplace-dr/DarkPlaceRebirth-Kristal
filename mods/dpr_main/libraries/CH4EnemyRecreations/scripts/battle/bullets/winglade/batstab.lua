local BatStab, super = Class(Bullet)

function BatStab:init(x, y, dir, speed, friction)
    super.init(self, x, y, "battle/bullets/winglade/batstab")

	self:setScale(1, 1)
    self.collider = Hitbox(self, self.width/2, self.height/4, self.width/3, self.height/2)
    self.tp = 2.5
    self.rotation = dir + math.rad(90)
    self.physics.speed = speed
    self.physics.friction = friction
	self.physics.match_rotation = true
    self.dropped = false
    self.dropped_time = 0
    self.spin = 0
end

function BatStab:update()
    super.update(self)
end

return BatStab