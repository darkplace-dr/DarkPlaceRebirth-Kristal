local the_locket, super = Class(LightEquipItem, "mg_item/the_locket")

function the_locket:init()
    super.init(self)

    -- Display name
    self.name = "The Locket"
    -- Name displayed in the normal item select menu
    self.short_name = "TheLocket"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 500
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "You can feel it beating."

    -- Light world check text
    self.check = "Armor DF 99\n* You can feel it beating."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 99
    }
end

function the_locket:showEquipText()
    Game.world:showText("* Right where it belongs.")
end

function the_locket:getLightBattleText(user, target)
    return "* Right where it belongs."
end

return the_locket