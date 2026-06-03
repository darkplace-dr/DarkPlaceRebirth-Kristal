---@class MyQuest : Quest
local NoelleQuest, super = Class(Quest, "noellemissing")

function NoelleQuest:init()
    super.init(self)
    self.name = "Lost Girl"
    self.description = "Susie mentioned Noelle not being with her when she entered the Dark World. Go search for clues on her wherabouts."
    self.progress_max = 2
end

function NoelleQuest:getDescription()
	if self:isCompleted() then
		return "You saved Noelle!" -- add description here after saving Noelle
	elseif self:getProgress() == 1 then
		return "Noelle." -- add description here after finding Noelle
	end
	return self.description
end

return NoelleQuest
