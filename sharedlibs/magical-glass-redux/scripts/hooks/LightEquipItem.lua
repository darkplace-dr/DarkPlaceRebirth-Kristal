local LightEquipItem, super = HookSystem.hookScript(LightEquipItem)

function LightEquipItem:convertToDark(inventory)
    if not Kristal.getLibConfig("magical-glass", "light_inventory_equipment_conversion") or Game.inventory:getItemIndex(self) ~= "items" then
        return false
    elseif self.delete_on_convert then
        return true
    else
        return super.convertToDark(self, inventory)
    end
end

function LightEquipItem:init()
    super.init(self)

    self.delete_on_convert = false
    self.storage, self.index = nil, nil

    self.target = "ally"
end

function LightEquipItem:onManualEquip(target, replacement)
    local can_equip = true

    if (not self:onEquip(target, replacement)) then can_equip = false end
    if replacement and (not replacement:onUnequip(target, self)) then can_equip = false end
    if (not target:onEquip(self, replacement)) then can_equip = false end
    if (not target:onUnequip(replacement, self)) then can_equip = false end
    if (not self:canEquip(target, self.type, 1)) then can_equip = false end

    -- If one of the functions returned false, the equipping will fail
    return can_equip
end

function LightEquipItem:onBattleSelect(user, target)
    self.storage, self.index = Game.inventory:getItemIndex(self)

    return true
end

function LightEquipItem:showEquipText(target)
    Game.world:showText(string.format(
        "* %s equipped the %s.",
        target:getNameOrYou(),
        self:getUseName()
    ))
end

function LightEquipItem:showEquipTextFail(target)
    Game.world:showText(string.format(
        "* %s didn't want to equip the %s.",
        target:getNameOrYou(),
        self:getUseName()
    ))
end

function LightEquipItem:onWorldUse(target)
    local chara = target
    local replacing = nil

    if self.type == "weapon" then
        replacing = chara:getWeapon()
    elseif self.type == "armor" then
        replacing = chara:getArmor(1)
    end

    if self:onManualEquip(chara, replacing) then
        Assets.playSound("item")
        if replacing then
            Game.inventory:replaceItem(self, replacing)
            if Kristal.getLibConfig("magical-glass", "light_inventory_equipment_conversion") and self.type == "weapon" and not self.dark_item and replacing.dark_item == chara:getFlag("dark_weapon") then
                self.delete_on_convert = false
                replacing.delete_on_convert = true
            end
        end
        if self.type == "weapon" then
            chara:setWeapon(self)
        elseif self.type == "armor" then
            chara:setArmor(1, self)
        else
            error("LightEquipItem " .. self.id .. " invalid type: " .. self.type)
        end

        self:showEquipText(target)

        return replacing == nil
    else
        self:showEquipTextFail(target)

        return false
    end
end

function LightEquipItem:getLightBattleText(user, target)
    local text = string.format(
        "* %s equipped the %s.",
        target.chara:getNameOrYou(),
        self:getUseName()
    )

    if user ~= target then
        text = string.format(
            "* %s gave the %s to %s.\n* %s equipped it.",
            user.chara:getNameOrYou(),
            self:getUseName(),
            target.chara:getNameOrYou(true),
            target.chara:getNameOrYou()
        )
    end

    return text
end

function LightEquipItem:getLightBattleTextFail(user, target)
    local text = string.format(
        "* %s didn't want to equip the %s.",
        target.chara:getNameOrYou(),
        self:getUseName()
    )

    if user ~= target then
        text = string.format(
            "* %s gave the %s to %s.\n* %s didn't want to equip it.",
            user.chara:getNameOrYou(),
            self:getUseName(),
            target.chara:getNameOrYou(true),
            target.chara:getNameOrYou()
        )
    end

    return text
end

function LightEquipItem:getBattleText(user, target)
    local replacing = nil

    if self.type == "weapon" then
        replacing = target.chara:getWeapon()
    elseif self.type == "armor" then
        replacing = target.chara:getArmor(1)
    end

    if self:onManualEquip(target.chara, replacing) then
        local text = string.format(
            "* %s equipped the %s!",
            target.chara:getName(),
            self:getUseName()
        )

        if user ~= target then
            text = string.format(
                "* %s gave the %s to %s!\n* %s equipped it!",
                user.chara:getName(),
                self:getUseName(),
                target.chara:getName(),
                target.chara:getName()
            )
        end

        return text
    else
        local text = string.format(
            "* %s didn't want to equip the %s.",
            target.chara:getName(),
            self:getUseName()
        )

        if user ~= target then
            text = string.format(
                "* %s gave the %s to %s!\n* %s didn't want to equip it.",
                user.chara:getName(),
                self:getUseName(),
                target.chara:getName(),
                target.chara:getName()
            )
        end

        return text
    end
end

function LightEquipItem:onLightBattleUse(user, target)
    local chara = target.chara
    local replacing = nil

    if self.type == "weapon" then
        replacing = chara:getWeapon()
    elseif self.type == "armor" then
        replacing = chara:getArmor(1)
    end

    if self:onManualEquip(chara, replacing) then
        Assets.playSound("item")
        if replacing then
            Game.inventory:addItemTo(self.storage, self.index, replacing)
            if Kristal.getLibConfig("magical-glass", "light_inventory_equipment_conversion") and self.type == "weapon" and not self.dark_item and replacing.dark_item == chara:getFlag("dark_weapon") then
                self.delete_on_convert = false
                replacing.delete_on_convert = true
            end
        end
        if self.type == "weapon" then
            chara:setWeapon(self)
        elseif self.type == "armor" then
            chara:setArmor(1, self)
        else
            error("LightEquipItem " .. self.id .. " invalid type: " .. self.type)
        end

        Game.battle:battleText(self:getLightBattleText(user, target))
    else
        Game.inventory:addItemTo(self.storage, self.index, self)
        Game.battle:battleText(self:getLightBattleTextFail(user, target))
    end
    self.storage, self.index = nil, nil
end

function LightEquipItem:onBattleUse(user, target)
    local chara = target.chara
    local replacing = nil

    if self.type == "weapon" then
        replacing = chara:getWeapon()
    elseif self.type == "armor" then
        replacing = chara:getArmor(1)
    end

    if self:onManualEquip(chara, replacing) then
        Assets.playSound("item")
        if replacing then
            Game.inventory:addItemTo(self.storage, self.index, replacing)
            if Kristal.getLibConfig("magical-glass", "light_inventory_equipment_conversion") and self.type == "weapon" and not self.dark_item and replacing.dark_item == chara:getFlag("dark_weapon") then
                self.delete_on_convert = false
                replacing.delete_on_convert = true
            end
        end
        if self.type == "weapon" then
            chara:setWeapon(self)
        elseif self.type == "armor" then
            chara:setArmor(1, self)
        else
            error("LightEquipItem " .. self.id .. " invalid type: " .. self.type)
        end
    else
        Game.inventory:addItemTo(self.storage, self.index, self)
    end
    self.storage, self.index = nil, nil
end

function LightEquipItem:onSave(data)
    super.onSave(self, data)

    data.delete_on_convert = self.delete_on_convert
end

function LightEquipItem:onLoad(data)
    super.onLoad(self, data)

    self.delete_on_convert = data.delete_on_convert
end

return LightEquipItem