local Saws, super = Class(Wave)

function Saws:init()
    super.init(self)
	
    self.time = 300/30

    self.btimer = 99
    self.enemies = self:getAttackers()
	self.sameattack = #self.enemies
end

function Saws:update()
    local ratio = self:getEnemyRatio()
    local arena = Game.battle.arena
    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer

    self.btimer = self.btimer + DTMULT

	for sameattacker = 0, #self.enemies-1 do
        if (self.btimer - (6 * sameattacker)) > (30 + (10 * ratio)) and remaining_time > (20/30) then
            self.btimer = 0

            local section = (140 / self.sameattack) * sameattacker
            local doy = (arena.y - 70) + (MathUtils.randomInt(140 / self.sameattack) + 1) + section

            local saw = self:spawnBullet("wicabel/saw", arena.x - 135, doy, 0, -5 - MathUtils.random(2))
            saw.alarm_0 = 1
            saw.delay = math.ceil(saw.delay * math.sqrt(ratio))
            saw.physics.gravity_direction = -math.rad(0)
            saw.physics.gravity = 0.5
        end
    end

    super.update(self)
end

function Saws:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return Saws