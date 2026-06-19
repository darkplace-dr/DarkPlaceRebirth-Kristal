---@class quest : Quest
local quest, super = Class(Quest, "plushies_for_silver")

function quest:init()
    super.init(self)
    self.name = "Plushies for Silver"

    self.description = "Silver from The Tower's south hub kindly asked you to bring all plushies you find to her."
    self.progress_max = 0

    self.plush_flags = {
        ["dess"] = function() return Game:getFlag("dess_plush", false) end,
        ["hero"] = function() return Game:getFlag("hero_plush", false) end,
        ["silver"] = function() return Game:getFlag("silver_plush", false) end,
    }

    self.progress_max = TableUtils.getKeyCount(self.plush_flags)
end

function quest:getDescription()
	if self:isCompleted() then
		return "Now she can play with as many cute plushies as she wants."
	end
	return self.description
end

function quest:isUnlocked()
    return super.isUnlocked(self) and Game:getFlag("hub_silver_npc_progress", 0) > 0
end

function quest:getProgress()
    local points = 0
    for _, v in pairs(self.plush_flags) do
        if v() == true then points = points + 1 end
    end
    return points
end

function quest:setProgress(v)
    
end

return quest
