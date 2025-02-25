local StarwalkerRoom, super = Class(Map)

function StarwalkerRoom:onEnter()
    super.onEnter(self)

    for i = 1, 6 do
        Game.world:spawnObject(LightFairy(80, 80), "objects_stars")
    end
	
    for i = 1, 6 do
        Game.world:spawnObject(LightFairy(80, 160), "objects_stars")
    end

    for i = 1, 6 do
        Game.world:spawnObject(LightFairy(240, 80), "objects_stars")
    end
	
    for i = 1, 6 do
        Game.world:spawnObject(LightFairy(240, 160), "objects_stars")
    end
end

return StarwalkerRoom