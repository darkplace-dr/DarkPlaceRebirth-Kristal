---@class GrazeSprite : GrazeSprite
local GrazeSprite, super = HookSystem.hookScript(GrazeSprite)

function GrazeSprite:init(x, y)
    super.init(self, x, y)

    self.texture = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/graze")
end

return GrazeSprite