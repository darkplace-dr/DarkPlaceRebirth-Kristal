---@class Quest.mainline : Quest
local quest, super = Class("mainline", true)

function quest:init()
    super.init(self)
    self.description = "Reality is collapsing in on itself and that's lame as hell so don't do that idiot"
end

return quest

