local item, super = Class(LightEquipItem, "undertale/ballet_shoes")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ballet Shoes"
    self.short_name = "BallShoes"
    self.serious_name = "Shoes"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 80
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "These used shoes make you feel incredibly dangerous."

    -- Light world check text
    self.check = "Weapon AT 7\n* These used shoes make you\nfeel incredibly dangerous."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 7
    }

    self.light_bolt_count = 3
    self.light_bolt_speed = 10
    self.light_bolt_speed_variance = 0
    self.light_bolt_start = -90
    self.light_bolt_miss_threshold = 2
    self.light_bolt_direction = "right"
    self.light_multibolt_variance = {{0, 25, 50}, {100, 125, 150}}
    
    self.bolt_count = 3
    self.multibolt_variance = {{40, 60}}

    self.attack_sound = "punchstrong"
    
    self.can_equip = {
        ["susie"] = false
    }
end

function item:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou().." equipped Ballet Shoes.")
end

function item:showEquipTextFail(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " didn't want to equip Ballet Shoes.")
end

function item:getLightBattleText(user, target)
    local text = "* "..target.chara:getNameOrYou().." equipped "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave the "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." equipped it."
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

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/hyperfoot", color = true,
      crit_color = true, shake = true, speed = 2/30, scale = 1, crit_sound = true, battle_shake = true})

    Game.battle.timer:after(10/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)

    return false
end

return item