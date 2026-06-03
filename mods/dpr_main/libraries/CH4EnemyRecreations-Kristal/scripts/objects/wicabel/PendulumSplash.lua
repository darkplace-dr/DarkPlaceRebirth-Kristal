local PendulumSplash, super = Class(Object)

function PendulumSplash:init(x, y)
    super.init(self, x, y)
    self:setOrigin(0.5, 0.5)

	self.lifetime = 0
    self.splash_size = 16
end

function PendulumSplash:update()
    self.lifetime = self.lifetime + DTMULT
	if self.lifetime <= 2 then
		self.splash_size = self.splash_size + 16 * DTMULT
	else
		self.splash_size = math.max(0, (self.splash_size * 0.96) - (3*DTMULT))
	end
end

function PendulumSplash:draw()
    Draw.setColor(1, 1, 1, 1)
	local arena = Game.battle.arena.sprite
    love.graphics.ellipse("fill", MathUtils.lengthDirX(2, arena.shake_dir), MathUtils.lengthDirY(2, arena.shake_dir), self.splash_size, self.splash_size)
    super.draw(self)
end

return PendulumSplash