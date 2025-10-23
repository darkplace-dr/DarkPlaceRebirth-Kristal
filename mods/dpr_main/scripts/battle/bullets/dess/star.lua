local DessStar, super = Class(Bullet)

function DessStar:init(x, y, dir, speed)
    super.init(self, x, y, "effects/spells/dess/star_basic")

    self:setScale(1)

	self:setHitbox(10, 14, 12, 9)
    self.physics.direction = dir
    self.physics.speed = speed

    self.destroy_on_hit = false

	self.trailtimer = 0
	self.wave_masked = false
end

function DessStar:trailStar()
	local starparticle = Sprite("effects/spells/dess/rainbow_star", self.x + MathUtils.random(1, 17), self.y + MathUtils.random(1, 17))
	starparticle:setOrigin(0.5, 0.5)
	starparticle:setScale(1)
	starparticle.layer = self.layer - 0.1
	starparticle.visible = not self.wave_masked
	starparticle.wave_masked = self.wave_masked
	Game.battle:addChild(starparticle)
	starparticle:play(0.1, false)
	starparticle:fadeOutAndRemove(0.5)
end

function DessStar:update()
	self.trailtimer = self.trailtimer + 1 * DTMULT
	if (self.trailtimer % 2) == 0 then
		self:trailStar()
	end

    super.update(self)
end

return DessStar