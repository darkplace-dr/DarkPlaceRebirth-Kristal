local item, super = Class(LightEquipItem, "mg/shiny_spoon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Shiny Spoon"
    self.short_name = "ShinySpoon"
    self.serious_name = "Spoon"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Can you mine diamonds with it?\nProbably not."

    -- Light world check text
    self.check = "Weapon 2 AT\n* Can you mine diamonds with it?\n[wait:10]* Probably not."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 6

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 2
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "absorbax"
end

return item