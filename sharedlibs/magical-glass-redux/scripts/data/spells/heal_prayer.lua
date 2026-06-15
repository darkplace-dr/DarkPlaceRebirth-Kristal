local spell, super = Class("heal_prayer", true)

function spell:init()
    super.init(self)
    
    self.check = {"Heavenly light restores a little HP to\none party member.", "* Depends on Magic."}
end

function spell:onLightCast(user, target)
    local base_heal = math.ceil(Game:isLight() and user.chara:getStat("magic") * 2 or user.chara:getStat("magic") * 5)
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
    
    target:heal(heal_amount)
end

function spell:onCast(user, target)
    if Game:isLight() then
        local base_heal = math.ceil(user.chara:getStat("magic") * 2)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

        target:heal(heal_amount)
    else
        super.onCast(self, user, target)
    end
end

function spell:onLightWorldCast(chara)
    Game.world:heal(chara, 60)
end

return spell