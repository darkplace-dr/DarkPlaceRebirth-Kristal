Utils.hook(Item, "init", function(orig, self)
    orig(self)

    -- Name displayed in the normal item select menu
    self.short_name = nil
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = nil

    -- Tags that apply to this item
    self.tags = {}

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "used"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = nil
    
    -- Whether this weapon should display its magic bonus instead of its defense bonus in shops
    self.show_magic_in_shop = false
    -- Doesn't display stats for weapons and armors in light shops
    self.shop_dont_show_change = false
end)

Utils.hook(Item, "getShortName", function(orig, self) return self.short_name or self.serious_name or self.name end)
Utils.hook(Item, "getSeriousName", function(orig, self) return self.serious_name or self.short_name or self.name end)

Utils.hook(Item, "getUseName", function(orig, self)
    if (Game.state == "OVERWORLD" and Game:isLight()) or
       (Game.state == "BATTLE" and MagicalGlass:getCurrentBattleSystem() == "undertale") then
        return self.use_name or self:getName()
    else
        return orig(self)
    end
end)

Utils.hook(Item, "hasTag", function(orig, self, tag)
    return Utils.containsValue(self.tags, tag)
end)

Utils.hook(Item, "onCheck", function(orig, self)
    if type(self.check) == "string" then
        Game.world:showText("* \"" .. self:getName() .. "\" - " .. self:getCheck())
    elseif type(self.check) == "table" then
        local text = {}
        for i, check in ipairs(self:getCheck()) do
            if i > 1 then
                table.insert(text, check)
            end
        end
        Game.world:showText({{"* \"" .. self:getName() .. "\" - " .. self:getCheck()[1]}, text})
    end
end)
    
Utils.hook(Item, "onToss", function(orig, self)
    if Game:isLight() then
        local choice = Utils.random(1, 30, 1)
        if choice == 1 then
            Game.world:showText("* You bid a quiet farewell\n to the " .. self:getName() .. ".")
        elseif choice == 2 then
            Game.world:showText("* You put the " .. self:getName() .. "\non the ground and gave it a\nlittle pat.")
        elseif choice == 3 then
            Game.world:showText("* You threw the " .. self:getName() .. "\non the ground like the piece\nof trash it is.")
        elseif choice == 4 then
            Game.world:showText("* You abandoned the\n" .. self:getName() .. ".")
        else
            Game.world:showText("* The " .. self:getName() .. " was\nthrown away.")
        end
    end
    return true
end)

Utils.hook(Item, "onLightBattleSelect", function(orig, self, user, target) end)
Utils.hook(Item, "onLightBattleDeselect", function(orig, self, user, target) end)

Utils.hook(Item, "onLightBattleUse", function(orig, self, user, target) end)

Utils.hook(Item, "getLightBattleText", function(orig, self, user, target)
    return "* " .. target.chara:getNameOrYou() .. " " .. self:getUseMethod(target.chara) .. " the " .. self:getUseName() .. "."
end)

Utils.hook(Item, "applyWorldHealBonuses", function(orig, self, amount)
    -- get the member with the highest heal bonuses
    local member_amounts = {}
    for _,member in ipairs(Game.party) do
        local member_amount = amount
        for _,equip in ipairs(member:getEquipment()) do
            member_amount = equip:applyHealBonus(member_amount)
        end
        table.insert(member_amounts, member_amount)
    end
    table.sort(member_amounts, function(a, b) return a > b end)
    return member_amounts[1]
end)

Utils.hook(Item, "applyBattleHealBonuses", function(orig, self, user, amount)
    for _,equip in ipairs(user.chara:getEquipment()) do
        amount = equip:applyHealBonus(amount)
    end
    return amount
end)

--[[ Utils.hook(Item, "getLightShopDescription", function(orig, self)
    return self.shop
end)

Utils.hook(Item, "getLightShopShowMagic", function(orig, self)
    return self.shop_magic
end)

Utils.hook(Item, "getLightShopDontShowChange", function(orig, self)
    return self.shop_dont_show_change
end)

Utils.hook(Item, "getLightTypeName", function(orig, self)
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
end) ]]

--[[ Utils.hook(Item, "save", function(orig, self)
    local saved_dark_item = self.dark_item
    local saved_light_item = self.light_item
    if isClass(self.dark_item) then saved_dark_item = self.dark_item:save() end
    if isClass(self.light_item) then saved_light_item = self.light_item:save() end

    local data = {
        id = self.id,
        flags = self.flags,

        dark_item = saved_dark_item,
        dark_location = self.dark_location,

        light_item = saved_light_item,
        light_location = self.light_location,
    }
    self:onSave(data)
    return data
end) ]]