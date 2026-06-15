local SpinHeart, super = Class(Wave)

function SpinHeart:init()
    super.init(self)

    self.time = 140/30
end

function SpinHeart:onStart()
    local x = Game.battle.arena.x
    local y = Game.battle.arena.y
    self:spawnBullet("hathy/spinheart", x, y, math.rad(0))
end

function SpinHeart:update()
    super.update(self)
end

return SpinHeart