local heart_locket, super = Class(LightEquipItem, "mg_item/heart_locket")

function heart_locket:init()
    super.init(self)

    -- Display name
    self.name = "Heart Locket"
    -- Name displayed in the normal item select menu
    self.short_name = "<--Locket"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "H. Locket"
    -- Name displayed when used
    self.use_name = "locket"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 250
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "It says \"Best Friends Forever.\""

    -- Light world check text
    self.check = "Armor DF 15\n* It says \"Best Friends Forever.\""

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 15
    }
end

return heart_locket