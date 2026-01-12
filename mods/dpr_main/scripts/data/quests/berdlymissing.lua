---@class MyQuest : Quest
local BerdlyQuest, super = Class(Quest, "berdlymissing")

function BerdlyQuest:init()
    super.init(self)
    self.name = "Missing Berd"
    self.description = "Susie mentioned Berdly not being with her when she entered the Dark World. Go search for clues on his wherabouts."
    self.progress_max = 2
end

function BerdlyQuest:getDescription()
	if self:isCompleted() then
		return "Berdly has been saved! Unfortunatly the gaming stations used to access him seem to not be working anymore, so returning to that place seems to be impossible, at least for now."
	elseif self:getProgress() == 1 then
		return "Berdly, alongside Hero and Susie are locked inside a video game in the Cybercity! Perhaps Spamton has the way out? Use a bomb to blow up the door to the house he's in!"
	end
	return self.description
end

return BerdlyQuest
