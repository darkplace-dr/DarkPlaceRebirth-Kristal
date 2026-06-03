---@class LightSaveMenu : LightSaveMenu
local LightSaveMenu, super = HookSystem.hookScript(LightSaveMenu)

function LightSaveMenu:init(marker)
    super.init(self, marker)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return LightSaveMenu