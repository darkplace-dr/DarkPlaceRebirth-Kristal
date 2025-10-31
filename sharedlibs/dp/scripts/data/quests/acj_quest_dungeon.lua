---@class AcJQuest : Quest
local AcJQuest, super = Class(Quest, "acj_quest_dungeon")

function AcJQuest:init()
    super.init(self)
    self.name = "Jamm's Closure"
    self.description = "Jamm revealed to you the reason why he hates Enzio so much. He says to head back to the TOMBSITE and walk \"left, down, right, up\". What will you find in the new area Jamm told you about?"
    self.progress = 0
    self.progress_max = 0
end

function AcJQuest:isVisible()
    return Game:getFlag("acj_quest_dungeon_prog", nil) ~= nil
end

function AcJQuest:getDescription()
	if Game:getFlag("acj_quest_dungeon_prog", 0) == 1 then
		return "As Jamm and Dess walked into the dungeon, the door locked behind them. The two must progress through the dungeon, all while Jamm tries not to be annoyed to death by Dess."
	elseif Game:getFlag("acj_quest_dungeon_prog", 0) == 2 then
		if Game:getFlag("dungeonkiller") then
			return "Jamm and Dess escape the dungeon, but something seems wrong with Jamm. He may never be back to his old self again."
		else
			return "Jamm and Dess escape the dungeon. It turns out that the two really can work well together when they actually try to. Perhaps they could eventually end up as friends? ...Maybe not, but Jamm could tolerate Dess slightly more."
		end
	end
	return self.description
end

return AcJQuest
