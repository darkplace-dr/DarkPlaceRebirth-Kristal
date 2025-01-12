local item, super = Class(LightHealItem, "mg_item/unisicle")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Unisicle"
    -- Name displayed in the normal item select menu
    self.short_name = "Unisicle" -- getname moment
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Popsicle"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 11

    -- Default shop sell price
    self.sell_price = 2
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (for the debug menu)
    self.description = "It's a SINGLE-pronged popsicle.\nWait, that's just normal..."

    -- Light world check text
    self.check = "Heals 11 HP\n* It's a SINGLE-pronged popsicle.[wait:10]\nWait,[wait:10] that's just normal..."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

return item