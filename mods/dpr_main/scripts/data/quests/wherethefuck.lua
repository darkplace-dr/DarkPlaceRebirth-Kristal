---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "wherethefuck")

function MyQuest:init()
    super.init(self)
    self.name = "Into the Unknown"
    self.description = "Where The Hell Are You?"
    self.progress_max = 1
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return "You Know Where The Hell You Are."
	end
	return self.description
end

return MyQuest
