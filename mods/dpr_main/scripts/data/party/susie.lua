---@class PartyMember.susie : PartyMember
local susie, super = Class("susie", true)

function susie:init()
    super.init(self)
    self:setDepthsActor("susie_depths")
end

return susie