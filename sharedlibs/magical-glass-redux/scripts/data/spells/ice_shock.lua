local spell, super = Class("ice_shock", true)

function spell:init()
    super.init(self)
    
    self.check = "Deals magical ice damage to one enemy."
end

function spell:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    
    if chara and chara:checkWeapon("mg/thorn") then
        cost = MathUtils.round(cost / 2)
    end
    return cost
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local min_magic = MathUtils.clamp(user.chara:getStat("magic") - 4, 1, 999)
        return math.ceil((min_magic * 8) + 30 + MathUtils.random(5))
    else
        return super.getDamage(self, user, target)
    end
end

return spell