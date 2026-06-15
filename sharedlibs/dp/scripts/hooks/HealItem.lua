local HealItem, super = HookSystem.hookScript(HealItem)

function HealItem:getBattleHealAmountModified(id, healer)
    local amount = super.getBattleHealAmountModified(self, id, healer)
    
    if healer.id == "jamm" and Game:getFlag("jamm_skill_1") then
        amount = math.floor(amount * 1.15)
    end
    
    if healer.id == "jamm" and Game:getFlag("jamm_skill_14") and self.jamm_modified then
        amount = math.floor(amount * 0.5)
    end
    
    return amount
end

function HealItem:onBattleUse(user, target)
    if user.chara.id == "jamm" and Game:getFlag("jamm_skill_14") and self:getTarget() == "ally" then
        self.target = "party"
        target = Game.battle.party
        self.jamm_modified = true
    end
    super.onBattleUse(self, user, target)
end

return HealItem
