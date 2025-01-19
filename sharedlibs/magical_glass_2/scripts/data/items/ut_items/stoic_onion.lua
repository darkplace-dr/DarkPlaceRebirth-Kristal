local item, super = Class(LightHealItem, "mg_item/stoic_onion")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Stoic Onion"
    -- Name displayed in the normal item select menu
    self.short_name = "StocOnion"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Onion"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 5

    -- Default shop sell price
    self.sell_price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (for the debug menu)
    self.description = "Even eating it raw, the tears just won't come."
    -- Light world check text
    self.check = "Heals 5 HP\n* Even eating it raw,[wait:10] the\ntears just won't come."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseText(target)
    if not Game.battle.encounter.serious and Utils.ronud(Utils.random(10)) > 8 then
        return super.getWorldUseText(self, target) .. "\n* " .. target:getNameOrYou() .. " didn't cry..."
    end
    return super.getWorldUseText(self, target)
end

function item:getLightBattleText(user, target)
    if not Game.battle.encounter.serious and Utils.ronud(Utils.random(10)) > 8 then
        return super.getLightBattleText(self, user, target) .. "\n* " .. target:getNameOrYou() .. " didn't cry..."
    end
    return super.getLightBattleText(self, user, target)
end

return item