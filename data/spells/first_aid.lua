local spell, super = Class(Spell, "first_aid")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "First Aid"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal\n25 HP"
    -- Menu description
    self.description = "Heal 25 HP using simple first aid.\nEffectiveness not affected by your stats."

    -- TP cost
    self.cost = 0

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end


function spell:onCast(user, target)
    target:heal(25)
end

return spell