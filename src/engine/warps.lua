local Warps = {}
local self = Warps
self.warpsPath = "data/warps"

function self:setWarpsFolder(path)
    self.warpsPath = path
end

function self:binifyString(str)
    str = str:upper()
    str = str:sub(1, 8)
    return str
end

function self:loadWarps(path)
    path = path or self.warpsPath
    local loadedWarps = {}

    for _,warp in pairs(love.filesystem.getDirectoryItems(path)) do
        local warpName = warp:sub(1, -5)
        local requirePath = path .. "/" .. warpName
        package.loaded[requirePath] = nil
        local warpData = require(requirePath)
        local warpID = warpData.id or warpName

        local warpSetName = warpData.id or warpName
        warpSetName = self:binifyString(warpSetName)
        local warpTo = warpData.warp or warpName
        local binWarpData = {result = (warpID .. "/".. warpTo), mod = warpData.mod or "dpr_main"}
        print("Loading warp " .. warpName .. "= {result: " .. binWarpData.result .. ", mod: " .. binWarpData.mod .. "}")
        loadedWarps[warpSetName] = binWarpData
        if warpData.variants then
            for _,id in pairs(warpData.variants) do
                id = self:binifyString(id)
                loadedWarps[id] = binWarpData
                print("Loaded warp variant \"" .. id .. "\"")
            end
        end
    end

    return loadedWarps
end

return self