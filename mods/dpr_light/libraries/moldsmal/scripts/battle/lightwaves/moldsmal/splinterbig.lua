local wave, super = Class(LightWave)

function wave:init()
    super.init(self)
    self.time = 4
end

function wave:onStart()
    local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)

    local bullet = self:spawnBullet("splinterbig", x, Game.battle.arena.top)

    local time = 1
    if #Game.battle.enemies == 2 then
        time = 45/30
    elseif #Game.battle.enemies == 3 then
        time = 2
    end

    self.timer:every(time, function()
        x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)

        bullet = self:spawnBullet("splinterbig", x, Game.battle.arena.top)
    end)
end

return wave