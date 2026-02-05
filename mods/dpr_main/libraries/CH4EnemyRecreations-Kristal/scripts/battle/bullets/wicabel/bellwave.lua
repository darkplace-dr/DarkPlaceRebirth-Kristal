local CornerPendulum, super = Class(Bullet)

function CornerPendulum:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/wicabel/bellwave")
	
	self.sprite:play(1/30)
	self.physics.speed = speed or 2
	self.physics.direction = dir or 0
	self.remove_offscreen = true
	
	self.damage = 45
	self.tp = 0.6
end

return CornerPendulum