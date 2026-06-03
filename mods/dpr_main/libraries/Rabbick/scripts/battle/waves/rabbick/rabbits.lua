local Rabbits, super = Class(Wave)

function Rabbits:init()
	super.init(self)
	
	self.time = 170/30
    self.btimer = 99
end

function Rabbits:update()
    self.btimer = self.btimer + (1 * DTMULT)

    local bmax = self:getEnemyRatio()

    if self.btimer >= bmax then
        for _, attacker in ipairs(self:getAttackers()) do
            local x = Game.battle.arena.x + Game.battle.arena.width
            local y = Game.battle.arena.y

            self:spawnBullet("rabbick/rabbit", x, y)

            self.btimer = 0
        end
    end

    super.update(self)
end

function Rabbits:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 34
    elseif enemies == 2 then
        return 46
    elseif enemies >= 3 then
        return 60
    end
end

return Rabbits