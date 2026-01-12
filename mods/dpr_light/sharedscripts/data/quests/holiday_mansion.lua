---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "holiday_mansion")

function MyQuest:init()
    super.init(self)
    self.name = "Holiday Mansion Mystery"
    self.description = "Seems like the Holidays haven't showed up in a while. Perhaps it's time to visit them yourself? Go search for a way to open the gate to their house. Perhaps the mayor's office would be a good place to start."
    self.progress_max = 0
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return ""
	elseif self:getProgress() == 1 then
		return ""
	end
	return self.description
end

return MyQuest
