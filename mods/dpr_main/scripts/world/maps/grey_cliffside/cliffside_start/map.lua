local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
    if Game.tutorial then

        Game.world.music:stop()
        local darknessoverlay = DarknessOverlay()
        darknessoverlay.layer = 1
        Game.world:addChild(darknessoverlay)
        local lightsource = LightSource(15, 28, 60)
        lightsource.alpha = 0.25
        Game.world.player:addChild(lightsource)        

        Game.world.player:setSprite("fell")


        Game.world.map.darknessoverlay = darknessoverlay
        Game.world.map.lightsource = lightsource
    end

    Game.world:spawnObject(white_glows(), "objects_bg")

end

return map