local PathAssetLoader = require("src.engine.loading.loaders.PathAssetLoader")
local FontAssetLoader = require("src.engine.loading.loaders.FontAssetLoader")
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
    AssetLoaders.register("sound", SoundAssetLoader({ "sounds" }, { "wav", "ogg" }))
    AssetLoaders.register("music", PathAssetLoader({ "music" }, { 
        -- AUDIO FORMATS
        "mp3", "wav", "ogg",
        -- TRACKER FORMATS
        "mod", "s3m", "xm", "it", "669", "amf", "ams", "dbm", "dmf", "dsm", "far",
        "mdl", "med", "mtm", "okt", "ptm", "stm", "ult", "umx", "mt2", "psm",
        -- COMPRESSED TRACKER FORMATS
        "mdz", "s3z", "xmz", "itz", "zip",
        "mdr", "s3r", "xmr", "itr", "rar",
        "mdgz", "s3gz", "xmgz", "itgz", "gz"
    }))
    AssetLoaders.register("video", PathAssetLoader({ "videos" }, { "ogg", "ogv" }))
    AssetLoaders.register("font", FontAssetLoader({ "fonts" }, { "png", "ttf", "json", "fnt" }))
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
