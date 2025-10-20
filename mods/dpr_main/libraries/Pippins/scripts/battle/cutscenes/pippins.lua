return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    cheat1 = function(cutscene)

        local enemy = Game.battle:getActiveEnemies()
        local pippins = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "pippins" end)

        -- Open textbox and wait for completion
        for _, battler in ipairs(Game.battle.party) do
            if battler.chara.id == "susie" then
                battler.dialogue_offset = {-80, 50}
            end
        end
        cutscene:text("* Susie drew 4 dots on all the dice! The enemies got TIRED!")
        cutscene:wait(0.1)
        for _,enemys in ipairs(enemy) do
            enemys:setTired(true)
            enemys:setAnimation("tired")
        end
        cutscene:battlerText("susie", "Who's the highroller\nnow, idiot!?", {right = true})
        for _,enemys in ipairs(enemy) do
            enemys.cheat = true
            enemys.cheatcount = 1
        end
    end,

    cheat2 = function(cutscene)
        local enemy = Game.battle:getActiveEnemies()
        local ralsei = cutscene:getCharacter("ralsei")
        cutscene:wait(0.5)
        if ralsei.sprite.anim == "battle/act" then
            ralsei:setAnimation("battle/act_end")
        end
        cutscene:text("* Susie got bored of cheating and drew a mustache on Ralsei!")
        Assets.playSound("magicmarker", 1.5)
        Game.battle:addChild(mustache2(ralsei.x - 25,ralsei.y - 92))
        cutscene:wait(1.3)
        for _,enemys in ipairs(enemy) do
            enemys.cheatcount = 2
        end
    end,

    cheat3 = function(cutscene)
        local enemy = Game.battle:getActiveEnemies()
        local kris = cutscene:getCharacter("kris")
        cutscene:wait(0.5)
        if kris.sprite.anim == "battle/act" then
            kris:setAnimation("battle/act_end")
        end
        cutscene:text("* Susie got bored of cheating and drew dead eyes on Kris!")
        Assets.playSound("magicmarker", 1.5)
        Game.battle:addChild(eye(kris.x - 25,kris.y - 74))
        cutscene:wait(1.3)
        for _,enemys in ipairs(enemy) do
            enemys.cheatcount = 3
        end
    end,

    cheat4 = function(cutscene)
        cutscene:text("* Susie is tired of cheating and doodling!")
    end,

    bribe = function(cutscene, battler, self)
        local enemy = Game.battle:getActiveEnemies()
        local ralsei = cutscene:getCharacter("ralsei")

        for _, battler in ipairs(Game.battle.party) do
            if battler.chara.id == "ralsei" then
                battler.dialogue_offset = {-40, 20}
            end
        end

        cutscene:text("* You and Ralsei used 80 TPs to BRIBE the enemy!")
        ralsei:setActSprite("party/ralsei/dark/battle/hurt", -13, -2)
        Assets.playSound("wing")
        ralsei:shake(4)
        cutscene:battlerText("ralsei", "It's, it's not a...", {right = true})

        for _,enemys in ipairs(enemy) do
            enemys.bribe = true
        end

        self:exitSpare()
        self:defeat("SPARED", false)
        self:onSpared()
	    self:remove()
    end,
}