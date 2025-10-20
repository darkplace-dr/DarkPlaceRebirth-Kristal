local froggitbullet_1, super = Class(Bullet)

function froggitbullet_1:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/smallbullet")
    self.sprite:play(0.2, true)
    self:setScale(4)
    self.color = {1,1,0}
	self.timer = 45
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.destroy_on_hit = false
    self.m1 = 0
    self.m2 = 0
    self.m3 = 0
    self.m4 = 0
    self.rotation = dir
end

function froggitbullet_1:update()
    -- For more complicated bullet behaviours, code here gets called every update
	self.timer = self.timer - (DT*60)
    if self.timer <= 15 and self.m1 == 0 then
        self.m1 = 1
        self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = 6
        self.rotation = self.physics.direction
    end
    if self.timer <= 10 and self.m2 == 0 then
        self.m2 = 1
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = 9
        self.rotation = self.physics.direction
    end
    if self.timer <= 5 and self.m3 == 0 then
        self.m3 = 1
        self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = 12
        self.rotation = self.physics.direction
    end
    if self.timer <= 0 and self.m4 == 0  then
        Assets.playSound("rudebuster_hit")
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = 9
        self.m4 = 1
        self.rotation = self.physics.direction
        Assets.playSound("rudebuster_hit")
		local x, y = self:getRelativePos(self.width/2, self.height/2, Game.battle)
        local beam1 = self.wave:spawnBullet("smallbullet", x, y, math.rad(0) + self.rotation, 18)
        local beam1 = self.wave:spawnBullet("smallbullet", x, y, math.rad(0) + self.rotation + math.rad(45), 18)
        local beam1 = self.wave:spawnBullet("smallbullet", x, y, math.rad(0) + self.rotation - math.rad(45), 18)
    end
    super.update(self)
end

return froggitbullet_1