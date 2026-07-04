local SpinPetalMaker, super = Class(Event)

function SpinPetalMaker:init(data)
	super.init(self, data)
	local properties = data and data.properties or {}
	self.petal_rate = 35
	self.timer = 0
	self.preheat_count = 0
end

function SpinPetalMaker:onAdd(parent)
    super.onAdd(self,parent)
	for i = 0, 100 do
		self:makePetal(true)
	end
end

function SpinPetalMaker:makePetal(preheated)
    local petal = WaterSpinPetal(MathUtils.random(self.x, self.x + self.width, self.y + self.height))
	petal.physics.speed_y = 0.8 + MathUtils.random(0.5)
	petal.layer = self.layer
	if preheated then
		petal.y = petal.y + (self.preheat_count * self.petal_rate * petal.physics.speed_y)
		self.preheat_count = self.preheat_count + 1
	end
	Game.world:addChild(petal)
end

function SpinPetalMaker:update()
    super.update(self)
	self.timer = self.timer + DTMULT
	if self.timer >= self.petal_rate then
		self:makePetal(false)
		self.timer = 0
	end
end

return SpinPetalMaker