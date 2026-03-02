
---@class SpriteAssetLoader : AssetLoader<love.Image[], SpriteAssetLoader.Task, SpriteAssetLoader.TaskResult>
---
---@field protected image_extensions string[]
---
---@field protected mario_texture love.Image
---
local SpriteAssetLoader, super = Class(AssetLoader, "SpriteAssetLoader")

---@class SpriteAssetLoader.FramePath
---@field frame integer
---@field path string

---@class SpriteAssetLoader.Task
---@field frames SpriteAssetLoader.FramePath[]

---@class SpriteAssetLoader.TaskResult
---@field texture_data love.ImageData[]
---@field texture_paths string[]

---@param valid_subfolders string[]
---@param valid_extensions string[]
function SpriteAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)

    self.image_extensions = valid_extensions

    -- Mario mode support
    if love.graphics and love.filesystem.getInfo("mario.png") and Kristal.Args["mario-mode"] then
        self.mario_texture = love.graphics.newImage("mario.png")
    end
end

function SpriteAssetLoader:beginLoad(file, queue)
    -- Split an asset id like `"idle_01"` into `"idle", "01"`
    local identifier_split = StringUtils.split(file.identifier, "_")
    local split_frame = (#identifier_split > 1 and ( tonumber(identifier_split[#identifier_split]) and table.remove(identifier_split, #identifier_split))) or nil
    local identifier = table.concat(identifier_split, "_")

    -- Sprite frames and metadata all form the same asset, so the task table is modified
    local task = queue[identifier] or { frames = {} }

    -- If the filename has a frame separator, convert it to a number
    local frame_index = tonumber(split_frame)

    if split_frame then
        assert(frame_index, string.format("Invalid frame separator '%s', expected number", split_frame))
        assert(frame_index > 0, string.format("Frame index must begin at 1 (%s)", file.relative_path))
    end

    -- All textures are frame 1 of the sprite unless otherwise specified
    frame_index = frame_index or 1
    
    for i = #task.frames, 1, -1 do
        if task.frames[i].frame == frame_index then
            table.remove(task.frames, i)
        end
    end

    table.insert(task.frames, {
        frame = frame_index,
        path = file.full_path
    })

    if queue[identifier] == nil then
        queue[identifier] = task

        self:logDebug(string.format("Queued load for sprite '%s'", identifier))
    end
end

function SpriteAssetLoader:load(asset_id, task)
    ---@type SpriteAssetLoader.TaskResult
    local result = {
        texture_data = {},
        texture_paths = {},
    }

    -- Load frame image data (images themselves cannot be loaded on a separate thread)
    for _, frame_data in ipairs(task.frames) do
        assert(result.texture_data[frame_data.frame] == nil, string.format("Duplicate frame index %d on %s", frame_data.frame, asset_id))

        local image_data = love.image.newImageData(frame_data.path)

        result.texture_data[frame_data.frame] = image_data
        result.texture_paths[frame_data.frame] = frame_data.path
    end

    assert(#result.texture_data == #task.frames, string.format("Unexpected gap between frame indexes for '%s'", asset_id))

    self:logDebug(string.format(
        "Loaded %d frame(s) for sprite '%s'",
        #task.frames, asset_id
    ))

    return result
end

function SpriteAssetLoader:apply(asset_id, output)
    local textures = {}
    local texture_data = {}

    -- Now on the main thread, create textures from the loaded data
    for i, data in ipairs(output.texture_data) do
        local texture = love.graphics.newImage(data)

        if self.mario_texture == nil then
            textures[i] = texture
        else
            textures[i] = self:generateMario(texture)
        end

        texture_data[i] = data
    end

    -- Build the final sprite
    return textures -- Sprite(asset_id, textures, output.meta, texture_data, output.texture_paths)
end

--- Mario mode image creation
---@internal
---@param texture love.Image
---@return love.Image
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
    return love.graphics.newImage(new_mario_data)
end

return SpriteAssetLoader
