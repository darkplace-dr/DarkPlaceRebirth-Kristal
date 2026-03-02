local item, super = Class(RegenItem, "super_elixir")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SuperElixir"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Whether this item heals
    self.heals = true

    -- Battle description
    self.effect = "+300HP\n+300MP"
    -- Shop description
    self.shop = "Ominous\nflask\n+250HP and MP"
    -- Menu description
    self.description = "Ominous flask with vibrant colors. \nHeals 300HP and regenerates 300MP."

    -- Amount healed (HealItem variable)
    self.heal_amount = 300
    -- Amount healed (HealItem variable)
    self.regen_amount = 300

    -- Default shop price (sell price is halved)
    self.price = 650
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Is this just hot sauce? Sweet.",
        ralsei = self:getRalseiReaction(),
        noelle = "... *cough* *cough*... I'm fine."
    }
end

function item:getRalseiReaction()
    if Game:hasPartyMember("kris") then
        return "*cough* Kris, do you have water?"
    else
        return "HOT HOT HOT HOT HOT!"
    end
end

function item:onWorldUse(target)
    local consumed = super.onWorldUse(self, target)

    return consumed
end

return item