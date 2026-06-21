local item, super = Class(LightEquipItem, "mg/tough_glove")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Tough Glove"
    self.short_name = "TuffGlove"
    self.serious_name = "Glove"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "Slap 'em."
    -- Default shop price (sell price is halved)
    self.price = 50
    if Kristal.getLibConfig("magical-glass", "balanced_undertale_items_price") then
        self.sell_price = 5
    else
        -- Default shop sell price
        self.sell_price = 50
    end
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A worn pink leather glove.\nFor five-fingered folk."

    -- Light world check text
    self.check = "Weapon AT 5\n* A worn pink leather glove.[wait:10]\n* For five-fingered folk."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 5
    }

    self.light_bolt_count = 4
    self.light_bolt_speed = 8
    self.light_bolt_speed_variance = 0
    self.light_bolt_direction = "right"
    self.light_bolt_miss_threshold = 4
    self.light_multibolt_variance = {{15, 50}, {85, 120}, {155, 190}}
    self.light_attack_crit_multiplier = 2.1

    self.attack_sound = "punchstrong"

    self.tags = {"punch", "slice_damage"}
end

function item:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .." equipped Tough Glove.")
end

function item:showEquipTextFail(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " didn't want to equip Tough Glove.")
end

function item:getLightBattleText(user, target)
    local text = "* "..target.chara:getNameOrYou().." equipped "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." equipped it."
    end
    return text
end

function item:getLightBattleTextFail(user, target)
    local text = "* "..target.chara:getNameOrYou().." didn't want to equip "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." didn't want to equip it."
    end
    return text
end

function item:onLightBoltHit(lane)
    local battler = lane.battler
    local enemy = Game.battle:getActionBy(battler).target

    if enemy and lane.bolts[2] then
        self:startLightAttackAnimation(battler, enemy, nil, nil, nil, {sprite = "effects/lightattack/regfist", sound = "punchweak", color = true,
          position = {enemy:getRelativePos((love.math.random(enemy.width)), (love.math.random(enemy.height)))}, shake = true, speed = 2/30, scale = 1, trigger_dodge = false})
    end
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/hyperfist", color = true,
      shake = true, speed = 2/30, scale = 1, battle_shake = true})
    
    Game.battle.timer:after(10/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)

    return false
end

return item