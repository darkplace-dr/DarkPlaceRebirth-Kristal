local FireballSquare, super = Class(Bullet)

function FireballSquare:init(x, y, width, hflip, vflip, len)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.tp = 0
	self:setOrigin(0.5,0.5)
    self:setSprite("battle/bullets/jackenstein/bullet/bullet_small", 0, false)
	self.path = {}
	self.basex = self.x
	self.basey = self.y
	self.square_width = width or 27
	self.hflip = hflip or 1
	self.vflip = vflip or 1
	self.cycle_length = len or 40
	self:setSquarePath()
	self.trueprevx = self.x
	self.trueprevx = self.y
	self.iris_tex = Assets.getFrames("battle/bullets/jackenstein/bullet/iris")
	self.iris = true
	self.iris_dir = math.rad(-1)
end

function FireballSquare:setSquarePath()
	table.insert(self.path, {x = self.basex, y = self.basey - (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex + (self.square_width * self.hflip), y = self.basey - (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex + (self.square_width * self.hflip), y = self.basey})
	table.insert(self.path, {x = self.basex + (self.square_width * self.hflip), y = self.basey + (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex, y = self.basey + (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex - (self.square_width * self.hflip), y = self.basey + (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex - (self.square_width * self.hflip), y = self.basey})
	table.insert(self.path, {x = self.basex - (self.square_width * self.hflip), y = self.basey - (self.square_width * self.vflip)})
	table.insert(self.path, {x = self.basex, y = self.basey - (self.square_width * self.vflip)})
	self:slidePath(self.path, {speed = (self.square_width * 4) / self.cycle_length, loop = true, snap = true})
end

function FireballSquare:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function FireballSquare:update()
    super.update(self)
	if self.iris and (self.physics.move_path.speed or self.square_width == 0) then
		local soul = Game.battle.soul
		if self.trueprevx == self.x and self.trueprevy == self.y then
			self.iris_dir = MathUtils.angle(self.x, self.y, soul.x, soul.y)
		else
			self.iris_dir = self.iris_dir + MathUtils.angleDiff(MathUtils.dist(self.trueprevx, self.trueprevy, self.x, self.y), self.iris_dir) / 5
		end
	end
	self.trueprevx = self.x
	self.trueprevx = self.y
end

function FireballSquare:draw()
	local scaler = 0
	self.sprite.scale_x = -scaler
	self.sprite.scale_y = scaler
    super.draw(self)
	if self.iris then
		local big = 0
		if self.width > 12 then
			big = 1
		end
		local xdir = 0
		if self.iris_dir <= math.rad(90) or self.iris_dir >= math.rad(270) then
			xdir = 1
		end
		Draw.draw(self.iris_tex[big+1], -math.cos(self.iris_dir) * (3 + big * xdir), -math.sin(self.iris_dir) * 4, self.iris_dir, 1, 1, 2, 3)
	end
end

return FireballSquare