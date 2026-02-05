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
        -- Load warp script
        local warpName = warp:sub(1, -5)
        local requirePath = path .. "/" .. warpName
        package.loaded[requirePath] = nil

        local warpData = require(requirePath)
        local warpID = warpData.id or warpData.name or warpName
        local warpTo = warpData.name or warpName
        local warpSetName = self:binifyString(warpTo)
        local resultWarp = warpName

        if warpData.id then
            resultWarp = warpID .. "/".. warpTo
        else
            resultWarp = warpTo
        end

        if warpData.warp then
            resultWarp = warpData.warp
        end

        if warpData.loadbin then
            resultWarp = warpData.loadbin
        end

        local binWarpData = {result = resultWarp, mod = warpData.mod or "dpr_main"}

        -- print("r = " .. binWarpData.result .. "\nm = " .. binWarpData.mod)

        local loadWarp = true
        if warpData.load then
            loadWarp = warpData:load()
        end

        if loadWarp ~= false then
            print("Loading warp \"" .. warpName .. "\" as \"" .. warpSetName .. "\"")
            if binWarpData then
                loadedWarps[warpSetName] = binWarpData
            end

            if warpData.variants then
                local finalString = ""
                for _,rawID in pairs(warpData.variants) do
                    id = self:binifyString(rawID)

                    -- print("id = " .. id .. "\nr = " .. binWarpData.result .. "\nm = " .. binWarpData.mod)
                    
                    loadedWarps[id] = binWarpData
                    finalString = finalString .. "\"" .. id .. "\", "
                end
                
                -- Remove last "," for debugging
                finalString = string.sub(finalString,1,-3)
                
                print("loaded warp variants " .. finalString)
            end
        end
    end

    return loadedWarps
end

return self