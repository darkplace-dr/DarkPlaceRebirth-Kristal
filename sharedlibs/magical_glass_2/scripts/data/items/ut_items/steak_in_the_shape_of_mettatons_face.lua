local item, super = Class(LightHealItem, "mg_item/steak_in_the_shape_of_mettatons_face")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Face Steak"
    -- Name displayed in the normal item select menu
    self.short_name = "FaceSteak"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Steak"
    -- Name displayed in shops
    self.shop_name = "Steak in the Shape of Mettaton's Face"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 60

    -- Shop description
    self.shop = "Heals 60HP\nDon't ask.\nPlease."
    -- Default shop price (sell price is halved)
    self.price = 500
    -- Default shop sell price
    self.sell_price = 14
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Huge steak in the shape of Mettaton's face.\n(You don't feel like it's made of real meat...)"

    -- Light world check text
    self.check = {
        "Heals 60 HP\n* Huge steak in the shape\nof Mettaton's face.",
        "* (You don't feel like it's\nmade of real meat...)"
    }

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getShortName()
    local name = Kristal.Config["defaultName"]
    if name == "DRAK" or name == "GIGI" or name == "GUGU" or name == "SAM" then
        return "Fsteak"
    end
    return super.getShortName(self)
end

return item