---@class GonerChoice : GonerChoice
local GonerChoice, super = HookSystem.hookScript(GonerChoice)

function GonerChoice:init(x, y, choices, on_complete, on_select)
    super.init(self, x, y, choices, on_complete, on_select)

    self.soul:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_blur")
end

return GonerChoice