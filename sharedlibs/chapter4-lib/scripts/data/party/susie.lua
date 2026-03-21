local character, super = HookSystem.hookScript("susie")
---@cast character PartyMember
---@cast super PartyMember

function character:init()
    super.init(self)

	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#EA79C8FF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#383F9DFF")
end

return character
