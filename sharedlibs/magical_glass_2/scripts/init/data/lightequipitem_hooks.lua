Utils.hook(LightEquipItem, "init", function(orig, self)
    LightEquipItem.__super.init(self)

    -- This needs to be "ally" due to how light world equipping works.
    self.target = "ally"

    -- Name displayed in the light world stat menu
    self.equip_name = nil

    -- The amount of bolts spawned when attacking.
    -- Having more than 1 changes point calculation.
    self.bolt_count = 1

    -- How fast this item's bolts move
    self.bolt_speed = 11
    -- A random bonus added to this item's bolt speed.
    -- For example, if bolt_speed is 11, setting this to 2 would result
    -- in the speed being a floating point number anywhere between 11-13. 
    self.bolt_speed_variance = 2

    -- An offset to where this item's bolt spawns.
    -- If it's a table, a random value will be picked from said table.
    self.bolt_start = -16
    -- A table of numbers or tables that determine where bolts spawned after
    -- the first bolt should spawn.
    -- Number entries always place a bolt in a certain positions, table entries
    -- will get a random value picked from them.
    self.multibolt_variance = 10
    -- Whether bolts after the first should be spawned relative to the first bolt.
    self.relative_multibolt_variance = false

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "right" -- "right", "left", or "random"

    -- The texture/animation used when attacking an enemy if onLightBattleAttack isn't
    -- overwritten.
    self.attack_sprite = "effects/attack/strike"
    -- The sound played when attacking if onLightBattleAttack isn't overwritten.
    self.attack_sound = "laz_c"
    -- The pitch of this item's attack sound.
    self.attack_pitch = 1

    -- Whether this item should be equipped when used in battles
    self.battle_swap_equip = true
end)

Utils.hook(LightEquipItem, "getEquipName", function(orig, self)
    if self.equip_name then
        return self.equip_name
    else
        return self:getName()
    end
end)

Utils.hook(LightEquipItem, "getBoltCount", function(orig, self)
    return self.bolt_count
end)

Utils.hook(LightEquipItem, "getBoltSpeed", function(orig, self)
    return self.bolt_speed + Utils.random(self:getBoltSpeedVariance())
end)

Utils.hook(LightEquipItem, "getBoltSpeedVariance", function(orig, self)
    return self.bolt_speed_variance
end)

Utils.hook(LightEquipItem, "getBoltStartOffset", function(orig, self)
    if type(self.bolt_start) == "table" then
        return Utils.pick(self.bolt_start)
    elseif type(self.bolt_start) == "number" then
        return self.bolt_start
    end
end)

Utils.hook(LightEquipItem, "getBoltDirection", function(orig, self)
    if self.bolt_direction == "random" then
        return Utils.pick({"right", "left"})
    else
        return self.bolt_direction
    end
end)

Utils.hook(LightEquipItem, "getMultiboltVariance", function(orig, self)
    return self.multibolt_variance
end)

Utils.hook(LightEquipItem, "getAttackSprite", function(orig, self)
    return self.attack_sprite
end)

Utils.hook(LightEquipItem, "getAttackSound", function(orig, self)
    return self.attack_sound
end)

Utils.hook(LightEquipItem, "getAttackPitch", function(orig, self)
    return self.attack_pitch
end)

Utils.hook(LightEquipItem, "applyHealBonus", function(orig, self, amount) return (amount or 0) + self:getStatBonus("heal") end)
Utils.hook(LightEquipItem, "applyFleeBonus", function(orig, self, amount) return (amount or 0) + self:getStatBonus("flee") end)
Utils.hook(LightEquipItem, "applyInvBonus", function(orig, self, amount) return (amount or 0) + self:getStatBonus("inv") end)

Utils.hook(LightEquipItem, "onWorldUse", function(orig, self, target)
    self:playWorldUseSound(target)
    local replacing = nil
    if self.type == "weapon" then
        if target:getWeapon() then
            replacing = target:getWeapon()
            replacing:onUnequip(target, self)
            Game.inventory:replaceItem(self, replacing)
        end
        target:setWeapon(self)
    elseif self.type == "armor" then
        if target:getArmor(1) then
            replacing = target:getArmor(1)
            replacing:onUnequip(target, self)
            Game.inventory:replaceItem(self, replacing)
        end
        target:setArmor(1, self)
    else
        error("LightEquipItem "..self.id.." invalid type: "..self.type)
    end

    self:onEquip(target, replacing)
    self:showEquipText(target)
    return false
end)

Utils.hook(LightEquipItem, "showEquipText", function(orig, self, target)
    Game.world:showText("* " .. target:getNameOrYou() .. " equipped the " .. self:getUseName() .. ".")
end)

Utils.hook(LightEquipItem, "onLightBattleNextTurn", function(orig, self, battler, turn) end)

Utils.hook(LightEquipItem, "onLightBattleUse", function(orig, self, user, target)
    self:playLightBattleUseSound(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target))
end)

Utils.hook(LightEquipItem, "getLightBattleText", function(orig, self, user, target)
    return "* " .. target.chara:getNameOrYou() .. " equipped the " .. self:getUseName() .. "."
end)

Utils.hook(LightEquipItem, "onLightBattleBoltHit", function(orig, self, battler, enemy, attack) end)
Utils.hook(LightEquipItem, "onLightBattleBoltMiss", function(orig, self, battler, enemy, attack) end)

Utils.hook(LightEquipItem, "onLightBattleAttack", function(orig, self, battler, enemy, damage, stretch, attack, crit)
    local after_func = function()
        Game.battle:finishActionBy(battler)
    end

    local x, y = enemy:getRelativePos((enemy.width / 2) - 5, (enemy.height / 2) - 5)
    local anim = BasicAttackAnim(x, y, self:getAttackSprite(), stretch, {sound = self:getAttackSound(), after = after_func})
    Game.battle:addChild(anim)

    -- should finish action automatically, damage override, don't damage enemy when the attack ends
    return false
end)

Utils.hook(LightEquipItem, "onLightBattleMiss", function(orig, self, battler, enemy)
    -- should finish action automatically, don't hit for 0 damage when the attack ends
end)

Utils.hook(LightEquipItem, "playWorldUseSound", function(orig, self, target)
    Assets.playSound("item")
end)

Utils.hook(LightEquipItem, "playLightBattleUseSound", function(orig, self, user, target)
    Assets.playSound("item")
end)