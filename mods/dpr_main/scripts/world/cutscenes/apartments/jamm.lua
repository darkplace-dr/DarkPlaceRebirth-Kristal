return {
	breaker_box	= function(cutscene, event)
		cutscene:text("* It's a breaker box.[wait:10]\n* For some reason,[wait:5] it's locked.")
	end,
	
	balcony_door = function(cutscene, event)
		cutscene:text("* The door to the balcony seems stuck.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* Yeah,[wait:5] sorry,[wait:5] I've been meaning to fix that...", "nervous", "jamm")
			cutscene:hideNametag()
		end
	end,
}