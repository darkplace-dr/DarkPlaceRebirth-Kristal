local character, super = HookSystem.hookScript("kris")
---@cast character PartyMember
---@cast super PartyMember

function character:init()
    super.init(self)

	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#00A2E8FF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#526ACDFF")
end

return character
