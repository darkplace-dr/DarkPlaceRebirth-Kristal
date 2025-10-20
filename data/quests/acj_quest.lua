---@class AcJQuest : Quest
local AcJQuest, super = Class(Quest, "acj_quest")

function AcJQuest:init()
    super.init(self)
    self.name = "AcousticFamily"
    self.description = "Jamm's daughter, Marcy, states that her father mentioned a secret area in Deoxtest. Where could it be...?"
    self.progress = 0
    self.progress_max = 0
end

function AcJQuest:isVisible()
    return Game:getFlag("acj_quest_prog", nil) ~= nil
end

function AcJQuest:getDescription()
	if Game:getFlag("acj_quest_prog", 0) == 1 then
		return "You found Jamm in the forest. However, something seems off about him. Not only that, but the forest seems different than when you entered. Try to find your way out!"
	elseif Game:getFlag("acj_quest_prog", 0) == 2 then
		return "You found Jamm (for real this time) during your battle against Enzio. Jamm asked you to arrive to his apartment so he could properly thank you."
	elseif Game:getFlag("acj_quest_prog", 0) == 3 then
		return "Jamm is now a part of your team!"
	end
	return self.description
end

return AcJQuest
