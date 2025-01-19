local spell, super = Class("red_buster", true)

function spell:onLightCast(user, target)
    user.delay_turn_end = true
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = (SCREEN_WIDTH/2), SCREEN_HEIGHT
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = RudeBusterBeam(true, x, y, tx, ty, function(pressed)
            local damage = self:getDamage(user, target, pressed)
            if pressed then
                Assets.playSound("scytheburst")
            end
            target:hurt(damage, user)
            Game.battle:finishAction()
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:getDamage(user, target, pressed)
    if Game:isLight() then
        local damage = math.ceil((user.chara:getStat("magic") * 2.25) + (user.chara:getStat("attack") * 4.25) - (target.defense * 1.625)) + 25
        if pressed then
            damage = damage + 10
        end
        return damage
    else
        return super.getDamage(self, user, target, pressed)
    end
end

return spell