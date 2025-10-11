local DazzleParticle, super = Class(Object)

function DazzleParticle:init(x, y)
    super.init(self, x, y)

    self.physics.speed = 7 + MathUtils.random(7)
    self.physics.friction = 0.6
    self.rotspeed = 4
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

function DazzleParticle:draw()
    local particle = Assets.getTexture("effects/dazzle_particle")
    Draw.draw(particle, 0, 0, 0, 1, 1, 16, 16)
    super.draw(self)
end

return DazzleParticle