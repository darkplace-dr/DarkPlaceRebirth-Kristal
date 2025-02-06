local lib = {}
Registry.registerGlobal("PauseLib", lib)
PauseLib = lib

function PauseLib:init()
    self.paused = false
    Utils.hook(Kristal, "callEvent", function (orig, f, ...)
        if not self.paused then
            return orig(f,...)
        end
        if Utils.startsWith(f, "onKey") then
            return Kristal.libCall(self.info.id, f, ...)
        end
        return orig(f,...)
    end)
end

function PauseLib:setPaused(new)
    if self.paused == new then return end
    if new then
        self.paused = true
        Kristal.callEvent("onPause")
        if not self.paused then return end -- Allow suppressing pauses
        ---@type Music[]
        self.paused_music = Music.getPlaying()
        for _, mus in pairs(self.paused_music) do
            mus:pause()
        end
        self.overlay = Kristal.Stage:addChild(PauseOverlay())
    else
        self.paused = false
        for _, mus in pairs(self.paused_music) do
            mus:resume()
        end
        self.overlay:remove()
        self.overlay = nil
    end
end

function PauseLib:onKeyPressed(key)
    if self.paused then
        self.overlay:onKeyPressed(key)
    elseif Input.is("pause", key) then
        self:setPaused(true)
    end
end

function PauseLib:unload()
    self:setPaused(false)
end

return lib