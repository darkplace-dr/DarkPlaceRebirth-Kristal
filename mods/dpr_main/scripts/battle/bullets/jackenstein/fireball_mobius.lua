local FireballMobius, super = Class(Bullet)

function FireballMobius:init(x, y, width, height, rate, len, len2, tlen)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.tp = 0
	self:setOrigin(0.5,0.5)
    self:setSprite("battle/bullets/jackenstein/bullet/bullet", 0, false)
	self.basex = self.x
	self.basey = self.y
	self.square_width = width or 56
	self.square_height = height or 13
	self.rate = rate or 1
	self.cycle_length = len or 90
	self.cycle_length2 = len2 or 180
	self.timer = 0
	self.timer2 = 0
	self.iris_tex = Assets.getFrames("battle/bullets/jackenstein/bullet/iris")
	self.iris = true
	self.iris_dir = math.rad(-1)
	self.orbs = {}
	self.trail_length = tlen or 2
	for i = 1, self.trail_length+1 do
		local orb = self.wave:spawnObject(GhostHouseDot(xc, yc-12+liney, hy+3-5))
		orb.float = -1
		table.insert(self.orbs, orb)
	end
end

function FireballMobius:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function FireballMobius:update()
	local old_x = self.x
	local old_y = self.y
    super.update(self)
	self.timer = self.timer + (math.pi / self.cycle_length) * self.rate * DTMULT
	self.timer2 = self.timer2 + (math.pi / self.cycle_length2) * self.rate * DTMULT
	self.x = MathUtils.round(self.basex + (math.sin(self.timer) * self.square_width))
	self.y = MathUtils.round(self.basey + (math.sin(self.timer2) * self.square_height))
	if self.rate and self.rate ~= 0 then
		for i,orb in ipairs(self.orbs) do
			if orb and orb.suck == 0 then
				local timer = self.timer - ((((2 + (8 * i)) * math.pi) / self.cycle_length) * self.rate)
				local timer2 = self.timer2 - ((((2 + (8 * i)) * math.pi) / self.cycle_length2) * self.rate)
				orb.x = self.basex + math.sin(timer) * self.square_width
				orb.x = self.basex + math.cos(timer) * self.square_height
			end
		end
	end
	if self.iris then
		local soul = Game.battle.soul
		self.iris_dir = MathUtils.round(MathUtils.angle(self.x, self.y, soul.x, soul.y) / 15) * 15
	end
end

function FireballMobius:draw()
	local scaler = 0
	self.sprite.scale_x = -scaler
	self.sprite.scale_y = scaler
    super.draw(self)
	if self.iris then
		local big = 0
		if self.width > 12 then
			big = 1
		end
		Draw.draw(self.iris_tex[big+1], -math.cos(self.iris_dir) * 4, -math.sin(self.iris_dir) * 4, self.iris_dir, 1, 1, 2, 3)
	end
end

return FireballMobius