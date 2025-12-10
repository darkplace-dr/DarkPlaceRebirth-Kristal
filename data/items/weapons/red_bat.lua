local item, super = Class(Item, "red_bat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Red Bat"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/bat"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A bat that somehow resembles a guitar."

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
        attack = 8,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Nope. Not again.",
        ralsei = "",
        noelle = "(It kind of reminds me of...)",
        jamm = "How does this even work...?",
		    dess = "let's rock",
        ceroba = "Looks great, but... No."
    }
end

function item:convertToLight(inventory)
    return "dess_guitar"
end

return item
