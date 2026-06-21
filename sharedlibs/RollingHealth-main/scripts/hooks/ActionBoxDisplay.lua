local ActionBoxDisplay, super = HookSystem.hookScript(ActionBoxDisplay)

function ActionBoxDisplay:getRollHPConfig(name)
	return Kristal.getLibConfig("rolling-health", name)
end

function ActionBoxDisplay:mapRollHPTable(tbl, func)
    local result = {}
    for index, value in ipairs(tbl) do
        result[index] = func(value, index)
    end
    return result
end

function ActionBoxDisplay:drawCurrentHealth(color, x, y)
    local battler = self.actbox.battler
    local string_from = tostring(battler.health_rolling_last)
    local string_to = tostring(battler.chara:getHealth())
    local max_string_length = math.max(StringUtils.len(string_from), StringUtils.len(string_to))
    for i = 1, max_string_length - StringUtils.len(string_from) do
        string_from = ' ' .. string_from
    end
    for i = 1, max_string_length - StringUtils.len(string_to) do
        string_to = ' ' .. string_to
    end
    local health_offset = (max_string_length - 1) * 8
    x = x - health_offset
    local roll_progress = MathUtils.clamp((battler.health_rolling_timer / battler:getRollSpeed()) * self:getRollHPConfig("display_roll_speed"), 0, 1)
    local rolling_down = battler.chara:getHealth() < battler.health_rolling_last
    if rolling_down then roll_progress = 1 - roll_progress end
    if self:getRollHPConfig("stencil") then
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", x, y, health_offset + 8, 10)
        end, "replace", 1)
        love.graphics.setStencilTest("equal", 1)
    end
    for i = 1, max_string_length do
        local number_from, number_to = StringUtils.sub(string_from, i, i) or '', StringUtils.sub(string_to, i, i) or ''
        if number_from == number_to then
            Draw.setColor(color)
            love.graphics.print(number_from, x + (i - 1) * 8, y)
        else
            -- Looks horrible (but it works)
            local function drawNumber(number, first, dark)
                Draw.setColor(self:mapRollHPTable(color, function(value, index)
                    if index == 4 then return self:getRollHPConfig("change_alpha") and (first and roll_progress or (1 - roll_progress)) or value
                    else return (dark and self:getRollHPConfig("darken_previous")) and value * 0.25 or value
                    end
                end))
                love.graphics.print(number, x + (i - 1) * 8, y + (roll_progress - (first and 1 or 0)) * 12)
            end
            if rolling_down then
                drawNumber(number_to, false, false)
                drawNumber(number_from, true, true)
            else
                drawNumber(number_from, false, true)
                drawNumber(number_to, true, false)
            end
        end
    end
    if self:getRollHPConfig("stencil") then
        love.graphics.setStencilTest()
    end
end

function ActionBoxDisplay:draw()
	if self.actbox.battler:canHealthRoll() then
		if Game.battle.current_selecting == self.actbox.index then
			Draw.setColor(self.actbox.battler.chara:getColor())
		else
			Draw.setColor(PALETTE["action_strip"], 1)
		end

		love.graphics.setLineWidth(2)
		love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)

		love.graphics.setLineWidth(2)
		if Game.battle.current_selecting == self.actbox.index then
			love.graphics.line(1  , 2, 1,   36)
			love.graphics.line(212, 2, 212, 36)
		end

		Draw.setColor(PALETTE["action_fill"])
		love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)

		Draw.setColor(PALETTE["action_health_bg"])
		love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, 76, 9)

		if self.actbox.battler.succumbed then
			love.graphics.setFont(self.font)
			Draw.setColor(1, 0, 0)
			love.graphics.print("SUCCUMBED", 129, 9 - self.actbox.data_offset)

			super.super.draw(self)
			return
		end

		local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * 76

		if health > 0 then
			Draw.setColor(self.actbox.battler.chara:getColor())
			love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.ceil(health), 9)
		end

		local health_rolling_diff = ((self.actbox.battler.health_rolling_to - self.actbox.battler.chara:getHealth()) / self.actbox.battler.chara:getStat("health")) * 76
		if health_rolling_diff ~= 0 and health > 0 then
			Draw.setColor(self:mapRollHPTable({self.actbox.battler.chara:getColor()}, function(value, index)
				if index == 4 then return value
				else
					return value * 0.75
				end
			end))
			local x_start = health
			local width = health_rolling_diff
			if health_rolling_diff < 0 then
				x_start = math.ceil(health + width)
				width = math.ceil(width) - 1
			end
			-- Kristal.Console:log(x_start + math.abs(math.floor(width)))
			love.graphics.rectangle("fill", 128 + x_start, 22 - self.actbox.data_offset, math.abs(width), 9)
		end

		local color = PALETTE["action_health_text"]
		if health <= 0 then
			color = PALETTE["action_health_text_down"]
		elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4)) then
			color = PALETTE["action_health_text_low"]
		else
			color = PALETTE["action_health_text"]
		end

		local mortal_damage_color = self:getRollHPConfig("mortal_damage_color")
		if mortal_damage_color and self.actbox.battler.health_rolling_to <= 0 and health > 0 then
			color = mortal_damage_color
			if self.actbox.battler.health_rolling_swooned then
				color = ColorUtils.mergeColor(mortal_damage_color, COLORS.red, 0.5)
			end
		end

		love.graphics.setFont(self.font)
		self:drawCurrentHealth(color, 152, 9 - self.actbox.data_offset)
		Draw.setColor(PALETTE["action_health_text"])
		love.graphics.print("/", 161, 9 - self.actbox.data_offset)
		local string_width = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
		Draw.setColor(color)
		love.graphics.print(self.actbox.battler.chara:getStat("health"), 205 - string_width, 9 - self.actbox.data_offset)
		super.super.draw(self)
	else
		super.draw(self)
	end
end

return ActionBoxDisplay