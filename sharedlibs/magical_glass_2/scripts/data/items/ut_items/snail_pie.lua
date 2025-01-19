local item, super = Class(LightHealItem, "mg_item/snail_pie")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Snail Pie"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 350
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "An acquired taste."

    -- Light world check text
    self.check = "Heals Some HP\n* An acquired taste."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onWorldUse(target)
    self:playWorldUseSound(target)
    if target:getHealth() < target:getStat("health") - 1 then
        target:setHealth(target:getStat("health") - 1)
    end
    if target.id == Game.party[1].id then
        Game.world:showText(self:getWorldUseText(target).."\n* Your HP was maxed out.")
    else
        Game.world:showText(self:getWorldUseText(target).."\n* "..target:getName().."'s HP was maxed out.")
    end
    return true
end

function item:onLightBattleUse(user, target)
    self:playLightBattleUseSound(user, target)
    
    if self.target == "ally" then
        if target.chara:getHealth() < target.chara:getStat("health") - 1 then
            target.chara:setHealth(target.chara:getStat("health") - 1)
        end
    end

    if target.chara.id == Game.battle.party[1].chara.id then
        Game.battle:battleText(self:getLightBattleText(user, target).."\n* Your HP was maxed out.")
    else
        Game.battle:battleText(self:getLightBattleText(user, target).."\n* "..target.chara:getName().."'s HP was maxed out.")
    end

    return true
end

return item