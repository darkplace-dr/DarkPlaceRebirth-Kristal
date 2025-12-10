local FireballLinear, super = Class(Bullet)

function FireballLinear:init(x, y, type, width, rate, len)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.tp = 0
	self:setOrigin(0.5,0.5)
    self:setSprite("battle/bullets/jackenstein/bullet/bullet", 0, false)
	self.basex = self.x
	self.basey = self.y
	self.type = type or 0
	self.square_width = width or 60
	self.rate = rate or 1
	self.cycle_length = len or 120
	self.timer = 0
	self.frame = 2
	self.deform = true
	if self.type == 0 then		
		self:setSprite("battle/bullets/jackenstein/bullet/pumpkin_horizontal", 0, false)
	else
		self:setSprite("battle/bullets/jackenstein/bullet/pumpkin_vertical", 0, false)
	end
	self:setFrame(2)
end

function FireballLinear:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function FireballLinear:update()
	local prev_x = self.x
	local prev_y = self.y
    super.update(self)
	self.timer = self.timer + (math.pi / self.cycle_length) * self.rate * DTMULT
	if self.type == 0 then
		self.x = self.basex + math.sin(self.timer) * self.width
	else
		self.y = self.basey + math.sin(self.timer) * self.width
	end
	if self.sprite.texture_path == "battle/bullets/jackenstein/bullet/pumpkin_horizontal" then
		self.frame = MathUtils.approach(self.frame, 2.01 + (2 * MathUtils.sign(self.x - prev_x)), (2 / (math.log(math.abs(self.width)) / math.log(2)) * DTMULT))
		self:setFrame(math.floor(self.frame+1))
	elseif self.sprite.texture_path == "battle/bullets/jackenstein/bullet/pumpkin_vertical" then
		self.frame = MathUtils.approach(self.frame, 2.01 + (2 * MathUtils.sign(self.y - prev_y)), (2 / (math.log(math.abs(self.width)) / math.log(2)) * DTMULT))
		self:setFrame(math.floor(self.frame+1))
	end
end

function FireballLinear:draw()
    super.draw(self)
	local scaler = 0
	if self.deform then
		scaler = (-math.cos(self.timer * 2) / 4) * (1 - (2 * self.type))
	end
	self.sprite.scale_x = -scaler
	self.sprite.scale_y = scaler
    super.draw(self)
end


return FireballLinear