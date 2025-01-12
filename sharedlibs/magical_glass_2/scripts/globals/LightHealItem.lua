local LightHealItem, super = Class(HealItem, "LightHealItem")

function LightHealItem:init()
    super.init(self)

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "use"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "uses"


    self.swallow_sound = true
    -- The sound that plays when this item is used
    self.use_sound = "power"
end

function LightHealItem:onWorldUse(target)
    local text = self:getWorldUseText(target)
    if self.target == "ally" then
        self:playWorldUseSound(target)
        local amount = self:getWorldHealAmount(target.id)
        amount = self:applyWorldHealBonuses(amount)
        Game.world:heal(target, amount, text, self)
        return true
    elseif self.target == "party" then
        self:playWorldUseSound(target)
        for _,party_member in ipairs(target) do
            local amount = self:getWorldHealAmount(party_member.id)
            amount = self:applyWorldHealBonuses(amount)
            party_member:heal(amount, false)
        end
        Game.world:showText(text)
        return true
    else
        return false
    end
end

function LightHealItem:getWorldUseText(target)
    if self.target == "ally" then
        return "* "..target:getNameOrYou().." "..self:getUseMethod(target).." the "..self:getUseName().."."
    elseif self.target == "party" then
        if #Game.party > 1 then
            return "* Everyone "..self:getUseMethod("other").." the "..self:getUseName().."."
        else
            return "* You "..self:getUseMethod("self").." the "..self:getUseName().."."
        end
    end
end

--[[ function LightHealItem:getLightWorldHealingText(target, amount, maxed)
    if target.you and maxed then
        return  "* Your HP was maxed out."
    elseif maxed then
        return  "* " .. target:getNameOrYou() .. "'s HP was maxed out."
    else
        return "* " .. target:getNameOrYou() .. " recovered " .. amount .. " HP!"
    end
end ]]

function LightHealItem:getUseMethod(target)
    if type(target) == "string" then
        if target == "other" and self.use_method_other then
            return self.use_method_other
        end
    elseif isClass(target) then
        if (not target.you and self.use_method_other and self.target ~= "party") then
            return self.use_method_other
        end
    end
    return self.use_method
end

function LightHealItem:playWorldUseSound(target)
    if self.swallow_sound then
        Game.world.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound(self.use_sound)
        end)
    else
        Assets.stopAndPlaySound(self.use_sound)
    end
end

function LightHealItem:onLightBattleUse(user, target)
    local text = self:getLightBattleText(user, target)

    if self.target == "ally" then
        self:playLightBattleUseSound(user, target)
        local amount = self:getBattleHealAmount(target.chara.id)
        amount = self:applyBattleHealBonuses(user, amount)
        target:heal(amount)
        text = text .. "\n" .. self:getLightBattleHealingText(user, target, amount)
        Game.battle:battleText(text)
        return true
    elseif self.target == "party" then
        self:playLightBattleUseSound(user, target)
        for _,battler in ipairs(target) do
            local amount = self:getBattleHealAmount(battler.chara.id)
            amount = self:applyBattleHealBonuses(user, amount)
            battler:heal(amount)
        end
        Game.battle:battleText(text)
        return true
    elseif self.target == "enemy" then
        self:playLightBattleUseSound(user, target)
        local amount = self:getHealAmount()
        amount = self:applyBattleHealBonuses(user, amount)
        target:heal(amount)
        Game.battle:battleText(text)
        return true
    elseif self.target == "enemies" then
        self:playLightBattleUseSound(user, target)
        for _,enemy in ipairs(target) do
            local amount = self:getHealAmount()
            amount = self:applyBattleHealBonuses(user, amount)
            enemy:heal(amount)
        end
        Game.battle:battleText(text)
        return true
    else
        -- No target or enemy target (?), do nothing
        return false
    end
end

function LightHealItem:getLightBattleHealingText(user, target, amount)
    local maxed
    if target then
        if self.target == "ally" then
            maxed = target.chara:getHealth() >= target.chara:getStat("health")
        end
    end

    if self.target == "ally" then
        if target.chara.you and maxed then
            return "* Your HP was maxed out."
        elseif maxed then
            return "* " .. target.chara:getNameOrYou() .. "'s HP was maxed out."
        else
            return "* " .. target.chara:getNameOrYou() .. " recovered " .. amount .. " HP!"
        end
    end
end

function LightHealItem:playLightBattleUseSound(user, target)
    if self.swallow_sound then
        Game.battle.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound(self.use_sound)
        end)
    else
        Assets.stopAndPlaySound(self.use_sound)
    end
end

return LightHealItem