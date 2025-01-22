local item, super = Class("revivebrite", true)

function item:init()
    super.init(self)
    
    self.short_name = "RevivBrite"
end

function item:onLightBattleUse(user, target)
    item:onBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target).."\n"..(#Game.battle.party > 1 and "* Everyone were revived with 100% HP." or self:getLightBattleHealingText(user, target, 50)))
end

return item