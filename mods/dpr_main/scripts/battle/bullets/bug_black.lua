local BugBlack, super = Class(Bullet)

function BugBlack:init(x, y)
    super.init(self, x, y, "battle/bullets/smallbullet")
	
	self.alpha = 0
	self:fadeTo(1, 0.1)
    self.rotation = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    self.physics.speed = 0
	self.physics.match_rotation = true
	self.graphics.grow = -0.1
	self.targeting = true
	-- Dont remove this bullet offscreen, because the "basic" wave spawns it offscreen
    self.remove_offscreen = false
end

function BugBlack:update(dt)
	if self.targeting then
		self.rotation = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
	end
	super.update(self, dt)
end

return BugBlack