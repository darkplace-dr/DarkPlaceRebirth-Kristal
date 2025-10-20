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
    self:getEvent(66):addFX(LeaderColorFX())

    local susie = self:getEvent(63)
    if Game:hasUnlockedPartyMember("susie") == false or Game:hasPartyMember("susie") then
        susie:remove()
    end
    local hero = self:getEvent(64)
    if Game:hasUnlockedPartyMember("hero") == false or Game:hasPartyMember("hero") then
        hero:remove()
    end
    local dess = self:getEvent(68)
    if Game:hasUnlockedPartyMember("dess") == false or Game:hasPartyMember("dess") then
        dess:remove()
    end
    local noelle = self:getEvent(69)
    if Game:hasUnlockedPartyMember("noelle") == false or Game:hasPartyMember("noelle") then
        noelle:remove()
    end
    local berdly = self:getEvent(70)
    if Game:hasUnlockedPartyMember("berdly") == false or Game:hasPartyMember("berdly") then
        berdly:remove()
    end
    local kris = self:getEvent(71)
    if Game:hasUnlockedPartyMember("kris") == false or Game:hasPartyMember("kris") then
        kris:remove()
    end
    local ralsei = self:getEvent(72)
    if Game:hasUnlockedPartyMember("ralsei") == false or Game:hasPartyMember("ralsei") then
        ralsei:remove()
    end
    local mario = self:getEvent(73)
    if Game:hasUnlockedPartyMember("mario") == false or Game:hasPartyMember("mario") then
        mario:remove()
    end
    local pauling = self:getEvent(74)
    if Game:hasUnlockedPartyMember("pauling") == false or Game:hasPartyMember("pauling") then
        pauling:remove()
    end
    local ostarwalker = self:getEvent(75)
    if Game:hasUnlockedPartyMember("ostarwalker") == false or Game:hasPartyMember("ostarwalker") then
        ostarwalker:remove()
    end
end

return PartyRoom