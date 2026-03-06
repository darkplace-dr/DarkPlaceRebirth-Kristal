local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/pippins/smallbullet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
	self.tp = 1.6
	self.damage = 55
	-- This isn't actually in DELTARUNE but I'm pretty
	-- sure you don't fight Pippins and Zapper together
	-- in actual DR anyway so whatever
	if Game.battle.encounter.volume_up then
		bullet:setScale(2.5)
		bullet.tp = 6.4
	end
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet