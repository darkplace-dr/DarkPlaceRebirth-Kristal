---@class Choicebox : Choicebox
local Choicebox, super = HookSystem.hookScript(Choicebox)

function Choicebox:init(x, y, width, height, battle_box, options)
    super.init(self, x, y, width, height, battle_box, options)

    self.heart = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return Choicebox