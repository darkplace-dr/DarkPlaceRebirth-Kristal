local Basic, super = Class(Wave)

function Basic:onStart()
    local enemies = #Game.battle:getActiveEnemies()
    self.timer:every(enemies/3, function()
        local attackers = self:getAttackers()
        for i, v in ipairs(attackers) do
            local x = Utils.random(-40, 40) + Game.battle.soul.x
            local y = Game.battle.arena.top - 20
    
            local bullet = self:spawnBullet("droppedpebble", x, y, math.rad(180), 0)
    
            bullet.remove_offscreen = true
        end
    end)
end

function Basic:update()

    super.update(self)
end

return Basic