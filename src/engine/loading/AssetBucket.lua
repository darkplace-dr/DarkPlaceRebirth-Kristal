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
    self.assets_total = 0
    self.assets_loaded = 0
end

function AssetBucket:unload()
    Assets.queued_tasks[self.bucket_id] = {}
    self.loaded_assets = {}
    self.state = AssetBucket.State.UNLOADED
    self.assets_total = 0
    self.assets_loaded = 0
end

---@param paths string[]?
function AssetBucket:startLoading(paths)
    assert(self.state == AssetBucket.State.UNLOADED, "Can't load a bucket that's already loaded")
    self.state = AssetBucket.State.LOADING
    self.paths = paths or self.paths
    for _, asset_search_path in ipairs(self.paths) do
        for asset_type, loader in AssetLoaders.iterLoaders() do
            for _, subfolder in ipairs(loader.valid_subfolders or error(TableUtils.dump(loader))) do
                local files = FileSystemUtils.getFilesRecursive(asset_search_path .. "/" .. subfolder)
                table.sort(files)
                for i, subpath in ipairs(files) do
                    local full_path = asset_search_path .. "/" .. subfolder .. "/" .. subpath
                    local filepath = FilePath(asset_search_path .. "/" .. subfolder, full_path)
                    if TableUtils.contains(loader.valid_extensions, filepath.extension) then
                        loader:beginLoad(filepath, Assets.getQueue(self.bucket_id, asset_type))
                    end
                end
            end
        end
    end
    for asset_type, _ in pairs(Assets.queued_tasks[self.bucket_id]) do
        
        self.assets_total = self.assets_total + TableUtils.getKeyCount(Assets.getQueue(self.bucket_id, asset_type))
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

--[[

for k, v in pairs(Assets.getQueue("engine", "sprite")) do
    Assets.getFrames(k)
end

--]]

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
        local result, final
        local ok, traceback = xpcall(function()
            result = loader:load(asset_id, Assets.getQueue(self.bucket_id, asset_type)[asset_id])
            final = loader:apply(asset_id, result)
        end, debug.traceback)
        if not ok then error({ msg = string.format("While loading %s %s:\n%s", asset_type, asset_id, traceback) }) end
        self.loaded_assets[asset_type][asset_id] = final
        Assets.getQueue(self.bucket_id, asset_type)[asset_id] = nil
        self.assets_loaded = self.assets_loaded + 1
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
