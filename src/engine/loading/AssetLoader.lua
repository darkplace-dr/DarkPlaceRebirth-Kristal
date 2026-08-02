---@class AssetLoader<TAssetType, TTask, TTaskResult> : Class
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : AssetLoader
local AssetLoader, super = Class(nil, "AssetLoader")

---@param valid_subfolders string[]
---@param valid_extensions string[]
function AssetLoader:init(valid_subfolders, valid_extensions)
    self.valid_subfolders = valid_subfolders
    self.valid_extensions = valid_extensions
end

---@param file FilePath
---@param queue table<string, TTask>
function AssetLoader:beginLoad(file, queue) end

---@param asset_id string
---@param task TTask
---@return TTaskResult
function AssetLoader:load(asset_id, task)
    error(ClassUtils.getClassName(self) .. " has not overriden load!")
end

---@param asset_id string
---@param output TTaskResult
---@return TAssetType
function AssetLoader:apply(asset_id, output)
    error(ClassUtils.getClassName(self) .. " has not overriden apply!")
end

---@param asset TAssetType
function AssetLoader:release(asset) end

---@param output TTaskResult
function AssetLoader:releaseOutput(output) end

---@param object love.Object?
function AssetLoader:releaseObject(object)
    if not object or not object.release then return end
    if object.isDestroyed and object:isDestroyed() then return end
    object:release()
end

---@protected
function AssetLoader:logDebug(message) end

---@protected
function AssetLoader:logError(message)
    if Kristal.Console then
        Kristal.Console:error(message)
    else
        print("[ERROR] " .. message)
    end
end

---@protected
function AssetLoader:logWarn(message)
    if Kristal.Console then
        Kristal.Console:warn(message)
    else
        print("[WARNING] " .. message)
    end
end

return AssetLoader
