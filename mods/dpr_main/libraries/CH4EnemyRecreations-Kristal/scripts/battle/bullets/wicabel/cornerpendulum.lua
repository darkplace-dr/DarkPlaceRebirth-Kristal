local CornerPendulum, super = Class(Bullet)

function CornerPendulum:init(x, y)
    super.init(self, x, y, "battle/bullets/wicabel/pendulum_ball")
	
	self.x = self.x + 16
	self.y = self.y + 16
    self:setScale(1)
    self.sprite:setOriginExact(16, 16)
    self.collider = CircleCollider(self, 0, 0, 16)

	self.side = 1
	self.alpha = 0
    self.swingtarget_x = self.x
    self.swingtarget_y = self.y
    self.swingpoint_x = self.swingtarget_x
    self.swingpoint_y = Game.battle.arena.top - 16 + 16
	self.swingdistance = MathUtils.dist(self.x, self.y, self.swingpoint_x, self.swingpoint_y)
	self.vertical_mirroring = 1
    self.collidable = false
	self.remove_offscreen = false
	self.destroy_on_hit = false
	self.damage = 65
	self.tp = 1.6
	self.accel = 0
end

function CornerPendulum:update()
    super.update(self)

	self.alpha = self.alpha + 0.1 * DTMULT
	if self.alpha >= 1.5 then
		self.collidable = true
	end
	
	-- The code here isn't 1:1 with DELTARUNE
	-- but this is the only way I could get it mostly accurate	
	local dirwrap = math.pi*2
	local shaftdir = -MathUtils.angle(self.x, self.y, self.swingpoint_x, self.swingpoint_y)
	local shaftdir_hack, accel, swingdir
	if self.vertical_mirroring == 1 then
		if self.side == 1 then
			swingdir = shaftdir - math.rad(90)
		else
			swingdir = shaftdir + math.rad(90)
		end
		accel = MathUtils.lengthDirY(0.5, swingdir)
	elseif self.vertical_mirroring == -1 then
		if self.side == 1 then
			swingdir = shaftdir - math.rad(90)
		else
			swingdir = shaftdir + math.rad(90)
		end
		accel = -MathUtils.lengthDirY(0.5, swingdir)
	end
	self.accel = self.accel + accel * DTMULT
	self.physics.speed_x = MathUtils.lengthDirX(self.accel, swingdir) * DTMULT
	self.physics.speed_y = MathUtils.lengthDirY(self.accel, swingdir) * DTMULT
	
	self.physics.direction = swingdir
	self.x = self.swingpoint_x - MathUtils.lengthDirX(self.swingdistance, shaftdir)
	self.y = self.swingpoint_y - MathUtils.lengthDirY(self.swingdistance, shaftdir)
	self.sprite.rotation = MathUtils.angle(self.swingpoint_x, self.swingpoint_y, self.x, self.y) - math.rad(90)
	
	local direction = math.deg(self.physics.direction)
	if (self.x >= self.swingtarget_x and (direction > 330 or direction < 30) and self.side == 1)
	or (self.x <= self.swingtarget_x and (direction > 150 or direction < 210) and self.side == -1) then
		self.x = self.swingtarget_x - 16
		self.y = self.swingtarget_y - 16
		Game.battle.arena.sprite.shake_ = 90
		Game.battle.arena.sprite.splash_x = self.x
		Game.battle.arena.sprite.splash_x = self.y
		self.wave.bullet_speed = 2.8 - (MathUtils.clamp(#Game.battle:getActiveEnemies() - 1, 0, 2) * 0.6)
		if #Game.battle:getActiveEnemies() > 2 then
			self.wave.bullet_dir_add = 42
			self.wave.bullet_dir = self.wave.bullet_dir_add * (-0.5 + MathUtils.random(1))
			self.wave.bullet_number = 4
		else
			self.wave.bullet_dir_add = 48
			self.wave.bullet_dir = self.wave.bullet_dir_add * (-0.5 + MathUtils.random(1))
			self.wave.bullet_number = 3
		end
		local splash = self.wave:spawnObject(PendulumSplash(), self.x, self.y)
		splash.layer = self.layer
		self.wave:spawnBullets(true, self.x, self.y)
		Game.battle.timer:after(2.5/30, function()
			local success = false
			if #Game.battle:getActiveEnemies() <= 2 then
				success = true
			end
			self.wave:spawnBullets(success, self.x, self.y)
		end)
		Game.battle.timer:after(5.5/30, function()
			local success = false
			if #Game.battle:getActiveEnemies() <= 1 then
				success = true
			end
			self.wave:spawnBullets(success, self.x, self.y)
		end)
		self:remove()
	end
end

function CornerPendulum:draw()
    super.draw(self)
end

function CornerPendulum:drawMasked()
	local shaftdir = -MathUtils.angle(self.x, self.y, self.swingpoint_x, self.swingpoint_y)
    Draw.setColor(ColorUtils.hexToRGB("#777777"))
	local x1 = self.x + MathUtils.lengthDirX(3, shaftdir - math.rad(90)) - 16
	local y1 = self.y + MathUtils.lengthDirY(3, shaftdir - math.rad(90)) - 16
	local x2 = self.x + MathUtils.lengthDirX(3, shaftdir + math.rad(90)) - 16
	local y2 = self.y + MathUtils.lengthDirY(3, shaftdir + math.rad(90)) - 16
	local x3 = self.swingpoint_x + MathUtils.lengthDirX(3, shaftdir + math.rad(90)) - 16
	local y3 = self.swingpoint_y + MathUtils.lengthDirY(3, shaftdir + math.rad(90)) - 16
	local x4 = self.swingpoint_x + MathUtils.lengthDirX(3, shaftdir - math.rad(90)) - 16
	local y4 = self.swingpoint_y + MathUtils.lengthDirY(3, shaftdir - math.rad(90)) - 16
	love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3)
	love.graphics.polygon("fill", x1, y1, x3, y3, x4, y4)
    Draw.setColor(COLORS.white)
end

return CornerPendulum