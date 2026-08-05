local item, super = Class(Item, "bug")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Bug"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack  = 0 / 0,
    }

    -- Whether this item is for the light world
    self.light = false

    -- Battle description
    self.effect = "Useless"
    -- Shop description
    self.shop = "Useless"
    -- Menu description
    self.description = "Bug, Deals NaN damage. useless"
    -- Light world check text
    self.check = "It's useless"

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "none"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        len = true,
    }

    -- Character reactions
    self.reactions = {
        len = "(Oh my mew...)",
    }
end

return item