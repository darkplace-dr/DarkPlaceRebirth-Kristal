local item, super = Class("thornring", true)

function item:convertToLightEquip(chara)
    return "mg/thorn"
end

function item:onLightBattleUpdate(battler)
    super.onBattleUpdate(self, battler)
end

return item