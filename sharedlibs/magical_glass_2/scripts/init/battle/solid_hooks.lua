Utils.hook(Solid, "init", function(orig, self, filled, x, y, width, height)
    orig(self, filled, x, y, width, height)
    if filled and MagicalGlass:getCurrentBattleSystem() == "undertale" then
        self.color = {Game.battle.arena:getColor()}
    end
end)