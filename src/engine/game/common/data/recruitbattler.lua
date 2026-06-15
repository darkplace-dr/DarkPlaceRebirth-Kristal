---@class RecruitBattler : Class
---
---@field name              string          The display name of this recruit
---
---
---@overload fun(...) : RecruitBattler
local RecruitBattler = Class()

function RecruitBattler:init()
    self.name = "Test Recruit"
    
    self.dialogue = nil
    
    self.actor_id = nil
    
    self.flip = false
end

function RecruitBattler:onTurnStart() end

function RecruitBattler:onUpdate() end

function RecruitBattler:onActionsEnd() end

return RecruitBattler

