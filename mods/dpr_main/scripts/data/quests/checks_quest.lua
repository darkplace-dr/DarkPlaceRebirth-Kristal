---@class AcJQuest : Quest
local ChecksQuest, super = Class(Quest, "checks_quest")

function ChecksQuest:init()
    super.init(self)
    self.name = "Checks Quest 2"
    self.description = "The Hacker needs your help in finding the blue checksmarks again. Find the 3 blue checkmarks hidden around the Cyber City floor, then return to the Hacker."
    self.progress = 0
    self.progress_max = 3
end

function ChecksQuest:isVisible()
    return Game:getFlag("hackerSidequest", 0, 0) ~= 0
end

function ChecksQuest:getDescription()
	if self:isCompleted() then
		return "You recovered all three blue checkmarks, and thus this marks the end of your \"Checks Quest 2\"."
	elseif Game:getFlag("hackerCheckmarks", 0) >= 3 then
		return "You found all three of the blue checkmarks! Return to the Hacker to complete the quest."
	end
	return self.description
end

function ChecksQuest:getProgress() return Game:getFlag("hackerCheckmarks", 0) end

function ChecksQuest:isCompleted()
    return self:getProgressPercent() >= 1.0 and Game:getFlag("hackerSidequest", 0) >= 2
end

return ChecksQuest
