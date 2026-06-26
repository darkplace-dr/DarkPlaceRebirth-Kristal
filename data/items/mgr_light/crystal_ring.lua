local item, super = Class(LightEquipItem, "mg/crystal_ring")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Crystal Ring"
    self.short_name = "CrstalRing"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true
    
    -- Item description text (unused by light items outside of debug menu)
    self.description = "Something about it feels...\nLike malfeasance.\nYou might get frostbite while holding it."

    -- Light world check text
    self.check = {"Wpn 6 AT 10 MG\n* Something about it feels...\n[wait:10]* Like malfeasance.", "* You might get frostbite while holding it."}

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 12
    
    self.shop_magic = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 6,
        magic = 10
    }

    -- Attack sprite (only used for simple animations)
    self.attack_sprite = "effects/lightattack/slap"
    self.attack_pitch = 1.5
    
    self.can_equip = {
        ["susie"] = false
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "freezering"
end

return item