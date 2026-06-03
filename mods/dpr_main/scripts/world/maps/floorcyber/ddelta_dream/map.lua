local Room1, super = Class(Map)

function Room1:init(world, data)
    super.init(self, world, data)
	self.siner = 0
end

function Room1:onEnter()
    super.onEnter(self)
	self.diamond = self:getEvent("diamonds_symbol")
	for _, follower in ipairs(Game.world.followers) do
		follower.visible = false
	end
end

function Room1:update()
    super.update(self)
	if self.diamond then
		self.siner = self.siner + DTMULT
		self.diamond.y = 400 + math.sin(self.siner / 10) * 8
	end
end

return Room1