return {
    
    tl = function(cutscene, event)
        cutscene:text("* Tina and Lilly.")
    end,

    nm = function(cutscene, event)
        cutscene:text("* Natalie and Matt.")
    end,

    be = function(cutscene, event)
        cutscene:text("* Queen Bowsuki and Empress Kernel.")
    end,

    mb = function(cutscene, event)
        cutscene:text("* Mae and Boey.")
    end,

    eye = function(cutscene, event)
        cutscene:text("* I love the eye that goes by many names.")

    end,

    ms = function(cutscene, event)
        cutscene:text("* Michael and Sayori.")
    end,

    fa = function(cutscene, event)
        cutscene:text("* Feldspar and Amber.")
    end,

    unknown = function(cutscene, event)
        cutscene:text("* Love for all the unknown that died and were forgotten.")
        if Game:getFlag("tl_lt_check_1") and not Game:getFlag("tl_lt_check_2") then
            cutscene:text("* ...")
            local itemcheck = Game.inventory:addItem("jackpot_jab")
            if itemcheck then
                Game:setFlag("tl_lt_check_2", true)
                cutscene:text("* One of the tree leaves is folded.")
                cutscene:text("* There is a badge in that leaf.")
                cutscene:text("* A memory from another hero.")
                cutscene:text("* Their technique should come in handy.")
                if Game:getFlag("tl_chestsearch2") then
                    Game:setFlag("tl_chestsearch3", true)
                end
                if Game:getFlag("tl_chestsearch1") then
                    Game:setFlag("tl_chestsearch2", true)
                end
                Game:setFlag("tl_chestsearch1", true)
            else
                cutscene:text("* No, there is nothing of note.")
            end
        end
        Game:setFlag("tl_lt_check_1", true)
    end,


    explain = function(cutscene, event)
        cutscene:text("* These trees are symbols of special bonds. Loving couples itch their names into the wood.")
        cutscene:text("* Every time the moon will rise, the quantum maiden will bring the trees to a different world.")
        cutscene:text("* Throughout all the worlds, thier love will remain and everyone can be happy for them.")
    end
}