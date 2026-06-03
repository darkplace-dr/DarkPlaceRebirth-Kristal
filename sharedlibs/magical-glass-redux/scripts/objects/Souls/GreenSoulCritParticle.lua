local GreenSoulCritParticle, super = Class(Sprite)

function GreenSoulCritParticle:init(x, y)
    super.init(self, "effects/greensoul/parry_spark", x, y)

    self:setColor(229 / 255, 208 / 255, 0)

    self.physics.speed = MathUtils.round(MathUtils.random(4, 9))

    local scale = (MathUtils.random() * 0.3) + 0.4
    self.scale_x = scale
    self.scale_y = scale
    self.alpha = 0.2
end

function GreenSoulCritParticle:update()
    super.update(self)

    local scale_factor = math.pow(0.85, DTMULT)
    self.physics.speed = self.physics.speed * scale_factor
    self.scale_x = self.scale_x * scale_factor
    self.scale_y = self.scale_y * scale_factor

    self.rotation = self.rotation - (math.rad(45) * DTMULT)
    self.alpha = self.alpha + (0.2 * DTMULT)

    if self.scale_x + self.scale_y < 0.16 then
        self:remove()
    end
end

return GreenSoulCritParticle