---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "cliffsides_cat")

function MyQuest:init()
    super.init(self)
    self.name = "Cliffside's Cat"
    self.description = "You have encountered a talking cat in this strage yet familliar location. It has asked you to follow it somewhere up north.\n\nPerhaps the way out is that way?"
    self.progress_max = 0
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return "The cat has taught you everything there is to know about this world. Now it wants you to return to where you first met it, as it has a friend that will show you the way forward."
	end
	return self.description
end

return MyQuest
