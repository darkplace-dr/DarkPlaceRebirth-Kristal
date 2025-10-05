return function(cutscene)
    local whirlwind = Whirlwind(120, 0)
    Game.battle:addChild(whirlwind)

    local kris = Game.battle:getPartyBattler('kris')
    local susie = Game.battle:getPartyBattler('susie')
    local ralsei = Game.battle:getPartyBattler('ralsei')
    local cutscene_ended = false

    kris.sprite.anim_speed = 0
    susie.sprite.anim_speed = 0
    ralsei.sprite.anim_speed = 0

    Game.battle.timer:during(1, function()
        kris.sprite.anim_speed = kris.sprite.anim_speed + DT
        susie.sprite.anim_speed = susie.sprite.anim_speed + DT
        ralsei.sprite.anim_speed = ralsei.sprite.anim_speed + DT
    end, function()
        kris.sprite.anim_speed = 1
        susie.sprite.anim_speed = 1
        ralsei.sprite.anim_speed = 1
    end)

    Game.battle.timer:after(1 + 50/30, function()
        Game.battle.timer:during(1, function()
            kris.sprite.anim_speed = kris.sprite.anim_speed - DT
            susie.sprite.anim_speed = susie.sprite.anim_speed - DT
            ralsei.sprite.anim_speed = ralsei.sprite.anim_speed - DT
        end, function()
            if not cutscene_ended then
                kris.sprite.anim_speed = 0
                susie.sprite.anim_speed = 0
                ralsei.sprite.anim_speed = 0
            end
        end)
    end)

    cutscene:wait(cutscene:text("* Everyone spun masterfully!\n* It's a whirlwind...!"))
    cutscene:wait(whirlwind:getEndCallback())

    cutscene_ended = true

    kris.sprite.anim_speed = 1
    susie.sprite.anim_speed = 1
    ralsei.sprite.anim_speed = 1

    for _, enemy in ipairs(Game.battle.enemies) do
        enemy:spare()
    end
end