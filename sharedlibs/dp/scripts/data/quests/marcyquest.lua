---@class MyQuest : Quest
local MarcyQuest, super = Class(Quest, "marcyquest")

function MarcyQuest:init()
    super.init(self)
    self.name = "Patch the Pirate"
    self.description = "Marcy arrived on the ship her father went to, but not without punishment. Jamm lectured Marcy on the importance of not leaving the dark, and Marcy feels guilty. She thinks it would be best to talk to the captain."
    self.progress = 0
    self.progress_max = 0
end

function MarcyQuest:isVisible()
    return Game:getFlag("marcyquest_prog", nil) ~= nil
end

function MarcyQuest:getDescription()
	if Game:getFlag("marcyquest_prog", 0) == 1 then
		return "Marcy talked to the captain and, as it turns out, she was able to join the crew for now. She decided it would be best if she took her time to explore for now."
	elseif Game:getFlag("marcyquest_prog", 0) == 2 then
		return "As the ship stops for maintenance, Jamm and Marcy decide to explore the stone island before them. This seems like the perfect opportunity for them to bond."
	elseif Game:getFlag("marcyquest_prog", 0) == 3 then
		return "After the ambush, Jamm brought Marcy to the ship for medical aid. As soon as Marcy wakes up, she learns that her father is currently fighting. She decides to help her father out."
	end
	return self.description
end

return MarcyQuest
