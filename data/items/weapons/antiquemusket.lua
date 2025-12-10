local item, super = Class(Item, "antiquemusket")

function item:init()
    super.init(self)
    -- TODO: Make this work properly, just a placeholder for now

    -- Display name
    self.name = "A.Musket"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/gun"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "An antique musket with an ivory engraving.\nATK way up but it must be reloaded."

    -- Default shop price (sell price is halved)
    self.price = 15000
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 45,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Reload"
    self.bonus_icon = "ui/menu/icon/downb"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        brenda = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Why would you ever use this?",
        ralsei = "U-um... No thanks.",
        noelle = "D-don't point it at me!",
		dess = "ew i hate realism",
        brenda = "(I'm gonna regret this, aren't I?)",
        noel = "Just another hot piece of metal.",
        ceroba = "I'm not good with firearms...",
        jamm = "I don't know how to..."
    }
end

function item:convertToLightEquip(inventory)
    return "light/foam_dart_rifle" -- Placeholder
end

return item
