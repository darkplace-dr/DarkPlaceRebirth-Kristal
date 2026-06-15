local LightCellMenu, super = HookSystem.hookScript(LightCellMenu)

function LightCellMenu:runCall(call)
    super.runCall(self, call)

    if Mod.libs["magical-glass"].rearrange_cell_calls then
        table.insert(Game.world.calls, 1, TableUtils.removeValue(Game.world.calls, call))
    end
end

return LightCellMenu