local PinkTree, super = Class(Event)

function PinkTree:init(data)
    super.init(self, data)

    local properties = data and data.properties or {}
    self:setSprite("world/events/pinktree")
	self:setOrigin(0.5, 1)
	self.scale_x = properties["flip"] and -1 or 1
end

function PinkTree:update()
	super.update(self)
	-- TODO: Platformer-specific code
end

return PinkTree