Utils.hook(Registry.getSpell("dual_heal"), "onLightBattleCast", function(orig, self, user, target)
    Game.battle.timer:script(function(wait)
        Assets.playSound("spellcast", 1, 0.9)
        wait(14/30)
        Assets.playSound("power")
    end)
    for _,battler in ipairs(target) do
        battler:heal(user.chara:getStat("magic") * 5.5)
    end
end)