local spell, super = Class(Spell, "ow_prayer")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Ow Prayer"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal ally\nCosts HP"
    -- Menu description
    self.description = "Shadowly dark restores a little HP to\none party member in exhange of\nHP, Depends on Magic."

    -- TP cost
    self.cost = 12

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local heal = user.chara:getStat("magic") * 4
    local dmg = heal * (2 / (user.chara:getStat("magic") / 10))
    
    user:hurt(dmg)
    target:heal(heal)
end

return spell