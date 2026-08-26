return {
    use_console = function(cutscene, event)
		local world = Game.world.kikky_world
		cutscene:text("* (Looks like a game console.)")
		cutscene:text("* (Play it?)")
        local c = cutscene:choicer({"Yes", "No"})
        if c == 1 then
            cutscene:detachFollowers()
			Game.world.player.active = false
			world.gameplay_active = true
			world.player:setColor(COLORS.white)
			--world.ui.instruction_active = true
		end
    end,
}
