local DanceRoom, super = Class(Map)

function DanceRoom:onEnter()
    super.onEnter(self)

    self:getTileLayer("Tile Layer 1"):addFX(LeaderColorFX())
    self:getTileLayer("Tile Layer 3"):addFX(LeaderColorFX())

    self:getEvent(41):addFX(LeaderColorFX())
    self:getEvent(42):addFX(LeaderColorFX())
end

return DanceRoom
