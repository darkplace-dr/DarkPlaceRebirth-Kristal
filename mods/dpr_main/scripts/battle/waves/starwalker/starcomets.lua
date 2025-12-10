local Starwings, super = Class(Wave)

function Starwings:init()
    super.init(self)
    self.time = 10
    self.starwalker = self:getAttackers()[1]
    self.starwalker.layer = self.starwalker.layer + 500
end

function Starwings:onStart()
    self.starwalker:setMode("flying")

    self.timer:every(1, function()
        Assets.playSound("stardrop")
        local star = self:spawnBullet(self.starwalker:makeCometBullet(self.starwalker.x, self.starwalker.y - 20))
        star.inv_timer = 10/30
    end)
end

function Starwings:onEnd()
    self.starwalker:setMode("normal")
    self.starwalker.layer = self.starwalker.layer - 500
    super.onEnd(self)
end

function Starwings:update()
    super.update(self)
end

return Starwings
