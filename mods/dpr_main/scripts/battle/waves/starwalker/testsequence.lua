---@class Wave.starwalker.testsequence : SequenceWave
local seq, super = Class(SequenceWave)

function seq:init()
    super.init(self)
    self:addWave("starwalker/starcomets")
    self:addDelay(.5,true)
    self:addWave("starwalker/staract")
    self:addDelay(.5,true)
    self:addWave("starwalker/starup")
    self:addDelay(.5,true)
    self:addWave("starwalker/stardust")
    self:addDelay(.5,true)
    self:addWave("starwalker/starwingsfaster")
end

return seq