return {
    lazul = function(cutscene)

        local quest = Game:getFlag("package_quest")
        if quest and quest == 1 then
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* In case you forgot the bin code:[wait:5] The code is [color:yellow]00000000[color:blue].")
            cutscene:hideNametag()
        elseif quest and quest > 1 then
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* We have nothing to discuss.")
            cutscene:hideNametag()
        else
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* Hey![wait:5] Do you happen to be a delivery man?[wait:5] No?[wait:5] Good.")
            Game.inventory:addItem("diamond_package")
            Assets.playSound("item")
            cutscene:hideNametag()
            cutscene:text("* You were given the [color:yellow]Diamond Package[color:reset].")
            cutscene:text("* The [color:yellow]Diamond Package[color:reset] was added to your [color:yellow]KEY ITEMs[color:reset].")
            cutscene:showNametag("Lazul", {color = {0, 0, 1, 1}})
            cutscene:text("[color:blue]* Take that to the man who lives in the Warp Hub.[wait:5] Use the Warp Bin.")
            cutscene:text("[color:blue]* The code is [color:yellow]00000000[color:blue].")
            cutscene:hideNametag()
            Game:getQuest("a_special_delivery"):unlock()
            Game:setFlag("package_quest", 1)
        end
    end,
}