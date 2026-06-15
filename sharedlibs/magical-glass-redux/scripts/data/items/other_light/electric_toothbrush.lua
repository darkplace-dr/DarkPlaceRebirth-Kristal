local item, super = Class(LightEquipItem, "mg/electric_toothbrush")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Elec. Toothbrush"
    self.short_name = "ElecBrush"
    self.use_name = "Electric Toothbrush"
    self.dark_name = "Elec. Brush"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "This sure will make your teeth whiten."

    -- Light world check text
    self.check = "Weapon 1 AT\n* This sure will make your teeth whiten."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 5

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "autoaxe"
end

return item