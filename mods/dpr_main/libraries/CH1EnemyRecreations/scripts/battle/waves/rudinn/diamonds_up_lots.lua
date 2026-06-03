local DiamondsUpLots, super = Class(Wave)

function DiamondsUpLots:init()
	super.init(self)
	
    self.time = 140/30
end

function DiamondsUpLots:onStart()
    local ratio = self:getEnemyRatio()

    self.timer:every(1/15*ratio, function()
        for _, attacker in ipairs(self:getAttackers()) do
            local x = -100 + love.math.random(200)
            local y = 140 + love.math.random(40)
            local num = Utils.pick{0, 1, 2, 3}
            if (num == 3) then
                x = -10 + love.math.random(20)
            end

            self:spawnBullet("rudinn/diamond_mix", Game.battle.soul.x + x, Game.battle.soul.y + y, math.rad(270))
        end
    end)
end

function DiamondsUpLots:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return DiamondsUpLots