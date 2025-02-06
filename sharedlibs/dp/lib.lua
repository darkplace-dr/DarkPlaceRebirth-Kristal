local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:onPause()
    if Game.tutorial then
        PauseLib.paused = false
        Assets.playSound("ui_cant_select",1.5)
    end
end

return lib