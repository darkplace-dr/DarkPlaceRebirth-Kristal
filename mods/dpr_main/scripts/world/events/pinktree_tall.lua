local PinkTreeTall, super = Class(Event)

function PinkTreeTall:init(data)
    super.init(self, data)

    local properties = data and data.properties or {}
    self:setSprite("world/events/pinktree_tall")
	self:setOrigin(0.5, 1)
	self.flip_x = properties["flip"] or false
end

function PinkTreeTall:update()
	super.update(self)
	-- TODO: Platformer-specific code
end

return PinkTreeTall