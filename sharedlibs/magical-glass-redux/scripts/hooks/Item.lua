local Item, super = HookSystem.hookScript(Item)

function Item:init()
    super.init(self)

    -- Short name for the light battle item menu
    self.short_name = nil
    -- Serious name for the light battle item menu
    self.serious_name = nil
    -- Dark name for the dark battle item menu
    self.dark_name = nil

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "used"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = nil

    -- Displays magic stats for weapons and armors in light shops
    self.shop_magic = false
    -- Doesn't display stats for weapons and armors in light shops
    self.shop_dont_show_change = false

    -- Whether this equipment item can convert on light change
    self.equip_can_convert = nil

    self.equip_display_name = nil

    self.heal_bonus = 0
    self.inv_bonus = 0
    self.flee_bonus = 0

    self.light_bolt_count = 1

    self.light_bolt_speed = 11
    self.light_bolt_speed_variance = 2
    self.light_bolt_speed_multiplier = 1

    self.light_bolt_acceleration = 0

    self.light_bolt_start = -16 -- number or table of where the bolt spawns. if it's a table, a value is chosen randomly
    self.light_multibolt_variance = nil

    self.light_bolt_direction = nil -- "right", "left", or "random"

    self.light_bolt_miss_threshold = nil -- (Defaults: 280 for slice weapons | 2 for shoe weapons)
    
    self.light_attack_crit_multiplier = 2.2

    self.attack_sprite = "effects/lightattack/strike"

    -- Sound played when attacking, defaults to laz_c
    self.attack_sound = "laz_c"
    self.attack_pitch = 1

    self.tags = {}
end

function Item:getSellPrice()
    if Kristal.getLibConfig("magical-glass", "balanced_undertale_items_price") and self.light and StringUtils.sub(self.id, 1, 10) == "undertale/" then
        return math.ceil(math.sqrt(super.getSellPrice(self)))
    end
    return super.getSellPrice(self)
end

function Item:getBuyPrice()
    if Kristal.getLibConfig("magical-glass", "balanced_undertale_items_price") and self.light and StringUtils.sub(self.id, 1, 10) == "undertale/" then
        return super.getBuyPrice(self) > 0 and super.getBuyPrice(self) or math.ceil(self:getSellPrice() * 15)
    end
    return super.getBuyPrice(self)
end

function Item:getName()
    if self.light and Game.state == "BATTLE" and not Game.battle.light and self.dark_name then
        return self.dark_name
    else
        return super.getName(self)
    end
end

function Item:getUseName()
    if self.light and Game.state == "BATTLE" and not Game.battle.light and self:getName() == self.dark_name then
        return self.use_name and self.use_name:upper() or self.name:upper()
    elseif (Game.state == "OVERWORLD" and Game:isLight()) or (Game.state == "BATTLE" and Game.battle.light) then
        return self.use_name or self:getName()
    else
        return self.light and self.use_name and self.use_name:upper() or super.getUseName(self)
    end
end

function Item:onLightBattleUpdate(battler) end

function Item:canEquip(character, slot_type, slot_index)
    if self.light then
        return self.can_equip[character.id] ~= false
    else
        return super.canEquip(self, character, slot_type, slot_index)
    end
end

function Item:getEquipDisplayName()
    return self.equip_display_name or self:getName()
end

function Item:getHealBonus() return self.heal_bonus end
function Item:getInvBonus() return self.inv_bonus end
function Item:getFleeBonus() return self.flee_bonus end

function Item:getLightBoltCount() return self.light_bolt_count end

function Item:getLightBoltSpeed()
    if Game.battle.multi_mode then
        return nil
    else
        return ((self.light_bolt_speed + MathUtils.round(MathUtils.random(0, self:getLightBoltSpeedVariance()))) * self:getLightBoltSpeedMultiplier())
    end
end

function Item:getLightBoltAcceleration() return self.light_bolt_acceleration end
function Item:getLightBoltSpeedVariance() return self.light_bolt_speed_variance end
function Item:getLightBoltSpeedMultiplier() return self.light_bolt_speed_multiplier end

function Item:getLightBoltStart()
    if Game.battle.multi_mode then
        return nil
    elseif type(self.light_bolt_start) == "table" then
        return TableUtils.pick(self.light_bolt_start)
    elseif type(self.light_bolt_start) == "number" then
        return self.light_bolt_start
    end
end

function Item:getLightMultiboltVariance(index)
    if Game.battle.multi_mode or self.light_multibolt_variance == nil then
        return nil
    elseif type(self.light_multibolt_variance) == "number" then
        return self.light_multibolt_variance * index
    elseif self.light_multibolt_variance[index] then
        return type(self.light_multibolt_variance[index]) == "table" and TableUtils.pick(self.light_multibolt_variance[index]) or self.light_multibolt_variance[index]
    else
        return (type(self.light_multibolt_variance[#self.light_multibolt_variance]) == "table" and TableUtils.pick(self.light_multibolt_variance[#self.light_multibolt_variance]) or self.light_multibolt_variance[#self.light_multibolt_variance]) * (index - #self.light_multibolt_variance + 1)
    end
end

function Item:getLightBoltDirection()
    if self.light_bolt_direction == "random" or self.light_bolt_direction == nil then
        return TableUtils.pick({"right", "left"})
    else
        return self.light_bolt_direction
    end
end

function Item:getLightAttackMissZone() return self.light_bolt_miss_threshold end

function Item:getLightAttackCritMultiplier() return self.light_attack_crit_multiplier end

function Item:getLightAttackSprite() return self.attack_sprite end
function Item:getLightAttackSound() return self.attack_sound end
function Item:getLightAttackPitch() return self.attack_pitch end

function Item:onLightBoltHit(battler) end

function Item:getLightBattleText(user, target)
    if self.target == "ally" then
        return string.format("* %s %s the %s.", target.chara:getNameOrYou(), self:getUseMethod(target.chara), self:getUseName())
    elseif self.target == "party" then
        if #Game.battle.party > 1 then
            return string.format("* Everyone %s the %s.", self:getUseMethod("other"), self:getUseName())
        else
            return string.format("* You %s the %s.", self:getUseMethod("self"), self:getUseName())
        end
    elseif self.target == "enemy" then
        return string.format("* %s %s the %s.", target.name, self:getUseMethod("other"), self:getUseName())
    elseif self.target == "enemies" then
        return string.format("* The enemies %s the %s.", self:getUseMethod("other"), self:getUseName())
    end
end

function Item:getLightBattleHealingText(user, target, amount)
    local maxed = false
    if self.target == "ally" then
        maxed = target.chara:getHealth() >= target.chara:getStat("health") or amount == math.huge
    elseif self.target == "enemy" then
        maxed = target.health >= target.max_health or amount == math.huge
    elseif self.target == "party" and #Game.battle.party == 1 then
        maxed = target[1].chara:getHealth() >= target[1].chara:getStat("health") or amount == math.huge
    end

    local message = ""

    if self.target == "ally" then
        if select(2, target.chara:getNameOrYou()) and maxed then
            message = "* Your HP was maxed out."
        elseif maxed then
            message = string.format("* %s's HP was maxed out.", target.chara:getNameOrYou())
        else
            message = string.format("* %s recovered %s HP!", target.chara:getNameOrYou(), amount)
        end

    elseif self.target == "party" then
        if #Game.battle.party > 1 then
            message = string.format("* Everyone recovered %s HP!", amount)
        elseif maxed then
            message = "* Your HP was maxed out."
        else
            message = string.format("* You recovered %s HP!", amount)
        end

    elseif self.target == "enemy" then
        if maxed then
            message = string.format("* %s's HP was maxed out.", target.name)
        else
            message = string.format("* %s recovered %s HP!", target.name, amount)
        end

    elseif self.target == "enemies" then
        message = string.format("* The enemies recovered %s HP!", amount)
    end

    return message
end

function Item:getLightShopDescription()
    return self.shop
end

function Item:getLightShopShowMagic()
    return self.shop_magic
end

function Item:getLightShopDontShowChange()
    return self.shop_dont_show_change
end

function Item:getLightTypeName()
    if self.type == "weapon" then
        if self:getLightShopShowMagic() then
            return "Weapon: " .. self:getStatBonus("magic") .. "MG"
        else
            return "Weapon: " .. self:getStatBonus("attack") .. "AT"
        end
    elseif self.type == "armor" then
        if self:getLightShopShowMagic() then
            return "Armor: " .. self:getStatBonus("magic") .. "MG"
        else
            return "Armor: " .. self:getStatBonus("defense") .. "DF"
        end
    end

    return ""
end

function Item:getShortName() return self.short_name or self:getName() end
function Item:getSeriousName() return self.serious_name or self:getShortName() end

function Item:getUseMethod(target)
    if type(target) == "string" then
        if target == "other" and self.use_method_other then
            return self.use_method_other
        elseif target == "self" and self.use_method_self then
            return self.use_method
        else
            return self.use_method
        end
    elseif isClass(target) then
        if (not select(2, target:getNameOrYou()) or target.id ~= Game.party[1].id) and self.use_method_other and self.target ~= "party" then
            return self.use_method_other
        else
            return self.use_method
        end
    end
end

function Item:battleUseSound(user, target) end

function Item:onLightBattleUse(user, target)
    self:battleUseSound(user, target)
    if self:getLightBattleText(user, target) then
        Game.battle:battleText(self:getLightBattleText(user, target))
    else
        Game.battle:battleText(string.format("* %s %s the %s.", user.chara:getNameOrYou(), self:getUseMethod(user.chara), self:getUseName()))
    end
end

function Item:startLightAttackAnimation(battler, enemy, damage, stretch, crit, options, func)
    options = options or {}
    
    if options["trigger_dodge"] ~= false then
        if damage <= 0 then
            enemy:onDodge(battler, true)
        end
    end
    
    if options["sound"] ~= false then
        local src = Assets.stopAndPlaySound(type(options["sound"]) == "string" and options["sound"] or type(options["sound"]) == "table" and options["sound"][1] or
          Game:isLight() and (self:getLightAttackSound() or "laz_c") or
          (battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSound(battler, enemy, stretch) or battler.chara:getAttackSound()) or "laz_c")
        
        src:setPitch(type(options["sound"]) == "table" and options["sound"][2] or
          Game:isLight() and (self:getLightAttackPitch() or 1) or
          (battler.chara:getWeapon() and battler.chara:getWeapon():getAttackPitch(battler, enemy, stretch) or battler.chara:getAttackPitch()) or 1)
    end
    
    if crit and options["crit_sound"] then
        if type(options["crit_sound"]) == "string" then
            Assets.stopAndPlaySound(options["crit_sound"])
        else
            Assets.stopAndPlaySound("saber3")
        end
    end
    
    if type(options["battle_shake"]) == "table" then
        Game.battle:shake(TableUtils.unpack(options["battle_shake"]))
    elseif type(options["battle_shake"]) == "boolean" then
        Game.battle:shake(options["battle_shake"])
    end
    
    local sprite = Sprite(options["sprite"] or
      Game:isLight() and (self:getLightAttackSprite() or "effects/lightattack/strike") or
      (battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSprite(battler, enemy, stretch) or battler.chara:getAttackSprite()) or "effects/attack/cut")
    
    sprite.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
    
    table.insert(enemy.dmg_sprites, sprite)
    
    if type(options["color"]) == "table" then
        sprite:setColor(crit and options["crit_color"] or options["color"])
    elseif options["color"] == true then
        if crit and options["crit_color"] == true then
            if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
                sprite:setColor(TableUtils.lerp(COLORS.white, COLORS.yellow, 0.5))
            else
                sprite:setColor(TableUtils.lerp({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
            end
        else
            sprite:setColor(crit and options["crit_color"] or {battler.chara:getLightMultiboltAttackColor()})
        end
    elseif options["color"] == false then
        sprite:setColor(crit and options["crit_color"] or {battler.chara:getLightAttackColor()})
    else
        if Game:isLight() then
            sprite:setColor(crit and options["crit_color"] or {battler.chara:getLightAttackColor()})
        end
    end
    
    if type(options["scale"]) == "number" then
        sprite:setScale(options["scale"])
    elseif type(options["scale"]) == "table" then
        sprite:setScale(options["scale"][1], options["scale"][2])
    else
        if Game:isLight() then
            sprite:setScale((stretch * 2) - 0.5)
        else
            sprite:setScale(2)
        end
    end
    
    if type(options["origin"]) == "number" then
        sprite:setOrigin(options["origin"])
    elseif type(options["origin"]) == "table" then
        sprite:setOrigin(options["origin"][1], options["origin"][2])
    else
        sprite:setOrigin(0.5)
    end
    
    if type(options["position"]) == "table" then
        sprite:setPosition(options["position"][1], options["position"][2])
    else
        local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (TableUtils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2) - 8)
        sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
    end
    
    sprite.layer = options["layer"] or LIGHT_BATTLE_LAYERS["above_arena_border"]
    
    enemy.parent:addChild(sprite)
    
    if options["shake"] then
        local x, y = 4, 4
        if type(options["shake"]) == "number" then
            x, y = options["shake"], options["shake"]
        elseif type(options["shake"]) == "table" then
            x, y = options["shake"][1], options["shake"][2]
        end
        
        sprite.shake_timer = 0
        local function sprite_exist() return sprite.parent end
        Game.battle.timer:doWhile(sprite_exist, function()
            sprite.shake_timer = sprite.shake_timer + DTMULT
            if sprite.shake_timer >= 1 then
                sprite:move(-x / 2, -y / 2)
                sprite:move(MathUtils.random(x), MathUtils.random(y))
                sprite.shake_timer = sprite.shake_timer - 1
            end
        end)
    end
    
    local anim_speed
    if type(options["speed"]) == "number" then
        anim_speed = options["speed"]
    else
        if Game:isLight() then
            anim_speed = 1 / (30 * (0.5 - (stretch / 4)))
        else
            anim_speed = 1 / 8
        end
    end
    
    if options["speed"] ~= false then
        sprite:play(anim_speed, options["loop"] and true or false, function(attack_sprite)
            if func then func() end
            
            if not options["loop"] then
                attack_sprite:remove()
                TableUtils.removeValue(enemy.dmg_sprites, attack_sprite)
            end
        end)
    elseif func then
        Game.battle.timer:after(1 / 30, function()
            func()
        end)
    end
    
    return sprite
end

function Item:onLightAttack(battler, enemy, damage, stretch, crit)
    self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, nil, function()
        Game.battle.timer:after(3 / 30, function()
            self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
        end)
    end)

    return false
end

function Item:onLightAttackHurt(battler, enemy, damage, stretch, crit, finish)
    local sound = enemy:getDamageSound() or "damage"
    if sound and type(sound) == "string" and (damage > 0 or enemy.always_play_damage_sound) then
        Assets.stopAndPlaySound(sound)
    end
    enemy:hurt(damage, battler)

    battler.chara:onLightAttackHit(enemy, damage)

    if finish ~= false then
        Game.battle:finishActionBy(battler)
    end
end

function Item:onLightMiss(battler, enemy, anim, show_status, attacked)
    enemy:hurt(0, battler, nil, nil, anim, show_status, attacked)
end

return Item