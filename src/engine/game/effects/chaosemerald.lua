---@class ChaosEmerald : Sprite
---@overload fun(...) : ChaosEmerald
local ChaosEmerald, super = Class(Sprite)

function ChaosEmerald:init(sprite, color, index, x, y, layer)
    super.index(self, sprite or "effects/chaos_emerald", color, index, x, y, layer)

    self:setOrigin(0.5, 0.5)
    self:setScale(1.5)

    self.siner = 0
    self.layer = 0
    self.index = index
    self:setColor(color)
end

return ChaosEmerald