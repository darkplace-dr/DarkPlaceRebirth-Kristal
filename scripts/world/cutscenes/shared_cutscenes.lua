return {

    test = function(cutscene)
        Assets.playSound("jump")
    end,

    test_2 = function(cutscene)
	cutscene:text("Allan please add details")
    end,
    greyarea = function(cutscene)
        Game:setFlag("greyarea_exit_to", {Game.world.map.id, Game.world.player.x, Game.world.player.y})
        cutscene:after(function()
            Game.world:loadMap("greyarea", "entry")
        end)
    end,
}
