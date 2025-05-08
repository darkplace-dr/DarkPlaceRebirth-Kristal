local froggitbullet_1, super = Class(Bullet)

function froggitbullet_1:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/royalspin")
    self.sprite:play(0.2, true)
    self:setScale(1)
    --self.color = {0.9, 0.5, 0.9}
	self.timer = 50
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.destroy_on_hit = false
    self.m1 = 0
    self.m2 = 0
    self.m3 = 0
end

function froggitbullet_1:update()
    -- For more complicated bullet behaviours, code here gets called every update
	self.timer = self.timer - (DT*60)
    if self.timer <= 22 and self.m1 == 0 then
        self.m1 = 1
        self.physics.speed = 10
    end
    if self.timer <= 15 and self.m2 == 0 then
        self.m2 = 1
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = -3
    end
    if self.timer <= 10 and self.m3 == 0 then
        self.m3 = 1
        self.physics.speed = -2
    end
    if self.timer <= 0 then
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.timer = 32
        self.physics.speed = 11
        self.m1 = 0
        self.m2 = 0
        self.m3 = 0
    end
    super.update(self)
end

return froggitbullet_1