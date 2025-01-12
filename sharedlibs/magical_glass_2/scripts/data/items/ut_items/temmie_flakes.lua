local item, super = Class(LightHealItem, "mg_item/temmie_flakes")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Temmie Flakes"
    -- Name displayed in the normal item select menu
    self.short_name = "TemFlakes"

    -- How this item is used on you (ate, drank, eat, use, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, uses, etc.) (defaults to use_method)
    self.use_method_other = "eats"  

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 2

    -- Shop description
    self.shop = "Heals 2HP\nfood of\ntem"
    -- Default shop price (sell price is halved)
    self.price = 3
    -- Default shop sell price
    self.sell_price = 2
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "It's just town up pieces of colored construction paper."

    -- Light world check text
    self.check = "Heals 2 HP\n* It's just town up pieces\nof colored construction paper."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item