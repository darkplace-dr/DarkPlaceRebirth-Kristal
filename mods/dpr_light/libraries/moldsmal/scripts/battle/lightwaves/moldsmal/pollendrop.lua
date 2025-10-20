local wave, super = Class(LightWave)

function wave:init()
    super.init(self)
    self.time = 4
end

function wave:onStart()
    local x = Utils.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)

    local bullet = self:spawnBullet("pollendrop", x, Game.battle.arena.top)

    local time = 15/30
    if #Game.battle.enemies == 2 then
        time = 1
    elseif #Game.battle.enemies == 3 then
        time = 22.5/30
    end

    self.timer:every(time, function()
        x = Utils.random(Game.battle.arena.left + 20, Game.battle.arena.right - 20)

        bullet = self:spawnBullet("pollendrop", x, Game.battle.arena.top)
    end)
end

return wave