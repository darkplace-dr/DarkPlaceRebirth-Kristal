---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "town_morning")
	self.rain_overlay_alpha = 0
	self.rain_overlay_alpha_target = 0
	if Game.stage:hasWeather("rain") then
		self.rain_overlay_alpha = 0.2
		self.rain_overlay_alpha_target = 0.2
	end
end

function MyBorder:draw()
    super.draw(self)
	local bw, bh = Kristal.getBorderSize()
	if Game.stage:hasWeather("rain") then
		self.rain_overlay_alpha_target = 0.2
	else
		self.rain_overlay_alpha_target = 0	
	end
	local rain_color = ColorUtils.mergeColor(COLORS.white, COLORS.blue, 0.7)
	self.rain_overlay_alpha = MathUtils.approach(self.rain_overlay_alpha, self.rain_overlay_alpha_target, 0.0125 * DTMULT)
    love.graphics.setColor(rain_color[1], rain_color[2], rain_color[3], BORDER_ALPHA * self.rain_overlay_alpha)
    love.graphics.rectangle("fill", 0, 0, bw, bh)
end

return MyBorder