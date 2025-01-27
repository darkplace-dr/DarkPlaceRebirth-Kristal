local spell, super = Class("snowgrave", true)

function spell:init()
    super.init(self)
    
    self.check = "Deals the fatal damage to all of the enemies."
end

function spell:getDamage(user, target)
    if Game:isLight() then
        return math.ceil((user.chara:getStat("magic") * 35) + 560)
    else
        return super.getDamage(self, user, target)
    end
end

return spell