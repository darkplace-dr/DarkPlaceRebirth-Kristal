local item, super = Class(LightEquipItem, "light/magic_ball")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Magic Ball"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A dusty fortune-telling crystal ball."

    -- Light world check text
    self.check = "Weapon 1 AT\n* A dusty fortune-telling crystal ball."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 1,
        defense = 0
    }

    -- Default dark item conversion for this item
    self.dark_item = "beginners_crystal"
end

return item