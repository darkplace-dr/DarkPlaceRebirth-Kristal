local Starbeam, super = Class(Wave)

function Starbeam:init()
    super.init(self)
    self.time = 8
	self.con = 0
	self.ftimer = 0
    self:setArenaSize(160, 120)
    self.bullet_flow_tex = Assets.getFrames("effects/dess/bullet_flow")
	self.angle = 0
	self.target_angle = 60
	self.draw_angle = 0
	self.angle_lerp = 0
	self.bg_x = 0
	self.lines_x = 0
	self.flow_color = COLORS.red
	self.flow_color_con = 0
	self.flow_color_timer = 0
	self.knockback = 0
	self.gt_x = 0
	self.tween = 0
	self.dess_orig_x = 0
	self.dess_orig_y = 0
	self.yoff = MathUtils.randomInt(60) + 2
end

function Starbeam:onStart()
    local dess = Game.battle:getEnemyBattler("dess")
	self.dess_orig_x, self.dess_orig_y = dess.x, dess.y
	self.gt_x = Game.battle.arena.x
    dess:setSprite("point")
    Assets.playSound("knight_drawpower", 3, 1.3)
    self.timer:after(1, function()
		self.con = 2
		Assets.playSound("rocket_long", 1, 0.6)
	end)
    local starsummoner
    self.timer:after(1.5, function()
        starsummoner = self.timer:every(1/7, function()
            Assets.playSound("stardrop", 0.5, 0.5)
            local direction = love.math.random(135+20, 225-20)
			local bullet = self:spawnBullet("dess/star", 430, 180, math.rad(direction), 7)
			bullet.wave_masked = true
			bullet:addFX(MaskFX(self))
        end)
    end)
    self.timer:after(5, function()
		self.con = 2.5
		self.knockback = 10
        self.timer:cancel(starsummoner)
    end)
end

function Starbeam:update()
    local dess = Game.battle:getEnemyBattler("dess")
	if self.con >= 3 then
		dess.x = MathUtils.lerp(dess.x, self.dess_orig_x, 0.15*DTMULT)
		dess.y = MathUtils.lerp(dess.y, self.dess_orig_y, 0.15*DTMULT)
	elseif self.tween < 1 then
		self.tween = MathUtils.approach(self.tween, 1, 0.05*DTMULT)
		dess.x = MathUtils.lerpEaseOut(self.dess_orig_x, 460, self.tween, 6)
		dess.y = MathUtils.lerpEaseOut(self.dess_orig_y, 220, self.tween, 6)
	end
	if self.con <= 1 then
		if self.con == 0 then
			self.con = 1
		end
		self.ftimer = self.ftimer + DTMULT
	end
	if self.con == 2 then
		if self.angle < self.target_angle then
			self.angle_lerp = MathUtils.approach(self.angle_lerp, 1, 0.025*DTMULT)
			self.angle = MathUtils.lerpEaseOut(0, self.target_angle, self.angle_lerp, 6)
		end
	end
	if self.con == 3 and self.ftimer > 0 then
		self.ftimer = self.ftimer - DTMULT
		if self.ftimer <= 0 then
			self.con = 4
		end
	end
	if self.con == 2.5 then
		if self.angle_lerp <= 0 and self.con < 3 then
			self.ftimer = 10
			dess:setAnimation("idle")
			self.yoff = 120 + MathUtils.randomInt(-60, 60)
			self.con = 3
		end
	end	
	if self.con >= 2.5 then
		self.angle_lerp = MathUtils.approach(self.angle_lerp, 0, 0.1*DTMULT)
		self.angle = MathUtils.lerpEaseIn(0, self.target_angle, self.angle_lerp, 6)
	end
	if self.angle_lerp > 0 then
		if self.flow_color_con == 0 then
			self.flow_color = ColorUtils.mergeColor(COLORS.red, COLORS.yellow, self.flow_color_timer)
			if self.flow_color_timer >= 1 then
				self.flow_color_timer = 0
				self.flow_color_con = 1
			end
		end
		if self.flow_color_con == 1 then
			self.flow_color = ColorUtils.mergeColor(COLORS.yellow, COLORS.blue, self.flow_color_timer)
			if self.flow_color_timer >= 1 then
				self.flow_color_timer = 0
				self.flow_color_con = 2
			end
		end
		if self.flow_color_con == 2 then
			self.flow_color = ColorUtils.mergeColor(COLORS.blue, COLORS.red, self.flow_color_timer)
			if self.flow_color_timer >= 1 then
				self.flow_color_timer = 0
				self.flow_color_con = 0
			end
		end
		self.flow_color_timer = MathUtils.approach(self.flow_color_timer, 1, 0.05*DTMULT)
	end
	if self.knockback ~= 0 then
		local knockback = math.pow(self.knockback/10, 5) * 10
		self.gt_x = self.gt_x - knockback*DTMULT
		self.knockback = MathUtils.approach(self.knockback, 0, 0.5*DTMULT)
		Game.battle.arena.sprite.x = MathUtils.random(-1, 1) * (knockback / 10)
		Game.battle.arena.sprite.y = MathUtils.random(-1, 1) * (knockback / 10)
	else
		self.gt_x = self.gt_x - ((self.angle / self.target_angle)/2) * DTMULT
		if self.con < 3 then
			Game.battle.arena.sprite.x = MathUtils.random(-1, 1) * (self.angle / self.target_angle)
			Game.battle.arena.sprite.y = MathUtils.random(-1, 1) * (self.angle / self.target_angle)
		end
	end
	Game.battle.arena.x = MathUtils.round(self.gt_x)
    super.update(self)
end

function Starbeam:draw()
    super.draw(self)
	if self.con == 1 then
		if self.ftimer < 28 then
			love.graphics.setBlendMode("add")
			Draw.setColor(0.5, 0.5, 0.5, 1)
			Draw.drawPart(self.bullet_flow_tex[3], 0, 180, self.ftimer * 1, (self.ftimer * 4) + self.yoff - 2, 215, 1, 0, 2, 2)
			if MathUtils.round(self.ftimer) % 2 == 0 then
				Draw.drawPart(self.bullet_flow_tex[3], 0, 180, self.ftimer * 2, self.ftimer * 4 + self.yoff, 215, 1, 0, 2, 2)
			end
			love.graphics.setBlendMode("alpha")
		else
			Draw.setColor(1, 1, 1, 1)
			Draw.rectangle("fill", 0, 180, 430, 2)
		end
		return
	end
	if self.con == 3 and self.ftimer > 0 then
		love.graphics.setBlendMode("add")
		Draw.setColor(0.5, 0.5, 0.5, 1)
		Draw.drawPart(self.bullet_flow_tex[3], 0, 180, (10 - self.ftimer) * 2, self.yoff - (10 - self.ftimer) * 4, 215, 1, 0, 2, 2)
		Draw.drawPart(self.bullet_flow_tex[3], 0, 180, (10 - self.ftimer) * 2, self.yoff + (10 - self.ftimer) * 4, 215, 1, 0, 2, 2)
		love.graphics.setBlendMode("alpha")
		self:drawMaskedSprites()
		return
	end
	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	if MathUtils.round(self.ftimer) % 2 >= 1 then
		self.draw_angle = 1
	else
		self.draw_angle = 0
	end
	local angle = self.angle > 0 and self.angle + self.draw_angle or 0
	local xleft = math.cos(math.rad(180) + math.rad(angle/2)) * 600
	local ytop = math.sin(math.rad(180) - math.rad(angle/2)) * 600
	local ybottom = math.sin(math.rad(180) + math.rad(angle/2)) * 600
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		love.graphics.polygon("fill", 430+xleft,180+ytop,430,180,430+xleft,180+ybottom)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		Game.battle.soul:fullDraw(false)
        love.graphics.setShader(last_shader)
    end, "replace", 0, true)
    love.graphics.setStencilTest("greater", 0)
	Draw.setColor(self.flow_color)
	Draw.draw(self.bullet_flow_tex[1], self.bg_x, 0, 0, 2, 2)
	Draw.draw(self.bullet_flow_tex[1], self.bg_x+640, 0, 0, 2, 2)
	Draw.draw(self.bullet_flow_tex[2], self.lines_x, 0, 0, 2, 2)
	Draw.draw(self.bullet_flow_tex[2], self.lines_x+640, 0, 0, 2, 2)
	Draw.setColor(1, 1, 1, MathUtils.lerp(1, 0, self.angle / self.target_angle))
	Draw.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setStencilTest()
	self.lines_x = self.lines_x - 80 * DTMULT
	self.bg_x = self.bg_x - 20 * DTMULT
	if self.lines_x < -640 then
		self.lines_x = self.lines_x + 640
	end
	if self.bg_x < -640 then
		self.bg_x = self.bg_x + 640
	end
	Draw.popCanvas()
	love.graphics.setBlendMode("add")
	Draw.setColor(1, 1, 1, 1)
	Draw.draw(canvas, 0, 0)
	love.graphics.setBlendMode("alpha")
	self:drawMaskedSprites()
end

function Starbeam:drawMaskedSprites()
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		self:drawMask()
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    for _,star in ipairs(Game.battle.stage:getObjects(Sprite)) do
        if star.wave_masked then
			star:fullDraw()
		end
	end
    love.graphics.setStencilTest()
end

function Starbeam:drawMask()
    love.graphics.push()
	if self.con >= 2.5 then
		Draw.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	else
		local angle = self.angle > 0 and self.angle + self.draw_angle or 0
		local xleft = math.cos(math.rad(180) + math.rad(angle/2)) * 600
		local ytop = math.sin(math.rad(180) - math.rad(angle/2)) * 600
		local ybottom = math.sin(math.rad(180) + math.rad(angle/2)) * 600
		love.graphics.polygon("fill", 430+xleft,180+ytop,430,180,430+xleft,180+ybottom)
	end
    love.graphics.pop()
end

return Starbeam