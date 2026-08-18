---@class TensionBar : TensionBar
local TensionBar, super = HookSystem.hookScript(TensionBar)

function TensionBar:hasReducedTension()
    return ((Game.battle and Game.battle:hasReducedTension()) or (not Game.battle and Game.world:hasReducedTension())) or false
end

return TensionBar