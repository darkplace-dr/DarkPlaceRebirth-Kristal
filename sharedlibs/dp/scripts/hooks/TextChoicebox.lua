---@class TextChoicebox : TextChoicebox
local TextChoicebox, super = HookSystem.hookScript(TextChoicebox)

function TextChoicebox:init(x, y, width, height, default_font, default_font_size, battle_box)
    super.init(self, x, y, width, height, default_font, default_font_size, battle_box)

    self.heart = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")

    self.heart_x = 122 + (self.current_choice - 1) * 192
    self.heart_y = 76
end

function TextChoicebox:shouldUseNewStyle()
    return Game:getConfig("newChoicers")
end

function TextChoicebox:draw()
    if self:shouldUseNewStyle() then
        super.super.draw(self)
        if not self:isTyping() then
            local t = 1 - (1 - 0.8) ^ DTMULT
            self.heart_x = MathUtils.lerp(self.heart_x, 122 + (self.current_choice - 1) * 192, t)

            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart, self.heart_x, self.heart_y, 0, 2, 2)
            Draw.setColor(1, 1, 1)
        end
    else
        super.draw(self)
    end
end

return TextChoicebox