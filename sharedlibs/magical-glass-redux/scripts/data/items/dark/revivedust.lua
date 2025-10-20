local item, super = Class("revivedust", true)

function item:onLightBattleUse(user, target)
    item:onBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target).."\n"..(#Game.battle.party > 1 and "* Everyone were revived with 25% HP." or self:getLightBattleHealingText(user, target, 10)))
end

return item