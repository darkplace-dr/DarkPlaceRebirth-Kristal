---@class SoulGlowEffect : Sprite
---@overload fun(...) : SoulGlowEffect
local SoulGlowEffect, super = Class(Sprite)

function SoulGlowEffect:init(x, y, sprite_override)
    local sprite
    super.init(self, sprite_override or (Game:isLight() and "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart") or "player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_dodge", x or 0, y or 0)

    self:setOrigin(0.5, 0.5)
    self.alpha = 0
    self.image_alpha_increase = 0.1
end

function SoulGlowEffect:update()
    local soul = Game.world.soul
    if Game.battle then
        soul = Game.battle.soul
    end

    if soul.inv_timer == 0 then
        self.alpha = self.alpha + self.image_alpha_increase * DTMULT
        if self.alpha >= 1 then
            self.alpha = 1
            self.image_alpha_increase = -self.image_alpha_increase
        end
        if self.alpha <= 0 then
            self.alpha = 0
            self.image_alpha_increase = -self.image_alpha_increase
        end
    else
        self.alpha = 0
        self.image_alpha_increase = math.abs(self.image_alpha_increase)
    end

    if Game.pp <= 0 then
        self:remove()
    end

    super.update(self)
end

return SoulGlowEffect