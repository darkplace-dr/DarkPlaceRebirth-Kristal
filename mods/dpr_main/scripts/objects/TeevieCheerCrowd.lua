local TeevieCheerCrowd, super = Class(Object)

function TeevieCheerCrowd:init(x, y, width, height)
    super.init(self, x, y, width, height)
	
	self.crowd_a = Assets.getFrames("world/events/teevie_cameras/crowd_a") --44, 56
	self.crowd_b = Assets.getFrames("world/events/teevie_cameras/crowd_b") --28, 33
	self.gradient = Assets.getTexture("world/events/teevie_cameras/gradient")
	self.siner = 0
	self.siner_speed = 0
	self.anim = 0
	self.anim_speed = 0
	self.current_y_pos = 280 + 180
	self.glitz_active = false
	self.lerp_speed = 0.2
	self.gradient_style = "smooth"
	self.dess_moment = 0
end

function TeevieCheerCrowd:update()
    super.update(self)
	
	self.siner = self.siner + self.siner_speed * DTMULT
	self.anim = self.anim + self.anim_speed * DTMULT
	
	if self.dess_moment == 0 then
		if self.glitz_active then
			self.current_y_pos = Utils.lerp(self.current_y_pos, 280, 0.6*DTMULT)
			self.siner_speed = 0.4
			self.anim_speed = 0.2
		else
			self.current_y_pos = Utils.lerp(self.current_y_pos, 280 + 180, 0.1*DTMULT)
			self.siner_speed = Utils.lerp(self.siner_speed, 0, 0.01*DTMULT)
			self.anim_speed = Utils.lerp(self.anim_speed, 0, 0.01*DTMULT)
		end
	elseif self.dess_moment == 1 then
		self.siner_speed = 0
		self.anim_speed = 0
	elseif self.dess_moment == 2 then
		self.current_y_pos = Utils.lerp(self.current_y_pos, 280 + 180, 0.05*DTMULT)
		self.siner_speed = 0
		self.anim_speed = 0
	end
	
	if Game.world:hasCutscene() or Game.world.encountering_enemy or Game.world.state == "MENU" or Game.state ~= "OVERWORLD" then
		self.siner_speed = 0
		self.anim_speed = 0
	end
end

function TeevieCheerCrowd:draw()
	local offset = 10
	local max_width = self.width
	local max_amount = math.floor(max_width / 126)
	love.graphics.setColor(1,1,1,1)
	for i = 1, max_amount do
		local y_offset = -10
		if (i-1 % 2) == 1 then y_offset = -20 end
		local x_pos = ((i-1) * 126) + (math.cos((self.siner + ((i-1) * 80)) / 4) * 8)
		Draw.draw(self.crowd_b[math.floor((self.anim * 1.5) % #self.crowd_b) + 1], x_pos, self.current_y_pos + y_offset + (math.sin(self.siner) * 8), 0, 1.8 + math.sin(self.siner) * 0.2, 2 + math.sin(self.siner) * 0.1, 28, 33)
	end
	max_width = self.width
	max_amount = math.floor(max_width / 132)
	for i = 1, max_amount do
		local y_offset = 20
		if (i-1 % 2) == 1 then y_offset = 0 end
		local x_pos = 40 + ((i-1) * 132)
		Draw.draw(self.crowd_a[math.floor((self.anim) % #self.crowd_a) + 1], x_pos - math.sin((self.siner * (((i-1) * 6) + 1) * 6) / 400) * 2, self.current_y_pos + y_offset + (math.sin(self.siner) * 8), 0, 1.8 + (math.sin(self.siner + (30 * (i-1))) * 0.1), 2 + math.sin(self.siner + (30 * (i-1))) * 0.1, 45, 56)
	end
	max_width = self.width
	max_amount = math.floor(max_width / 120)
	for i = 1, max_amount do
		local y_offset = 0
		if (i-1 % 2) == 1 then y_offset = 30 end
		local x_pos = 40 + ((i-1) * 120)
		Draw.draw(self.crowd_b[math.floor((self.anim + 0.6) % #self.crowd_b) + 1], x_pos, self.current_y_pos + y_offset + (math.sin(self.siner + ((i-1) * 20) * 8)), 0, 1.8 + math.sin(self.siner) * 0.2, 2 + math.sin(self.siner) * 0.1, 28, 33)
	end
	offset = 60
	max_width = self.width
	max_amount = math.floor(max_width / 140)
	for i = 1, max_amount do
		local y_offset = 10
		if (i-1 % 2) == 1 then y_offset = 30 end
		local x_pos = 88 + ((i-1) * 140)
		Draw.draw(self.crowd_a[math.floor((self.anim + 0.8) % #self.crowd_a) + 1], x_pos, self.current_y_pos + y_offset + (math.sin(self.siner) * 8), 0, 1.8 + math.sin(self.siner) * 0.2, 2 + math.sin(self.siner) * 0.1, 45, 56)
	end
	if self.gradient_style == "smooth" then
		love.graphics.setColor(0,0,0,1)
		Draw.draw(self.gradient, -100, 320-40, 0, (self.width+100)/20, 2)
		Draw.rectangle("fill", -100, 320, self.width+100, self.height)
	else
		for i = 1, 5 do
			love.graphics.setColor(0,0,0,(i-1)/5)
			Draw.rectangle("fill", 0, 200 + 40 + ((i-1) * 10) - 1, self.width, self.height)
		end
	end
	love.graphics.setColor(1,1,1,1)
	
    super.draw(self)
end

return TeevieCheerCrowd