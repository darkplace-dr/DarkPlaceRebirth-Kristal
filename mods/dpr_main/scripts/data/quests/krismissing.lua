---@class MyQuest : Quest
local KrisQuest, super = Class(Quest, "krismissing")

function KrisQuest:init()
    super.init(self)
    self.name = "Where's Kris"
    self.description = "Susie mentioned Kris not being with her when she entered the Dark World. Go search for clues on their wherabouts."
    self.progress_max = 2
end

function KrisQuest:getDescription()
	if self:isCompleted() then
		return "Kris has been saved!" -- add description here after saving Kris
	elseif self:getProgress() == 1 then
		return "Kris." -- add description here after finding Kris
	end
	return self.description
end

return KrisQuest
