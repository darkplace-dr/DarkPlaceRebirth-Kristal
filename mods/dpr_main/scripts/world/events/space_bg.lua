local Space_Bg, super = Class(Event)
function Space_Bg:init(data)
    local map = Game.world.map
    function map:onEnter()
        Game.world:spawnObject(SpaceBG(), "objects_bg")

    end
    super.init(self, data)
end
return Space_Bg