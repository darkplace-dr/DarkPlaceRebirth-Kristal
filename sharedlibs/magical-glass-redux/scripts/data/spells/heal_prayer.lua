local spell, super = Class("heal_prayer", true)

function spell:onLightCast(user, target)
    local amount = math.ceil(Game:isLight() and user.chara:getStat("magic") * 2.5 or user.chara:getStat("magic") * 5)
    target:heal(amount, false, true)
end

function spell:onCast(user, target)
    if Game:isLight() then
        target:heal(math.ceil(user.chara:getStat("magic") * 2.5))
    else
        super.onCast(self, user, target)
    end
end

return spell