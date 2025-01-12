Utils.hook(PartyMember, "init", function(orig, self)
    orig(self)
    
    self.undertale_movement = false

    self.lw_stats["magic"] = 0

    self.you = false -- self.insert

    self.lw_color = nil
    self.lw_dmg_color = nil
    self.lw_miss_color = nil
    self.lw_attack_color = nil
    self.lw_attack_bolt_color = nil
    self.lw_xact_color = nil
end)

Utils.hook(PartyMember, "getNameOrYou", function(orig, self)
    if self.you then
        return "You"
    else
        return self:getName()
    end
end)

Utils.hook(PartyMember, "getLightMaxLV", function(orig, self)
    return #self.lw_exp_needed
end)

Utils.hook(PartyMember, "getLightColor", function(orig, self)
    if self.lw_color then
        return Utils.unpackColor(self.lw_color)
    else
        return self:getColor()
    end
end)

Utils.hook(PartyMember, "getLightDamageColor", function(orig, self)
    if self.lw_dmg_color then
        return Utils.unpackColor(self.lw_dmg_color)
    else
        return self:getDamageColor()
    end
end)

Utils.hook(PartyMember, "getLightMissColor", function(orig, self)
    if self.lw_miss_color then
        return Utils.unpackColor(self.lw_miss_color)
    else
        return self:getDamageColor()
    end
end)

Utils.hook(PartyMember, "getLightAttackBoltColor", function(orig, self)
    if self.lw_attack_bolt_color then
        return Utils.unpackColor(self.lw_attack_bolt_color)
    else
        return self:getLightColor()
    end
end)

Utils.hook(PartyMember, "getLightAttackColor", function(orig, self)
    if self.lw_attack_color then
        return Utils.unpackColor(self.lw_attack_color)
    else
        return self:getLightColor()
    end
end)

Utils.hook(PartyMember, "getLightXActColor", function(orig, self)
    if self.lw_xact_color then
        return Utils.unpackColor(self.lw_xact_color)
    else
        return self:getXActColor()
    end
end)

Utils.hook(PartyMember, "onLightBattleAttackHit", function(orig, self, enemy, damage) end)

Utils.hook(PartyMember, "onLightLevelUp", function(orig, self, level)
    self.lw_stats = {
        health = 16 + level * 4,
        attack = 8 + level * 2,
        defense = 9 + math.ceil(level / 4),
        magic = 0
    }

    if level >= self:getLightMaxLV() then
        self.lw_stats.health = 99
    end
end)

Utils.hook(PartyMember, "gainLightEXP", function(orig, self, amount)
    if self:getLightLV() >= self:getLightMaxLV() then return end

    self.lw_exp = self.lw_exp + amount
    self.lw_exp = Utils.clamp(self.lw_exp, 0, self:getLightEXPNeeded(#self.lw_exp_needed))

    return self:checkLightEXP()
end)

Utils.hook(PartyMember, "checkLightEXP", function(orig, self)
    local old_lv = self:getLightLV()
    local new_lv

    for lv, exp in pairs(self.lw_exp_needed) do
        if self.lw_exp >= exp then
            new_lv = lv
        end
    end

    self.lw_lv = new_lv
    self:onLightLevelUp(self.lw_lv)

    return new_lv > old_lv
end)

Utils.hook(PartyMember, "setLightLV", function(orig, self, level, change_exp)
    if self:getLightLV() == level then return end
    if level > self:getLightMaxLV() then return end

    self.lw_lv = level
    self:onLightLevelUp(self.lw_lv)

    if change_exp == nil or change_exp == true then
        self.lw_exp = self:getLightEXPNeeded(self.lw_lv)
    end
end)