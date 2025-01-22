local item, super = Class(HealItem, "undertale/snail_pie")

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
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
end

function item:onWorldUse(target)
    self:worldUseSound(target)
    
    local old_health = target:getHealth()
    Game.world:heal(target, math.huge, self:getWorldUseText(target), self)
    if old_health < target:getStat("health") and target:getStat("health") > 1 then
        target:setHealth(target:getStat("health") - 1 + old_health % 1)
    end
    
    return true
end

function item:onLightBattleUse(user, target)
    self:battleUseSound(user, target)
    
    if self.target == "ally" then
        local old_health = target.chara:getHealth()
        target:heal(math.huge, false)
        if old_health < target.chara:getStat("health") and target.chara:getStat("health") > 1 then
            target.chara:setHealth(target.chara:getStat("health") - 1 + old_health % 1)
        end
    elseif self.target == "enemy" then
        local old_health = target.health
        target:heal(math.huge)
        if old_health < target.max_health and target.max_health > 1 then
            target.health = target.max_health - 1 + old_health % 1
        end
    end

    Game.battle:battleText(self:getLightBattleText(user, target).."\n"..self:getLightBattleHealingText(user, target, math.huge))
    
    return true
end

function item:onBattleUse(user, target)
    if self.target == "ally" then
        local old_health = target.chara:getHealth()
        target:heal(math.huge)
        if old_health < target.chara:getStat("health") and target.chara:getStat("health") > 1 then
            target.chara:setHealth(target.chara:getStat("health") - 1 + old_health % 1)
        end
    elseif self.target == "enemy" then
        local old_health = target.health
        target:heal(math.huge)
        if old_health < target.max_health and target.max_health > 1 then
            target.health = target.max_health - 1 + old_health % 1
        end
    end

    return true
end

return item