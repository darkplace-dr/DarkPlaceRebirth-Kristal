local TeevieFloorLight, super = Class(Event)

function TeevieFloorLight:init(data)
    super.init(self, data)
	
    self:setSprite("world/events/teevie_light/base")
	self.sprite:setScale(2,2)
	self.light = Sprite("world/events/teevie_light/light", self.x + 20,  self.y + 20)
	self.light:setScale(2,2)
	self.light.alpha = 0.15
	self.light:setOriginExact(6, 22)
	Game.world:addChild(self.light)

    self.light_active = false
	
	local properties = data.properties or {}
	
	self.odd = properties["odd"] ~= false
	self.timer = 0
	if self.odd then
		self.timer = 1
	end
	self.paused = false
	self.dont_unpause = false
	local can_kill = Game:getFlag("can_kill", false)
	if can_kill then
		self.paused = true
		self.dont_unpause = true
		self.light.alpha = 0
	end
end

function TeevieFloorLight:onLoad()
    super.onLoad(self)
	
	self.light:setLayer(Game.world:parseLayer("objects"))
end

function TeevieFloorLight:pause()
	if self.dont_unpause then return end
	self.paused = true
	Game.world.timer:after(1/30, function()
		Game.world.timer:tween(15/30, self.light, {alpha = 0}, "out-cubic")
	end)
end

function TeevieFloorLight:unpause()
	if self.dont_unpause then return end
	self.paused = false
	self.timer = 1
end

function TeevieFloorLight:update()
    super.update(self)

	if self.paused then return end
	self.timer = self.timer + DT
	if self.timer >= 1 then
		if self.light_active then
			self.light_active = false
			Game.world.timer:tween(15/30, self.light, {alpha = 0.15}, "out-cubic")
		else
			self.light_active = true
			Game.world.timer:tween(15/30, self.light, {alpha = 0.35}, "out-cubic")
		end
		self.timer = 0
	end
end

return TeevieFloorLight