local spell, super = Class(Spell, "persist")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Persist"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal 50 HP\nto self"
    -- Menu description
    self.description = "The user takes a deep breath and persists, healing 50 HP to themselves."

    -- TP cost
    self.cost = 20

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." persists."
end

function spell:onCast(user, target)

    user:heal(50)
    Game.battle:finishActionBy(user)

    return false
end

return spell