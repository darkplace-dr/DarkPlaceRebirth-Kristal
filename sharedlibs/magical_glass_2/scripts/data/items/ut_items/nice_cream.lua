local item, super = Class(LightHealItem, "mg_item/nice_cream")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Nice Cream"
    -- Name displayed in the normal item select menu
    self.short_name = "NiceCream"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Ice Cream"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 15

    -- Default shop price (sell price is halved)
    self.price = 15
    -- Default shop sell price
    self.sell_price = 2
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Instead of a joke, the wrapper says something nice."

    -- Light world check text
    self.check = "Heals 15 HP\n* Instead of a joke,[wait:10] the\nwrapper says something nice."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseText(target)
    return Utils.pick({
        "* You're just great!",
        "* You look nice today!",
        "* Are those claws natural?",
        "* You're super spiffy!",
        "* Have a wonderful day!",
        "* Is this as sweet as you?",
        "* (An illustration of a hug.)",
        "* Love yourself! I love you!"
    })
end

function item:getLightBattleText(user, target)
    return Utils.pick({
        "* You're just great!",
        "* You look nice today!",
        "* Are those claws natural?",
        "* You're super spiffy!",
        "* Have a wonderful day!",
        "* Is this as sweet as you?",
        "* (An illustration of a hug.)",
        "* Love yourself! I love you!"
    })
end

return item