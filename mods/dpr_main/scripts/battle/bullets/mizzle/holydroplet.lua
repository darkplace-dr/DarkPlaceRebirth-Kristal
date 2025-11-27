local HolyDroplet, super = Class(Bullet, "mizzle/holydroplet")

function HolyDroplet:init(x, y)
    super.init(self, x, y, "battle/bullets/mizzle/holydroplet")

    self:setScale(1)
    self:setOriginExact(16, 18)

    self.tp = (1/3) / 2.5
end

function HolyDroplet:update()
    super.update(self)
end

return HolyDroplet 