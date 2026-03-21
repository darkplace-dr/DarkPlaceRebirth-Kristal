---@class TutorialText : Object
local TutorialText, super = Class(Object)

function TutorialText:init(type, target)
    super.init(self)
	self.instruction_type = type or 0
	self.target = target or nil
    self:setPosition(0,0)
    self:setParallax(0,0)
    self.instruction_active = false
    self.instruction_lerp = 0
    self.font = Assets.getFont("main")
	self.instruction_lines = {}
	self.line_count = 0
	self.canceltimer = 0
	self.canceltime = 0
	self.holdvalue = 0
	self.holdvaluelimit = 0
	self.timer_tex = Assets.getFrames("ui/timer/timer")
	if self.instruction_type == 1 then
		self.line_count = 2
		table.insert(self.instruction_lines, {line = "Play", but = "confirm"})
		table.insert(self.instruction_lines, {line = "Exit", but = "cancel", hold = true, cancel = true})
	end
	if self.instruction_type == 2 then
		self.line_count = 3
		table.insert(self.instruction_lines, {line = "Play", but = "confirm"})
		table.insert(self.instruction_lines, {line = "Shift Octave", but = "menu"})
		table.insert(self.instruction_lines, {line = "Exit", but = "cancel", hold = true, cancel = true})
	end
	if self.instruction_type == 3 then
		self.line_count = 3
		table.insert(self.instruction_lines, {line = "Play Piano", but = "confirm"})
		table.insert(self.instruction_lines, {line = "Reset", but = "menu", hold = true})
		table.insert(self.instruction_lines, {line = "Exit", but = "cancel", hold = true, cancel = true})
	end
	if self.instruction_type == 4 then
		self.line_count = 3
		table.insert(self.instruction_lines, {line = "Move Piano", but = "confirm"})
		table.insert(self.instruction_lines, {line = "Exit", but = "cancel", hold = true, cancel = true})
	end
end

function TutorialText:onAdd(parent)
    super.onAdd(self, parent)
    self:setLayer(WORLD_LAYERS["ui"])
end

function TutorialText:update()
    super.update(self)
	if self.target then
		self.instruction_active = false
		if self.target.show_instructions and not self.target.forceend then
			self.instruction_active = true
		end
		self.canceltimer = self.target.canceltimer
		self.canceltime = self.target.canceltime
	end
end

function TutorialText:draw()
    super.draw(self)
    love.graphics.push()
    love.graphics.setFont(self.font)
    if self.instruction_lerp > 0 or self.instruction_active then
		if self.instruction_lerp < 1 and self.instruction_active then
			self.instruction_lerp = math.min(self.instruction_lerp + 0.1 * DTMULT, 1)
		elseif not self.instruction_active then
			self.instruction_lerp = math.max(self.instruction_lerp - 0.1 * DTMULT, 0)
		end
		local easelerp = math.pow(self.instruction_lerp-1, 3) + 1
		local space = 28
		local margin = 20
		local yloc = SCREEN_HEIGHT - (space * (#self.instruction_lines+1)) - margin
		local reddening = MathUtils.clamp(self.canceltimer / self.canceltime, 0, 1)
		local redcol = ColorUtils.mergeColor(COLORS.white, COLORS.red, reddening)
		local butmarg = -12
		for i, lines in ipairs(self.instruction_lines) do
			local xloc = SCREEN_WIDTH + 100 - margin - (easelerp * 100)
			if Input.usingGamepad() then
				local buttspr = Input.getTexture(lines.but)
				local butoffset = 4
				if not lines.cancel then
					local str = " : "..lines.line
					local strwidth = self.font:getWidth(str)
					love.graphics.printfOutline(str, xloc - strwidth, yloc + (space * i), 1)
					local butxpos = xloc - strwidth - buttspr:getWidth() + butmarg
					Draw.draw(buttspr, butxpos, yloc + (space * i) + butoffset, 0, 2, 2)
					if lines.hold ~= nil then
						local holdstr = "Hold "
						local holdstrwidth = self.font:getWidth(holdstr)
						love.graphics.printfOutline(holdstr, butxpos - holdstrwidth, yloc + (space * i), 1)
					end
					if lines.holdvaluelimit ~= nil then
						local holdstr = "Hold "
						local holdstrwidth = self.font:getWidth(holdstr)
						local spritexpos = butxpos - holdstrwidth - 28 - 6
						local spriteypos = yloc + (space * i) + 3
						Draw.setColor(1,1,1,lines.holdvalue / 8)
						Draw.draw(self.timer_tex[1 + math.floor(Utils.clamp((28 - ((self.holdvalue / self.holdvaluelimit) * 28)), 0, 28))], spritexpos, spriteypos, 0, 2, 2)
					end
				else
					local str = " : "..lines.line
					local strwidth = self.font:getWidth(str)
					Draw.setColor(redcol[1], redcol[2], redcol[3], 1)
					love.graphics.printfOutline(str, xloc - strwidth, yloc + (space * i), 1)
					local butxpos = xloc - strwidth - buttspr:getWidth() + butmarg
					Draw.draw(buttspr, butxpos, yloc + (space * i) + butoffset, 0, 2, 2)
					local holdstr = "Hold "
					local holdstrwidth = self.font:getWidth(holdstr)
					love.graphics.printfOutline(holdstr, butxpos - holdstrwidth - 4, yloc + (space * i), 1)
					local spritexpos = butxpos - 4 - 28 - 1 - holdstrwidth + MathUtils.round(butmarg / 2)
					local spriteypos = yloc + (space * i) + 3
					Draw.setColor(redcol[1], redcol[2], redcol[3], self.canceltimer/8)
					if self.instruction_active then
						Draw.draw(self.timer_tex[1 + math.floor(MathUtils.clamp((28 - ((self.canceltimer / self.canceltime) * 28)), 0, 28))], spritexpos, spriteypos, 0, 2, 2)
					end
				end
				Draw.setColor(1,1,1,1)
			else
				local holdstr = ""
				if lines.hold then
					holdstr = "Hold "
				end
				local str = holdstr..Input.getText(lines.but).." : "..lines.line
				local strwidth = self.font:getWidth(str)
				if lines.cancel then
					str = "Hold "..Input.getText(lines.but).." : "..lines.line
					strwidth = self.font:getWidth(str)
					local spritexpos = 720 - easelerp * 100 - MathUtils.round(strwidth) - 28 - 8
					local spriteypos = yloc + (space * i) + 3
					Draw.setColor(redcol[1], redcol[2], redcol[3], self.canceltimer/8)
					if self.instruction_active then
						Draw.draw(self.timer_tex[1 + math.floor(MathUtils.clamp((28 - ((self.canceltimer / self.canceltime) * 28)), 0, 28))], spritexpos, spriteypos, 0, 2, 2)
					end
					Draw.setColor(redcol[1], redcol[2], redcol[3], 1)
				end
				love.graphics.printfOutline(str, xloc - strwidth, yloc + (space * i), 1)
				Draw.setColor(1,1,1,1)
				if lines.holdvaluelimit ~= nil and not lines.cancel then
					local spritexpos = 720 - easelerp * 100 - MathUtils.round(strwidth) - 28 - 8
					local spriteypos = yloc + (space * i) + 3
					Draw.setColor(1,1,1,lines.holdvalue / 8)
					Draw.draw(self.timer_tex[1 + math.floor(MathUtils.clamp((28 - ((self.holdvalue / self.holdvaluelimit) * 28)), 0, 28))], spritexpos, spriteypos, 0, 2, 2)
				end
				Draw.setColor(1,1,1,1)
			end
		end
    end
    love.graphics.pop()
end

return TutorialText