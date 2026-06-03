local spell, super = Class("ultimate_heal", true)

function spell:init()
    super.init(self)
    
    self.check = "Heals 1 party member to the best of Susie's ability."
end

function spell:onLightCast(user, target)
    local base_heal = math.ceil(Game:isLight() and user.chara:getStat("magic") or user.chara:getStat("magic") + 1)
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

    target:heal(heal_amount)
end

function spell:onCast(user, target)
    if Game:isLight() then
        local base_heal = math.ceil(user.chara:getStat("magic"))
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

        target:heal(heal_amount)
    else
        super.onCast(self, user, target)
    end
end

return spell
