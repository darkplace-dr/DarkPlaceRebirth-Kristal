local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:onPause()
    if Game.tutorial then
        PauseLib.paused = false
        Assets.playSound("ui_cant_select",1.5)
    end
end

function lib:save(data)
    if not MagicalGlassLib then
        data.magical_glass = self.mg_data_preserve
    end
end

function lib:load(data)
    if not MagicalGlassLib then
        self.mg_data_preserve = data.magical_glass
    end
end

return lib