local DazzleParticle, super = Class(Sprite)

function DazzleParticle:init(x, y)
    super.init(self, "effects/mizzle/dazzle_particle", x, y)

    self:setOriginExact(16, 16)

    self.rotspeed = 4
    self.physics.speed = 7 + MathUtils.random(7)
    self.physics.friction = 0.6
end

function DazzleParticle:update()
    super.update(self)
	
    if self.scale_x > 0 then
        self.scale_x = self.scale_x - 0.05 * DTMULT
    else
        self:remove()
    end
    self.scale_y = self.scale_x

    if self.rotspeed > 0 then
        self.rotspeed = self.rotspeed - 0.1 * DTMULT
    end

    self.rotation = self.rotation + -math.rad(self.rotspeed) * DTMULT
end

return DazzleParticle