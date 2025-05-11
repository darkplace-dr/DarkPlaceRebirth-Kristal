---@class RareCatsMinigame : RareCats
local RareCatsMinigame, super = Class(RareCats)

function RareCatsMinigame:init()
    super.init(self)

    self.name = self.name
end

return RareCatsMinigame