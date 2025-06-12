return {
	starbits = function(cutscene, event)
		local arlee = cutscene:getCharacter('arlee')
        cutscene:setSpeaker(arlee)
        cutscene:showNametag("arlee")
        cutscene:text("* hello and good morning friend!")
        cutscene:hideNametag()
		if Game:getFlag("star_bits", 0) == 0 then
            cutscene:showNametag("arlee")
			cutscene:text("* oh! it seems you havent got any starbits yet")
			cutscene:text("* very sad indeed but do not worry im not in a hurry")
			cutscene:text("* once you find one tell me okay?")
            cutscene:hideNametag()
        end
        if Game:getFlag("star_bits", 0) == 1 and Game:getFlag("star_prog", 0) == 0  then
            cutscene:showNametag("arlee")
            cutscene:text("* hey hey! you found one!")
            cutscene:text("* thank you very much mister miss!")
            cutscene:text("* now you only need 4 more!")
            cutscene:text("* see you around!")
            Game:getQuest("stargazer"):addProgress(1)
            Game:setFlag("star_prog", 1)
            cutscene:hideNametag()
		end
	end,

    computer = function(cutscene, event)
        if event.interact_count == 1 and Game:getFlag("star_bits", 0) == 0 then
        cutscene:text("* * On the computer's desktop you see a folder called 'SMWBT'.")
        cutscene:text("* You decide not to mess with it.")
        end
        if event.interact_count == 2 and Game:getFlag("star_bits", 0) == 0 then
        cutscene:text("* You look under the desk.")
        cutscene:text("* The light almost blinds you.")
        cutscene:text("* You catch it.")
        local item = "starbit"
        if Game.inventory:addItem(item) then
                    if item.id == "starbit" then
                        Assets.stopAndPlaySound("egg")
                    else
                        Assets.stopAndPlaySound("item")
                    end
                    cutscene:text("* You got a StarBit.")
                    Game:setFlag("star_bits", 1)
            end
        elseif event.interact_count >= 2 or Game:getFlag("star_bits", 0) == 1 then
        cutscene:text("* Nothing to see anymore.")
        end
    end
}