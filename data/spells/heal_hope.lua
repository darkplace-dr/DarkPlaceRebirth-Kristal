local spell, super = Class(Spell, "heal_hope")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Heal Hope"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    if Game.chapter <= 3 then
        self.effect = "Heal\nAlly"
    else
        self.effect = "Heal\nally"
    end
    -- Menu description
    self.description = "Heavenly hope restores a little HP to\none party member. Depends on Magic."

    -- TP cost
    self.cost = 16

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local base_heal = user.chara:getStat("magic") * 1.5
    local heal_amount = Game.battle:applyHealBonuses(base_heal, user.chara)

    target:heal(heal_amount)
end

function spell:hasWorldUsage(chara)
    return true
end

function spell:onWorldCast(chara)
    Game.world:heal(chara, 50)
end

return spell