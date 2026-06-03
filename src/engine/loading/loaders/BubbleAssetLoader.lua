---@class BubbleAssetLoader : AssetLoader<table, string, table>
--- An asset loader that just forwards the full path of the asset. Yeah it's pretty brilliant
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : PathAssetLoader
local PathAssetLoader, super = Class(AssetLoader, "PathAssetLoader"), AssetLoader

function PathAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)
end

function PathAssetLoader:beginLoad(file, queue)
    -- Pass the file path to the load thread
    queue[file.identifier] = file.full_path
end

function PathAssetLoader:load(asset_id, task)
    -- And pass the file path to the main thread.
    local output = JSON.decode(love.filesystem.read(task))
    return output
end

function PathAssetLoader:apply(asset_id, output)
    return output
end

return PathAssetLoader
