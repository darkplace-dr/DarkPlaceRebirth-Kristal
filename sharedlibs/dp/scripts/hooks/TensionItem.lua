local TensionItem, super = HookSystem.hookScript(TensionItem)

function TensionItem:onWorldUse(target)
    if Game:getFlag("tension_storage", false) then
        Game:giveTension(self:getTensionAmount())
        Assets.playSound("cardrive", 0.8, 1.4)
        return true
    end
    return super.onWorldUse(self, target)
end

return TensionItem