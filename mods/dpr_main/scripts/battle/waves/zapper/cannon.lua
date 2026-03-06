local ZapperCannon, super = Class(Wave)

function ZapperCannon:init()
	super.init(self)
	
	self.time = 200/30
end

function ZapperCannon:onStart()
    local attackers = self:getAttackers()
	local reload = 32
    local enemies = Game.battle:getActiveEnemies()
    for _, enemy in ipairs(enemies) do
		if enemy.id == "shuttah" then
			reload = 40
		end
	end
    for i, attacker in ipairs(attackers) do
        attacker.alpha = 0

		local attacker_x, attacker_y = attacker:getRelativePos(0, 30)
		local cannon = self:spawnBullet("zapper/cannon_manager", attacker_x - 18, attacker_y - 28)
		cannon.reload = reload
		cannon.layer = attacker.layer
		cannon.attacker = i - 1
		cannon.attackerid = attacker
		local zapper_cannon_reload_ratio = 1
		if #enemies ~= #attackers then
			if #enemies == 2 then
				zapper_cannon_reload_ratio = 1.6
			end
			if #enemies >= 3 then
				zapper_cannon_reload_ratio = 2.3
			end
		end
		for _, bullet in ipairs(self.bullets) do
			if bullet and bullet.id == "zapper/cannon_manager" then
				bullet:startAnimation()
				bullet.fire_timer = bullet.fire_timer + (i - 1) * bullet.reload * zapper_cannon_reload_ratio
				bullet.reload = bullet.reload * (#attackers * zapper_cannon_reload_ratio)
			end
		end
	end
end

function ZapperCannon:onEnd()
    for _, attacker in ipairs(self:getAttackers()) do
        attacker.alpha = 1
		if attacker.id == "zapper" then
			attacker:onTurnEnd()
		end
    end
end

return ZapperCannon