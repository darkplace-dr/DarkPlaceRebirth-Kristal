---@class ClimbEntry : ClimbEntry
local ClimbEntry, super = HookSystem.hookScript(ClimbEntry)

function ClimbEntry:onLoad()
    if not (self.target == nil and self.target_identifier == nil) then
        return super.onLoad(self)
    end
    Kristal.Console:warn(string.format("ClimbEntry at (%d, %d) has invalid or missing target.", self.x, self.y))
    local marker_ref = "AutoGenMarkerThisSucks_" .. tostring(self) .. ""
    local up = self.data.properties.up and true or false
    Game.world.map.markers[marker_ref] = {
        center_x = self.x + TILE_WIDTH / 2,
        center_y = self.y + (TILE_HEIGHT * (up and -0.5 or 2)),
    }
    local exit = ClimbExit(self.x, self.y + (TILE_HEIGHT * (up and 1 or -1)), {self.width, math.min(self.height, TILE_HEIGHT)}, {
        target = marker_ref
    })
    self.parent:addChild(exit)
    exit:setLayer(self.layer)
    exit:onLoad()
    self.target = exit

    return super.onLoad(self)
end

return ClimbEntry
