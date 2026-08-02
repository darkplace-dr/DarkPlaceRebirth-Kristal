---@class DestructableClimbArea : FallingClimbArea
local DestructableClimbArea, super = Class(FallingClimbArea)

---@param x number?
---@param y number?
---@param shape EventShape?
---@param settings FallingClimbAreaSettings?
function DestructableClimbArea:init(x, y, shape, settings)
    settings = settings or {}
    shape = shape or { TILE_WIDTH, TILE_HEIGHT }
    super.init(self, x, y, shape)

    self.dont_break = settings.properties.break_Upward and { "down" } or nil
    self.breaks_on_leave = settings.properties.break_ontime or true
    self.fall_time = settings.properties.dangertime or 60
    self.timed = settings.properties.dangerous or false
    self.no_unsafe_area = false

    self.state = 0 -- 0 = idle, 1 = player overlapping, 2 = falling
    self.timer = 0

    if settings.properties.sprite then
        self:setSprite(settings.properties.sprite)
    else
        self:setSprite("world/events/climbtiles/brittle")
    end

    self.unsafe_area = nil
    Kristal.Console:warn("Replace DestructableClimbArea with FallingClimbArea!")
end

return DestructableClimbArea
