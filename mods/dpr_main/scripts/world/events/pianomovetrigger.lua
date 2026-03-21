local PianoMoveTrigger, super = Class(Event)

function PianoMoveTrigger:init(data)
    super.init(self, data)

    local properties = data and data.properties or {}
	self.solid_breakable = true
    self.solid = properties["solid"] ~= false
	self.extflag = properties["extflag"] or ""
end

return PianoMoveTrigger