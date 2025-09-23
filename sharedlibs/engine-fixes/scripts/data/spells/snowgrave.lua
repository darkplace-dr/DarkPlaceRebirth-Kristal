local spell, super = Class("snowgrave", true)

function spell:onCast(user, target)
    local object = SnowGraveSpell(user, self)
    object.damage = self:getPrimaryDamage(user, target)
    object.layer = BATTLE_LAYERS["above_ui"]
    Game.battle:addChild(object)

    return false
end

function spell:getPrimaryDamage(user, target)
    return math.ceil((user.chara:getStat("magic") * 40) + 600)
end

function spell:getSecondaryDamage(user, target)
    return Utils.random(0, 100, 1)
end

return spell