---@class AssetLoaders
---@field loaders table<string, AssetLoader>
local AssetLoaders = {}

---@internal
function AssetLoaders.init()
    AssetLoaders.loaders = {}
    AssetLoaders.registerDefaults()
end

---@private
function AssetLoaders.registerDefaults()
    AssetLoaders.register("shader", ShaderAssetLoader({ "shaders" }, { "glsl" }))
    AssetLoaders.register("sprite", SpriteAssetLoader({ "sprites" }, { "png" }))
end

---@generic T : AssetLoader
---@param asset_type string
---@param loader T
---@return T loader
function AssetLoaders.register(asset_type, loader)
    AssetLoaders.loaders[asset_type] = loader
    return loader
end

function AssetLoaders.exists(asset_type)
    return AssetLoaders.loaders[asset_type] ~= nil
end

function AssetLoaders.get(asset_type)
    return AssetLoaders.loaders[asset_type] or error(string.format("Attempt to get missing loader for asset type '%s'", asset_type), 2)
end

return AssetLoaders
