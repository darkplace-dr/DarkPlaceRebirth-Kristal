local DDeltaJamKikkyWorld, super = Class(Map)

function DDeltaJamKikkyWorld:init(world, data)
	super.init(self, world, data)
end

function DDeltaJamKikkyWorld:onEnter()
	super.onEnter(self)
	local grid = self:getTileLayer("grid")
	grid.visible = false
end

function DDeltaJamKikkyWorld:update()
	super.update(self)
end

return DDeltaJamKikkyWorld