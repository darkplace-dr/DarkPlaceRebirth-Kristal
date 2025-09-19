---@class Event.tile_oscillate : Event
local event, super = Class(Event, "tile_oscillate")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
end

-- Optimization: Do nothing
function event:fullDraw() end

return event