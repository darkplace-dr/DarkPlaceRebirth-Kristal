return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    auch = function(cutscene, battler, enemy)
        cutscene:battlerText(battler, "auch")
    end,

    ---@param cutscene BattleCutscene
    negotiate = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Ralsei tries to negotiate\nwith Len.")

        -- Ralsei text
        cutscene:text("* I know this looks bad but....", "small_smile_side", "ralsei")
        cutscene:text("* There has to be a better way of handling this", "neutral", "ralsei")

        if cutscene:getCharacter("susie") then
            -- Ralsei text, if he's in the party
            cutscene:text("* Yeah,[wait:5] dude,[wait:5] we don't have to fight", "nervous", "susie")
            cutscene:battlerText(battler, "And lower my guard?[wait:5] after what YOU did to those darkners?\nyeah no i pass")
        else
            cutscene:battlerText(battler, "YOU are no better than them,[wait:5] you could have done anything to stop them...\nbut you didn't")
            cutscene:battlerText(battler, "So don't tell me this isn't how I\nshould handle this!")
        end
    end,
    ---@param cutscene BattleCutscene
    ---@param battler EnemyBattler
    pacify = function(cutscene, battler, enemy)
        cutscene:battlerText(battler, "soo.. tired...")
        cutscene:battlerText(battler, "I just...[wait:5] i just need...")
    end,
    ---@param cutscene BattleCutscene
    ---@param battler EnemyBattler
    dies = function(cutscene, battler, enemy)
        cutscene:battlerText(battler, "Agh...")
        cutscene:battlerText(battler, "...don't think you won just yet")
        cutscene:battlerText(battler, "i might be dying...[wait:5] but i can still stop this")
        cutscene:battlerText(battler, "I just...[wait:5] i just need...")
        cutscene:battlerText(battler, "CONSOLE: \"Game:setFlag(\"Dess_Mode\", false)")
        Game:setFlag("Dess_Mode", false)
        cutscene:battlerText(battler, "...")
        cutscene:battlerText(battler, "[shake:2]...haha")
        cutscene:battlerText(battler, "[shake:5]...HAHAHAHA")
        cutscene:battlerText(battler, "...")
        cutscene:battlerText(battler, "...you shouldn't have released me from my chains")
        battler:onDefeatFatal()
    end,
    ---@param cutscene BattleCutscene
    ---@param battler EnemyBattler
    frozen = function(cutscene, battler, enemy)
        cutscene:battlerText(battler, "...why is it soo cold?")
        cutscene:battlerText(battler, "...i can't...think...")
        cutscene:battlerText(battler, "I just...[wait:5] i just...")
        battler:addTired(9999)
    end,
}