---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "mainline")

function MyQuest:init()
    super.init(self)
    self.name = "Dark Place: REBIRTH"
    self.description = "This is the Mainline quest. This is hardcoded into the library for the main story of your mod. The ID for this quest is 'mainline', so you can change the description by overriding it."
    self.progress = 0
    self.progress_max = 0
end

return MyQuest
