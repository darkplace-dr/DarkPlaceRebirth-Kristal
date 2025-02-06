local spell, super = Class(Spell, "barrier")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Barrier"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Setup\nShield"
    -- Menu description
    self.description = "Sets up a barrier to protect\none party member from damage."
    -- Check description
    self.check = "Sets up a barrier\nto protect one party member\nfrom damage."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"shield"}
end

function spell:onCast(user, target)
    target:addShield(math.huge)
end

function spell:hasWorldUsage(chara)
    return false
end

return spell