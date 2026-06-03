local EventSolid, super = Class(Event)

function EventSolid:init(data)
    super.init(self, data)
	
	local properties = data and data.properties or {}
    self.solid = properties["solid"] or true
end

return EventSolid