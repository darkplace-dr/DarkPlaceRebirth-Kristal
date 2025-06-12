local item, super = Class(Item, "titan_hammer")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TitanHammer"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/hammer"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Fit for a\nLegend"
    -- Menu description
    self.description = "It has no special powers, but sure it's\na classic!"

    -- Default shop price (sell price is halved)
    self.price = nil
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "gerson"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 12,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "???"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        gerson = true,
    }

    -- Character reactions
    self.reactions = {
        gerson = "Gyaa Ha ha! ol' reliable!",
    }
end

return item