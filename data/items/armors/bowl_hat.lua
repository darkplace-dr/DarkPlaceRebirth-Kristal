local item, super = Class(Item, "bowl_hat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Bowl Hat"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Crafted\nbowl"
    -- Menu description
    self.description = "A bowl made of love (and wood)"

    -- Default shop price (sell price is halved)
    self.price = 12
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
        defense = 12,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        susie = "Sturdy, nice.",
        ralsei = "Food wars!",
        noelle = "How it's not falling off?",
        dess = "Yummy wood",
        jamm = "Why?",
        brenda = "Its soo sturdy!",
        mario = "Weege!",
        noel = "How can this defend at all?",
        ceroba = "A bowl...? okay",
        len = "How is this an armour?"
    }
end

return item