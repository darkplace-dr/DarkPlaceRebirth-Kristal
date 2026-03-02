local item, super = Class(RegenItem, "medium_potion")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MediumPotion"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Whether this item heals
    self.healing_item = false

    -- Whether this item regenerates mana
    self.mana_regen_item = true

    -- Battle description
    self.effect = "Regens\n80MP"
    -- Shop description
    self.shop = "Good\npotion that\nregens 80MP"
    -- Menu description
    self.description = "A normal flask of clear liquid.\nRecovers 80MP."

    -- Amount regened (HealItem variable)
    self.regen_amount = 80

    -- Default shop price (sell price is halved)
    self.price = 320
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {
        susie =  "Pretty normal to me...",
        ralsei = "Very nice!",
        noelle = "I wish these were real."
    }
end

function item:onWorldUse(target)
    local consumed = super.onWorldUse(self, target)

    return consumed
end

return item