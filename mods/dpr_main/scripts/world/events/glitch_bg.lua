local Glitch_Bg, super = Class(Event)
function Glitch_Bg:init(data)
    local map = Game.world.map
    map.onEnter = Utils.override(map.onEnter, function(orig, ...)
        orig(...)
        map.white_glows = Game.world:spawnObject(white_glows(), "objects_bg")
    end)
    super.init(self, data)
end
return Glitch_Bg