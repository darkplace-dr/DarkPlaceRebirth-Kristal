local pre_ebott, super = Class(Map)

function pre_ebott:load()
	super.load(self)
end

function pre_ebott:init(world, data)
	super.init(self, world, data)
	self.bg_colors = {
		{ColorUtils.hexToRGB("#32b9ff"), ColorUtils.hexToRGB("#5c9fae")},
		{ColorUtils.hexToRGB("#2b99e3"), ColorUtils.hexToRGB("#5c9fae")},
		{ColorUtils.hexToRGB("#8a3b56"), ColorUtils.hexToRGB("#4d3c60")},
		{ColorUtils.hexToRGB("#15153e"), ColorUtils.hexToRGB("#171821")}
	}
	local overcast_alpha = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				overcast_alpha = (w.weathertimer / 120)
			end
		end
	end
	if Game:getFlag("hometown_time", "day") == "day" then
		self.bg_color = ColorUtils.mergeColor(self.bg_colors[1][1], self.bg_colors[1][2], overcast_alpha)
	elseif Game:getFlag("hometown_time", "day") == "morning" then
		self.bg_color = ColorUtils.mergeColor(self.bg_colors[2][1], self.bg_colors[2][2], overcast_alpha)
	elseif Game:getFlag("hometown_time", "day") == "evening" then
		self.bg_color = ColorUtils.mergeColor(self.bg_colors[3][1], self.bg_colors[3][2], overcast_alpha)
	elseif Game:getFlag("hometown_time", "day") == "night" then
		self.bg_color = ColorUtils.mergeColor(self.bg_colors[4][1], self.bg_colors[4][2], overcast_alpha)
	end
	self.last_overcast_alpha = overcast_alpha
end

function pre_ebott:update()
	super.update(self)
	local overcast_alpha = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				overcast_alpha = (w.weathertimer / 120)
			end
		end
	end
	if self.last_overcast_alpha ~= overcast_alpha then
		if Game:getFlag("hometown_time", "day") == "day" then
			self.bg_color = ColorUtils.mergeColor(self.bg_colors[1][1], self.bg_colors[1][2], overcast_alpha)
		elseif Game:getFlag("hometown_time", "day") == "morning" then
			self.bg_color = ColorUtils.mergeColor(self.bg_colors[2][1], self.bg_colors[2][2], overcast_alpha)
		elseif Game:getFlag("hometown_time", "day") == "evening" then
			self.bg_color = ColorUtils.mergeColor(self.bg_colors[3][1], self.bg_colors[3][2], overcast_alpha)
		elseif Game:getFlag("hometown_time", "day") == "night" then
			self.bg_color = ColorUtils.mergeColor(self.bg_colors[4][1], self.bg_colors[4][2], overcast_alpha)
		end
		self.last_overcast_alpha = overcast_alpha
	end
end

return pre_ebott