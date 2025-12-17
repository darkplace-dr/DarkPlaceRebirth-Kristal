---@class SoulExapndEffect : Sprite
---@overload fun(...) : SoulExapndEffect
local SoulExapndEffect, super = Class(Sprite)

function SoulExapndEffect:init(x, y, sprite_override)
    super.init(self, Game:isLight() and "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart" or "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_dodge", x or 0, y or 0)

    self:setOrigin(0.5, 0.5)
end

function SoulExapndEffect:update()
    self.scale_x = self.scale_x + 0.1 * DTMULT
    self.scale_y = self.scale_y + 0.1 * DTMULT
    self.alpha = self.alpha - 0.05 * DTMULT

    if self.alpha <= 0 then
        self:remove()
    end

    super.update(self)
end

return SoulExapndEffect