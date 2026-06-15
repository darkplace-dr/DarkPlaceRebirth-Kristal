---@class MusicAssetLoader : AssetLoader<MusicAssetLoader.MusicResult, MusicAssetLoader.MusicTask, MusicAssetLoader.MusicResult>
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : MusicAssetLoader
local MusicAssetLoader, super = Class(AssetLoader, "MusicAssetLoader"), AssetLoader


---@class MusicAssetLoader.MusicTask
---@field music_path string?
---@field music_loop_path string?
---@field metadata_path string?

---@class MusicAssetLoader.MusicResult
---@field path string
---@field loop_path string?
---@field metadata MusicAssetLoader.MusicMetadata

---@class MusicAssetLoader.MusicMetadata
---@field loop_start integer
---@field pitch number
---@field volume number


---@param metadata_extensions string[]
function MusicAssetLoader:init(valid_subfolders, valid_extensions, metadata_extensions)
    super.init(self, valid_subfolders, TableUtils.mergeMany(valid_extensions, metadata_extensions))
    self.music_extensions = valid_extensions
    self.metadata_extensions = metadata_extensions
end

function MusicAssetLoader:beginLoad(file, queue)
    local loop, identifier = StringUtils.endsWith(file.identifier, ".loop")
    if loop and TableUtils.contains(self.metadata_extensions, file.extension) then
        error(string.format("Music metadata file must not end in `.loop` (%s)", file.full_path))
    end
    queue[identifier] = queue[identifier] or {}
    if TableUtils.contains(self.metadata_extensions, file.extension) then
        queue[file.identifier].metadata_path = file.full_path
    elseif loop then
        queue[identifier].music_loop_path = file.full_path
    else
        if loop then
            queue[identifier].music_loop_path = file.full_path
        else
            queue[identifier].music_path = file.full_path
        end
    end
end

function MusicAssetLoader:load(asset_id, task)
    if not task.music_path then
        error(string.format("Metadata found for %s, but no actual audio file", asset_id))
    end
    ---@type MusicAssetLoader.MusicMetadata
    local metadata = {}
    -- Load metadata if we have any
    if task.metadata_path then
        metadata = JSON.decode(love.filesystem.read(task.metadata_path))
    end
    -- Fill default values
    metadata.loop_start = metadata.loop_start or 0
    metadata.pitch = metadata.pitch or 1
    metadata.volume = metadata.volume or 1
    return {
        path = task.music_path,
        loop_path = task.music_loop_path,
        metadata = metadata,
    }
end

function MusicAssetLoader:apply(asset_id, output)
    return output
end

return MusicAssetLoader
