local item, super = Class(Item, "mg_item/undyne_letter_ex")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Undyne Letter EX"
    -- Name displayed in the normal item select menu
    self.short_name = "UndynLtrX"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Letter"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Whether the item can be sold
    self.can_sell = false

    -- Item description text (for the debug menu)
    self.description = "It has DON'T DROP IT written on it."

    -- Light world check text
    self.check = "Unique\n* It has DON'T DROP IT\nwritten on it."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onLightBattleSelect(user, target)
    return false
end

function item:onWorldUse()
    Game.world:showText({"* You tried to open the letter,[wait:5]\nbut...",
                         "* It's been shut so tightly,[wait:5]\nyou'd need a chainsaw in\norder to open it."})
    return false
end

function item:onToss()
    Game.world:showText("* (The letter is too powerful to\nthrow away.)[wait:5]\n* (It gets the better of you.)")
    return false
end

return item