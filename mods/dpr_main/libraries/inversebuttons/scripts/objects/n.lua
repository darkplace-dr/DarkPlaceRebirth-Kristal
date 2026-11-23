---@class n : Event
local n, super = Class(Event)

function n:init(x, y, shape)
    super.init(self, x, y, shape)
    self.solid = false
end

return n
