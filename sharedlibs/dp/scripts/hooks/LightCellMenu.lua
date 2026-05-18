---@class LightCellMenu : LightCellMenu
local LightCellMenu, super = HookSystem.hookScript(LightCellMenu)

function LightCellMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return LightCellMenu