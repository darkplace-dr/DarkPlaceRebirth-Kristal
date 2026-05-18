---@class EasingSoul : EasingSoul
local EasingSoul, super = HookSystem.hookScript(EasingSoul)

function EasingSoul:init(x, y, target_x, target_y)
    super.init(self, x, y, target_x, target_y)

    self.sprite:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return EasingSoul