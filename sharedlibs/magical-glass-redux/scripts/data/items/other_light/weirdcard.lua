local item, super = Class(LightEquipItem, "mg/weirdcard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Weird Card"
    self.short_name = "WeirdCard"
    
    self.can_sell = false

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "The Joker Card.\nDid it just smiled at you?"

    -- Light world check text
    self.check = "Weapon 8 AT 5 MG\n* The Joker Card.\n* Did it just smiled at you?"

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 8,
        magic = 5
    }
    
    self.light_bolt_speed_multiplier = 1.25
    
    -- Default dark item conversion for this item
    self.dark_item = "devilsknife"
end

function item:onToss()
    if Game:getConfig("canTossLightWeapons") then
        Game.world:showText("* (You fumbled and caught it.[wait:5]\nYou can't throw it away!)")
        return false
    else
        return super.onToss(self)
    end
end

return item