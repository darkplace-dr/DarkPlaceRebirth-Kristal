local BugWhite, super = Class(Bullet)

function BugWhite:init(x, y, dir)
    super.init(self, x, y, "battle/bullets/smallbullet")

	self:setScale(2, 2)
    self.rotation = dir
    self.physics.speed = 10
	self.physics.match_rotation = true
    -- Dont remove this bullet offscreen, because the "basic" wave spawns it offscreen
    self.remove_offscreen = false
end

return BugWhite