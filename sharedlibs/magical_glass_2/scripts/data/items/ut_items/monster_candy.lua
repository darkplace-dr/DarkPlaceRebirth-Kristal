local item, super = Class(LightHealItem, "mg_item/monster_candy")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Monster Candy"
    -- Name displayed in the normal item select menu
    self.short_name = "MnstrCndy"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 10

    -- Default shop sell price
    self.sell_price = 25
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Has a distinct, non licorice flavor."

    -- Light world check text
    self.check = "Heals 10 HP\n* Has a distinct,[wait:10]\nnon licorice flavor."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseText(target)
    if not Game.battle.encounter.serious then
        local picker = Utils.round(Utils.random(15))
        if picker == 15 then
            return super.getWorldUseText(self, target) .. "\n* ... tastes like licorice."
        end
        if picker <= 2 then
            return super.getWorldUseText(self, target) .. "\n* Very un-licorice-like."
        end
    end
    return super.getWorldUseText(self, target)
end

function item:getLightBattleText(user, target)
    if not Game.battle.encounter.serious then
        local picker = Utils.random(15)
        if picker == 15 then
            return super.getLightBattleText(self, user, target) .. "\n* ... tastes like licorice."
        end
        if picker <= 2 then
            return super.getLightBattleText(self, user, target) .. "\n* Very un-licorice-like."
        end
    end
    return super.getLightBattleText(self, user, target)
end

return item