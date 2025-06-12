---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "stargazer")

function MyQuest:init()
    super.init(self)
    self.name = "StarGazer"
    self.description = "Arlee has sent you to search StarBits, what does she want with them anyway?"
    self.progress_max = 5
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return "The star has lend you her strength, use it wisely."
	end
	return self.description
end

return MyQuest
