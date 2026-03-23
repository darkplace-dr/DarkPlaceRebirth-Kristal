local TennaBattleBackground, super = Class(BattleBackground)

function TennaBattleBackground:init()
    super.init(self)
	self.starbgtile_tex = Assets.getFrames("ui/tv_starbgtile/rainbow/starbgtile")
	self.starbgtile_blue_tex = Assets.getTexture("ui/tv_starbgtile/starbgtile_allblue")
	self.crowd_tex = Assets.getFrames("world/events/teevie_cameras/crowd_a")
	self.siner = 0
	self.rate = 1
	self.font = Assets.getFont("8bit")
	self.score = 0
	self.addscore = 0
	self.addscorereason = nil
	self.battle_started = false
	self.stop_counting_points = false
	self.move_timer_offset = false
	self.scoretimer = 0
	self.scorecountdelay = 0
	self.battle_timer = 400*20
	self.battle_timer_max = self.battle_timer
	self.timeloss_timer = 0
	self.timeloss_max = 35
	self.time_offy = 0
	self.scrollx = 0
	self.audience_y_pos = SCREEN_HEIGHT+80
	self.gameover = false
	self.dark_amount = 0
end

function TennaBattleBackground:addScore(score, clamp, reason, delay)
	self.addscore = self.addscore + score
	if clamp then
		if self.score >= 0 and self.score+self.addscore < 0 then
			self.addscore = -self.score
		end
	end
	self.addscorereason = reason or nil
    self.scorecountdelay = delay or self.scorecountdelay
end

function TennaBattleBackground:getAddScore()
    return self.addscore
end

function TennaBattleBackground:printOutline(string, x, y, color, outlinecolor, alpha, align, r, sx, sy, ox, oy, kx, ky)
    color = color or {love.graphics.getColor()}
    outlinecolor = outlinecolor or COLORS.blue
    Draw.setColor(outlinecolor[1], outlinecolor[2], outlinecolor[3], alpha or 1)
    Draw.printAlign(string, x - sx or 1, y, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
	Draw.printAlign(string, x + sx or 1, y, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x, y - sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x, y + sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x - sx or 1, y - sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x + sx or 1, y + sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x + sx or 1, y - sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
    Draw.printAlign(string, x - sx or 1, y + sy or 1, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)

    Draw.setColor(color[1], color[2], color[3], alpha or 1)
    Draw.printAlign(string, x, y, align or "left", r or 0, sx or 1, sy or 1, ox or 0, oy or 0, kx or 0, ky or 0)
end

function TennaBattleBackground:update()
	super.update(self)
	if not self.battle_started or self.gameover then return end
	if self.scorecountdelay < 1 then
		self.scoretimer = self.scoretimer + DTMULT
		if self.scoretimer >= 1 then
			local rep = 10
			if self.addscore <= 20 then
				rep = 1
			end
			for i = 0, rep do
				if self.addscore > 0 and not self.stop_counting_points then
					self.addscore = self.addscore - 1
					self.score = self.score + 1
					self.timeloss_max = 35
				end
			end
			rep = 10
			if self.addscore >= -20 or self.addscorereason == "bet" then
				rep = 1
			end
			for i = 0, rep do
				if self.addscore < 0 and (not self.stop_counting_points or self.addscorereason == "bet") then
					self.addscore = self.addscore + 1
					self.score = self.score - 1
					self.timeloss_max = 35
				end
			end
			self.scoretimer = 0
		end
	else
		self.scorecountdelay = self.scorecountdelay - DTMULT
	end
	if self.stop_counting_points then
		if self.move_timer_offset then
			self.time_offy = MathUtils.lerp(self.time_offy, 45, 0.15*DTMULT)
		end
		self.battle_timer = self.battle_timer - 0.5 * DTMULT
	else
		self.time_offy = MathUtils.lerp(self.time_offy, 0, 0.25*DTMULT)
		self.battle_timer = self.battle_timer - 1 * DTMULT
		if self.addscore == 0 then
			self.timeloss_timer = self.timeloss_timer + DTMULT
			if self.timeloss_timer >= self.timeloss_max then
				if self.score > 0 then
					self.score = self.score - 1
				end
				self.timeloss_timer = 0
				self.timeloss_max = MathUtils.approach(self.timeloss_max, 3, 1)
			end
		end
	end
end

function TennaBattleBackground:drawBackground()
	self.siner = self.siner + self.rate * DTMULT
	local col = {ColorUtils.HSVToRGB((self.siner / 255) % 1, 1, 1)}
	local col2 = {ColorUtils.HSVToRGB((self.siner / 255) % 1, 1, 0.5)}
	Draw.setColor(col[1], col[2], col[3], self.alpha)
	local frame = (math.floor(self.siner)%#self.starbgtile_tex)+1
	Draw.drawWrapped(self.starbgtile_tex[frame], true, true, self.siner, self.siner, 0, 2, 2)
    love.graphics.setColor(0, 0, 0, self.dark_amount / 20)
    love.graphics.rectangle("fill", -40, -40, SCREEN_WIDTH + 80, SCREEN_HEIGHT + 80)
	love.graphics.setFont(self.font)
    self:printOutline(self.score, 320, 80-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 2 + (math.sin(self.siner / 4) * 0.3), 1.5)
    self:printOutline("SCORE", 320, 50-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 2 + (math.sin(self.siner / 4) * 0.05), 1.5 + (math.sin(self.siner / 4) * 0.1))
	if self.addscore > 0 then
	    self:printOutline("bonus", 320 + 114, 50-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 0.7 + (math.sin(self.siner / 6) * 0.2), 1.5)
		self:printOutline("+"..self.addscore, 320 + 110, 80-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 1 + (math.sin(self.siner / 6) * 0.2), 1.5)
	end
	if self.addscore < 0 then
		if self.addscorereason == "bet" then
			self:printOutline("bet", 320 + 110, 50-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 1 + (math.sin(self.siner / 6) * 0.2), 1.5)
		else
			self:printOutline("lost", 320 + 114, 50-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 1 + (math.sin(self.siner / 6) * 0.2), 1.5)
		end
		self:printOutline(self.addscore, 320 + 110, 80-self.time_offy/3, COLORS.white, col2, self.alpha, "center", 0, 1 + (math.sin(self.siner / 6) * 0.2), 1.5)
	end
	if self.gameover then
		self:printOutline("FINISH!", 320, 235+self.time_offy, COLORS.white, col2, self.alpha, "center", 0, 2 + (math.sin(self.siner / 4) * 0.05), 1.5 + (math.sin(self.siner / 4) * 0.1))
	else
		Draw.setColor(1, 1, 1, 0.2 + (math.sin(self.siner / 6) * 0.04) * self.alpha)
		love.graphics.rectangle("fill", 135, 215+self.time_offy, (self.battle_timer/self.battle_timer_max)*372, 65)
		Draw.setColor(0, 0, 0, 0.4 + (math.sin(self.siner / 6) * 0.04) * self.alpha)
		love.graphics.rectangle("fill", 135+(self.battle_timer/self.battle_timer_max)*372, 215+self.time_offy, 372-((self.battle_timer/self.battle_timer_max)*372), 65)
		local timecol = COLORS.white
		local timecol2 = col2
		if self.battle_timer <= self.battle_timer_max/4 then
			timecol = ColorUtils.mergeColor({1,0.5,0.5}, COLORS.white, (self.battle_timer/(self.battle_timer_max/4)))
			timecol2 = ColorUtils.mergeColor(COLORS.maroon, col2, (self.battle_timer/(self.battle_timer_max/4)))
		end
		self:printOutline("TIME REMAINING", 320, 220+self.time_offy, timecol, timecol2, self.alpha, "center", 0, 1.3 + (math.sin(self.siner / 4) * 0.05), 1.5 + (math.sin(self.siner / 4) * 0.1))
		self:printOutline(MathUtils.round(self.battle_timer/20), 320, 250+self.time_offy, timecol, timecol2, self.alpha, "center", 0, 2 + (math.sin(self.siner / 4) * 0.3), 1.5)
	end
	local vx = 314
	local xsep = 70
	self.scrollx = self.scrollx + 3 * self.rate * DTMULT
	if self.scrollx >= 70 then
		self.scrollx = self.scrollx - 70
	end

	if self.scrollx < 0 then
		self.scrollx = self.scrollx + 70
	end
	Draw.setColor(1,1,1,self.alpha)
	for i = -12, 10, 2 do
		local myx = vx + ((i * xsep) / 2) + (self.scrollx * 1.5)
		Draw.draw(self.crowd_tex[(math.floor(math.abs(myx / 60))%#self.crowd_tex)+1], myx, self.audience_y_pos + (math.sin((self.siner / 12) + (myx / 80)) * 12) + (math.sin(myx / 20) * 8), 0, 1, 1, 44, 56);
	end
	for i = -11, 10, 2 do
		local myx = vx + ((i * xsep) / 2) + (self.scrollx * 1.5)
		Draw.draw(self.crowd_tex[(math.floor(math.abs(myx / 60))%#self.crowd_tex)+1], myx, self.audience_y_pos + (math.sin((self.siner / 12) + (myx / 80)) * 12) + (math.sin(myx / 20) * 8), 0, 1, 1, 44, 56);
	end
end

return TennaBattleBackground