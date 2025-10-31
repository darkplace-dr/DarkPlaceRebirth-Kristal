local GhostHouseExitArrow, super = Class(Sprite)

function GhostHouseExitArrow:init(x, y)
    super.init(self, "battle/ghost_house/exit_arrow", x, y)

    self:setOrigin(0.5, 0.5)
	self:setScale(2,2)
	self.alpha = 0
	self.rotation =  -math.rad(90)
    self.timer = 0
	self.stop_timer = false
end

function GhostHouseExitArrow:draw()
	if not self.stop_timer then
		self.timer = self.timer + 0.18479956785822313 * DTMULT
	else
		self.rotation = self.rotation + self.physics.speed * DTMULT
	end
	love.graphics.translate(-math.cos(self.rotation) * math.sin(self.timer) * 2 + 5, -math.sin(self.rotation) * math.sin(self.timer) * 2 + 5)
    super.draw(self)
	love.graphics.translate(0,0)
end

return GhostHouseExitArrow