local item, super = Class(Item, "paper_hat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Paper Hat"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Paper\nhat"
    -- Menu description
    self.description = "A bowl made of... paper?"

    -- Default shop price (sell price is halved)
    self.price = -1
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
        defense = -1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        ralsei = false,
        noelle = false,
        dess = false,
        jamm = false,
        brenda = false,
        mario = false,
        noel = false,
        ceroba = false
    }

    -- Character reactions
    self.reactions = {
        hero = "What?",
        susie = "Hell yeah!",
        ralsei = "...",
        noelle = "...",
        dess = "Ew",
        jamm = "Why?",
        brenda = "Its too weak!",
        mario = "Mari-no",
        noel = "...",
        ceroba = "...?",
    }
end

return item