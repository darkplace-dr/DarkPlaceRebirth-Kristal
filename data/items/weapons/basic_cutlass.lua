local item, super = Class(Item, "basic_cutlass")

function item:init()
    super.init(self)

    -- Display name
    self.name = "B. Cutlass"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/cutlass"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Shock\nSling"
    -- Menu description
    self.description = "A cutlass that has seen a lot of battles."

    -- Default shop price (sell price is halved)
    self.price = 600
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
        attack = 5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        calypso = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        jamm = "I'm putting all that behind me.",
        calypso = "Aye, to better beginnings!",
        len = "Still breathing.",
    }
end

-- function item:convertToLightEquip(inventory)
    -- return "light/whip_sling"
-- end

return item
