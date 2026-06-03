---@class EasingSoulMenuComponent : EasingSoulMenuComponent
local EasingSoulMenuComponent, super = HookSystem.hookScript(EasingSoulMenuComponent)

function EasingSoulMenuComponent:init(x_sizing, y_sizing, options)
    super.init(self, x_sizing, y_sizing, options)

    if self.soul_sprite then
        self.soul_sprite:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_menu")
    end
end

return EasingSoulMenuComponent