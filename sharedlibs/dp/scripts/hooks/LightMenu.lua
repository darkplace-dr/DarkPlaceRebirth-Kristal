---@class LightMenu : LightMenu
local LightMenu, super = HookSystem.hookScript(LightMenu)

function LightMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return LightMenu