local character, super = Class("noelle", true)

function character:init()
    super.init(self)

	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#ECFFBBFF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#5259C2FF")
end

return character