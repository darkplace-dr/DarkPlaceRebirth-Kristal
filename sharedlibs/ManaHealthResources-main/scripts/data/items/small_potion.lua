local item, super = Class(RegenItem, "small_potion")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SmallPotion"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Whether this item heals
    self.healing_item = false

    -- Whether this item regenerates mana
    self.mana_regen_item = true

    -- Battle description
    self.effect = "Regens\n45MP"
    -- Shop description
    self.shop = "Nice\npotion that\nregens 45MP"
    -- Menu description
    self.description = "A small flask of clear liquid.\nRecovers 45MP."

    -- Amount regened (HealItem variable)
    self.regen_amount = 45

    -- Default shop price (sell price is halved)
    self.price = 260
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
        susie =  "Could it have been any smaller?",
        ralsei = "So small!",
        noelle = "How cute!"
    }
end

function item:onWorldUse(target)
    local consumed = super.onWorldUse(self, target)

    return consumed
end

return item