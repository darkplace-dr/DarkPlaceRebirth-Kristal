local item, super = Class(LightHealItem, "mg_item/hot_cat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Hot Cat"
    self.short_name = "Hot Cat"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 21

    -- Default shop price (sell price is halved)
    self.price = 30
    -- Default shop sell price
    self.sell_price = 11
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Like a hot dog, but with little cat ears on the end."

    -- Light world check text
    self.check = "Heals 21 HP\n* Like a hot dog,[wait:10] but with\nlittle cat ears on the end."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false 
end

function item:getWorldUseSound(target)
    return "catsalad"
end

function item:getLightBattleUseSound(user, target)
    if Game.battle.encounter.serious then
        return "power"
    else
        return "catsalad"
    end
end

return item