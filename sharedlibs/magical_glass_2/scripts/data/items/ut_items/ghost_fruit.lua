local item, super = Class(LightHealItem, "mg_item/ghost_fruit")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ghost Fruit"
    -- Name displayed in the normal item select menu
    self.short_name = "GhostFrut"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "GhstFruit"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 16

    -- Default shop sell price
    self.sell_price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "If eaten, it will never pass to the other side."

    -- Light world check text
    self.check = "Heals 16 HP\n* If eaten,[wait:10] it will never\npass to the other side."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item