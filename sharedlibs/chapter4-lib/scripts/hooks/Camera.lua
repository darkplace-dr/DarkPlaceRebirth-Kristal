---@class Camera : Camera
---@field tower CylinderTower
local Camera, super = HookSystem.hookScript(Camera)
---@cast super Camera

function Camera:init(parent, x, y, width, height, keep_in_bounds)
    super.init(self, parent, x, y, width, height, keep_in_bounds)
    self.climb = CameraClimbState(self)
    self.state_manager:addState("CLIMB", self.climb)
end

function Camera:getMinPosition(...)
    if not self.tower then
        return super.getMinPosition(self, ...)
    end
    local _, y = super.getMinPosition(self, ...)

    return -math.huge, y
end

function Camera:getMaxPosition(...)
    if not self.tower then
        return super.getMaxPosition(self, ...)
    end
    local _, y = super.getMaxPosition(self, ...)

    return math.huge, y
end

function Camera:updateAttached()
    super.updateAttached(self)
    if self.tower and self.tower:isRemoved() then
        self.tower = nil
    end
    if self.tower then
        self.x = self.parent.player.x
    end
end

return Camera
