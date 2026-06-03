---@class TextChoicebox : TextChoicebox
local TextChoicebox, super = HookSystem.hookScript(TextChoicebox)

function TextChoicebox:init(x, y, width, height, default_font, default_font_size, battle_box)
    super.init(self, x, y, width, height, default_font, default_font_size, battle_box)

    self.heart = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
end

return TextChoicebox