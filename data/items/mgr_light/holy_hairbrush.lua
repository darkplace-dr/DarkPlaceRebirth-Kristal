local item, super = Class(LightEquipItem, "mg/holy_hairbrush")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Holy Hairbrush"
    self.short_name = "HlyBrush"
    
    self.can_sell = false

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "It shines brightly.\nYou feel proud to hold this."

    -- Light world check text
    self.check = "Weapon 15 AT\n* It shines brightly.\n* You feel proud to hold this."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 15
    }
    
    -- Default dark item conversion for this item
    self.dark_item = "justiceaxe"
end

function item:onToss()
    if Game:getConfig("canTossLightWeapons") then
        Game.world:showText({
            "* (You didn't quite understand\nwhy...)",
            "* (But, the thought of discarding\nit felt very wrong.)"
        })
        return false
    else
        return super.onToss(self)
    end
end

return item