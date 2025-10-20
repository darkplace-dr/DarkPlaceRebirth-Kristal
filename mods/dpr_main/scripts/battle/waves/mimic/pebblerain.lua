local Basic, super = Class(Wave)

function Basic:onStart()
    ---@type EnemyBattler.Mimic
    local mimic = Game.battle:getEnemyBattler("mimic")
    mimic:morph("pebblin")
    self.timer:every(1/6, function()
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
        local y = Game.battle.arena.top - 20

        local bullet = self:spawnBullet("droppedpebble", x, y, math.rad(180), 0)

        bullet.remove_offscreen = true
    end)
end

function Basic:update()

    super.update(self)
end

return Basic