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
	
	stove = function(cutscene, event)
		cutscene:text("* It's a stove.[wait:10]\n* The quality on it is immaculate.")
	end,
	
	tv = function(cutscene, event)
		cutscene:text("* It's a small flatscreen TV.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* It's a humble little thing,[wait:5] yeah...", "nervous", "jamm")
			cutscene:text("* Money's been tight when I bought this thing,[wait:5] but Marcy seems to like it.", "side_smile", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	couch = function(cutscene, event)
		cutscene:text("* It's a small couch.\n* The cushons seem to be glued on.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...Long story.", "nervous", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	bathroom = function(cutscene, event)
		cutscene:text("* The door is locked.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...Sorry,[wait:5] the bathroom is currently undergoing remodeling.", "neutral", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	closet = function(cutscene, event)
		cutscene:text("* The door is locked.")
		if cutscene:getCharacter("jamm") then
			cutscene:showNametag("Jamm")
			cutscene:text("* ...No,[wait:5] you are not going to see my closet,[wait:5] okay?", "stern", "jamm")
			cutscene:hideNametag()
		end
	end,
	
	marcy_bed = function(cutscene, event)
	end,
	
	marcy_desk = function(cutscene, event)
	end,
	
	marcy_closet = function(cutscene, event)
	end,
	
	jamm_bed = function(cutscene, event)
	end,
	
	jamm_desk = function(cutscene, event)
	end,
	
	jamm_closet = function(cutscene, event)
	end,
}