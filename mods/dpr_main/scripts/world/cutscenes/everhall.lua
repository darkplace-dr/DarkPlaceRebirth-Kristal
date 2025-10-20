---@type table<string,fun(cutscene:WorldCutscene, event?: Event|NPC)>
local everhall = {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
	entry = function(cutscene, event)
		cutscene:wait(cutscene:fadeOut(0.25))
		if (Game:getFlag("hallways", 0) >= 5) then
			cutscene:text("* You walk all the way back to where you were...")
		end
		cutscene:loadMap("floor2/dev/everhall", "leftmark")
		cutscene:wait(cutscene:fadeIn(0.25))
	end,
	
	exits = function(cutscene, event)
		cutscene:wait(cutscene:fadeOut(0.25))
		if (Game:getFlag("hallways", 0) >= 5) then
			cutscene:text("* You made it to room " .. Game:getFlag("hallways", 0) .. ".")
		end
		cutscene:loadMap("floor2/dev/everhall_entry", "hall_exit")
		cutscene:wait(cutscene:fadeIn(0.25))
	end,

	progress = function(cutscene, event)
		cutscene:wait(cutscene:fadeOut(0.25))
		Game:addFlag("hallways", 1)
		if (Game:getFlag("hallways", 0) < 20000) then
			cutscene:loadMap("floor2/dev/everhall", "leftmark")
		else
			cutscene:loadMap("floor2/dev/everhall_end", "entry")
		end
		cutscene:wait(cutscene:fadeIn(0.25))
	end,
}
return everhall
