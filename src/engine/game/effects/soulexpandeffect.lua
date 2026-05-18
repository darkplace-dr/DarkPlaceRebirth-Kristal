---@class SoulExpandEffect : Sprite
---@overload fun(...) : SoulExpandEffect
local SoulExpandEffect, super = Class(Sprite)

function SoulExpandEffect:init(x, y, sprite_override)
    super.init(self, sprite_override or (Game:isLight() and "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart") or "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_dodge", x or 0, y or 0)

    self:setOrigin(0.5, 0.5)
end

function SoulExpandEffect:update()
    self.scale_x = self.scale_x + 0.2 * DTMULT
    self.scale_y = self.scale_y + 0.2 * DTMULT
    self.alpha = self.alpha - 0.05 * DTMULT

    if self.alpha <= 0 then
        self:remove()
    end

    super.update(self)
end

return SoulExpandEffect