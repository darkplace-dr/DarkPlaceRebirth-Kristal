local item, super = Class(LightEquipItem, "custom/scarf")

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
    self.check = "Weapon 2 MG\n* A magical pink scarf.\n* It's quite fluffy."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.price = 70
    
    self.shop_magic = true
    
    self.light_bolt_direction = "random"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        magic = 2
    }
end

return item