local item, super = Class(Item, "sparkbat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "SparkBat"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/bat"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "25+ colors \nper second"
    -- Menu description
    self.description = "A bat that is flickering with many colors.\nMay cause epilepsy for some people."

    -- Default shop price (sell price is halved)
    self.price = 700
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 4,
        magic = 2,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = true,
    }

    -- Character reactions
    self.reactions = {
        hero = "I don't wanna be blind.", 
        susie = "This is AWESOME! Can I have it?", 
        ralsei = "So many colors...",
        noelle = "(That reminds me...)",
        dess = {
            susie = "(SHE gets a lightsaber?!)",
            dess = "teehee"
        },
        jamm = "Shiny...",
    }
end

return item
