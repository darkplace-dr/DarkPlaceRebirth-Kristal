---@class HeartBurst : HeartBurst
local HeartBurst, super = HookSystem.hookScript(HeartBurst)

function HeartBurst:init(x, y, color)
    super.init(self, x, y, color)

    self.heart_outline_outer = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_outline_outer")
    self.heart_outline_inner = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_outline_inner")
    self.heart_outline_filled_inner = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_outline_filled_inner")
end

return HeartBurst