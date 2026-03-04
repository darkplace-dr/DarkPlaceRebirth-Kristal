---@class FontAssetLoader : AssetLoader< Partial< FontAssetLoader.Font >, FontAssetLoader.Task, FontAssetLoader.Output >
--- An asset loader that just forwards the full path of the asset. Yeah it's pretty brilliant
---@overload fun(valid_subfolders: string[], valid_extensions: string[]) : FontAssetLoader
local FontAssetLoader, super = Class(AssetLoader, "PathAssetLoader"), AssetLoader

---@alias FontAssetLoader.Output FontAssetLoader.OutputWithFontData | FontAssetLoader.OutputWithImageData | FontAssetLoader.OutputWithBMFont

---@class FontAssetLoader.OutputWithFontData
---@field font_data love.FileData
---@field settings FontAssetLoader.FontSettings?

---@class FontAssetLoader.OutputWithImageData
---@field image_data love.ImageData
---@field settings FontAssetLoader.FontSettings?

---@class FontAssetLoader.OutputWithBMFont
---@field bmfont_path string
---@field settings FontAssetLoader.FontSettings?

---@alias FontAssetLoader.FontSettings Assets.font_settings

---@alias FontAssetLoader.Task FontAssetLoader.TaskWithFontData | FontAssetLoader.TaskWithImageData | FontAssetLoader.TaskWithBMFont

---@class FontAssetLoader.TaskWithFontData
---@field font_path string
---@field settings_path string?

---@class FontAssetLoader.TaskWithImageData
---@field image_path string
---@field settings_path string?

---@class FontAssetLoader.TaskWithBMFont
---@field bmfont_path string
---@field settings_path string?

---@class FontAssetLoader.Font
---@field image_data love.ImageData
---@field default integer
---@field font love.Font
---@field settings FontAssetLoader.FontSettings

function FontAssetLoader:init(valid_subfolders, valid_extensions)
    super.init(self, valid_subfolders, valid_extensions)
end

function FontAssetLoader:beginLoad(file, queue)
    local task = queue[file.identifier] or {} ---@as FontAssetLoader.Task
    queue[file.identifier] = task

    if file.extension == "json" then
        task.settings_path = file.full_path
    elseif file.extension == "ttf" then
        task.font_path = file.full_path
    elseif file.extension == "png" then
        task.image_path = file.full_path
    elseif file.extension == "fnt" then
        task.bmfont_path = file.full_path
    end
end

function FontAssetLoader:load(asset_id, task)
    local output = {} ---@as FontAssetLoader.Output
    if task.bmfont_path then
        output.bmfont_path = task.bmfont_path
    end
    if task.font_path then
        output.font_data = love.filesystem.newFileData(task.font_path)
    end
    if task.image_path then
        output.image_data = love.image.newImageData(task.image_path)
    end
    if task.settings_path then
        output.settings = JSON.decode(love.filesystem.read(task.settings_path))
    end
    return output
end

function FontAssetLoader:apply(asset_id, output)
    if not output.font_data then
        -- output.settings.autoScale = output.settings.autoScale ~= false
    end
    local default = output.settings and output.settings.defaultSize or 12;
    ---@type Partial<FontAssetLoader.Font>
    local font = {
        image_data = output.image_data;
        default = default;
        settings = output.settings;
        font = (
            nil
            or (output.bmfont_path and love.graphics.newFont(output.bmfont_path))
            or (output.image_data and love.graphics.newImageFont(output.image_data, assert(output.settings.glyphs) ))
        );
        font_data = output.font_data;
    } 
    return font
end

return FontAssetLoader
