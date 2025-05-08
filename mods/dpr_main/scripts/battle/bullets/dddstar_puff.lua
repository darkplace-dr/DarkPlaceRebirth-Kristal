local froggitbullet_1, super = Class(Bullet)

function froggitbullet_1:init(x, y, dir, speed)
    -- Last argument = sprite path
    self:setScale(2)
    super.init(self, x, y, "battle/bullets/dddstar")
	self.timer = 80
    self.color = {0.9, 0.5, 0.9}
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
end

function froggitbullet_1:update()
    -- For more complicated bullet behaviours, code here gets called every update
	self.timer = self.timer - (DT*60)
	if self.timer <= 0 then
        self.timer = 160
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
	end
    super.update(self)
end

return froggitbullet_1