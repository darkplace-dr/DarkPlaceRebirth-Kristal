local item, super = Class(LightEquipItem, "mg/dirty_toothbrush")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Dirty Toothbrush"
    self.short_name = "DirtyBrush"
    self.dark_name = "Dirty Brush"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Seems like it wasn't washed for a long time."

    -- Light world check text
    self.check = "Weapon 1 AT\n* Seems like it wasn't washed for a long time."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 2

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "toxicaxe"
end

return item