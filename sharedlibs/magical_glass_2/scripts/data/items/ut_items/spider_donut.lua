local item, super = Class(LightHealItem, "mg_item/spider_donut")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Spider Donut"
    -- Name displayed in the normal item select menu
    self.short_name = "SpidrDont"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "SpidrDonut"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 12

    -- Default shop price (sell price is halved)
    self.price = 7
    -- Default shop sell price
    self.sell_price = 30
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A donut made with Spider Cider in the batter."

    -- Light world check text, has "ITEM NAME - " prefixing the string.
    self.check = "Heals 12 HP\n* A donut made with Spider\nCider in the batter."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getLightBattleText(user, target)
    if not Game.battle.encounter.serious then
        if Utils.random(10) > 9 then
            return super.getLightBattleText(self, user, target) .. "\n* Don't worry,[wait:10] Spider didn't."
        end
    end
    return super.getLightBattleText(self, user, target)
end

return item