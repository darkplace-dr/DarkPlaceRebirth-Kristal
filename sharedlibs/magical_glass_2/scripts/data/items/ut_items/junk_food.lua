local item, super = Class(LightHealItem, "mg_item/junk_food")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Junk Food"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 17

    -- Shop description
    self.shop = "Heals 17HP\nHas a big\nbite out of\nit."
    -- Default shop price (sell price is halved)
    self.price = 25
    -- Default shop sell price
    self.sell_price = 1
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Food that was probably once thrown away."

    -- Light world check text
    self.check = "Heals 17 HP\n* Food that was probably\nonce thrown away."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item