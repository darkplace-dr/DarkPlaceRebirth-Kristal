local PluginLoader = {
    plugin_scripts = {},
    script_chunks = {}
}
local self = PluginLoader
function PluginLoader.addScriptChunk(mod_id, path, chunk)
    if self.script_chunks[mod_id] == nil then self.script_chunks[mod_id] = {} end
    self.script_chunks[mod_id][path] = chunk
end

---@return fun(): table?, boolean?, table?
function PluginLoader.iterPlugins(active_only)
    local index = 0
    local all_mods = Kristal.Mods.getMods()
    return function()
        repeat
            index = index + 1
            if index > #all_mods then return nil end
            if all_mods[index].plugin then
                if Kristal.Config["plugins/enabled_plugins"][all_mods[index].id] or (active_only ~= true) then
                    return all_mods[index],
                        Kristal.Config["plugins/enabled_plugins"][all_mods[index].id],
                        Kristal.PluginLoader.plugin_scripts[all_mods[index].id] or {}
                end
            end
        until index > #all_mods
    end
end

function PluginLoader.pluginCall(f, ...)
    local result = {}
    for _,_,plugin in Kristal.PluginLoader.iterPlugins(true) do
        if plugin[f] then
            local plugin_results = {plugin[f](plugin, ...)}
            if(#plugin_results > 0) then
                result = plugin_results
            end
        end
    end
    return Utils.unpack(result)
end

function PluginLoader.checkActive(ignorelist)
    ignorelist = ignorelist or {}
    local banned_plugins = {}
    for plugin in self.iterPlugins(true) do
        local key = plugin.id
        for _, ignoretest in ipairs(ignorelist) do
            if key == ignoretest then goto continue end
        end
        local plugin = Kristal.Mods.getMod(key)
        table.insert(banned_plugins, plugin)
        ::continue::
    end
    return (#banned_plugins > 0), banned_plugins
end

return PluginLoader