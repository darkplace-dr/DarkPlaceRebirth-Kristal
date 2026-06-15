---@class Shop : Shop
local Shop, super = HookSystem.hookScript(Shop)

function Shop:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return Shop