local HeartShaper, super = Class(Wave)

function HeartShaper:init()
    super.init(self)

    self.time = 180/30

    self.btimer = 99
end

function HeartShaper:update()
    super.update(self)

    local headhathy = TableUtils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "headhathy" end)
    local ratio = 1.3 - (#headhathy / 10) -- not sure if this is entirely accurate.

    self.btimer = self.btimer + (1 * DTMULT)

    if self.btimer >= (26 * ratio) then
        local x, y = Game.battle.arena.x, Game.battle.arena.y
        local hs = self:spawnBullet("hathy/heartshaper", x, y)
        hs.maxradius = 50
        hs.type = 1
        self.btimer = 0
        hs.thisx = (x - 50) + MathUtils.random(100)
        hs.thisy = (y - 50) + MathUtils.random(100)
    end
end

return HeartShaper