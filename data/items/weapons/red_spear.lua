local item, super = Class(Item, "red_spear")

function item:init()
    super.init(self)

    -- Display name
    self.name = "RedSpear"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack  = 28,
        defense = 14,
        magic   = 12,
    }

    -- Whether this item is for the light world
    self.light = false

    -- Battle description
    self.effect = "You admire the red spear."
    -- Shop description
    self.shop = "Red Spear of Destiny"
    -- Menu description
    self.description = "A red spear made by a long forgotten traveler."
    -- Light world check text
    self.check = "You admire the red spear."

    -- Default shop price (sell price is halved)
    self.price = 24000
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "none"

    -- No special bonus
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {
        hero = true,
        susie = true,
        len = true,
    }
end

return item