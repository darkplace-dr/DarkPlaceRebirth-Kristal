---@class Character : Character
local Character, super = HookSystem.hookScript(Character)

function Character:init(actor,x,y)
    super.init(self,actor,x,y)
    self.inherit_color = true
end

return Character