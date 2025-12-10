---@class FountainShadowFX : ShadowFX
---@overload fun(...) : FountainShadowFX
local ChurchShadowFX, super = Class(ShadowFX)

function ChurchShadowFX:init(priority)
    super.init(self, 0, nil, 0, priority)
end

function ChurchShadowFX:draw(texture)
    local alpha = self:getAlpha()
	
    local sx, sy = self.parent:getFullScale()

    Draw.setColor(1, 1, 1)
    Draw.draw(texture)

    local ox, oy, ow, oh = self:getObjectBounds()

    Draw.setColor(0, 0, 0, alpha)
    Draw.draw(texture, ox, oy+oh + (self.shadow_offset * sy), 0, 1, -self:getScale(), ox, oy+oh)
end

return ChurchShadowFX