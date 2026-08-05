local FlowershopHangingLight, super = Class(Sprite)

function FlowershopHangingLight:init(x, y, color)
    super.init(self, "world/events/flowershop_hanging_light", x, y)

    self:setOriginExact(15, 0)
    self:setScale(2)
    self:setLayer(WORLD_LAYERS["above_events"])
    self.color = color or {1, 1, 1}
end

return FlowershopHangingLight
