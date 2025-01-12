local item, super = Class(LightEquipItem, "light/ring")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ring"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true
    
    -- Item description text (unused by light items outside of debug menu)
    self.description = "Has a snowflake emblem on it.\nA reminder of a lost girl."

    -- Light world check text
    self.check = "Weapon 3 MG\n* Has a snowflake emblem on it.\n* A reminder of a lost girl."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Default shop price (sell price is halved)
    self.price = 300

    -- Whether this weapon should display its magic bonus instead of its defense bonus in shops
    self.show_magic_in_shop = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        magic = 3
    }

    -- Attack animation (only used for simple animations)
    self.attack_animation = "effects/attack/slap_n"
    -- The sound played when attacking if onLightBattleAttack isn't overwritten.
    self.attack_sound = "punchweak"
    -- The pitch of this item's attack sound.
    self.attack_pitch = 1.4
    
    -- Default dark item conversion for this item
    self.dark_item = "snowring"
end

return item