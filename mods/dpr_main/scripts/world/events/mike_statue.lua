local MikeStatue, super = Class(Event, "mike_statue")

function MikeStatue:init(data)
    super.init(self, data)
	
	self.texture = data.properties["sprite"] or "world/events/mike_statue/shush_1"
	self.solid = true
	self:setSprite(self.texture)
	self.act = false
	self.timer = 0
	self:setHitbox(10, 80, 40, 40)
end

function MikeStatue:update()
	if self.act then
		self.sprite.x = MathUtils.randomInt(-1, 2)
		self.sprite.y = MathUtils.randomInt(-1, 2)
		self.timer = self.timer + DTMULT
		
		if self.timer > 10 then
			self.act = false
			self.timer = 0
			self.sprite.x = 0
			self.sprite.y = 0
		end
	end
	super.update(self)
end

return MikeStatue