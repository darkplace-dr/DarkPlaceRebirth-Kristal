local spell, super = HookSystem.hookScript("rude_buster")

function spell:getDamage(user, target, damage_bonus)
    local damage = super.getDamage(self, user, target, damage_bonus)
    if target.id == "titan_spawn" then
        damage = math.ceil(damage * 0.5)
    end
    return damage
end

return spell