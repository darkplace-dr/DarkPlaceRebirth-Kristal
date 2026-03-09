local TopFloorWindowEye, super = Class(Event)

function TopFloorWindowEye:init(data)
	super.init(self, data)
	self.eye_init_x = self.width/2
	self.eye_init_y = self.height/2
    self.eye_tex = Assets.getTexture("world/maps/topfloor/window_eye")
end

function TopFloorWindowEye:draw()
	super.draw(self)
	if self.world.player then
		local px, py = self.world.player:getRelativePos(self.world.player.width/2, self.world.player.height/2)
		local eye_angle = MathUtils.angle(self.x + self.eye_init_x, self.y + self.eye_init_y, px, py)
		local eye_x = MathUtils.lengthDirX(self.width/2, -eye_angle)
		local eye_y = MathUtils.lengthDirY(self.height/2, -eye_angle)
		Draw.draw(self.eye_tex, self.eye_init_x + eye_x, self.eye_init_y + eye_y, 0, 2, 2, 3, 3) 
	else
		Draw.draw(self.eye_tex, self.eye_init_x, self.eye_init_y, 0, 2, 2, 3, 3) 
	end
end

return TopFloorWindowEye