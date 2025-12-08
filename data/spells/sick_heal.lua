local spell, super = Class(Spell, "sick_heal")

function spell:init()
    super.init(self)

    if self.cost == 80 then
        Game:setFlag("susie_heal", 0)
    end

    -- Battle description
    self.effect = "Best\nhealing"

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    if Game:getFlag("susie_heal") ~= 30 and not Game:getFlag("kindness_heal") then
        local base_heal = user.chara:getStat("magic") * 6 + 15 + Game:getFlag("susie_heal") * 4
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        Game:addFlag("susie_heal", 1)
    elseif Game:getFlag("kindness_heal") then
        local base_heal = user.chara:getStat("magic") * 8 + user.chara:getStat("attack") * 3 + Game:getFlag("susie_heal") * 5
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
    else
        local base_heal = user.chara:getStat("magic") * 8 + user.chara:getStat("attack") * 3 + Game:getFlag("susie_heal") * 4
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        Game:setFlag("susie_heal", 30)
    end
end

function spell:getName()
    if Game:getFlag("kindness_heal") then
        return "KindnessHeal"
    elseif Game:getFlag("susie_heal") == 30 then
        return "SkilledHeal"
    else
        return "SickHeal"
    end
end

function spell:getCastName()
    if Game:getFlag("kindness_heal") then
        return "KINDNESSHEAL"
    elseif Game:getFlag("susie_heal") == 30 then
        return "SKILLEDHEAL"
    else
        return "SICKHEAL"
    end
end

function spell:getDescription()
    if Game:getFlag("susie_heal") == 30 then
        return "With all that effort, you've reached its\nobsolete state. It is now complete."
    elseif Game:getFlag("kindness_heal") then
        return "With the axe's powers, you've reached its\nfinal state. Yet, its not perfect enough."
    else
        return "It has lost its spark over time.\nWill you be able to restore it?"
    end    
end

function spell:getTPCost()
    if Game:getFlag("kindness_heal") then
        return 50
    else
        return 80 - Game:getFlag("susie_heal")
    end
end

return spell
