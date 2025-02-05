local item, super = Class("s_poison", true)

function item:getLightBattleText(user, target)
    return "* "..target.chara:getNameOrYou().." administered "..self:getUseName().."."
end

function item:onLightBattleUse(user, target)
    target:heal(self.battle_heal_amount, false)
    self:battleUseSound(user, target)

    if target.poison_effect_timer then
        Game.battle.timer:cancel(target.poison_effect_timer)
    end

    local poison_left = self.battle_poison_amount
    target.poison_effect_timer = Game.battle.timer:every(10/30, function()
        if poison_left == 0 then
            return false
        end
        if target.chara:getHealth() > 1 then
            target.chara:setHealth(target.chara:getHealth() - 1)
            poison_left = poison_left - 1
        else
            poison_left = 0
            return false
        end
    end)
    Game.battle:battleText(self:getLightBattleText(user, target).."\n"..Utils.sub(self:getLightBattleHealingText(user, target, self.battle_heal_amount), 1, -2).."?"
    .."\n* "..target.chara:getNameOrYou().." "..(select(2, target.chara:getNameOrYou()) and "are" or "is").." poisoned.")
end

function item:battleUseSound(user, target)
    Game.battle.timer:script(function(wait)
        Assets.stopAndPlaySound("swallow")
        wait(0.4)
        Assets.stopAndPlaySound("power")
        Assets.stopAndPlaySound("hurt")
    end)
end

return item