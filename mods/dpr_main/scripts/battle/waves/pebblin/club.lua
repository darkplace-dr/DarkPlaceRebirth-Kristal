local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)

    self.time = 5 + #Game.battle:getActiveEnemies()*2.5
end

function Basic:onStart()
    local attackers = self:getAttackers()
    for i, v in ipairs(attackers) do
        local x = v.x - 60
        local y = v.y - 40
    
        local bullet = self:spawnBullet("pebbleclub", x, y, math.rad(0), 0)
    
        bullet.remove_offscreen = false
    end
end

function Basic:update()

    super.update(self)
end

return Basic