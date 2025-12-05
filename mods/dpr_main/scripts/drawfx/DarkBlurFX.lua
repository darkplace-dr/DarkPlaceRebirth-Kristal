local DarkBlurFX, super = Class(FXBase)

function DarkBlurFX:init(amount, alpha, blacken)
    super.init(self, 1)
    self.alpha = alpha or 0.3
    self.amount = amount or 0
	self.blacken = blacken or false
	self.room_x_x = 0
end

function DarkBlurFX:draw(texture)
	self.room_x_x = self.room_x_x + 0.2 * DTMULT
	local room_x_a = math.sin(self.room_x_x) * 0.025
	if self.blacken then
		Draw.setColor(0,0,0,1)
		Draw.drawCanvas(texture)
	end
	Draw.setColor(1,1,1,self.alpha + room_x_a)
    Draw.draw(texture, room_x_a * 20, room_x_a * 20)
    Draw.draw(texture, self.amount + room_x_a * 15, self.amount + room_x_a * 20)
	Draw.setColor(1,1,1,1)
end

return DarkBlurFX