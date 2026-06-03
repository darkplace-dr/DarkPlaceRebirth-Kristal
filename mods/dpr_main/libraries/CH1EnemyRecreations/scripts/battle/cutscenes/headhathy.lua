return {
    x_flirt = function(cutscene, battler, enemy)
        for _, enemy in ipairs(Game.battle.enemies) do
            enemy:addMercy(100)
        end

        --TODO: add the rest of the interactions for this ACT.
        cutscene:text("* You flirted with the enemies. [wait:5]\nIt worked![wait:5] (Susie did not \nhelp.)")
    end,
}