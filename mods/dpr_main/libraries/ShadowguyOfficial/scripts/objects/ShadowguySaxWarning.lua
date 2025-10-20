local ShadowguySaxWarning, super = Class(Object)

function ShadowguySaxWarning:init()
    super.init(self)
	
	self:setScale(1)
	self.path = GMPath()
	self.path:init({type = GMPath.TYPE_CURVED, closed = false, precision = 4})
	self.aim_at_player = true
	self.shoot_speed = 1
	self.timer2 = self.shoot_speed
	self.fired_shots = 0
	self.bullet_count = 10
	self.progress_loop = 0
	self.attack_wait_time = 0.6
	self.path_lifetime = 1.2
	self.grow_speed = 0.05
	self.fade_speed = 0.05
	self.sax_animation = nil
	self.anim_change = 0
	self.destroy_time = 30
	self.loop_start = 0
	self.color_progress = 0
	self.alpha = 1
	self.started = false
end

function ShadowguySaxWarning:update()
	super.update(self)
	
	--if (self.anim_change == 1 & self.progress_loop) > self.attack_wait_time + 1 then
	--	self.anim_change = 0
	--end
	
	self.loop_start = self.progress_loop
	
	if self.loop_start > 1 then
		if self.loop_start > 2 then
			self.color_progress = 2
		else
			self.color_progress = self.loop_start - 1
		end
	end
	
	if self.progress_loop >= self.path_lifetime then
		self.progress_loop = self.progress_loop + self.fade_speed * DTMULT
		self.alpha = self.path_lifetime + 1 - self.progress_loop
	else
		self.progress_loop = self.progress_loop + self.grow_speed * DTMULT
		self.alpha = 1
	end
	if self.progress_loop > self.attack_wait_time then
		if self.timer2 >= self.shoot_speed then
			if self.anim_change == 0 then
				self.anim_change = 1
				Assets.stopSound("shadowman_sax_long_1")
				Assets.stopSound("shadowman_sax_long_2")
				Assets.stopSound("shadowman_sax_long_3")
				Assets.stopSound("shadowman_sax_long_4")
				Assets.stopSound("shadowman_sax_long_solo_note")
				Assets.playSound(Utils.pick({"shadowman_sax_long_1", "shadowman_sax_long_2", "shadowman_sax_long_3", "shadowman_sax_long_4", "shadowman_sax_long_solo_note"}))
				local dir = Utils.angle(self.x, self.y, self.path:getPosition(0.02).x, self.path:getPosition(0.02).y)			
				self.wave.timer:script(function(wait)
					for i = 1, self.bullet_count do
						local d = self.wave:spawnBullet("shadowguy/saxnote", -20, -20)
						d.xx = self.x
						d.yy = self.y
						d.direction = dir
						d.path = self.path
						wait(0.05)
					end
				end)
			end
		end
	end
end


function ShadowguySaxWarning:startSax()
	self.path:clear()
	local relative_y = 0
	self.path:addPoint(self.x, self.y, 100)
	self.path:addPoint(self.x - 30, self.y - 20, 100)
	local boxy = Game.battle.arena.top-70 -- evil boxy boo
	for i = 1, 5 do
		local xpoint = (-150 * i) + self.x
		if self.aim_at_player and relative_y == 0 and (xpoint - Game.battle.soul.x) <= 150 then
			relative_y = Utils.random(-80 * i, 80 * i) + boxy
			self.path:addPoint(xpoint, relative_y, 100)
			relative_y = (Game.battle.soul.y - relative_y) / math.abs(Game.battle.soul.x - xpoint)
		elseif self.aim_at_player and relative_y ~= 0 then
			relative_y = Game.battle.soul.y + (relative_y * math.abs(Game.battle.soul.x - xpoint))
			self.path:addPoint(xpoint, Utils.clamp(relative_y, (-80 * i) + boxy, (80 * i) + boxy), 100)
			relative_y = 0
		else		
			self.path:addPoint(xpoint, Utils.random((-80 * i) + boxy, (80 * i) + boxy), 100)
		end
	end
	self.started = true
end

function ShadowguySaxWarning:inverseLerp(a, b, t, oob)
    if (b == a) then
        return 0
    end
    return (t - a) / (b - a)
end

function ShadowguySaxWarning:draw()
	super.draw(self)
	if not self.started then return end
	local line_length = 0.0125
	
	local i = math.min(self.loop_start, 1)
	while i > 0 do
		local first_color = Utils.mergeColor(COLORS["red"], COLORS["gray"], self.loop_start+0.5-i)
		if self.color_progress < 1 then
			self.color_progress = self.color_progress + 0.05 * DTMULT
		end
		local x1, y1 = self.path:getPosition(i).x, self.path:getPosition(i).y
		local x2, y2 = self.path:getPosition(i-line_length).x, self.path:getPosition(i-line_length).y
		love.graphics.setLineWidth(1)
		love.graphics.setColor(first_color[1], first_color[2], first_color[3], self.alpha)
		love.graphics.line(x1, y1, x2, y2)
		local gap1, gap2
		if i >= 0.25 then
			gap1 = Utils.lerp(5, 8, math.pow(Utils.clamp(self:inverseLerp(0.25, 1, i), 0, 1), 2))
		else
			gap1 = Utils.lerp(2, 5, math.pow(Utils.clamp(self:inverseLerp(0, 0.25, i), 0, 1), 2))
		end
		if i-line_length >= 0.25 then
			gap2 = Utils.lerp(5, 8, math.pow(Utils.clamp(self:inverseLerp(0.25, 1, i-line_length), 0, 1), 2))
		else
			gap2 = Utils.lerp(2, 5, math.pow(Utils.clamp(self:inverseLerp(0, 0.25, i-line_length), 0, 1), 2))
		end
		local dir1, dir2
		if i == 1 then
			dir1 = Utils.angle(x1, y1, x2, y2) + math.rad(90)
		else
			dir1 = Utils.angle(self.path:getPosition(i+line_length).x, self.path:getPosition(i+line_length).y, x2, y2) + math.rad(90)
		end
		if i == line_length then
			dir2 = math.rad(90)
		else
			dir2 = Utils.angle(x1, y1, self.path:getPosition(i-(line_length*2)).x, self.path:getPosition(i-(line_length*2)).y) + math.rad(90)
		end
		local xx1 = math.cos(dir1) * gap1
		local yy1 = math.sin(dir1) * gap1
		local xx2 = math.cos(dir2) * gap2
		local yy2 = math.sin(dir2) * gap2
		love.graphics.line(x1 - (xx1 * 2), y1 - (yy1 * 2), x2 - (xx2 * 2), y2 - (yy2 * 2))
		love.graphics.line(x1 - (xx1 * 1), y1 - (yy1 * 1), x2 - (xx2 * 1), y2 - (yy2 * 1))
		love.graphics.line(x1 + (xx1 * 1), y1 + (yy1 * 1), x2 + (xx2 * 1), y2 + (yy2 * 1))
		love.graphics.line(x1 + (xx1 * 2), y1 + (yy1 * 2), x2 + (xx2 * 2), y2 + (yy2 * 2))
		if (i % 0.05) >= 0.024 and (i % 0.05) <= 0.026 then
			love.graphics.line(x1 - (xx1 * 2), y1 - (yy1 * 2), x1 + (xx2 * 2), y1 + (yy2 * 2))
		end
		love.graphics.setColor(1,1,1,1)
		i = i - line_length
	end
end

return ShadowguySaxWarning