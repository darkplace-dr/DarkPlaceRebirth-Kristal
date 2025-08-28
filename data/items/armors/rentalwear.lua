local item, super = Class(Item, "rentalwear")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Rentalwear"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Rental\n+1MAG +1ATK"
    -- Menu description
    self.description = "A smart plate of armor which takes some of your earnings for good defense."

    -- Default shop price (sell price is halved)
    self.price = 80
    -- Whether the item can be sold
    self.can_sell = false

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
        defense = 2,
        magic = 1,
        attack = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "$ -30%"
    self.bonus_icon = "ui/menu/icon/down"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        noel = false,
    }

    -- Character reactions
    self.reactions = {
        susie = "No! Not my money!",
        ralsei = "At least it's... good?",
        noelle = "(Does it just... suck money?)",
        dess = "oh noooo how will I pay my taxes now",
        jamm = "...Eh, not as bad as student loans.",
        noel = "",
        ceroba = "Goodbye my earnings.",
    }
end

function item:applyMoneyBonus(gold)
    return gold * 0.7
end

return item
