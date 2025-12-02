local item, super = Class(Item, "bloombowtie")

function item:init()
    super.init(self)

    -- Display name
    self.name = "BloomBowtie"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A pink and blue bowtie.\nFor some reason, it only suits kind ones."

    -- Default shop price (sell price is halved)
    self.price = 0
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
        defense = 5,
        magic = 5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Kindness Up"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        susie = "It's so... soft?",
        ralsei = "I'll treasure it.",
        noelle = "(Seems... familiar?)",
        dess = "this STINKS",
        mario = "So long-a, Wilter!",
    }
end

return item