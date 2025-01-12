local item, super = Class(LightHealItem, "mg_item/crab_apple")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Crab Apple"
    -- Name displayed in the normal item select menu
    self.short_name = "CrabApple"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 18

    -- Shop description
    self.shop = "Heals 18HP\n(Looks\nlike a\ncrab.)"
    -- Default shop price (sell price is halved)
    self.price = 25
    -- Default shop sell price
    self.sell_price = 5
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "An aquatic fruit that resembles a crustacean."

    -- Light world check text
    self.check = "Heals 18 HP\n* An aquatic fruit that\nresembles a crustacean."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item