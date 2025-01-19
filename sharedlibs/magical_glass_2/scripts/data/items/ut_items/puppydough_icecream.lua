local item, super = Class(LightHealItem, "mg_item/puppydough_icecream")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Puppydough Icecream"
    -- Name displayed in the normal item select menu
    self.short_name = "PDIceCram"
    self.serious_name = "Ice Cream"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 28

    -- Default shop sell price
    self.sell_price = 2
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Made by young pups."

    -- Light world check text
    self.check = "Heals 28 HP\n* Made by young pups."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item