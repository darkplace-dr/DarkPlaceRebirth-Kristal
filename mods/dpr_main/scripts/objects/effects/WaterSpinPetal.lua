local WaterSpinPetal, super = Class(Sprite)

function WaterSpinPetal:init(x, y)
    super.init(self, "effects/particles/spin_petal", x, y)
	self:setOrigin(0.5, 0.5)
	self:play(0.2 + MathUtils.random(-0.02, 0.02), true)
	self:setScale(TableUtils.pick({-2, 2}), 2)
	self.rando = MathUtils.random(100)
	self.reflectblend = ColorUtils.mergeColor(self.color, COLORS.aqua, 0.2)
	self:setColor(ColorUtils.mergeColor(self.color, COLORS.black, 0.35))
end

function WaterSpinPetal:update()
    super.update(self)
	self.x = self.init_x + (math.sin(self.rando + ((Kristal.getTime() * 30) / 15) * 3))
	if self.y >= Game.world.map.height * Game.world.map.tile_height + 16 then
		self:remove()
	end
end

function WaterSpinPetal:draw()
	Draw.setColor(self.reflectblend, self.alpha / 3)
	Draw.draw(self.texture, 0, 10, 0, 1, -1)
	Draw.setColor(self.color, self.alpha)
	super.draw(self)
end

return WaterSpinPetal