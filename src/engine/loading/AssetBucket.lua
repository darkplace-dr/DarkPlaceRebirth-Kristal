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
    self.texture_ids = {}
    self.exact_sprite_groups = {}
    self.sprite_frames_for = {}
    self.dispatched_tasks = {}
    self.pending_tasks = 0
    self.completion_callbacks = {}
    self.generation = 0
    self.state = AssetBucket.State.UNLOADED
    self.assets_total = 0
    self.assets_loaded = 0
    self.load_stats = nil
    self.last_load_stats = nil
end

function AssetBucket:unload()
    self.generation = self.generation + 1
    for asset_type, assets in pairs(self.loaded_assets) do
        local loader = AssetLoaders.get(asset_type)
        for _, asset in pairs(assets) do
            loader:release(asset)
        end
    end
    Assets.queued_tasks[self.bucket_id] = {}
    self.loaded_assets = {}
    self.texture_ids = {}
    self.exact_sprite_groups = {}
    self.sprite_frames_for = {}
    self.dispatched_tasks = {}
    self.pending_tasks = 0
    self.completion_callbacks = {}
    self.state = AssetBucket.State.UNLOADED
    self.assets_total = 0
    self.assets_loaded = 0
    self.load_stats = nil
end

---@param paths string[]?
---@param after function?
function AssetBucket:startLoading(paths, after)
    assert(self.state == AssetBucket.State.UNLOADED, "Can't load a bucket that's already loaded")
    local started_at = love.timer.getTime()
    self.generation = self.generation + 1
    self.state = AssetBucket.State.LOADING
    self.paths = paths or self.paths
    self.loaded_assets = {}
    self.texture_ids = {}
    self.exact_sprite_groups = {}
    self.sprite_frames_for = {}
    self.dispatched_tasks = {}
    self.pending_tasks = 0
    self.completion_callbacks = {}
    self.assets_total = 0
    self.assets_loaded = 0
    Assets.queued_tasks[self.bucket_id] = {}
    if after then table.insert(self.completion_callbacks, after) end
    for _, asset_search_path in ipairs(self.paths) do
        for asset_type, loader in AssetLoaders.iterLoaders() do
            for _, subfolder in ipairs(loader.valid_subfolders or error(TableUtils.dump(loader))) do
                local files = FileSystemUtils.getFilesRecursive(asset_search_path .. "/" .. subfolder)
                table.sort(files)
                for i, subpath in ipairs(files) do
                    local filepath = FilePath(asset_search_path .. "/" .. subfolder, subpath)
                    if TableUtils.contains(loader.valid_extensions, string.lower(filepath.extension)) then
                        loader:beginLoad(filepath, Assets.getQueue(self.bucket_id, asset_type))
                    end
                end
            end
        end
    end
    for asset_type, _ in pairs(Assets.queued_tasks[self.bucket_id]) do
        self.assets_total = self.assets_total + TableUtils.getKeyCount(Assets.getQueue(self.bucket_id, asset_type))
    end
    for group_id, task in pairs(Assets.getQueue(self.bucket_id, "sprite")) do
        for exact_id in pairs(task.file_positions) do
            self.exact_sprite_groups[exact_id] = group_id
        end
    end
    self.load_stats = {
        bucket_id = self.bucket_id,
        started_at = started_at,
        discovery_time = love.timer.getTime() - started_at,
        worker_decode_time = 0,
        worker_tasks = 0,
        worker_heaps = {},
        synchronous_decode_time = 0,
        synchronous_tasks = 0,
        apply_time = 0,
        assets_total = self.assets_total,
    }
end

---@param callback function
function AssetBucket:onComplete(callback)
    if self.state == AssetBucket.State.LOADED then
        callback()
    else
        assert(self.state == AssetBucket.State.LOADING, "Can't await an unloaded bucket")
        table.insert(self.completion_callbacks, callback)
    end
end

---@param limit integer
---@return integer dispatched
function AssetBucket:dispatchTasks(limit)
    if self.state ~= AssetBucket.State.LOADING or limit <= 0 then return 0 end
    local dispatched = 0
    for asset_type, queue in pairs(Assets.queued_tasks[self.bucket_id] or {}) do
        self.dispatched_tasks[asset_type] = self.dispatched_tasks[asset_type] or {}
        for asset_id, task in pairs(queue) do
            if not self.dispatched_tasks[asset_type][asset_id] then
                Assets.asset_load_in_channel:push({
                    bucket_id = self.bucket_id,
                    generation = self.generation,
                    asset_type = asset_type,
                    asset_id = asset_id,
                    task = task,
                })
                self.dispatched_tasks[asset_type][asset_id] = true
                self.pending_tasks = self.pending_tasks + 1
                dispatched = dispatched + 1
                if dispatched >= limit then return dispatched end
            end
        end
    end
    return dispatched
end

---@param asset_type string
---@param asset_id string
---@param success boolean
---@param result any
---@param decode_time number?
---@param worker_id integer?
---@param worker_heap_kb number?
function AssetBucket:receiveTask(asset_type, asset_id, success, result, decode_time, worker_id, worker_heap_kb)
    self.pending_tasks = math.max(0, self.pending_tasks - 1)
    if self.dispatched_tasks[asset_type] then
        self.dispatched_tasks[asset_type][asset_id] = nil
    end

    local loader = AssetLoaders.get(asset_type)
    local queue = Assets.getQueue(self.bucket_id, asset_type)
    if self.load_stats then
        self.load_stats.worker_decode_time = self.load_stats.worker_decode_time + (decode_time or 0)
        self.load_stats.worker_tasks = self.load_stats.worker_tasks + 1
        if worker_id and worker_heap_kb then
            self.load_stats.worker_heaps[worker_id] = worker_heap_kb
        end
    end
    if not success then
        error(string.format("Failed to load %s/%s/%s:\n%s",
            self.bucket_id, asset_type, asset_id, tostring(result)))
    elseif not queue[asset_id] then
        -- asset gotten synchronously
        loader:releaseOutput(result)
    else
        self:applyResult(asset_type, asset_id, result)
    end
end

---@param asset_type string
---@param asset_id string
---@param result any
function AssetBucket:applyResult(asset_type, asset_id, result)
    local loader = AssetLoaders.get(asset_type)
    local apply_started_at = love.timer.getTime()
    local final = loader:apply(asset_id, result)
    if self.load_stats then
        self.load_stats.apply_time = self.load_stats.apply_time + (love.timer.getTime() - apply_started_at)
    end
    self:ensureLoader(asset_type)
    self.loaded_assets[asset_type][asset_id] = final
    Assets.getQueue(self.bucket_id, asset_type)[asset_id] = nil
    self.assets_loaded = self.assets_loaded + 1

    if asset_type == "sprite" then
        for exact_id, texture in pairs(final.exact_textures) do
            self.texture_ids[texture] = exact_id
        end
        for frame, exact_id in pairs(final.frame_ids) do
            self.sprite_frames_for[exact_id] = { asset_id, frame }
        end
        for frame, texture in pairs(final.textures) do
            self.texture_ids[texture] = self.texture_ids[texture] or (asset_id .. "_" .. frame)
        end
    end
    return final
end

---@param exact_id string
---@return boolean found
function AssetBucket:hasExactSprite(exact_id)
    return self.state ~= AssetBucket.State.UNLOADED
        and self.exact_sprite_groups[exact_id] ~= nil
end

---@param exact_id string
---@return love.Image? texture
---@return love.ImageData? data
function AssetBucket:getExactSprite(exact_id)
    local group_id = self.exact_sprite_groups[exact_id]
    if not group_id then return nil end
    local group = self:get("sprite", group_id)
    return group.exact_textures[exact_id], group.exact_data[exact_id]
end

---@param exact_id string
---@return string? group_id
---@return integer? frame
function AssetBucket:getFramesForExactSprite(exact_id)
    local frames_for = self.sprite_frames_for[exact_id]
    if frames_for then return frames_for[1], frames_for[2] end
    return nil, nil
end

function AssetBucket:finishIfReady()
    if self.state ~= AssetBucket.State.LOADING
        or self.pending_tasks > 0
        or self.assets_loaded < self.assets_total then return false end

    self.state = AssetBucket.State.LOADED
    local stats = self.load_stats
    if stats then
        stats.total_time = love.timer.getTime() - stats.started_at
        stats.pipeline_time = stats.total_time - stats.discovery_time
        stats.assets_loaded = self.assets_loaded
        stats.worker_count = Assets.asset_load_worker_count or 1
        stats.in_flight_limit = Assets.asset_load_in_flight_limit or 64
        stats.worker_heap_kb = 0
        for _, heap_kb in pairs(stats.worker_heaps) do
            stats.worker_heap_kb = stats.worker_heap_kb + heap_kb
        end
        self.last_load_stats = stats
        print(string.format(
            "[AssetLoader] %s: %d assets in %.3fs (discovery %.3fs, pipeline %.3fs, decode CPU %.3fs/%d tasks on %d workers, worker heap %.1f MB, apply %.3fs, synchronous %.3fs/%d tasks)",
            self.bucket_id, stats.assets_loaded, stats.total_time,
            stats.discovery_time, stats.pipeline_time,
            stats.worker_decode_time, stats.worker_tasks, stats.worker_count,
            stats.worker_heap_kb / 1024,
            stats.apply_time, stats.synchronous_decode_time, stats.synchronous_tasks
        ))
    end
    self.load_stats = nil
    local callbacks = self.completion_callbacks
    self.completion_callbacks = {}
    for _, callback in ipairs(callbacks) do callback() end
    return true
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
            final = self:applyResult(asset_type, asset_id, result)
        end, debug.traceback)
        if not ok then error(({ msg = string.format("While loading %s %s:\n%s", asset_type, asset_id, traceback) }).msg) end
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
