local HealItem, super = HookSystem.hookScript(HealItem)

function HealItem:onWorldUse(target)
    if Game:isLight() then
        local text = self:getWorldUseText(target)
        if self.target == "ally" then
            self:worldUseSound(target)
            local amount = self:getWorldHealAmount(target.id)
            local best_amount
            for _, member in ipairs(Game.party) do
                local equip_amount = 0
                for _, equip in ipairs(member:getEquipment()) do
                    equip_amount = equip_amount + equip:getHealBonus()
                end
                if not best_amount or equip_amount > best_amount then
                    best_amount = equip_amount
                end
            end
            amount = amount + best_amount
            Game.world:heal(target, amount, text, self)

            return true
        elseif self.target == "party" then
            self:worldUseSound(target)
            for _, party_member in ipairs(target) do
                local amount = self:getWorldHealAmount(party_member.id)
                local best_amount
                for _, member in ipairs(Game.party) do
                    local equip_amount = 0
                    for _, equip in ipairs(member:getEquipment()) do
                        equip_amount = equip_amount + equip:getHealBonus()
                    end
                    if not best_amount or equip_amount > best_amount then
                        best_amount = equip_amount
                    end
                end
                amount = amount + best_amount
                Game.world:heal(party_member, amount, text, self)
            end

            return true
        else
            return false
        end
    else
        return super.onWorldUse(self, target)
    end
end

function HealItem:onLightBattleUse(user, target)
    local text = self:getLightBattleText(user, target)

    if self.target == "ally" then
        self:battleUseSound(user, target)
        local amount = self:getBattleHealAmount(target.chara.id)

        for _, equip in ipairs(user.chara:getEquipment()) do
            if equip.getHealBonus then
                amount = amount + equip:getHealBonus()
            end
        end

        target:heal(amount, false)
        if self:getLightBattleHealingText(user, target, amount) then
            if type(text) == "table" then
                text[#text] = text[#text] .. (text[#text] ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            else
                text = text .. (text ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            end
        end
        Game.battle:battleText(text)

        return true
    elseif self.target == "party" then
        self:battleUseSound(user, target)

        local amount = 0
        for _, battler in ipairs(target) do
            amount = self:getBattleHealAmount(battler.chara.id)
            for _, equip in ipairs(user.chara:getEquipment()) do
                if equip.getHealBonus then
                    amount = amount + equip:getHealBonus()
                end
            end

            battler:heal(amount, false)
        end

        if self:getLightBattleHealingText(user, target, amount) then
            if type(text) == "table" then
                text[#text] = text[#text] .. (text[#text] ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            else
                text = text .. (text ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            end
        end
        Game.battle:battleText(text)

        return true
    elseif self.target == "enemy" then
        local amount = self:getBattleHealAmount(target.id)

        for _, equip in ipairs(user.chara:getEquipment()) do
            if equip.getHealBonus then
                amount = amount + equip:getHealBonus()
            end
        end

        target:heal(amount)

        if self:getLightBattleHealingText(user, target, amount) then
            if type(text) == "table" then
                text[#text] = text[#text] .. (text[#text] ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            else
                text = text .. (text ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            end
        end
        Game.battle:battleText(text)

        return true
    elseif self.target == "enemies" then
        local amount = 0
        for _, enemy in ipairs(target) do
            amount = self:getBattleHealAmount(enemy.id)
            for _, equip in ipairs(user.chara:getEquipment()) do
                if equip.getHealBonus then
                    amount = amount + equip:getHealBonus()
                end
            end

            enemy:heal(amount)
        end

        if self:getLightBattleHealingText(user, target, amount) then
            if type(text) == "table" then
                text[#text] = text[#text] .. (text[#text] ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            else
                text = text .. (text ~= "" and "\n" or "") .. self:getLightBattleHealingText(user, target, amount)
            end
        end
        Game.battle:battleText(text)

        return true
    else
        -- No target or enemy target (?), do nothing
        return false
    end
end

function HealItem:getLightBattleText(user, target)
    if self.target == "ally" then
        return string.format(
            "* %s %s the %s.",
            target.chara:getNameOrYou(),
            self:getUseMethod(target.chara),
            self:getUseName()
        )

    elseif self.target == "party" then
        if #Game.battle.party > 1 then
            return string.format(
                "* Everyone %s the %s.",
                self:getUseMethod("other"),
                self:getUseName()
            )
        else
            return string.format(
                "* You %s the %s.",
                self:getUseMethod("self"),
                self:getUseName()
            )
        end

    elseif self.target == "enemy" then
        return string.format(
            "* %s %s the %s.",
            target.name,
            self:getUseMethod("other"),
            self:getUseName()
        )

    elseif self.target == "enemies" then
        return string.format(
            "* The enemies %s the %s.",
            self:getUseMethod("other"),
            self:getUseName()
        )
    end
end

function HealItem:getWorldUseText(target)
    if self.target == "ally" then
        return string.format(
            "* %s %s the %s.",
            target:getNameOrYou(),
            self:getUseMethod(target),
            self:getUseName()
        )

    elseif self.target == "party" then
        if #Game.party > 1 then
            return string.format(
                "* Everyone %s the %s.",
                self:getUseMethod("other"),
                self:getUseName()
            )
        else
            return string.format(
                "* You %s the %s.",
                self:getUseMethod("self"),
                self:getUseName()
            )
        end
    end
end

function HealItem:getLightBattleHealingText(user, target, amount)
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

function HealItem:getLightWorldHealingText(target, amount)
    local maxed = false

    if self.target == "ally" or self.target == "party" and #Game.party == 1 then
        maxed = target:getHealth() >= target:getStat("health") or amount == math.huge
    end

    local message = ""

    if self.target == "ally" then
        if select(2, target:getNameOrYou()) and maxed then
            message = "* Your HP was maxed out."
        elseif maxed then
            message = string.format("* %s's HP was maxed out.", target:getNameOrYou())
        else
            message = string.format("* %s recovered %s HP!", target:getNameOrYou(), amount)
        end

    elseif self.target == "party" then
        if #Game.party > 1 then
            message = string.format("* Everyone recovered %s HP!", amount)
        elseif maxed then
            message = "* Your HP was maxed out."
        else
            message = string.format("* You recovered %s HP!", amount)
        end
    end

    return message
end

function HealItem:onBattleUse(user, target)
    if Game:isLight() then
        if self.target == "ally" then
            -- Heal single party member
            local amount = self:getBattleHealAmount(target.chara.id)
            for _, equip in ipairs(user.chara:getEquipment()) do
                amount = amount + equip:getHealBonus()
            end
            target:heal(amount)
        elseif self.target == "party" then
            -- Heal all party members
            for _, battler in ipairs(target) do
                local amount = self:getBattleHealAmount(battler.chara.id)
                for _, equip in ipairs(user.chara:getEquipment()) do
                    amount = amount + equip:getHealBonus()
                end
                battler:heal(amount)
            end
        elseif self.target == "enemy" then
            -- Heal single enemy
            local amount = self:getBattleHealAmount(target.id)
            for _, equip in ipairs(user.chara:getEquipment()) do
                amount = amount + equip:getHealBonus()
            end
            target:heal(amount)
        elseif self.target == "enemies" then
            -- Heal all enemies
            for _, enemy in ipairs(target) do
                local amount = self:getBattleHealAmount(enemy.id)
                for _, equip in ipairs(user.chara:getEquipment()) do
                    amount = amount + equip:getHealBonus()
                end
                enemy:heal(amount)
            end
        else
            -- No target, do nothing
        end
    else
        super.onBattleUse(self, user, target)
    end
end

function HealItem:battleUseSound(user, target)
    Game.battle.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        Assets.stopAndPlaySound("power")
    end)
end

function HealItem:worldUseSound(target)
    Game.world.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        Assets.stopAndPlaySound("power")
    end)
end

return HealItem