local SpearStab, super = Class(Bullet)

function SpearStab:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/speardee")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
	self.rotation = dir - math.rad(180)
end

function SpearStab:update()
    -- For more complicated bullet behaviours, code here gets called every update
	if self.physics.direction ~= math.rad(90) then
		self.physics.direction = self.physics.direction - (math.rad(1) * (DT*60))
		self.rotation = self.physics.direction - math.rad(180)
	end

    super.update(self)
end

return SpearStab
