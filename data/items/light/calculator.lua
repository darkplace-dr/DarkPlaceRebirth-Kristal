local item, super = Class(LightEquipItem, "light/calculator")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Calculator"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A small calculator that can do basic mathematics."

    -- Light world check text
    self.check = "Armor 1 DF\n* A small calculator that can do basic mathematics."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 0,
        defense = 1
    }
	
    -- Default dark item conversion for this item
    self.dark_item = "life_odometer"
end

return item