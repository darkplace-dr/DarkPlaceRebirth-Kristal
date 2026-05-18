---@class SimpleSaveMenu : SimpleSaveMenu
local SimpleSaveMenu, super = HookSystem.hookScript(SimpleSaveMenu)

function SimpleSaveMenu:init(save_id, marker)
    super.init(self, save_id, marker)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return SimpleSaveMenu