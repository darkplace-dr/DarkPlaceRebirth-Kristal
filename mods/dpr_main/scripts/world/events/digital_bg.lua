local DigitalBG, super = Class(Event)
function DigitalBG:init(data)
    local map = Game.world.map
    map.onEnter = Utils.override(map.onEnter, function(orig, ...)
        orig(...)
        map.digital_bg = Game.world:spawnObject(DigitalMatrixBG(), "objects_bg")
    end)
    super.init(self, data)
end
return DigitalBG