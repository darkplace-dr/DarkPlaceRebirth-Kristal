local OrganikkParticle, super = Class(Sprite)

function OrganikkParticle:init(x, y)
    super.init(self, "effects/organikk/dazzle_particle", x, y)

    self:setOriginExact(16, 16)

    self.xs = 0
    self.ys = -6 - MathUtils.randomInt(10)
    self.scale_x = MathUtils.random(0.8) + 0.2
    self.scale_y = self.scale_x

    self:setColor({229/255, 208/255, 0/255})
    self.alpha = 0.2
end

function OrganikkParticle:update()
    super.update(self)

    self.x = self.x + self.xs * DTMULT
    self.y = self.y + self.ys * DTMULT

    self.xs = self.xs * (0.85 ^ DTMULT)
    self.ys = self.ys * (0.85 ^ DTMULT)
    self.scale_x = self.scale_x * (0.85 ^ DTMULT)
    self.scale_y = self.scale_y * (0.85 ^ DTMULT)

    if (self.scale_x + self.scale_y) < 0.16 then
        self:remove()
    end

    self.rotation = self.rotation + -math.rad(45) * DTMULT
    self.alpha = self.alpha + 0.2 * DTMULT
end

return OrganikkParticle