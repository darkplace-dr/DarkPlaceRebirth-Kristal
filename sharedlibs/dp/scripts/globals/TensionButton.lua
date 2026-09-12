---@class TensionButton : ActionButton
---@overload fun(...) : TensionButton
local TensionButton, super = Class(ActionButton)

---@param battler PartyBattler
---@param x number
---@param y number
function TensionButton:init(battler, x, y)
    super.init(self, battler, x, y)
end

function TensionButton:getTexture()
    return Assets.getTexture("ui/battle/btn/tension")
end

function TensionButton:getHoveredTexture()
    return Assets.getTexture("ui/battle/btn/tension_h")
end

function TensionButton:getSpecialTexture()
    return Assets.getTexture("ui/battle/btn/tension_a")
end

function TensionButton:getDisabledTexture()
    return Assets.getTexture("ui/battle/btn/tension_d")
end

function TensionButton:select()
    Game.battle:pushAction("TENSION", nil, { tp = -Game.battle:getDefendTension(self.battler) * 2 })
end

return TensionButton
