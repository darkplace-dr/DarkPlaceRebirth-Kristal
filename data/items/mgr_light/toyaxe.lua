local item, super = Class(LightEquipItem, "mg/toyaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Toy Axe"
    self.short_name = "ToyAxe"
    self.serious_name = "Axe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Made of fabric.\nIt squeaks when you squeeze it."

    -- Light world check text
    self.check = "Weapon 1 AT\n* Made of fabric.\n* It squeaks when you squeeze it."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.sell_price = 3

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "brave_ax"
end

return item