local PartyRoom, super = Class(Map)

function PartyRoom:onEnter()
    super.onEnter(self)
	
    self.space_bg = Game.world:spawnObject(SpaceBG())
    self.space_bg.layer = WORLD_LAYERS["bottom"]
	
    self:getTileLayer("Tile Layer 1"):addFX(LeaderColorFX())
    self:getTileLayer("Tile Layer 2"):addFX(LeaderColorFX())
	
    self:getEvent(55):addFX(LeaderColorFX())
    self:getEvent(56):addFX(LeaderColorFX())
    self:getEvent(57):addFX(LeaderColorFX())
    self:getEvent(58):addFX(LeaderColorFX())
    self:getEvent(59):addFX(LeaderColorFX())
    self:getEvent(60):addFX(LeaderColorFX())
    self:getEvent(61):addFX(LeaderColorFX())
end

return PartyRoom