local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)

end

function map:update()
    super.update(self)
    local download = Game.world:getCharacter("download")

    if download then
        if download.x < 0 then
            download:setScale(-2, 2)
            download.x = 1
            download.physics.speed_x = 1
            download.x = 1
        elseif download.x > 145 then
            download:setScale(2, 2)
            download.x = 144
            download.physics.speed_x = -1
            download.x = 144
        end
    elseif Game:getFlag("badge_tutorial", false) then
        Game.world:spawnNPC("download", 50, 400)
        local download = Game.world:getCharacter("download")
            download.physics.speed_x = -1
    end

end

return map