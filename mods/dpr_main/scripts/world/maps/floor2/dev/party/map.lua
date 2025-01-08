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

    local susie = self:getEvent(63)
    if Game:hasUnlockedPartyMember("susie") == false or Game:hasPartyMember("susie") then
        susie:remove()
    end
    local hero = self:getEvent(64)
    if Game:hasUnlockedPartyMember("hero") == false or Game:hasPartyMember("hero") then
        hero:remove()
    end
end

return PartyRoom