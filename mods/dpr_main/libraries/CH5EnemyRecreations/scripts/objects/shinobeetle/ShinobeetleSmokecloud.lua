local ShinobeetleSmokecloud, super = Class(Sprite)

function ShinobeetleSmokecloud:init(x, y)
    super.init(self, "effects/world/shinobeetle/dustcloud", x, y)

    self:setOriginExact(32, 32)

    self.fadespeed = 0.04
end

function ShinobeetleSmokecloud:update()
    self.alpha = self.alpha - self.fadespeed * DTMULT
    if self.alpha <= 0 then
        self:remove()
    end

    super.update(self)
end

return ShinobeetleSmokecloud
