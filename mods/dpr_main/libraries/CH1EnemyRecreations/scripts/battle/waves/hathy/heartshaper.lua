local HeartShaper, super = Class(Wave)

function HeartShaper:init()
    super.init(self)

    self.time = 140/30
    if Game.battle.encounter.id == "triple_hathy" then
        self.time = 100/30
    end
end

function HeartShaper:onStart()
    local x, y = Game.battle.arena.x, Game.battle.arena.y
    local bullet = self:spawnBullet("hathy/heartshaper", x, y)
end

return HeartShaper