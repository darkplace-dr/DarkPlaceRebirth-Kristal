local ZapperLaserLineDraw, super = Class(Object)

function ZapperLaserLineDraw:init()
    super.init(self, 0, 0)
	self.total = 0
	self.force_aim_counter = 0
end

function ZapperLaserLineDraw:draw()
    super.draw(self)
	if Game.battle.wave_timer >= Game.battle.wave_length - 1/30 then
		self:remove()
	end
	if not Game.battle.arena then return end
	self.total = MathUtils.approach(self.total, 1, MathUtils.clamp((1 - self.total) * (0.2 * DTMULT), 0.01, 1))
	love.graphics.setLineWidth(4)
	Draw.setColor(ColorUtils.hexToRGB("#00C000"))
	love.graphics.line(Game.battle.arena.x - (165 * self.total), Game.battle.arena.bottom + 2, Game.battle.arena.x + (165 * self.total), Game.battle.arena.bottom + 2)
	love.graphics.line(Game.battle.arena.x - (165 * self.total), Game.battle.arena.top - 2, Game.battle.arena.x + (165 * self.total), Game.battle.arena.top - 2)
end

return ZapperLaserLineDraw