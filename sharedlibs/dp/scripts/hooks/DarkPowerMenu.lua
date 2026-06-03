---@class DarkPowerMenu : DarkPowerMenu
local DarkPowerMenu, super = HookSystem.hookScript(DarkPowerMenu)

function DarkPowerMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return DarkPowerMenu