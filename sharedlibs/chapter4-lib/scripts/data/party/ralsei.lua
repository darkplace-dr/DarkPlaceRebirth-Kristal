local character, super = Class("ralsei", true)

function character:init()
    super.init(self)

	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#B5E61DFF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#4A6ACAFF")
end

return character