---@class DarkPartyMenu : DarkPartyMenu
local DarkPartyMenu, super = HookSystem.hookScript(DarkPartyMenu)

function DarkPartyMenu:init(selected)
    super.init(self, selected)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return DarkPartyMenu