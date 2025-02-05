local character, super = Class("kris", true)

function character:init()
    super.init(self)
end

if Kristal.getLibConfig("magical-glass", "debug") then
    function character:onTurnStart(battler)
        super.onTurnStart(self, battler)
        if self:getFlag("auto_attack", false) then
            Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
        end
    end
    
    function character:onLightTurnStart(battler)
        super.onLightTurnStart(self, battler)
        if self:getFlag("auto_attack", false) then
            Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
        end
    end
end

return character