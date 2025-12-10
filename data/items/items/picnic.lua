local item, super = Class(HealItem, "picnic")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Picnic"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Does not\nHeal in\nbattle"
    -- Shop description
    self.shop = "Filled\nPicnic Basket.\nFull Heal\nout of battle."
    -- Menu description
    self.description = "A picnic basket filled with all sorts of treats. Fully heals the party outside of battle."

    -- Amount healed (HealItem variable)
    self.heal_amount = 999

    -- Default shop price (sell price is halved)
    self.price = 300
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Woah...it's like a feast...",
        ralsei = "It's got cake!",
        noelle = "Isn't sharing food nice?",
        jamm = "This... this brings me back.",
        ceroba = "I wish Chujin and Kanako were here.",
    }
end

return item
