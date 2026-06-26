local item, super = Class(LightEquipItem, "mg/ring")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ring"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true
    
    -- Item description text (unused by light items outside of debug menu)
    self.description = "For some reason, it feels\nreally cold in your hands."

    -- Light world check text
    self.check = "Weapon 3 MG\n* For some reason, it feels\nreally cold in your hands."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 10
    
    self.shop_magic = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        magic = 3
    }

    -- Attack sprite (only used for simple animations)
    self.attack_sprite = "effects/lightattack/slap"
    self.attack_pitch = 1.5
    
    self.can_equip = {
        ["susie"] = false
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "snowring"
end

return item