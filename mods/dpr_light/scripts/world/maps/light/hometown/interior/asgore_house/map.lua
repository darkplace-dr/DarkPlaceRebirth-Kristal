local asgore_house, super = Class(Map)

function asgore_house:load()
	super.load(self)

	local light_x_pos = 106 * 2
	local light_x_interval = 20 * 2
	local light_colors = { "#FCA8E2", "#FFA786", "#FFF984", "#F9EC00", "#A1F8FF", "#87ACFF", "#BCFFAE" }
	Game.world:addChild(FlowershopHangingLight(light_x_pos, 0, ColorUtils.hexToRGB(light_colors[1])))
	Game.world:addChild(FlowershopHangingLight(light_x_pos, -20 * 2, ColorUtils.hexToRGB(light_colors[6])))
	Game.world:addChild(FlowershopHangingLight((light_x_pos + light_x_interval), -30 * 2, ColorUtils.hexToRGB(light_colors[5])))
	Game.world:addChild(FlowershopHangingLight((light_x_pos + light_x_interval * 2 + 10 * 2), -30 * 2, ColorUtils.hexToRGB(light_colors[4])))
	Game.world:addChild(FlowershopHangingLight((light_x_pos + light_x_interval * 3 + 20 * 2), -30 * 2, ColorUtils.hexToRGB(light_colors[3])))
	Game.world:addChild(FlowershopHangingLight((light_x_pos + light_x_interval * 4 + 20 * 2), -20 * 2, ColorUtils.hexToRGB(light_colors[2])))
	Game.world:addChild(FlowershopHangingLight((light_x_pos + light_x_interval * 4 + 20 * 2), 0, ColorUtils.hexToRGB(light_colors[7])))
end

return asgore_house