return {
	room = function(cutscene, event)
		local zenore = Game.world:getCharacter("zenore")
		local ceroba = cutscene:getCharacter("ceroba")
		local ddelta = cutscene:getCharacter("ddelta")
		cutscene:text("* Oh hi "..Game.party[1]:getName().."...", "neutral", "zenore")
		cutscene:text("* My room is being worked on so I can't give you my quest...", "neutral", "zenore")
		cutscene:text("* So what do you want to talk about?", "neutral", "zenore")
		local topic = cutscene:choicer({"You?", "Thoughts", "why are you here", "Nothing"})
		if topic == 1 then
			if ceroba then
				cutscene:text("* Oh, uh... I know your most likely not MY Ceroba but...", "unhappy_side_look", "zenore")
				cutscene:text("* Just know Kanako is doing okay!", "neutral", "zenore")
			elseif ddelta then
				cutscene:text("* Oh, uh hi Ddelta...", "unhappy_side_look", "zenore")
				cutscene:text("* OH remember that one time the [color:red]SOUL[color:reset] swapped our souls and", "neutral_wink", "zenore")
				cutscene:text("* almost got you to kill a poor vessel... good times!", "neutral_wink", "zenore")
				cutscene:text("* WHAT DO YOU MEAN 'GOOD TIMES'!", "helpme", "ddelta")
			else
				cutscene:text("* Oh, uh... I dont really have much to talk about...", "unhappy_side_look", "zenore")
			end
		elseif topic == 2 then
			cutscene:text("* Hmmm... what do I think about this place?", "neutral", "zenore")
			cutscene:text("* Its... cool! i find it really interesting!", "neutral", "zenore")
		elseif topic == 3 then
			cutscene:text("* Why am I here?", "annoyed_closed_eyes", "zenore")
			cutscene:text("* I... was traveling worlds...", "neutral", "zenore")
			cutscene:text("* When I found it here!", "neutral", "zenore")
			cutscene:text("* Its a cool place here lots to explore!", "neutral", "zenore")
		else
			cutscene:text("* Alright then... see ya", "neutral", "zenore")
		end
	end,
}
