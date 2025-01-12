local worn_dagger, super = Class(LightEquipItem, "mg_item/worn_dagger")

function worn_dagger:init()
    super.init(self)

    -- Display name
    self.name = "Worn Dagger"
    -- Name displayed in the normal item select menu
    self.short_name = "WornDG"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "W. Dagger"
    -- Name displayed when used
    self.use_name = "dagger"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 250
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Perfect for cutting plants and vines."

    -- Light world check text
    self.check = "Weapon AT 15\n* Perfect for cutting plants\nand vines."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 15
    }
    
    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "random"
end

return worn_dagger