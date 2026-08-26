local DDeltaJamRoom, super = Class(Map)

function DDeltaJamRoom:init(world, data)
	super.init(self, world, data)
end

function DDeltaJamRoom:onEnter()
	super.onEnter(self)
	self.kikky_screen = self:getEvent("jam26ddelta_kikkyscreen")
	if self.kikky_screen then
		self.world.kikky_world.player:setColor(COLORS.dkgray)
	end
end

return DDeltaJamRoom