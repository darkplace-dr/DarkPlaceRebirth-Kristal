local DarkRoomBG, super = Class(Object)

function DarkRoomBG:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self:setScale(1)
	self:setParallax(1, 1)
    self.layer = WORLD_LAYERS["bottom"]

    self.window = Assets.getTexture("world/parallax/darksmallwindow")
    self.grad = Assets.getTexture("world/parallax/whitegradientdown_40")
	self.siner = 0
	self.debug_select = false
end

function DarkRoomBG:draw()
    super.draw(self)
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2
	self.siner = self.siner + DTMULT
	local xspace = 80
	local yspace = 120
	local bgx = -((cx / 6) % 80)
	local bgy = -((cy / 8) % 238)
	local bgcol = ColorUtils.hexToRGB("#000415")
	Draw.setColor(bgcol)
	love.graphics.rectangle("fill", cx - 5, cy - 5, SCREEN_WIDTH + 10, SCREEN_HEIGHT + 10)
	Draw.setColor(0, 0, 0, 0.5)
	Draw.draw(self.grad, cx, cy + SCREEN_HEIGHT/2, 0, 16, 6)
	Draw.setColor(1, 1, 1, 1)
	for i = -2, 9 do
		for ii = -2, 8 do
			local yoff = 0
			local xoff = 0
			if ii % 2 == 0 then
				xoff = 40
			end
			local sinstuff = math.sin(((self.siner + ((i + 3) * 8)) - ((ii + 3) * 15)) / 30) * 0.5
			local darkcol = ColorUtils.hexToRGB("#0C1747")
			local lightcol = ColorUtils.hexToRGB("#233D67")
			Draw.setColor(ColorUtils.mergeColor(darkcol, lightcol, MathUtils.clamp(0.5 + sinstuff, 0, 1)))
			Draw.draw(self.window, cx + (i * xspace) + xoff + bgx, cy + (ii * yspace) + yoff + bgy, 0, 2, 2)
		end
	end
	Draw.setColor(1, 1, 1, 1)
end

return DarkRoomBG