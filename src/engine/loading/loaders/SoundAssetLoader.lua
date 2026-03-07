---@class SoundAssetLoader : AssetLoader<love.Source, string, love.SoundData>
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : SoundAssetLoader
local SoundAssetLoader, super = Class(AssetLoader, "ShaderAssetLoader"), AssetLoader

function SoundAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)
end

function SoundAssetLoader:beginLoad(file, queue)
    -- Pass the file path to the load thread
    queue[file.identifier] = file.full_path
end

function SoundAssetLoader:load(asset_id, task)
    -- Simply load the text contents of the shader file to pass to the main thread
    local result = love.sound.newSoundData(task)

    return result
end

function SoundAssetLoader:apply(asset_id, output)
    -- Finally, the shader can be created on the main thread
    return love.audio.newSource(output)
end

return SoundAssetLoader
