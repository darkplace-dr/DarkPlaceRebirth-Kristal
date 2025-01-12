local spell, super = Class("ice_shock", true)

function spell:getDamage(user, target)
    if Game:isLight() then
        local min_magic = Utils.clamp(user.chara:getStat("magic") - 3, 1, 999)
        return math.ceil((min_magic * 9) + 36 + Utils.random(5))
    else
        return super.getDamage(self, user, target)
    end
end

return spell