---@class DarkConfigMenu : DarkConfigMenu
local DarkConfigMenu, super = HookSystem.hookScript(DarkConfigMenu)

function DarkConfigMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return DarkConfigMenu