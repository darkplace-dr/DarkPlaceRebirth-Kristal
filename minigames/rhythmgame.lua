---@class RhythmGameMinigame : RhythmGame
local RhythmGameMinigame, super = Class(RhythmGame)

function RhythmGameMinigame:init(song, hardmode)
    super.init(self, song, hardmode)
end

return RhythmGameMinigame