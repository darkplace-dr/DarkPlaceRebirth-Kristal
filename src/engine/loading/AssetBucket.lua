local FilePath = require("src.engine.loading.FilePath")
---@class AssetBucket : Class
---@field private loaded_assets table<string, table<string, any>>
---@field private paths string[]
---@field public state AssetBucket.State
---@overload fun(id: string, paths: string[]) : AssetBucket
local AssetBucket = Class(nil, "AssetBucket")

---@enum AssetBucket.State
AssetBucket.State = {
    UNLOADED = 0,
    LOADING = 1,
    LOADED = 2,
}

---@param paths string[]
function AssetBucket:init(id, paths)
    self.bucket_id = id
    self.paths = paths
    self.loaded_assets = {}
    self.state = AssetBucket.State.UNLOADED
end

function AssetBucket:unload()
    self.loaded_assets = {}
    self.state = AssetBucket.State.UNLOADED
end

---@param paths string[]?
function AssetBucket:startLoading(paths)
    assert(self.state == AssetBucket.State.UNLOADED, "Can't load a bucket that's already loaded")
    self.state = AssetBucket.State.LOADING
    self.paths = paths or self.paths
    for _, asset_search_path in ipairs(self.paths) do
        for asset_type, loader in pairs(AssetLoaders.loaders) do
            for _, subfolder in ipairs(loader.valid_subfolders) do
                for i, subpath in ipairs(FileSystemUtils.getFilesRecursive(asset_search_path .. "/" .. subfolder)) do
                    local full_path = asset_search_path .. "/" .. subfolder .. "/" .. subpath
                    local filepath = FilePath(asset_search_path .. "/" .. subfolder, full_path)
                    loader:beginLoad(filepath, Assets.getQueue(self.bucket_id, asset_type))
                end
            end
        end
    end
end


function AssetBucket:has(asset_type, asset_id)
    if self.state == AssetBucket.State.UNLOADED then
        return false
    end
    self:ensureLoader(asset_type)
    if self.loaded_assets[asset_type][asset_id] then
        return true
    end
    if Assets.getQueue(self.bucket_id, asset_type)[asset_id] then
        return true
    end
end

---@internal
---@param asset_type string
---@param asset_id string
function AssetBucket:get(asset_type, asset_id)
    if self.state == AssetBucket.State.UNLOADED then
        error(string.format("Attempt to get asset from bucket '%s' while it's unloaded", self.bucket_id), 2)
    end
    self:ensureLoader(asset_type)
    if self.loaded_assets[asset_type][asset_id] then
        return self.loaded_assets[asset_type][asset_id]
    elseif Assets.getQueue(self.bucket_id, asset_type)[asset_id] then
        local loader = AssetLoaders.get(asset_type)
        local result = loader:load(asset_id, Assets.getQueue(self.bucket_id, asset_type)[asset_id])
        local final = loader:apply(asset_id, result)
        self.loaded_assets[asset_type][asset_id] = final
        return final
    else
        error(string.format("Attempt to get missing asset of type '%s' with ID '%s'", asset_type, asset_id), 2)
    end
end

---@private
function AssetBucket:ensureLoader(asset_type)
    if not self.loaded_assets[asset_type] then
        self.loaded_assets[asset_type] = {}
    end
end

return AssetBucket
