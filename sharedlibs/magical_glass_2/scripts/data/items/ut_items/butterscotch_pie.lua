local item, super = Class(LightHealItem, "mg_item/butterscotch_pie")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Butterscotch Pie"
    -- Name displayed in the normal item select menu
    self.short_name = "ButtsPie"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Pie"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 180
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Butterscotch-cinnamon pie, one slice."

    -- Light world check text
    self.check = "All HP\n* Butterscotch-cinnamon\npie,[wait:10] one slice."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onWorldUse(target)
    self:playWorldUseSound(target)
    target:setHealth(target:getStat("health"))
    if target.you then
        Game.world:showText("* You ate the Butterscotch Pie.\n* Your HP was maxed out.")
    else
        Game.world:showText("* "..target:getNameOrYou().." ate the Butterscotch Pie.\n* "..target:getNameOrYou().."'s HP was maxed out.")
    end
    return true
end

function item:onLightBattleUse(user, target)
    self:playLightBattleUseSound(user, target)
    target.chara:setHealth(target.chara:getStat("health"))
    if target.chara.you then
        Game.battle:battleText("* You ate the Butterscotch Pie.\n* Your HP was maxed out.")
    else
        Game.battle:battleText("* "..target.chara:getNameOrYou().." ate the Butterscotch Pie.\n* "..target.chara:getNameOrYou().."'s HP was maxed out.")
    end
    return true
end

return item