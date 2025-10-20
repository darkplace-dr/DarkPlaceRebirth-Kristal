---@class AngryBirdsMinigame : AngryBirds
local AngryBirdsMinigame, super = Class(AngryBirds)

function AngryBirdsMinigame:init()
    super.init(self)

    self.name = self.name
end

return AngryBirdsMinigame