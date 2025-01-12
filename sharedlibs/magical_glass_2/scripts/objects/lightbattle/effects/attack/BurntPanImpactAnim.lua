local BurntPanImpactAnim, super = Class(Sprite, "BurntPanImpactAnim")

function BurntPanImpactAnim:init()
    super.init(self, "effects/attack/frypan_impact")

    self.inherit_color = true

    self:setScale(2)
    self:setOrigin(0.5)
    self:play(1/30, true)

    self.growing = true
    self.angle = 6 * Utils.pick({1, -1})
end

function BurntPanImpactAnim:update()
    self.rotation = self.rotation + math.rad(self.angle) * DTMULT

    if self.growing then
        self:setScale(self:getScale() + 0.3 * DTMULT)

        if self:getScale() > 2.8 then
            self.growing = false
        end
    else
        self:setScale(self:getScale() - 0.6 * DTMULT)
        self.alpha = self.alpha - 0.2 * DTMULT
    end

    super.update(self)
end

return BurntPanImpactAnim