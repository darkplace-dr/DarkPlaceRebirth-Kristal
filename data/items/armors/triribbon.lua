local item, super = Class(Item, "triribbon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TriRibbon"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Three ribbons. Require bilateral hair division."

    -- Default shop price (sell price is halved)
    self.price = 1500
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
        attack = 2,
        defense = 5,

        graze_size = 0.25,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "GrazeArea"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = false,
        dess = false,
		jamm = false
    }

    -- Character reactions
    self.reactions = {
        hero = "It's... kinda too much ribbons.",
        susie = "... it gets worse and worse.",
        ralsei = "Try around my horns!",
        noelle = "... nostalgic, huh.",
        dess = "why did you had to mix them",
        jamm = "Woah! Pop idle much???",
        ["jamm+marcy"] = "Sorry, Marcy. It won't stay.",
        noel = "THREE bracelets??",
        ceroba = "I think that's good enough.",
    }
end

return item