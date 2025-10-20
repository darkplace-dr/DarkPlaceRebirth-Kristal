local MikeHand, super = Class(Object)

function MikeHand:init(x, y)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self.parallax_x = 0
    self.parallax_y = 0
	
	self.hand_x = x or SCREEN_WIDTH/2
	self.hand_y = y or SCREEN_HEIGHT/2
	
	self.mouse_x = 0
	self.mouse_y = 0
	self.mouse_shake_x = 0
	self.mouse_shake_y = 0
	
	self.hand_sprite = {}
	self.outlined_hand_sprite = {}
	self.hand_offset = {}
	self.outlined_hand_offset = {}
	self.hand_sprite[1] = Assets.getTexture("ui/mike/hand")
	self.hand_sprite[2] = Assets.getTexture("ui/mike/grab_1")
	self.hand_sprite[3] = Assets.getTexture("ui/mike/grab_2")
	self.hand_sprite[4] = Assets.getTexture("ui/mike/give_1")
	self.hand_sprite[5] = Assets.getTexture("ui/mike/give_2")
	self.hand_sprite[6] = Assets.getTexture("ui/mike/ouch")
	self.hand_sprite[7] = Assets.getTexture("ui/mike/grab_3")
	self.outlined_hand_sprite[1] = Assets.getTexture("ui/mike/hand_outlined")
	self.outlined_hand_sprite[2] = Assets.getTexture("ui/mike/grab_outlined_1")
	self.outlined_hand_sprite[3] = Assets.getTexture("ui/mike/grab_outlined_2")
	self.outlined_hand_sprite[4] = self.hand_sprite[4]
	self.outlined_hand_sprite[5] = self.hand_sprite[5]
	self.outlined_hand_sprite[6] = self.hand_sprite[6]
	self.outlined_hand_sprite[7] = Assets.getTexture("ui/mike/grab_outlined_3")
	self.hand_offset[1] = {44, 86}
	self.hand_offset[2] = {42, 76}
	self.hand_offset[3] = {60, 16}
	self.hand_offset[4] = {50, 78}
	self.hand_offset[5] = {56, 78}
	self.hand_offset[6] = {44, 82}
	self.hand_offset[7] = {42, 76}
	self.outlined_hand_offset[1] = {51, 89}
	self.outlined_hand_offset[2] = self.hand_offset[2]
	self.outlined_hand_offset[3] = {57, 16}
	self.outlined_hand_offset[4] = self.hand_offset[4]
	self.outlined_hand_offset[5] = self.hand_offset[5]
	self.outlined_hand_offset[6] = self.hand_offset[6]
	self.outlined_hand_offset[7] = self.hand_offset[7]
	self.mouse_sprite = Assets.getTexture("ui/mike/mouse")
	self.hand_angle = 0
	self.hand_type = 1
	self.hand_alpha = 1
	self.hand_outlined = false
	self.hand_shake = 0
	self.hand_shake_con = 1
	self.fruit_scale = 0
	self.fruit_scale_2 = 0
	self.fruit_scale_3 = 0
	self.hand_fruit = 0
	self.hand_distance = 140
	self.hand_scale_x = 1
	self.hand_speed = 0
	self.size1 = 0
	self.size2 = 31
	self.size3 = 10
	self.hand_wait = 0
	self.hand_anim = 10
end

function MikeHand:update()
	super.update(self)
	if Kristal.isConsole() then
		local mx, my = Input.getThumbstick("left", true)
		local dist = Utils.dist(0, 0, mx, my) * self.hand_distance
		local mn =  math.sqrt(mx * mx + my * my)
		local dir = math.atan2(my / mn, mx / mn)
		if math.abs(mx) > 0 or math.abs(my) > 0 then
			self.mouse_x = self.mouse_x + ((self.hand_x + math.cos(dir) * dist) - self.mouse_x) * 0.2 * DTMULT
			self.mouse_y = self.mouse_y + ((self.hand_y + math.sin(dir) * math.min(dist, 200)) - self.mouse_y) * 0.2 * DTMULT
		end
		self.hand_speed = Utils.approach(self.hand_speed, 0.999, 0.1*DTMULT)
		if Input.pressed("confirm") then
			self:onLeftClick()
		end
	else
		local mx, my = Input.getMousePosition()
		local dist = math.min(self.hand_distance, Utils.dist(self.hand_x, self.hand_y, mx, my))
		local dir = Utils.angle(self.hand_x, self.hand_y, mx, my)
		self.hand_speed = Utils.approach(self.hand_speed, 0.999, 0.1*DTMULT)
		self.mouse_x = self.mouse_x + ((self.hand_x + math.cos(dir) * dist) - self.mouse_x) * self.hand_speed * DTMULT
		self.mouse_y = self.mouse_y + ((self.hand_y + math.sin(dir) * math.min(dist, 200)) - self.mouse_y) * self.hand_speed * DTMULT
		if Input.mousePressed(1) then
			self:onLeftClick()
		end
	end
	if self.hand_wait > 0 then
		self.hand_angle = math.rad(math.sin(Kristal.getTime() * 50) * 15)
	else
		self.hand_angle = Utils.approach(self.hand_angle, 0, 2*DTMULT)
	end
	
	self.hand_wait = self.hand_wait - DTMULT
end

function MikeHand:onLeftClick()
	if self.hand_wait >= 0 then
		return
	end
	self.hand_wait = self.hand_anim
	local juggle = false
	if not juggle then
		Assets.playSound("wing", 0.5, Utils.random(0.95, 1.05))
		Game.stage.timer:after(6/30, function()
			Assets.playSound("wing", 0.5, Utils.random(0.9, 1.1))
		end)
		local xx = self.mouse_x + math.cos(Utils.angle(self.hand_x, self.hand_y, self.mouse_x, self.mouse_y)) * 16
		local yy = self.mouse_y + math.sin(Utils.angle(self.hand_x, self.hand_y, self.mouse_x, self.mouse_y)) * 16
		local dir = Utils.angle(self.hand_x, self.hand_y, self.mouse_x, self.mouse_y) - math.rad(90)
		local effect = Sprite("ui/mike/shake")
		effect:setOrigin(0.5)
		effect:setScale(1)
		effect:setPosition(xx + math.cos(dir) * 8, yy + math.sin(dir) * 8)
		effect.layer = self.layer
		effect.rotation = dir
		effect.physics.speed = 2
		effect.physics.friction = 0.1
		effect.physics.match_rotation = true
		effect.alpha = 1.5
		effect:fadeOutSpeedAndRemove(0.1)
		self:addChild(effect)
		dir = Utils.angle(self.hand_x, self.hand_y, self.mouse_x, self.mouse_y) + math.rad(90)
		effect = Sprite("ui/mike/shake")
		effect:setOrigin(0.5)
		effect:setScale(1)
		effect:setPosition(xx + math.cos(dir) * 8, yy + math.sin(dir) * 8)
		effect.layer = self.layer
		effect.rotation = dir
		effect.physics.speed = 2
		effect.physics.friction = 0.1
		effect.physics.match_rotation = true
		effect.alpha = 1.5
		effect:fadeOutSpeedAndRemove(0.1)
		self:addChild(effect)
	end
end

function MikeHand:draw()
	super.draw(self)
	local mx, my = Input.getMousePosition()
	local dist = Utils.dist(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y) / (self.hand_distance / 2)
	local shake = 0
	local tx, ty = mx, my
	if Kristal.isConsole() then
		tx = self.mouse_x
		ty = self.mouse_y
	end
	Draw.setColor(Utils.mergeColor(COLORS["lime"], COLORS["yellow"], dist))
	if Utils.dist(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y) >= (self.hand_distance / 2) then
		dist = (Utils.dist(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y) - (self.hand_distance / 2)) / (self.hand_distance / 2)
		Draw.setColor(Utils.mergeColor(COLORS["yellow"], COLORS["red"], dist))
	end
	if math.ceil(Utils.dist(self.hand_x, self.hand_y, tx, ty)) >= self.hand_distance then
		shake = 1
		Draw.setColor(COLORS["red"])
	end
	for i = 1, math.floor(Utils.dist(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y) / 16) do
		local xx = math.cos(Utils.angle(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y)) * (i * 16)
		local yy = math.sin(Utils.angle(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y)) * (i * 16)
		if Utils.dist(self.mouse_x + xx, self.mouse_y + yy, self.hand_x, self.hand_y) > self.size1 * 1.5 then
			if Game.battle then
				love.graphics.setLineWidth(1)
				love.graphics.circle("line", self.mouse_x + love.math.random(-1, 1) * shake + xx, self.mouse_y + love.math.random(-1, 1) * shake + yy, 2)
			else
				local randx = love.math.random(-1, 1)
				local randy = love.math.random(-1, 1)
				Draw.setColor(COLORS["black"])
				love.graphics.circle("fill", self.mouse_x + randx * shake + xx, self.mouse_y + randy * shake + yy, 3)
				Draw.setColor(COLORS["white"])
				love.graphics.circle("fill", self.mouse_x + randx * shake + xx, self.mouse_y + randy * shake + yy, 2)
			end
		end
	end
	local angle = Utils.angle(self.mouse_x, self.mouse_y, self.hand_x, self.hand_y) - math.rad(90) + self.hand_angle
	
	if self.hand_type == 2 or self.hand_type == 7 then
		if self.mouse_y > self.hand_y then
			angle = math.rad(180)
		else
			angle = math.rad(0)
		end
	end
	if self.hand_type == 3 or self.hand_type == 4 or self.hand_type == 5 then
		angle = math.rad(0)
	end
	local spr = self.hand_sprite[self.hand_type]
	local ox, oy = self.hand_offset[self.hand_type][1], self.hand_offset[self.hand_type][2]
	if self.hand_outlined then
		spr = self.outlined_hand_sprite[self.hand_type]
		ox, oy = self.outlined_hand_offset[self.hand_type][1], self.outlined_hand_offset[self.hand_type][2]
	end
	Draw.setColor(1,1,1,self.hand_alpha)
	Draw.draw(spr, self.mouse_x + self.mouse_shake_x, self.mouse_y + self.mouse_shake_y, angle, self.hand_scale_x * 0.5, 0.5, ox, oy)
	Draw.setColor(1,1,1,1)
	self.fruit_scale = self.fruit_scale + (self.fruit_scale_2 - self.fruit_scale) * 0.25*DTMULT
	self.fruit_scale_2 = self.fruit_scale_2 + (self.fruit_scale_3 - self.fruit_scale_2) * 0.25*DTMULT
	if self.fruit_scale > 0 and self.hand_fruit ~= 0 then
		Draw.draw(spr, self.mouse_x + self.mouse_shake_x - 6, self.mouse_y + self.mouse_shake_y - self.fruit_scale*32, angle, self.fruit_scale, self.fruit_scale, ox, oy)
	end
	if Utils.dist(self.mouse_x + self.mouse_shake_x, self.mouse_y + self.mouse_shake_y, mx, my) > 64 and not Kristal.isConsole() then
		Draw.draw(self.mouse_sprite, mx, my)
	end
	
	self.hand_shake = self.hand_shake - DTMULT
	if self.hand_shake > 0 then
		self.mouse_shake_x = -Utils.random(-2, 2)
		self.mouse_shake_y = -Utils.random(-2, 2)
	end
	
	if self.hand_shake <= 0 and self.hand_shake_con == 0 then
		if self.hand_type == 4 then
			self.hand_type = 5
			self.fruit_scale_3 = 2
			self.hand_fruit = 1
		end
		if self.hand_type == 6 then
			self.hand_type = 1
		end
		self.mouse_shake_x = 0
		self.mouse_shake_y = 0
		self.hand_shake_con = 1
	end
	
	if self.hand_shake < -60 then
		if self.hand_shake_con == 1 then
			if self.hand_type == 5 then
				self.hand_type = 0
				self.fruit_scale_3 = 0
				self.fruit_scale_2 = 0
				self.fruit_scale = 0
				self.hand_fruit = 0
			end
			self.hand_shake_con = 2
		end
	else
		self.fruit_scale_3 = Utils.approach(self.fruit_scale_3, 1, 0.1*DTMULT)
	end
end

return MikeHand