local TensionItem, super = HookSystem.hookScript(TensionItem)

function TensionItem:onBattleSelect(user, target)
    if Game.battle.light then
        self.tension_given = Game:giveTension(self:getTensionAmount())

        local sound = Assets.newSound("cardrive")
        sound:setPitch(1.4)
        sound:setVolume(0.8)
        sound:play()
    else
        super.onBattleSelect(self, user, target)
    end
end

return TensionItem