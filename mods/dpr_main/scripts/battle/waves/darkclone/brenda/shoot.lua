local Shoot, super = Class(Wave)

function Shoot:init()
    super.init(self)
    self.time = -1
    local attacker = Game.battle.enemies[1]

    self.vollies = math.ceil(3 + (7 * (1 - (attacker.health/attacker.max_health))))
    self.volly_delay = math.ceil(100 - (40 * (1 - (attacker.health/attacker.max_health))))/100
end

function Shoot:onStart()
    local reticle = self:spawnBullet("darkclone/brenda/reticle", Game.battle.soul.x, Game.battle.soul.y, 0, 0)
    local attacker = Game.battle.enemies[1]
    attacker:setAnimation("aim")

    if attacker.fireball then
        local fireball = self:spawnBullet("darkclone/brenda/fireball", Game.battle.arena.right, Game.battle.arena.top, 0, 0)
        if attacker.health/attacker.max_health < 0.5 then
            local fireball_follower = self:spawnBullet("darkclone/brenda/fireball_follower", Game.battle.arena.right, Game.battle.arena.top, 0, 0)
            fireball_follower.target = fireball
            if attacker.health/attacker.max_health < 0.25 then
                local fireball_follower2 = self:spawnBullet("darkclone/brenda/fireball_follower", Game.battle.arena.right, Game.battle.arena.top, 0, 0)
                fireball_follower2.target = fireball_follower
            end
        end
    end

    local function volley()
        for i = 1, 3, 1 do
            self.timer:after(0.1*i, function()
                local x, y = attacker:getRelativePos(-10, attacker.height/2)
                local angle = Utils.angle(x, y, reticle.x, reticle.y)
                self:spawnBullet("darkclone/brenda/bullet", x, y, angle, 30)
                Assets.stopAndPlaySound("bigcut", 1, 1.5)
                attacker:shake()
            end)
        end
    end

    local vollyCount = 0
    for i = 1, self.vollies, 1 do
        self.timer:after(self.volly_delay*i, function()
            vollyCount = vollyCount + 1
            reticle.state = "AIMED"
            reticle.color = {1,0,0,1}
            Assets.playSound("bell")
            self.timer:after(0.1, function()
                volley()
                if vollyCount < self.vollies then
                    self.timer:after(self.volly_delay/2, function()
                        reticle.state = "AIMING"
                        reticle.color = {1,1,1,1}
                    end)
                end
            end)
        end)
    end

    self.timer:after(1 + (self.volly_delay*self.vollies), function()
        attacker:setAnimation("idle")
        self.finished = true
    end)

end

function Shoot:update()
    super.update(self)
end

return Shoot