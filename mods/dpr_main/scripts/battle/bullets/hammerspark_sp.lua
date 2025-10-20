local HammerSpark, super = Class(Bullet)

function HammerSpark:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/dddstar")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
	self.destroy_on_hit = false
	self.rotation = dir - math.rad(180)
end

function HammerSpark:update()
    -- For more complicated bullet behaviours, code here gets called every update
	if self.x < Game.battle.arena.right then
		Assets.playSound("impact")
		local x, y = self:getRelativePos(self.width/2, self.height/2, Game.battle)
		local smallddd1 = self.wave:spawnBullet("smallddd", x, y, math.rad(0) + math.rad(180), 8)
		local smallddd2 = self.wave:spawnBullet("smallddd", x, y, math.rad(45) + math.rad(180), 8)
		local smallddd3 = self.wave:spawnBullet("smallddd", x, y, math.rad(-45) + math.rad(180), 8)
		local smallddd4 = self.wave:spawnBullet("smallddd", x, y, math.rad(90) + math.rad(180), 8)
		local smallddd5 = self.wave:spawnBullet("smallddd", x, y, math.rad(-90) + math.rad(180), 8)
		self:remove()
	end

    super.update(self)
end

return HammerSpark
