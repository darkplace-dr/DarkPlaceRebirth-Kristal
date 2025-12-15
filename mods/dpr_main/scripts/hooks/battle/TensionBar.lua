---@class TensionBar : TensionBar
local TensionBar, super = HookSystem.hookScript(TensionBar)

function TensionBar:init(x, y, dont_animate, volume_mode)
	super.init(self, x, y, dont_animate)
	
	self.mic = Mod.mic_controller
	self.volume_bar_mode = volume_mode or false
	if Game.battle and Game.battle.encounter and Game.battle.encounter.mike_battle then
		self.volume_bar_mode = true
	end
	if self.volume_bar_mode then
		self.tp_text = Assets.getTexture("ui/battle/vol_text")
        self.tp_bar_fill = Assets.getTexture("ui/battle/vol_bar_fill")
        self.tp_bar_outline = Assets.getTexture("ui/battle/vol_bar_outline")
	end
	self.right_shoulder_display = false
	self.left_shoulder_display = false
	if Kristal.isConsole() then
		self.right_shoulder_display = true
		self.left_shoulder_display = true
		for aliasname, lalias in pairs(Input.gamepad_bindings) do
			for keyindex, lkey in ipairs(lalias) do
				if Utils.equal(lkey, "gamepad:rightshoulder") then
					self.right_shoulder_display = false
				end
				if Utils.equal(lkey, "gamepad:leftshoulder") then
					self.left_shoulder_display = false
				end
			end
		end
	end
end

function TensionBar:drawText()
	if self.volume_bar_mode then
		Draw.setColor(1, 1, 1, 1)
		Draw.draw(self.tp_text, -30, 30)

		local tamt = MathUtils.round(self.mic.mic_volume_real)
		self.maxed = false
		love.graphics.setFont(self.font)
		if (tamt < 100) then
			love.graphics.print(tostring(tamt), -30, 70)
			love.graphics.print("%", -25, 95)
		end
		if (tamt >= 100) then
			self.maxed = true

			self:drawMaxText()
		end
		
		if Kristal.isConsole() then
			local lx, ly = -14 - 10, -20
			local rx, ry = -14 + 36, -20
			if Input.getControllerType() == "ps4" then
				lx, ly = -14 - 14, -37
				rx, ry = -14 + 32, -37
			end
			Draw.setColor(ColorUtils.mergeColor(COLORS["gray"], COLORS["white"], MathUtils.clamp(self.mic.mic_volume_real/50, 0, 1)))
			if self.right_shoulder_display then
				Draw.draw(Input.getButtonTexture("gamepad:rightshoulder"), MathUtils.lerp(lx, rx, 0.5), ly, 0, 2, 2)
			elseif self.left_shoulder_display then
				Draw.draw(Input.getButtonTexture("gamepad:leftshoulder"), MathUtils.lerp(lx, rx, 0.5), ly, 0, 2, 2)
			end
			Draw.setColor(1, 1, 1, 1)
		end
	else
		super.drawText(self)
	end
end

function TensionBar:drawBack()
	if self.volume_bar_mode then
		Draw.setColor(ColorUtils.mergeColor(COLORS["red"], COLORS["black"], 0.75))
		Draw.pushScissor()
		Draw.scissorPoints(0, 0, 25, (196 * 0.1) + 1)
		Draw.draw(self.tp_bar_fill, 0, 0)
		Draw.popScissor()
		
		Draw.setColor(ColorUtils.mergeColor(COLORS["yellow"], COLORS["black"], 0.75))
		Draw.pushScissor()
		Draw.scissorPoints(0, (196 * 0.1), 25, (196 * 0.4) + 1)
		Draw.draw(self.tp_bar_fill, 0, 0)
		Draw.popScissor()
		
		Draw.setColor(ColorUtils.mergeColor(COLORS["green"], COLORS["black"], 0.75))
		Draw.pushScissor()
		Draw.scissorPoints(0, (196 * 0.4), 25, (196 * 0.9) + 1)
		Draw.draw(self.tp_bar_fill, 0, 0)
		Draw.popScissor()
		
		Draw.setColor(ColorUtils.mergeColor(COLORS["aqua"], COLORS["black"], 0.75))
		Draw.pushScissor()
		Draw.scissorPoints(0, (196 * 0.9), 25, 196 + 1)
		Draw.draw(self.tp_bar_fill, 0, 0)
		Draw.popScissor()
	else
		super.drawBack(self)
	end
end

function TensionBar:drawFill()
	if self.volume_bar_mode then
		love.graphics.setColor(COLORS["aqua"])
		if self.mic.mic_volume_real > 10 then
			love.graphics.setColor(COLORS["lime"])
		end
		if self.mic.mic_volume_real > 60 then
			love.graphics.setColor(COLORS["yellow"])
		end
		if self.mic.mic_volume_real > 90 then
			love.graphics.setColor(COLORS["red"])
		end
        Draw.pushScissor()
        Draw.scissorPoints(0, 197 - ((self.mic.mic_volume_real/100) * 196) - 4, 25, 197)
        Draw.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
	else
		super.drawFill(self)
	end
end

return TensionBar