local Spotlights, super = Class(Wave)

function Spotlights:init()
    super.init(self)

    self.time = 270/30
	self.spotlight = nil
end

function Spotlights:onStart()
    local attackers = #self:getAttackers()           --scr_monsterpop()
    local enemies = #Game.battle:getActiveEnemies()  --sameattack
    local arena = Game.battle.arena
	
	self.spotlight = self:spawnBullet("mizzle/spotlightcontroller", arena.x, arena.y)
	self.spotlight.attackers = attackers
	self.spotlight.enemies = enemies
	self.spotlight:setInfo()
end

return Spotlights