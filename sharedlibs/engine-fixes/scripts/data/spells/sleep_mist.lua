local spell, super = Class("sleep_mist", true)

function spell:onCast(user, target)
    local count = 0
    for _,enemy in ipairs(target) do
        if enemy.done_state == nil then
            local success = enemy.tired

            if success then
                enemy.done_state = "PACIFIED"
            end

            local parent = enemy.parent
            Game.battle.timer:after(10/30 * count, function()
                Assets.playSound("ghostappear")
                if success then
                    Assets.playSound("spell_pacify")
                end

                local x, y = enemy:getRelativePos(enemy.width/2, enemy.height/2)

                local effect = SleepMistEffect(x, y, success)
                effect.layer = BATTLE_LAYERS["above_battlers"]
                parent:addChild(effect)

                if success then
                    local w, h = 150, 100
                    Game.battle.timer:every(3/30, function()
                        local snowflake = IceSpellEffect(x - (w/2) + Utils.random(w), y - (h/2) + Utils.random(h))
                        snowflake:setScale(0.5)
                        snowflake.rotation_speed = Utils.random(5)
                        snowflake.layer = BATTLE_LAYERS["above_battlers"] - 1
                        parent:addChild(snowflake)
                    end, 8)

                    Game.battle.timer:after(12/30, function()
                        enemy:spare(true)
                    end)
                end
            end)

            count = count + 1
        end
    end
end

return spell