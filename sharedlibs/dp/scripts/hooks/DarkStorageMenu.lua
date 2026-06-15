---@class DarkStorageMenu : DarkStorageMenu
local DarkStorageMenu, super = HookSystem.hookScript(DarkStorageMenu)

function DarkStorageMenu:init(top_storage, bottom_storage)
    super.init(self, top_storage, bottom_storage)

    self.heart:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return DarkStorageMenu