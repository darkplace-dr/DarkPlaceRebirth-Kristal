local item, super = Class(Item, "mg_item/mystery_key")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Mystery Key"
    -- Name displayed in the normal item select menu
    self.short_name = "MystryKey"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Key"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "?????\nProbably\nto someone's\nhouse LOL"
    -- Default shop price (sell price is halved)
    self.price = 600
    -- Whether the item can be sold
    self.can_sell = false

    -- Item description text (unused by light items outside of debug menu)
    self.description = "It is too bent to fit on your keychain."

    -- Light world check text
    self.check = "Unique\n* It is too bent to fit on\nyour keychain."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onWorldUse()
    Game.world:showText("* You used the Mystery Key.[wait:10]\n* But nothing happened.")
    return false
end

function item:onToss()
    Game.world:showText("* The Mystery Key was\nthrown away.")
    return true
end

function item:onLightBattleSelect(user, target)
    return false
end

function item:onLightBattleUse(user, target)
    Game.battle:battleText("* You used the Mystery Key.[wait:10]\n* But nothing happened.")
end

return item