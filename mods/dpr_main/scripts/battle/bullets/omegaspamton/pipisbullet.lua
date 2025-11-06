local PipisBullet, super = Class(Bullet)

function PipisBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/omegaspamton/spamtonhead")
	self:setOrigin(0.5)
	self.sprite:play(1/8)
	self.sprite:setFrame(MathUtils.randomInt(1,4))
end

return PipisBullet