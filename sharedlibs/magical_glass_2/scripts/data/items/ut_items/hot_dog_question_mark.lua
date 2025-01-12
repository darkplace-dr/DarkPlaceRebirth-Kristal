local item, super = Class(LightHealItem, "mg_item/hot_dog_question_mark")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Hot Dog...?"
    -- Name displayed in the normal item select menu
    self.short_name = "Hot Dog"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 20

    -- Default shop price (sell price is halved)
    self.price = 30
    -- Default shop sell price
    self.sell_price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "The \"meat\" is made of something called a \"water sausage.\""

    -- Light world check text
    self.check = "Heals 20 HP\n* The \"meat\" is made of something\ncalled a \"water sausage.\""

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseSound(target)
    return "dogsalad"
end

function item:getLightBattleUseSound(user, target)
    if Game.battle.encounter.serious then
        return "power"
    else
        return "dogsalad"
    end
end

return item