local FireballHop, super = Class(Bullet)

function FireballHop:init(x, y, sprite, width, rate, len)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.tp = 0
	self:setOrigin(0.5,0.5)
    self:setSprite(sprite or "battle/bullets/jackenstein/bullet/pumpkin_vertical", 0, false)
	self.basex = self.x
	self.basey = self.y
	self.square_width = width or 60
	self.rate = rate or 1
	self.cycle_length = len or 120
	self.timer = 0
	self.frame = 0
end

function FireballHop:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function FireballHop:update()
	local prev_y = self.y
    super.update(self)
	self.timer = self.timer + (math.pi / self.cycle_length) * self.rate * DTMULT
	self.y = self.basey - math.max(0, math.abs(math.sin(self.timer))) * self.width
	if self.sprite.texture_path == "battle/bullets/jackenstein/bullet/pumpkin_vertical" then
		self.frame = MathUtils.approach(self.frame, 2.01 + (2 * MathUtils.sign(self.y - prev_y)), 1 * DTMULT)
		self:setFrame(math.floor(self.frame+1))
	end
end

function FireballHop:draw()
	local scaler = math.sin((self.timer * 2) + math.pi) / 4
	self.sprite.scale_x = -scaler
	self.sprite.scale_y = scaler
    super.draw(self)
end

return FireballHop