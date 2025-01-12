local toy_knife, super = Class(LightEquipItem, "mg_item/toy_knife")

function toy_knife:init()
    super.init(self)

    -- Display name
    self.name = "Toy Knife"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Made of plastic.\nA rarity nowadays."

    -- Light world check text
    self.check = "Weapon AT 3\n* Made of plastic.\n* A rarity nowadays."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 3
    }

    -- How fast this item's bolts move
    self.bolt_speed = self.bolt_speed * 1.25

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "random"
end

function toy_knife:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .." equipped Toy Knife.")
end

function toy_knife:getLightBattleText(user, target)
    return "* ".. target.chara:getNameOrYou() .. " equipped Toy Knife."
end

return toy_knife