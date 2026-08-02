---@class SpriteAssetLoader : AssetLoader<SpriteAssetLoader.Result, SpriteAssetLoader.Task, SpriteAssetLoader.TaskResult>
---
---@field protected image_extensions string[]
---
---@field protected mario_texture love.Image
---
local SpriteAssetLoader, super = Class(AssetLoader, "SpriteAssetLoader")

---@class SpriteAssetLoader.FramePath
---@field exact_id string
---@field frame integer
---@field path string

---@class SpriteAssetLoader.Task
---@field files SpriteAssetLoader.FramePath[]
---@field file_positions table<string, integer>
---@field frame_ids table<integer, string>
---@field max_frame integer

---@class SpriteAssetLoader.TaskResult
---@field exact_data table<string, love.ImageData>
---@field texture_paths table<string, string>
---@field frame_ids table<integer, string>
---@field max_frame integer

---@class SpriteAssetLoader.Result
---@field textures love.Image[]
---@field data love.ImageData[]
---@field exact_textures table<string, love.Image>
---@field exact_data table<string, love.ImageData>
---@field frame_ids table<integer, string>
---@field gap_textures love.Image[]

---@param valid_subfolders string[]
---@param valid_extensions string[]
function SpriteAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)

    self.image_extensions = valid_extensions

    self.placeholder = love.image.newImageData(1,1)

    -- Mario mode support
    if love.graphics and Kristal and love.filesystem.getInfo("mario.png") and Kristal.Args["mario-mode"] then
        self.mario_texture = love.graphics.newImage("mario.png")
    end
end

---@return string identifier
---@return integer? split_frame
function SpriteAssetLoader.splitIdentifier(full_identifier)
    local identifier, split_frame = full_identifier, 1
    local _, _, reverse_frame, reverse_identifier = string.find(string.reverse(full_identifier), "^(%d+)_?([^/]+.*)")
    if reverse_frame and reverse_identifier then
        identifier = string.reverse(reverse_identifier)
        split_frame = math.floor(assert(tonumber(string.reverse(reverse_frame))))
    end
    if split_frame < 1 then
        return full_identifier
    end
    return identifier, split_frame
end

function SpriteAssetLoader:beginLoad(file, queue)
    -- Split an asset id like `"idle_01"` into `"idle", "01"`
    local identifier, split_frame = SpriteAssetLoader.splitIdentifier(file.identifier)

    -- Sprites/frames form one task. Exact file IDs are\
    -- retained separately because multiple names can normalize to one frame so we need both.
    local task = queue[identifier] or {
        files = {},
        file_positions = {},
        frame_ids = {},
        max_frame = 0,
    }

    -- If the filename has a frame separator, convert it to a number
    local frame_index = tonumber(split_frame)

    if split_frame then
        assert(frame_index, string.format("Invalid frame separator '%s', expected number", split_frame))
        if (frame_index <= 0) then
            self:logWarn(string.format("Frame index must begin at 1 (%s)", file.relative_path))
        end
    end

    -- All textures are frame 1 of the sprite unless otherwise specified
    frame_index = frame_index or 1
    
    local frame = {
        exact_id = file.identifier,
        frame = frame_index,
        path = file.full_path
    }
    local position = task.file_positions[file.identifier]
    if position then
        task.files[position] = frame
    else
        table.insert(task.files, frame)
        task.file_positions[file.identifier] = #task.files
    end
    -- make sure that last-file-wins is still a thing even though we bucketmaxxing
    task.frame_ids[frame_index] = file.identifier
    task.max_frame = math.max(task.max_frame, frame_index)

    if queue[identifier] == nil then
        queue[identifier] = task

        self:logDebug(string.format("Queued load for sprite '%s'", identifier))
    end
end

function SpriteAssetLoader:load(asset_id, task)
    ---@type SpriteAssetLoader.TaskResult
    local result = {
        exact_data = {},
        texture_paths = {},
        frame_ids = task.frame_ids,
        max_frame = task.max_frame,
    }

    -- Load frame image data (images themselves cannot be loaded on a separate thread)
    for _, frame_data in ipairs(task.files) do
        assert(result.exact_data[frame_data.exact_id] == nil,
            string.format("Duplicate exact sprite ID '%s' on %s", frame_data.exact_id, asset_id))

        local image_data = love.image.newImageData(frame_data.path)

        result.exact_data[frame_data.exact_id] = image_data
        result.texture_paths[frame_data.exact_id] = frame_data.path
    end

    self:logDebug(string.format(
        "Loaded %d file(s) for sprite group '%s'",
        #task.files, asset_id
    ))

    return result
end

function SpriteAssetLoader:apply(asset_id, output)
    local textures = {}
    local texture_datas = {}
    local exact_textures = {}
    local exact_data = {}
    local gap_textures = {}
    local had_gap = false

    for exact_id, source_data in pairs(output.exact_data) do
        local texture_data = source_data
        if self.mario_texture ~= nil then
            texture_data = self:generateMario(texture_data)
            self:releaseObject(source_data)
        end
        exact_data[exact_id] = texture_data
        exact_textures[exact_id] = love.graphics.newImage(texture_data)
    end

    for i = 1, output.max_frame do
        local exact_id = output.frame_ids[i]
        if exact_id then
            textures[i] = assert(exact_textures[exact_id])
            texture_datas[i] = assert(exact_data[exact_id])
        else
            had_gap = true
            local texture = love.graphics.newImage(self.placeholder)
            textures[i] = texture
            texture_datas[i] = self.placeholder
            table.insert(gap_textures, texture)
        end
    end

    if had_gap then
        self:logError(string.format("Unexpected gap between frame indexes for '%s'", asset_id))
    end

    return {
        textures = textures,
        data = texture_datas,
        exact_textures = exact_textures,
        exact_data = exact_data,
        frame_ids = output.frame_ids,
        gap_textures = gap_textures,
    }
end

function SpriteAssetLoader:release(asset)
    for _, texture in pairs(asset.exact_textures or {}) do
        self:releaseObject(texture)
    end
    for _, texture in pairs(asset.gap_textures or {}) do
        self:releaseObject(texture)
    end
    for _, data in pairs(asset.exact_data or {}) do
        if data ~= self.placeholder then self:releaseObject(data) end
    end
end

function SpriteAssetLoader:releaseOutput(output)
    for _, data in pairs(output.exact_data or {}) do
        if data ~= self.placeholder then self:releaseObject(data) end
    end
end

--- Mario mode image creation
---@internal
---@param texture love.ImageData
---@return love.ImageData
function SpriteAssetLoader:generateMario(texture)
    local target_width, target_height = texture:getWidth(), texture:getHeight()
    local mario_width, mario_height = self.mario_texture:getWidth(), self.mario_texture:getHeight()

    local new_mario = love.graphics.newCanvas(target_width, target_height)

    local scale_x, scale_y = target_width / mario_width, target_height / mario_height

    Draw.pushCanvas(new_mario)
        love.graphics.draw(self.mario_texture, 0, 0, 0, scale_x, scale_y)
    Draw.popCanvas()
    local new_mario_data = new_mario:newImageData()
    new_mario:release()
    return new_mario_data
end

return SpriteAssetLoader
