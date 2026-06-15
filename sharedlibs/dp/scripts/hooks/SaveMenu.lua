---@class SaveMenu : SaveMenu
local SaveMenu, super = HookSystem.hookScript(SaveMenu)

function SaveMenu:init(marker)
    super.init(self, marker)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return SaveMenu