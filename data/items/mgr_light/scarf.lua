local item, super = Class(LightEquipItem, "mg/scarf")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Scarf"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true
    
    -- Item description text (unused by light items outside of debug menu)
    self.description = "A magical pink scarf.\nIt's quite fluffy."

    -- Light world check text
    self.check = "Weapon 3 MG\n* A magical pink scarf.\n* It's quite fluffy."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 6
    
    self.shop_magic = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        magic = 3
    }
end

return item