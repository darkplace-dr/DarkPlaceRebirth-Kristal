local item, super = Class(LightHealItem, "mg_item/starfait")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Starfait"

    -- note: in the mettaton ex fight, you *eat* the starfait, rather than drink it
    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "drinks"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 14

    -- Shop description
    self.shop = "Heals 14HP\nVery popular\nfood."
    -- Default shop price (sell price is halved)
    self.price = 60
    -- Default shop sell price
    self.sell_price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A sweet treat made of sparkling stars."

    -- Light world check text
    self.check = "Heals 14 HP\n* A sweet treat made of\nsparkling stars."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item