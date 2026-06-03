local OrganikkHighlight, super = Class(Sprite)

function OrganikkHighlight:init(x, y)
    super.init(self, "effects/organikk/highlight", x, y)

    self:play(1/(30*0.5), true)

    self:setScale(1.25, 0)
    self:setOriginExact(42, 43)
    self.alpha = 0.2

    self.made = false
end

function OrganikkHighlight:update()
    super.update(self)
	
    if not self.made then
        Game.stage.timer:after(2/30, function() self:remove() end)
        self.made = true
    end

    self.alpha = self.alpha + 0.2 * DTMULT
    self.scale_y = MathUtils.lerp(self.scale_y, -2, 0.2)
end

return OrganikkHighlight