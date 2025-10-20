---@class PartyMember.hero : PartyMember
local hero, super = Class("hero", true)

function hero:init()
    super.init(self)
    self:setDepthsActor("hero_depths")
end

return hero