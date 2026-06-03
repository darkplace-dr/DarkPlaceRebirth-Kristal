---@class DarkMenu : DarkMenu
local DarkMenu, super = HookSystem.hookScript(DarkMenu)

function DarkMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu_small")
end

return DarkMenu