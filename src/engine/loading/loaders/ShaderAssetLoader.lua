---@class ShaderAssetLoader : AssetLoader<love.Shader, string, string>
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : ShaderAssetLoader
local ShaderAssetLoader, super = Class(AssetLoader, "ShaderAssetLoader"), AssetLoader

function ShaderAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)
end

function ShaderAssetLoader:beginLoad(file, queue)
    -- Pass the file path to the load thread
    queue[file.identifier] = file.full_path
end

function ShaderAssetLoader:load(asset_id, task)
    -- Simply load the text contents of the shader file to pass to the main thread
    local result = love.filesystem.read(task)

    return result
end

function ShaderAssetLoader:apply(asset_id, output)
    -- Finally, the shader can be created on the main thread
    return love.graphics.newShader(output)
end

return ShaderAssetLoader
