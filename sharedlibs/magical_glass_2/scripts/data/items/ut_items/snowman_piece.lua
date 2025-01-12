local item, super = Class(LightHealItem, "mg_item/snowman_piece")

function item:init()
    -- this guy's probably pretty happy he got moved to an entirely different game
    super.init(self)

    -- Display name
    self.name = "Snowman Piece"
    -- Name displayed in the normal item select menu
    self.short_name = "SnowPiece"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 45

    -- Default shop sell price
    self.sell_price = 40
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (for the debug menu)
    self.description = "Please take this to the ends of the earth."

    -- Light world check text
    self.check = "Heals 45 HP\n* Please take this to the\nends of the earth."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item