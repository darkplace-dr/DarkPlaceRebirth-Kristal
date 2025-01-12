Utils.hook(Registry.getSpell("pacify"), "onLightBattleCast", function(orig, self, user, target)
    if target.tired then
        target:spare(true)

        if Game.chapter > 1 then
            Assets.playSound("spell_pacify")

            local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
            local z_count = 0
            local z_parent = target.parent
            Game.battle.timer:every(1/15, function()
                z_count = z_count + 1
                local z = SpareZ(z_count * -40, pacify_x, pacify_y)
                z:setScale(1.5)
                z.layer = target.layer + 0.002
                z_parent:addChild(z)
            end, 8)
        end
    else
        local recolor = target:addFX(RecolorFX())
        Game.battle.timer:during(8/30, function()
            recolor.color = Utils.lerp(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
        end, function()
            Game.battle.timer:during(8/30, function()
                recolor.color = Utils.lerp(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
            end, function()
                target:removeFX(recolor)
            end)
        end)
    end
end)

Utils.hook(Registry.getSpell("pacify"), "getLightBattleCastMessage", function(orig, self, user, target)
    local message = Spell.getLightBattleCastMessage(self, user, target)
    if target.tired then
        return message
    elseif target.mercy < 100 then
        return message.."\n[wait:0.25s]* But the enemy wasn't [color:blue]TIRED[color:reset]..."
    else
        return message.."\n[wait:0.25s]* But the foe wasn't [color:blue]TIRED[color:reset]...[wait:0.25s]\n* Try [color:yellow]SPARING[color:reset]!"
    end
end)
