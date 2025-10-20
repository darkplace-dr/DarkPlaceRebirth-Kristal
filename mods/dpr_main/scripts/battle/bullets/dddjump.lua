local Rocky, super = Class(Bullet)

function Rocky:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/starblock")
	self.destroy_on_hit = false

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
	self.rising = false
end

function Rocky:update()
    -- For more complicated bullet behaviours, code here gets called every update
	if self.y > Game.battle.arena.bottom - 15 then
		if self.rising == false then
			Assets.playSound("impact")
		end
		self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y - 100)
		self.physics.speed = 12
		self.physics.friction = 0.5
		self.rising = true
	end

	if self.physics.speed == 0 and self.rising == true then
		self.physics.direction = Utils.angle(self.x, self.y, self.x, self.y + 1)
		self.physics.speed = 4
		self.physics.friction = -1
		self.rising = false
	end

    super.update(self)
end

return Rocky
