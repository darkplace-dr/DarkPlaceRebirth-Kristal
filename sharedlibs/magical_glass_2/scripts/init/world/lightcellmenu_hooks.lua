Utils.hook(LightCellMenu, "runCall", function(orig, self, call)
    if type(call[2]) == "function" then
        Game.world:closeMenu()
        call[2]()
    elseif type(call[2]) == "string" then
        Assets.playSound("phone", 0.7)
        Game.world.menu:closeBox()
        Game.world.menu.state = "TEXT"
        Game.world:setCellFlag(call[2], Game.world:getCellFlag(call[2], -1) + 1)
        Game.world:startCutscene(call[2])
    end
end)