local spell, super = Class("pacify", true)

function spell:onCast(user, target)
    if target.tired then
        target:spare(true)
        
        if Kristal.getLibConfig("engine-fixes", "old_spells") == nil and Game.chapter > 1 or Kristal.getLibConfig("engine-fixes", "old_spells") == false then
            Assets.playSound("spell_pacify")

            local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
            local z_count = 0
            local z_parent = target.parent
            Game.battle.timer:every(1/15, function()
                z_count = z_count + 1
                local z = SpareZ(z_count * -40, pacify_x, pacify_y)
                z.layer = BATTLE_LAYERS["above_battlers"]
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
end

return spell