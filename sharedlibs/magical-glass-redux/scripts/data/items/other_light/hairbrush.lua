local item, super = Class(LightEquipItem, "custom/hairbrush")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Hairbrush"
    self.serious_name = "Brush"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Purple, with hair stuck to it.\nFire coloring on the handle."

    -- Light world check text
    self.check = "Weapon 1 AT\n* Purple, with hair stuck to it.\n* Fire coloring on the handle."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.price = 30

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1
    }
end

return item