---@class DarkEquipMenu : DarkEquipMenu
local DarkEquipMenu, super = HookSystem.hookScript(DarkEquipMenu)

function DarkEquipMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return DarkEquipMenu