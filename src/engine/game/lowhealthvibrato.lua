local LowHealthVibrato, super = Class(Object)

function LowHealthVibrato:init()
    super.init(self)
    
    self.time = 0
end

function LowHealthVibrato:update()
    super.update(self)
    
    self.time = self.time + (DT * 2)
    
    if Kristal.Config["musicDistort"] then
        local upcount = 0
        
        for k,v in ipairs(Game.party) do
            if v.health > 0 then upcount = upcount + 1 end
            if v.health > v:getStat("health")/4 then
                for _, music in ipairs(Music.getPlaying()) do   -- TODO: Figure out how to restore old values
                    music:setVolume(1)
                    music:setPitch(1)
                end
                return
            end
        end
    
        local hpRatio = 1 / 4
        
        if upcount < 2 then
            hpRatio = 1/8
        end
        
        local lowHealth = 1 - hpRatio

        local heartbeatSpeed = 2 + (lowHealth * 6)

        local heartbeat =
            (math.sin(self.time * heartbeatSpeed) + 1) / 2

        local pulse =
            1.0 - (heartbeat * lowHealth * 0.25)

        local wobbleSpeed = 1 + (lowHealth * 4)

        local wobble =
            math.sin(self.time * wobbleSpeed) *
            (0.01 + lowHealth * 0.1)

        local pitch = 1.0 + wobble

        pitch = pitch - (lowHealth * 0.08)
    
        for _, music in ipairs(Music.getPlaying()) do
            music:setVolume(MUSIC_VOLUME * (music.current and MUSIC_VOLUMES[music.current] or 1) * music.builtin_volume * pulse)
            music:setPitch(math.max((music.current and MUSIC_PITCHES[music.current] or 1) * music.builtin_pitch * pitch, 0.01))
        end
    end
end

return LowHealthVibrato
