local item, super = Class(Item, "emerald_staff")

function item:init()
    super.init(self)

    -- Display name
    self.name = "EmeraldStaff"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        magic   = 10,
    }

    -- Whether this item is for the light world
    self.light = false

    -- Battle description
    self.effect = "You check the staff."
    -- Shop description
    self.shop = "Staff made of emeralds"
    -- Menu description
    self.description = "A staff made of emeralds, designed to aid magic users."
    -- Light world check text
    self.check = "You check the staff."

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

    -- Everyone can equip
    self.can_equip = {
        susie = true,
        len = true
    }

    self.reactions = {
        susie = "Huh, so this is what it feels like.",
        len = {
            len = "You think we could summon another dess with this?",
            hero = "One is enough.",
            susie = "One is enough.",
            ralsei = "One is enough.",
            noelle = "(One is enough.)",
            dess = "One is enough.",
            jamm = "One is too much.",
            ["jamm+marcy"] = "One is too much. // Papa is right.",
            calypso = "One be enough.",
            ceroba = "One is enough.",
        }
    }
end

return item
