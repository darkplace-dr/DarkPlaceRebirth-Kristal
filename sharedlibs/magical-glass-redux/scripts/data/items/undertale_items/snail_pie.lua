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

function item:getHealAmount(id)
    local party_member = Game:getPartyMember(id)

    if not party_member then
        return self.heal_amount -- Fallback
    end

    return party_member:getStat("health") + math.abs(party_member:getHealth())
end

function item:onWorldUse(target)
    self:worldUseSound(target)
    
    local old_health = target:getHealth()
    Game.world:heal(target, self:getHealAmount(target.id), self:getWorldUseText(target), self)
    if old_health < target:getStat("health") and target:getStat("health") > 1 then
        target:setHealth(target:getStat("health") - 1 + old_health % 1)
    end
    
    return true
end

function item:onLightBattleUse(user, target)
    self:battleUseSound(user, target)
    
    local old_health = target.chara:getHealth()
    target:heal(self:getHealAmount(target.chara.id), false)
    if old_health < target.chara:getStat("health") and target.chara:getStat("health") > 1 then
        target.chara:setHealth(target.chara:getStat("health") - 1 + old_health % 1)
    end

    Game.battle:battleText(self:getLightBattleText(user, target).."\n"..self:getLightBattleHealingText(user, target, math.huge))
    
    return true
end

function item:onBattleUse(user, target)
    local old_health = target.chara:getHealth()
    target:heal(self:getHealAmount(target.chara.id))
    if old_health < target.chara:getStat("health") and target.chara:getStat("health") > 1 then
        target.chara:setHealth(target.chara:getStat("health") - 1 + old_health % 1)
    end

    return true
end

return item