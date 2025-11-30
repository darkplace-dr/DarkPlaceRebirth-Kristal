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
        local warpSetName = self:binifyString(warpID)
        local warpTo = warpData.warp or warpName
        local resultWarpID = warpName

        if warpData.id then
            resultWarpID = warpID .. "/".. warpTo
        else
            resultWarpID = warpTo
        end

        local binWarpData = {result = resultWarpID, mod = warpData.mod or "dpr_main"}

        print("Loading warp \"" .. warpName .. "\" as \"" .. warpSetName .. "\"")

        loadedWarps[warpSetName] = binWarpData

        if warpData.variants then
            local finalString = ""
            for _,id in pairs(warpData.variants) do
                id = self:binifyString(id)
                loadedWarps[id] = binWarpData
                finalString = finalString .. "\"" .. id .. "\", "
            end
            
            -- Remove last ","
            finalString = string.sub(finalString,1,-3)
            
            print("loaded warp variants " .. finalString)
        end
    end

    return loadedWarps
end

return self