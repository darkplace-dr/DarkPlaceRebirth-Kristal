---@class SoulMenuItemComponent : SoulMenuItemComponent
local SoulMenuItemComponent, super = HookSystem.hookScript(SoulMenuItemComponent)

function SoulMenuItemComponent:draw()
    super.super.draw(self)

    if self.draw_soul and self.selected and self.parent:isFocused() then
        love.graphics.setColor(Kristal.getSoulColor())
        love.graphics.draw(Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu"), 0, 10, 0, 2, 2)
    end
end

return SoulMenuItemComponent