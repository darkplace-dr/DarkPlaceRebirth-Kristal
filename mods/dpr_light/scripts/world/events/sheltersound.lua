local ShelterSound, super = Class(Event)

function ShelterSound:init(data)
    super.init(self, data)
end

function ShelterSound:onAddToStage()
    self.sound = Assets.playSound("smile", 0, 0.15)
    self.sound:setLooping(true)
end

function ShelterSound:update()
    local player = Game.world.player
    local _, py = player:getRelativePos(0, 0)
    local volume = 1
    local volume2 = 0
    if py >= 840 then
        volume = MathUtils.clamp(1 - ((py - 1240) / 800), 0, 1)
        volume2 = MathUtils.clamp(0 + ((py - 2200) / 300), 0, 1)
    end
    if Game.world.music:getVolume() ~= volume then
        Game.world.music:setVolume(volume)
    end
    if self.sound:getVolume() ~= volume2 then
        self.sound:setVolume(volume2)
    end
end

function ShelterSound:onRemoveFromStage()
    Assets.stopSound("smile")
end

return ShelterSound