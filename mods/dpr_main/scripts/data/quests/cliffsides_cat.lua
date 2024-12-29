---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "cliffsides_cat")

function MyQuest:init()
    super.init(self)
    self.name = "Cliffside's Cat"
    self.description = "You have encountered a talking cat in this strage yet familliar location. It has asked you to follow it somewhere up north.\n\nPerhaps the way out is that way?"
    self.progress_max = 0
end

return MyQuest
