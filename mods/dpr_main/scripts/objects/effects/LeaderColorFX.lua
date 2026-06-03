local LeaderColorFX, super = Class(RecolorFX)

function LeaderColorFX:init()
    super.init(self)

    -- all getColor() functions in tables because they return already unpacked rgb
    self.fx_color = {Game.party[1]:getColor()}
	self.fx_color_con = 0
	self.fx_color_timer = 0
end

function LeaderColorFX:update()
    super.update(self)

    if #Game.party >= 4 then
        if self.fx_color_con == 0 then
			self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 1
			end
		end
		if self.fx_color_con == 1 then
			self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[3]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 2
			end
		end
		if self.fx_color_con == 2 then
			self.fx_color = ColorUtils.mergeColor({Game.party[3]:getColor()}, {Game.party[4]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 3
			end
		end
        if self.fx_color_con == 3 then
			self.fx_color = ColorUtils.mergeColor({Game.party[4]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 0
			end
		end
		self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
    elseif #Game.party == 3 then
        if self.fx_color_con > 2 then self.fx_color_con = 0 end -- reset
        if self.fx_color_con == 0 then
			self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 1
			end
		end
		if self.fx_color_con == 1 then
			self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[3]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 2
			end
		end
		if self.fx_color_con == 2 then
			self.fx_color = ColorUtils.mergeColor({Game.party[3]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 0
			end
		end
		self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
    elseif #Game.party == 2 then
        if self.fx_color_con > 1 then self.fx_color_con = 0 end -- reset
        if self.fx_color_con == 0 then
			self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 1
			end
		end
		if self.fx_color_con == 1 then
			self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
			if self.fx_color_timer >= 1 then
				self.fx_color_timer = 0
				self.fx_color_con = 0
			end
		end
		self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
    else
        self.fx_color = {Game.party[1]:getColor()}
    end
end

function LeaderColorFX:draw(texture)
	if Kristal.Config["simplifyVFX"] or #Game.party == 1 then
		Draw.setColor(Game.party[1]:getColor())
	else
		Draw.setColor(self.fx_color)
	end
    Draw.drawCanvas(texture)
end

function LeaderColorFX:getColor()
	if Kristal.Config["simplifyVFX"] or #Game.party == 1 then
		return Game.party[1]:getColor()
	end
    return self.fx_color
end

return LeaderColorFX