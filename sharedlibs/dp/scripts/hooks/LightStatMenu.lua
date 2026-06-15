---@class LightStatMenu : LightStatMenu
local LightStatMenu, super = HookSystem.hookScript(LightStatMenu)

function LightStatMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return LightStatMenu