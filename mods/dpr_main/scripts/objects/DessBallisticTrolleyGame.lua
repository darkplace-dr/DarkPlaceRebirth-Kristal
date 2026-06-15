local DessBallisticTrolleyGame, super = Class(Object)

function DessBallisticTrolleyGame:init(y, height)
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.start_y = y
	self.line_dist = height

	self.canvas_x = 470
	self.canvas_y = 140

	self.canvas_scalex = 0.25
	self.canvas_scaley = 0.25
end

function DessBallisticTrolleyGame:draw()

	Draw.setColor(COLORS.black)
	love.graphics.setLineWidth(2)

	local top_y = self.start_y
	local bottom_y = self.start_y+self.line_dist

	local middle_y = self.start_y+self.line_dist/2

	love.graphics.line(0, top_y, 300, top_y)
	love.graphics.line(0, bottom_y, 300, bottom_y)

	love.graphics.line(300, top_y, 300+80, top_y-80)
	love.graphics.line(300, bottom_y, 300+80, bottom_y+80)

	love.graphics.line(300+80, top_y-80, SCREEN_WIDTH, top_y-80)

	love.graphics.line(300+80, bottom_y+80, SCREEN_WIDTH, bottom_y+80)

	love.graphics.line(300+40, middle_y, 300+40+60, middle_y+60)
	love.graphics.line(300+40, middle_y, 300+40+60, middle_y-60)

	love.graphics.line(300+40+60, middle_y+60, SCREEN_WIDTH, middle_y+60)
	love.graphics.line(300+40+60, middle_y-60, SCREEN_WIDTH, middle_y-60)

	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)

	Draw.setColor(COLORS.white)
	Draw.draw(SCREEN_CANVAS, 0, 0, 0, 
    	SCREEN_WIDTH / SCREEN_CANVAS:getWidth(),
    	SCREEN_HEIGHT / SCREEN_CANVAS:getHeight()
	)

	Draw.popCanvas()

	Draw.draw(canvas, self.canvas_x, self.canvas_y, 0, self.canvas_scalex, self.canvas_scaley)
end

return DessBallisticTrolleyGame