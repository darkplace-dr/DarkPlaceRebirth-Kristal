local ScarecrowWobbler, super = Class(Bullet)

function ScarecrowWobbler:init(x, y)
    super.init(self, x, y, "battle/bullets/shi/scarecrow")

	self:setScale(2)
	self:setOriginExact(12, 23)
	self:setHitbox(11, 4, 2, 18)

	self.damage = 92
	self.time_bonus = 0
	self.tp = 0.4
	self.destroy_on_hit = false

	self.grazetimer = 0
	self.stall = 0
	self.flip = TableUtils.pick{ 1, -1 }

	self.timer = Timer()
	self:addChild(self.timer)
end

function ScarecrowWobbler:update()
	self.grazetimer = self.grazetimer + DTMULT

	if self.grazetimer >= 3 then
		self.grazed = false
		self.grazetimer = 0
	end

	if self.stall > 0 then
		self.stall = self.stall - DTMULT
	end

	if self.stall == 0 and (MathUtils.dist(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) < 65) then
		self.stall = 15 + math.ceil(math.abs(self.rotation) / 7)
		self.timer:tween(self.stall/30, self, { rotation = -math.rad(self.flip * 40) }, "linear")
		self.flip = self.flip * -1

	elseif self.stall == 0 and self.rotation ~= -math.rad(0) then
		self.stall = 15
		self.timer:tween(14/30, self, { rotation = -math.rad(0) }, "out-sine")
	end

    super.update(self)
end

return ScarecrowWobbler