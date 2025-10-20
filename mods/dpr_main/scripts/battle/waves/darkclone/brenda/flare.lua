local Flare, super = Class(Wave)

function Flare:init()
    super.init(self)
    self.time = -1
    local attacker = Game.battle.enemies[1]

    self.delay = math.ceil(1 + (3 * (1 - (attacker.health/attacker.max_health))))
end

function Flare:onStart()
    local attacker = Game.battle.enemies[1]
    attacker:setAnimation("point")

    if attacker.health/attacker.max_health < 0.25 then
        self:spawnBullet("darkclone/brenda/fireball", Game.battle.arena.right, Game.battle.arena.top, 0, 0)
    end

    Game.battle.timer:after(0.3, function()
        self.timer:every(1/self.delay, function()
            local x, y = attacker:getRelativePos(-22, attacker.height/2)
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            self:spawnBullet("darkclone/brenda/flare", x, y, angle, 12)
            Assets.stopAndPlaySound("noise")
            attacker:shake()
        end)
        Game.battle.timer:after(3 + math.ceil(1 + (6 * (1 - (attacker.health/attacker.max_health)))), function()
            attacker:setAnimation("idle")
            self.finished = true
        end)
    end)
end

function Flare:update()
    super.update(self)
end

return Flare