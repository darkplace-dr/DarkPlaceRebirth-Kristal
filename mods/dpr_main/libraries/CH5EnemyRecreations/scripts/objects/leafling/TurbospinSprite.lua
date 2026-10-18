local TurbospinSprite, super = Class(Sprite)

function TurbospinSprite:init(x, y, spareable)
    super.init(self, spareable and "battle/enemies/leafling/spin_spared" or "battle/enemies/leafling/spin", x, y)

    self:setOriginExact(10, 36)

    self.siner = 0
end

function TurbospinSprite:update()
    self.siner = self.siner + DTMULT
    self.scale_x = 0 + math.sin(self.siner * 0.6) * 2

    super.update(self)
end

return TurbospinSprite