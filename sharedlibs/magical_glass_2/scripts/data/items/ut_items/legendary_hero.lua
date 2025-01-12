local item, super = Class(LightHealItem, "mg_item/legendary_hero")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Legendary Hero"
    -- Name displayed in the normal item select menu
    self.short_name = "Leg.Hero"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "L. Hero"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 40

    -- The sound that plays when this item is used
    self.use_sound = "hero"

    -- Shop description
    self.shop = "Heals 40HP\nHero Sandwich.\nATTACK UP\nin battle."
    -- Default shop price (sell price is halved)
    self.price = 300
    -- Default shop sell price
    self.sell_price = 40
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Sandwich shaped like a sword."

    -- Light world check text
    self.check = "Heals 40 HP\n* Sandwich shaped like a sword.\n* Increases ATTACK when eaten."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getLightBattleUseSound(user, target)
    if Game.battle.encounter.serious then
        return "power"
    else
        return self.use_sound
    end
end

function item:getLightBattleText(user, target, buff)
    if buff then
        return super.getLightBattleText(self, user, target) .. "\n* ATTACK increased by 4!"
    else
        return super.getLightBattleText(self, user, target)
    end
end

function item:onLightBattleUse(user, target)
    self:playLightBattleUseSound(user, target)
    local buff = false
    if target.chara:getStat("attack") < 150 then
        target.chara:addStatBuff("attack", 4)
        buff = true
    end
    local amount = self:getBattleHealAmount(target.chara.id)
    amount = self:applyBattleHealBonuses(user, amount)
    target:heal(amount)
    Game.battle:battleText(self:getLightBattleText(user, target, buff).."\n"..self:getLightBattleHealingText(user, target, amount))
    return true
end

return item