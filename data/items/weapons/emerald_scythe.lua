local item, super = Class(Item, "emerald_scythe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "EmeraldScythe"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack   = 10,
    }

    -- Whether this item is for the light world
    self.light = false

    -- Battle description
    self.effect = "You check the scythe."
    -- Shop description
    self.shop = "Scythe made of emeralds"
    -- Menu description
    self.description = "A scythe made of emeralds, designed to aid melee users."
    -- Light world check text
    self.check = "You check the scythe."

    -- Default shop price (sell price is halved)
    self.price = 2000
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
        susie = true,
        len = true,
    }
end

return item