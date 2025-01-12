Utils.hook(Registry.getSpell("heal_prayer"), "onLightBattleStart", function(orig, self, user, target)
    Game.battle.timer:script(function(wait)
        Assets.playSound("spellcast")
        wait(10/30)
        Assets.playSound("power")
    end)
    local amount = math.ceil(user.chara:getStat("magic") * 1.7)
    local maxed = target:heal(amount)
    local heal_text
    if target.chara.you and maxed then
        heal_text = "* Your HP was maxed out."
    elseif maxed then
        heal_text = "* " .. target.chara:getNameOrYou() .. "'s HP was maxed out."
    else
        heal_text = "* " .. target.chara:getNameOrYou() .. " recovered " .. amount .. " HP!"
    end
    Game.battle:battleText(self:getLightBattleCastMessage(user, target) .. "\n" .. heal_text)
    Game.battle:finishActionBy(user)
end)