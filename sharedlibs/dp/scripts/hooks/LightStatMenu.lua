---@class LightStatMenu : LightStatMenu
local LightStatMenu, super = HookSystem.hookScript(LightStatMenu)

function LightStatMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/" .. Game:getSoulPartyMember():getSoulFacing() .. "/heart_menu")

    if Game:getFlag("tension_storage", false) then
        self.tension_bar = self:createTensionBar()
    end
end

function LightStatMenu:createTensionBar()
    local bar
    if MagicalGlassLib then
        bar = LightTensionBar(560, 70, true)
    else
        bar = TensionBar(560, 70, true)
    end
    bar:setParallax(0, 0)
    bar.layer = WORLD_LAYERS["ui"]
    return Game.world:addChild(bar)
end

function LightStatMenu:onRemoveFromStage()
	if self.tension_bar then self.tension_bar:remove() end
end

return LightStatMenu