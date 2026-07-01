local HomingTriangle, super = Class(Wave)

function HomingTriangle:init()
	super.init(self)

    self.time = 200/30
	self.btimer = {99, 99, 99}
end

function HomingTriangle:update()
    local ratio = self:getEnemyRatio()
	for i, attacker in ipairs(self:getAttackers()) do
		self.btimer[i] = self.btimer[i] + DTMULT
		if self.btimer[i] - 90 >= ((10 * ratio) + (i * #self:getAttackers())) then
			self.btimer[i] = self.btimer[i] - (8 * ratio) + 3
			local soul = Game.battle.soul
			
			local dir = 30 + MathUtils.random(120)
			local radius = 140 + MathUtils.random(80)
			local x = MathUtils.lengthDirX(radius, math.rad(dir))
			local y = MathUtils.lengthDirY(radius, math.rad(dir))
			
			local triangle = self:spawnBullet("floradinn/triangle_black", soul.x + x, soul.y + y)
			if triangle.y < 40 then
				triangle.y = 40
			end
			triangle.attackers = self:getAttackers()
		end
    end
end

function HomingTriangle:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return HomingTriangle