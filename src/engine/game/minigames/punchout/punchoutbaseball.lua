---@class PunchOutHitbox : Object
local PunchOutBaseball, super = Class(Object)

function PunchOutBaseball:init(x, y, w, h)
    super.init(self, x, y, w, h)
end

function PunchOutBaseball:update()
    super.update(self)
end

function PunchOutBaseball:draw()
    super.draw(self)
end

return PunchOutBaseball