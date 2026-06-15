local spell, super = Class("dual_heal", true)

function spell:init()
    super.init(self)
    
    self.check = {"Heavenly light restores a little HP to\nall party members.", "* Depends on Magic."}
end

function spell:onLightCast(user, target)
    local base_heal = math.ceil(Game:isLight() and user.chara:getStat("magic") * 2.4 or user.chara:getStat("magic") * 5.5)
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

    for _, battler in ipairs(target) do
        battler:heal(heal_amount)
    end
end

function spell:onCast(user, target)
    if Game:isLight() then
        local base_heal = math.ceil(user.chara:getStat("magic") * 2.4)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

        for _, battler in ipairs(target) do
            battler:heal(heal_amount)
        end
    else
        super.onCast(self, user, target)
    end
end

return spell