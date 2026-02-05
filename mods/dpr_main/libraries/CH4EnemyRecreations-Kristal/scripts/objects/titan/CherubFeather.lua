---@class CherubFeather : Sprite
---@overload fun(...) : CherubFeather
local CherubFeather, super = Class(Sprite)

function CherubFeather:init(x, y)
    super.init(self, "effects/titan/cherub_feathers", x, y)
	
	self:stop()
	self:setFrame(MathUtils.randomInt(1, (self.frames and #self.frames or 1) + 1))
	
	self.physics.match_rotation = false
	self.physics.speed = MathUtils.random(5, 15)
	self.physics.friction = 2
	self.fallspeed = 0
	self.siner = MathUtils.random(94.24777960769379) -- ???
	self.spinner = 0
	self.spin_start = MathUtils.randomInt(-90, 90)
	self.spin_offset = self.spin_start
	self.lifetime = 30
	self.removing = false
    self:setOriginExact(12, 11)
    self:setScale(2,2)
end

function CherubFeather:update()
	if self.physics.speed < 5 then
		self.physics.friction = 0.2
	end
	if self.physics.speed < 2 then
		self.fallspeed = MathUtils.approach(self.fallspeed, 1, 0.05 * DTMULT)
	end
	self.y = self.y + self.fallspeed * DTMULT
	self.x = self.x + math.sin(self.siner / 15) * ((self.fallspeed / 2) * DTMULT)
	self.siner = self.siner + DTMULT
	self.rotation = -math.rad((-math.cos(self.siner / 15) * 30) + self.spin_offset)
	
	if self.spinner < 1 then
		local spinease = MathUtils.easeOutAccurate(self.spinner, 2)
		self.spinner = self.spinner + 0.1 * DTMULT
		self.spin_offset = MathUtils.lerp(self.spin_start, 0, spinease)
	end
	if self.fallspeed == 1 then
		self.lifetime = self.lifetime - DTMULT
	end
	if self.lifetime <= 0 and not self.removing then
		self:fadeOutSpeedAndRemove(0.1)
		self.removing = true
	end
    super.update(self)
end

return CherubFeather