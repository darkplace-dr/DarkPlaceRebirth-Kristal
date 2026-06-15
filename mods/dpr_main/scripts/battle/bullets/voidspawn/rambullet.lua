local RamBullet, super = Class(Bullet)

function RamBullet:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/voidspawn/rambullet")

    self.physics.direction = dir
    self.physics.speed = speed

    self.light = 0
    self.light_recover = 0.01

    self.highlight = self:addFX(ColorMaskFX())
    self.highlight:setColor(1, 1, 1)
    self.highlight.amount = 0

    self.destroy_on_hit = false
end

function RamBullet:destroy()
    local tp_blob = self.wave:spawnBullet("voidspawn/greenblob", self.x, self.y)
    tp_blob:setLayer(self.layer - 1)

    tp_blob.size = 4
	
	tp_blob:prime()

    self:remove()
end

function RamBullet:update()
    super.update(self)

    local hx, hy = Game.battle.soul.x, Game.battle.soul.y

    if (MathUtils.dist(self.x, self.y, hx, hy) < Game.battle.soul.light_radius) and self.color ~= COLORS.red then
        self.light = MathUtils.approach(self.light, 1, DT/0.75)

        if Game.battle.soul.ominous_loop then
			Game.battle.soul.ominous_decline = false
			Game.battle.soul.ominous_volume = MathUtils.approach(Game.battle.soul.ominous_volume, 1, ((1 - Game.battle.soul.ominous_volume) * 0.15) * DTMULT)
        end

        if MathUtils.randomInt(2) == 0 then
            local particle = Game.battle:addChild(TitanSpawnParticleGeneric(self.x + MathUtils.random(-12, 12), self.y + MathUtils.random(-12, 12)))
            particle:setColor(COLORS.white)
            particle.physics.direction = MathUtils.angle(hx, hy, particle.x, particle.y)
            particle.physics.speed = 1 + MathUtils.random(3)
            particle.shrink_rate = 0.2
			particle.layer = self.layer
        end

        self.physics.friction = 0.25
    else
        self.physics.friction = -0.25
    end

    self:setScale(2 - self.light)

    self.highlight.amount = self.light
    if self.light == 1 then
        self:destroy()
    end
end

return RamBullet