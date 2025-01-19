local item, super = Class(LightHealItem, "mg_item/cinnamon_bun")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Cinnamon Bun"
    -- Name displayed in the normal item select menu
    self.short_name = "CinnaBun"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "C. Bun"
    -- Name displayed when used
    self.use_name = "Cinnamon Bunny"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 22

    -- Shop description
    self.shop = "Heals 22HP\nIt's my own\nrecipe."
    -- Default shop price (sell price is halved)
    self.price = 25
    -- Default shop sell price
    self.sell_price = 8
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A cinnamon roll in the shape of a bunny."

    -- Light world check text
    self.check = "Heals 22 HP\n* A cinnamon roll in the shape\nof a bunny."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item