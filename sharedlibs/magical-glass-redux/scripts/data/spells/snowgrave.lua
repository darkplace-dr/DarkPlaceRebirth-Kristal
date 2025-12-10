local spell, super = Class("snowgrave", true)

function spell:init()
    super.init(self)
    
    self.check = "Deals the fatal damage to all of the enemies."
end

function spell:getPrimaryDamage(user, target)
    if Game:isLight() then
        return math.ceil((user.chara:getStat("magic") * 35) + 560)
    else
        return super.getPrimaryDamage(self, user, target)
    end
end

function spell:getSecondaryDamage(user, target)
    if Game:isLight() then
        return Utils.random(0, 50, 1)
    else
        return super.getSecondaryDamage(self, user, target)
    end
end

return spell