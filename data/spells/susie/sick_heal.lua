local spell, super = Class(Spell, "sick_heal")

function spell:init()
    super.init(self)

    -- Battle description
    self.effect = "Best\nhealing"

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- TP cost
    self.cost = 80

    -- Tags that apply to this spell
    self.tags = { "heal" }
end

function spell:onCast(user, target)
    local _, yellowhat_count = user.chara:checkArmor("yellowhat")

    if user.chara:getFlag("healing_used", 0) < 30 and not Game:getFlag("kindness_heal") then
        local base_heal = user.chara:getStat("magic") * 6 + 15 + user.chara:getFlag("healing_used", 0) * 4
        base_heal = base_heal + ((base_heal * 0.2) * yellowhat_count)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        user.chara:addFlag("healing_used", 1)
    elseif Game:getFlag("kindness_heal") then
        local base_heal = user.chara:getStat("magic") * 8 + user.chara:getStat("attack") * 3 + user.chara:getFlag("healing_used", 0) * 5
        base_heal = base_heal + ((base_heal * 0.2) * yellowhat_count)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
    else
        local base_heal = user.chara:getStat("magic") * 8 + user.chara:getStat("attack") * 3 + user.chara:getFlag("healing_used", 0) * 4
        base_heal = base_heal + ((base_heal * 0.2) * yellowhat_count)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        user.chara:setFlag("healing_used", 30)
    end
end

function spell:onLightCast(user, target)
    if user.chara:getFlag("healing_used", 0) < 30 then
        local base_heal = user.chara:getStat("magic") * 2 + 5 + user.chara:getFlag("healing_used", 0)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        user.chara:addFlag("healing_used", 1)
    else
        local base_heal = user.chara:getStat("magic") * 3 + user.chara:getStat("attack") + user.chara:getFlag("healing_used", 0)
        local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)
        target:heal(heal_amount)
        user.chara:setFlag("healing_used", 30)
    end
end

function spell:getName()
    if Game:getFlag("kindness_heal") and not Game:isLight() then
        return "KindnessHeal"
    elseif Game:getPartyMember("susie"):getFlag("healing_used", 0) == 30 then
        return "SkilledHeal"
    else
        return "SickHeal"
    end
end

function spell:getCastName()
    if Game:getFlag("kindness_heal") then
        return "KINDNESSHEAL"
    elseif Game:getPartyMember("susie"):getFlag("healing_used", 0) == 30 then
        return "SKILLEDHEAL"
    else
        return "SICKHEAL"
    end
end

function spell:getDescription()
    if Game:getPartyMember("susie"):getFlag("healing_used", 0) == 30 then
        return "With all that effort, you've reached its\nobsolete state. It is now complete."
    elseif Game:getFlag("kindness_heal") then
        return "With the axe's powers, you've reached its\nfinal state. Yet, its not perfect enough."
    else
        return "It has lost its spark over time.\nWill you be able to restore it?"
    end
end

function spell:getCheck()
    if Game:getPartyMember("susie"):getFlag("healing_used", 0) == 30 then
        return { "With all that effort, you've reached its obsolete state.", "* It is now complete." }
    else
        return "It has lost its spark over time. Will you be able to restore it?"
    end
end

function spell:getTPCost(chara)
    local cost = super.getTPCost(self, chara)

    if Game:getFlag("kindness_heal") then
        return cost - 30
    end

    return cost - chara:getFlag("healing_used", 0)
end

return spell
