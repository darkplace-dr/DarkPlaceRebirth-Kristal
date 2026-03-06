local ZapperLaser, super = Class(Wave)

function ZapperLaser:init()
	super.init(self)
	
	self.time = 260/30
	self.linedraw = nil
	self.afterimages = {}
	self.laserballs = {}
end

function ZapperLaser:onStart()
    local attackers = self:getAttackers()
    local enemies = Game.battle:getActiveEnemies()
    for i, attacker in ipairs(attackers) do
        attacker.alpha = 0

		local attacker_x, attacker_y = attacker:getRelativePos(0, 30)
		local laser = self:spawnBullet("zapper/laser_manager", attacker_x - 18, attacker_y - 28)
		laser.reload = reload
		laser.layer = attacker.layer
		laser.sameattack = #attackers
		laser.sameattacker = i - 1
		laser.attackerid = attacker
		if #enemies ~= #attackers then
			laser.nuisance = 1
		end
		for _, bullet in ipairs(self.bullets) do
			if bullet and bullet.id == "zapper/laser_manager" then
				bullet:startAnimation()
				bullet.fire_timer = 30 + (3 * (i - 1))
			end
		end
	end
	self.linedraw = self:spawnObject(ZapperLaserLineDraw())
	self.linedraw.layer = Game.battle.arena.layer + 0.1
end

function ZapperLaser:onEnd()
    for _, attacker in ipairs(self:getAttackers()) do
        attacker.alpha = 1
		if attacker.id == "zapper" then
			attacker:onTurnEnd()
		end
    end
    for _, ball in ipairs(self.laserballs) do
		if ball then
			ball:remove()
		end
    end
    for _, img in ipairs(self.afterimages) do
		if img then
			img:remove()
		end
    end
end

return ZapperLaser