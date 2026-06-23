local item, super = Class(LightEquipItem, "mg/hairbrush")

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
    self.description = "Purple, with hair stuck to it.\nIt has a bit of a sharp edge."

    -- Light world check text
    self.check = "Weapon 1 AT\n* Purple, with hair stuck to it.\n* It has a bit of a sharp edge."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 2

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "mane_ax"
end

return item