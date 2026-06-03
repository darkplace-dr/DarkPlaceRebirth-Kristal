local wave, super = Class(Wave)

function wave:init()
    super.init(self)
    self.time = 10
end

function wave:onStart()
    self:spawnBullet("balthizard/cloud_manager", Game.battle.arena.x, Game.battle.arena.y)
end

return wave