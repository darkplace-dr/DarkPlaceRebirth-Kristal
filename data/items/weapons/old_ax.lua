local item, super = Class(Item, "old_ax")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Old Ax"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "An old ax Susie had for a while.\nLost all of it's power, value, and color."

    -- Default shop price (sell price is halved)
    self.price = 50
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
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        hero = "It's monochrome!",
        susie = "Nope, I'm over that now.",
        ralsei = "Which ax was that again...?",
        noelle = "Wow, it's... Sure old, faha!",
	    dess = "damn Wings why'd you make her ax a goner",
        brenda = "",
	    jamm = "It's quite worn, isn't it...",
        noel = "",
        ceroba = "That old stuff? No way."
    }
end

return item
