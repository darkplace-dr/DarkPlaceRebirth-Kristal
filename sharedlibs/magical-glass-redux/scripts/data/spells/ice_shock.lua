local spell, super = Class("ice_shock", true)

function spell:init()
    super.init(self)
    
    self.check = "Deals magical ice damage to one enemy."
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local min_magic = Utils.clamp(user.chara:getStat("magic") - 3, 1, 999)
        return math.ceil((min_magic * 8) + 30 + Utils.random(5))
    else
        return super.getDamage(self, user, target)
    end
end

return spell