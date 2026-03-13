---@class Assets
---
---@field loaded boolean
---
---@field data Assets.data
---
---@field frames_for table<string, {[1]: string, [2]: number}>
---@field texture_ids table<love.Image, string>
---@field sounds table<string, love.Source>
---@field sound_instances table<string, love.Source[]>
---@field quads table<string, love.Quad>
---
---@field saved_data table|nil
---
local Assets = {}
local self = Assets

---@class Assets.data
---@field texture table<string, love.Image>
---@field texture_data table<string, love.ImageData>
---@field frames table<string, love.Image[]>
---@field frame_ids table<string, string[]>
---@field fonts table<string, love.Font|{default: number, [number]: love.Font}>
---@field font_data table<string, love.Data>
---@field font_bmfont_data table<string, string>
---@field font_image_data table<string, love.ImageData>
---@field font_settings table<string, Assets.font_settings>
---@field sound_data table<string, love.SoundData>
---@field music table<string, string>
---@field shaders table<string, love.Shader>
---@field shader_paths table<string, string>
---@field videos table<string, string>
---@field bubble_settings table<string, table>

--- Settings for a font asset, paired with the actual font data as a .json file.
---@class Assets.font_settings
---@field defaultSize integer? # The default size of the font.
---@field autoScale boolean? # Whether to scale the default-sized font to fit requested sizes. This is true by default for image and BMFont fonts.
---@field glyphs string? # (Image fonts only) Characters in the font, in order from left to right.
---@field hinting love.HintingMode? # (TrueType fonts only) The hinting mode to load the font with.
---@field fallbacks Assets.font_settings.fallbacks[]? # Fallback fonts to use in case there are missing glyphs.

---@class Assets.font_settings.fallbacks
---@field font string # ID of the fallback font. It must be of the same font type as the base font.
---@field size number? # (TrueType fonts only) The default size of the fallback font.

Assets.saved_data = nil

---@internal
---@return any task
function Assets.getQueue(bucket_id, asset_type)
    if not self.queued_tasks[bucket_id] then
        self.queued_tasks[bucket_id] = {}
    end
    if not self.queued_tasks[bucket_id][asset_type] then
        self.queued_tasks[bucket_id][asset_type] = {}
    end
    return self.queued_tasks[bucket_id][asset_type]
end

function Assets.init()
    Assets.clear()
    AssetLoaders.init()
    self.queued_tasks = {}
    ---@type AssetBucket[]
    self.buckets = {
        AssetBucket("engine", { "assets" }),
        AssetBucket("project", { "assets" }),
    }
    self.getBucket("engine"):startLoading({ "assets" })
end

function Assets.getAssetCount()
    local asset_total = 0
    local asset_loaded = 0
    for _, bucket in pairs(self.buckets) do
        asset_loaded = asset_loaded + bucket.assets_loaded
        asset_total = asset_total + bucket.assets_total
    end
    return asset_loaded, asset_total
end

function Assets.clear()
    self.loaded = false
    self.data = {
        texture = {},
        texture_data = {},
        frame_ids = {},
        frames = {},
        fonts = {},
        font_data = {},
        font_bmfont_data = {},
        font_image_data = {},
        font_settings = {},
        sound_data = {},
        music = {},
        videos = {},
        bubbles = {},
        bubble_settings = {},
        shaders = {},
        shader_paths = {}
    }
    self.frames_for = {}
    self.texture_ids = {}
    self.sounds = {}
    self.sound_instances = {}
    self.quads = {}
end

---@param path string
---@return new_path string
function Assets.checkSpritesOverride(path)
    local split_path = Utils.splitFast(path, "/")
    if #split_path > 1 then
        if split_path[1] == "player" then
            table.insert(split_path, 2, Kristal.getSoulFacing())
            return table.concat(split_path, "/")
        end
    end
    return path
end

---@param data Assets.data
function Assets.loadData(data)
    TableUtils.merge(self.data, data, true)

    self.parseData(data)

    self.loaded = true
end

---@param asset_type string
---@param asset_id string
---@return any asset
function Assets.get(asset_type, asset_id)
    if not AssetLoaders.exists(asset_type) then
        error(string.format("Attempt to get unknown asset type '%s' with id '%s'", asset_type, asset_id), 2)
    end
    return Assets.internalGet(asset_type, asset_id, 2)
end

function Assets.tryGet(asset_type, asset_id)
    if not AssetLoaders.exists(asset_type) then
        error(string.format("Attempt to get unknown asset type '%s' with id '%s'", asset_type, asset_id), 2)
    end
    if Assets.internalHas(asset_type, asset_id) then
        return Assets.internalGet(asset_type, asset_id)
    end
end

--- Iterate over assets of a particular type.
---@param asset_type string
---@param id_prefix string?
---@return fun(): string
function Assets.iterate(asset_type, id_prefix)
    id_prefix = id_prefix or ""
    return coroutine.wrap(function()
        for _, bucket in ipairs(self.buckets) do
            for id in pairs(Assets.getQueue(bucket.bucket_id, asset_type)) do
                if StringUtils.startsWith(id, id_prefix) then
                    coroutine.yield(id)
                end
            end
            for id in pairs(bucket.loaded_assets[asset_type] or {}) do
                if StringUtils.startsWith(id, id_prefix) then
                    coroutine.yield(id)
                end
            end
        end
    end)
end

---@private
---@param asset_type string
---@param asset_id string
---@return any asset
function Assets.internalGet(asset_type, asset_id, error_level)
    for i = #self.buckets, 1, -1 do
        if self.buckets[i]:has(asset_type, asset_id) then
            return self.buckets[i]:get(asset_type, asset_id)
        end
    end
    local errstring = string.format("Attempt to get missing asset of type '%s' with ID '%s'", asset_type, asset_id)
    error(errstring, error_level)
end

---@private
---@param asset_type string
---@param asset_id string
---@return boolean found
function Assets.internalHas(asset_type, asset_id)
    for i = #self.buckets, 1, -1 do
        if self.buckets[i]:has(asset_type, asset_id) then
            return true
        end
    end
    return false
    
end

---@param bucket_id string
---@return AssetBucket bucket
function Assets.getBucket(bucket_id)
    for i = 1, #self.buckets do
        if self.buckets[i].bucket_id == bucket_id then
            return self.buckets[i]
        end
    end
    error(string.format("Attempt to get non-existent bucket '%s'", bucket_id))
end

function Assets.saveData()
    self.saved_data = {
        data = TableUtils.copy(self.data, true),
        frames_for = TableUtils.copy(self.frames_for, true),
        texture_ids = TableUtils.copy(self.texture_ids, true),
        sounds = TableUtils.copy(self.sounds, true),
    }
end

---@return boolean
function Assets.restoreData()
    if self.saved_data then
        Assets.clear()
        for k, v in pairs(self.saved_data) do
            self[k] = TableUtils.copy(v, true)
        end
        self.loaded = true
        return true
    else
        return false
    end
end

---@param data Assets.data
function Assets.parseData(data)
    -- thread can't create images, we do it here
    for key, image_data in pairs(data.texture_data) do
        self.data.texture[key] = love.graphics.newImage(image_data)
        self.texture_ids[self.data.texture[key]] = key
    end

    -- create frame tables with images
    for key, ids in pairs(data.frame_ids) do
        self.data.frames[key] = {}
        for i, id in pairs(ids) do
            self.data.frames[key][i] = self.data.texture[id]
            self.frames_for[id] = { key, i }
        end
    end

    -- create TTF fonts
    for key, file_data in pairs(data.font_data) do
        local default = data.font_settings[key] and data.font_settings[key].defaultSize or 12
        self.data.fonts[key] = { default = default }
    end
    -- create bmfont fonts
    for key, file_path in pairs(data.font_bmfont_data) do
        data.font_settings[key] = data.font_settings[key] or {}
        if data.font_settings[key].autoScale == nil then
            data.font_settings[key].autoScale = true
        end
        self.data.fonts[key] = love.graphics.newFont(file_path)
    end
    -- set up bmfont font fallbacks
    for key, _ in pairs(data.font_bmfont_data) do
        if data.font_settings[key].fallbacks then
            local fallbacks = {}
            for _, fallback in ipairs(data.font_settings[key].fallbacks) do
                local font = self.data.fonts[fallback.font]
                if type(font) == "table" or (self.data.font_settings[fallback.font] and self.data.font_settings[fallback.font].glyphs) then
                    error("Attempt to use TTF or image fallback on BMFont font: " .. key)
                else
                    table.insert(fallbacks, font)
                end
            end
            self.data.fonts[key]:setFallbacks(unpack(fallbacks))
        end
    end
    -- create image fonts
    for key, image_data in pairs(data.font_image_data) do
        local glyphs = data.font_settings[key] and data.font_settings[key].glyphs or ""
        data.font_settings[key] = data.font_settings[key] or {}
        if data.font_settings[key].autoScale == nil then
            data.font_settings[key].autoScale = true
        end
        self.data.fonts[key] = love.graphics.newImageFont(image_data, glyphs)
    end
    -- set up image font fallbacks
    for key, _ in pairs(data.font_image_data) do
        if data.font_settings[key].fallbacks then
            local fallbacks = {}
            for _, fallback in ipairs(data.font_settings[key].fallbacks) do
                local font = self.data.fonts[fallback.font]
                if type(font) == "table" or not (self.data.font_settings[fallback.font] and self.data.font_settings[fallback.font].glyphs) then
                    error("Attempt to use TTF or BMFont fallback on image font: " .. key)
                else
                    table.insert(fallbacks, font)
                end
            end
            self.data.fonts[key]:setFallbacks(unpack(fallbacks))
        end
    end

    -- may be a memory hog, we clone the existing source so we dont need the sound data anymore
    --self.data.sound_data = {}
end

function Assets.update()
    local sounds_to_remove = {}
    for key, sounds in pairs(self.sound_instances) do
        for _, sound in ipairs(sounds) do
            if not sound:isPlaying() then
                table.insert(sounds_to_remove, { key = key, value = sound })
            end
        end
    end
    for _, sound in ipairs(sounds_to_remove) do
        TableUtils.removeValue(self.sound_instances[sound.key], sound.value)
    end
    -- TODO: Make background loading happen on loadthread. Currently this can cause stutters when loading large assets
    local time = love.timer.getTime()
    for _,bucket in ipairs(self.buckets) do
        if bucket.state == AssetBucket.State.LOADING then
            for asset_type, queue in pairs(self.queued_tasks[bucket.bucket_id] or {}) do
                for asset_id in pairs(queue) do
                    bucket:get(asset_type, asset_id)
                    if (love.timer.getTime() - time) + love.timer.getDelta() > 0.5/30 then
                        if Kristal.Config["verboseLoader"] then
                            Kristal.Loader.message = string.format("%s/%s: %s", bucket.bucket_id, asset_type, asset_id)
                        end
                        Kristal.Overlay.setLoading(true)
                        return
                    end
                end
            end
            bucket.state = AssetBucket.State.LOADED
        end
    end
    Kristal.Loader.message = ""
    Kristal.Overlay.setLoading(false)
end

---@param path string
---@return table
function Assets.getBubbleData(path)
    return self.get("bubble", path)
end

---@return FontAssetLoader.Font
function Assets.getFontInfo(asset_id)
    return self.get("font", asset_id)
end

---@param path string
---@param size? number
---@return love.Font
function Assets.getFont(path, size)
    local font = self.getFontInfo(path)
    local font_cache = self.data.fonts[path] or {}
    self.data.fonts[path] = font_cache
    local settings = font.settings or {}
    if not font.font then
        if settings.autoScale then
            size = font.default
        else
            size = size or font.default
        end
        if not font_cache[size] then
            ---@diagnostic disable-next-line: param-type-mismatch
            font_cache[size] = love.graphics.newFont(font.font_data --[[@as string]], size, settings.hinting or "mono")

            if settings.fallbacks then
                local fallbacks = {}

                for _, fallback in ipairs(settings.fallbacks) do
                    local fb_font = self.get("font", fallback.font).settings

                    if type(fb_font) ~= "table" then
                        error("Attempt to use image or BMFont fallback on TTF font: " .. path)
                    else
                        local ratio = (fallback.size or fb_font.default) / font.default
                        table.insert(fallbacks, self.getFont(fallback.font, size * ratio))
                    end
                end

                font_cache[size]:setFallbacks(unpack(fallbacks))
            end
        end
        return font_cache[size]
    else
        return font.font
    end
end

---@param path string
function Assets.getFontData(path)
    return self.getFontInfo(path).settings or {}
end

---@param path string
---@param size? number
---@return number
function Assets.getFontScale(path, size)
    local data = self.data.font_settings[path]
    if data and data.autoScale then
        return (size or 1) / (data.defaultSize or 1)
    else
        return 1
    end
end

---@param path string
---@return love.Image
function Assets.getTexture(path)
    local identifier_split = StringUtils.split(path, "_")
    local identifier, split_frame = SpriteAssetLoader.splitIdentifier(path)
    local frames = self.getFramesOrTexture(identifier)
    if not frames then
        return
    end
    local texture = frames[split_frame or 1] or error(string.format("Out-of-bounds frame %s on sprite '%s'", split_frame, identifier))
    return texture
end

---@return boolean
function Assets.hasSprite(asset_id)
    return Assets.internalHas("sprite", asset_id)
end

Utils.hook(Assets, "getTexture", function (orig, path)
    return orig(Assets.checkSpritesOverride(path)) or orig(path)
end)

---@param path string
---@return love.ImageData
function Assets.getTextureData(path)
    local identifier_split = StringUtils.split(path, "_")
    local identifier, split_frame = SpriteAssetLoader.splitIdentifier(path)
    local frames = self.get("sprite", identifier).data
    local texture = frames[split_frame or 1] or error(string.format("Out-of-bounds frame %s on sprite '%s'", split_frame, identifier))
    return texture
end

---@param texture love.Image|string
---@return string
function Assets.getTextureID(texture)
    for bucket_n = #Assets.buckets, 1, -1 do
        for sprite_id, sprite in pairs(Assets.buckets[bucket_n].loaded_assets.sprite or {}) do
            for frame_n = 1, #sprite.textures do
                if texture == sprite.textures[frame_n] then
                    return sprite_id .. "_" .. frame_n
                end
            end
        end
    end
end

---@param path string
---@return love.Image[]
function Assets.getFrames(path)
    return self.getFramesOrTexture(path)
end

Utils.hook(Assets, "getFrames", function (orig, path)
    return orig(Assets.checkSpritesOverride(path)) or orig(path)
end)

---@param path string
---@return string[]
function Assets.getFrameIds(path)
    local sprite_length = #self.getFrames(path)
    local sprite_frame_ids = {}
    for i = 1, sprite_length do
        sprite_frame_ids[i] = path .. "_" .. i
    end
    return sprite_frame_ids
end

---@param texture string
---@return string texture, number frame
function Assets.getFramesFor(texture)
    local identifier, frame = SpriteAssetLoader.splitIdentifier(texture)
    return identifier, frame or 1
end

---@param path string
---@return love.Image[]
function Assets.getFramesOrTexture(path)
    if not self.hasSprite(path) then
        return Kristal.Console:error(string.format("Attempt to get missing sprite with ID '%s", path))
    end
    return self.get("sprite", path).textures
end

---@param x number
---@param y number
---@param w number
---@param h number
---@param sw number
---@param sh number
---@return love.Quad
function Assets.getQuad(x, y, w, h, sw, sh)
    local key = x .. "," .. y .. "," .. w .. "," .. h .. "," .. sw .. "," .. sh
    if not self.quads[key] then
        self.quads[key] = love.graphics.newQuad(x, y, w, h, sw, sh)
    end
    return self.quads[key]
end

---@param sound string
---@return love.Source
function Assets.getSound(sound)
    return self.get("sound", sound)
end

---@param sound string
---@return love.Source
function Assets.newSound(sound)
    return self.getSound(sound):clone()
end

---@param sound string
---@return love.Source
function Assets.startSound(sound)
    local src = self.get("sound", sound)
    src:stop()
    src:play()
    return src
end

---@param sound string
---@param actually_stop? boolean
function Assets.stopSound(sound, actually_stop)
    for _, src in ipairs(self.sound_instances[sound] or {}) do
        if actually_stop then
            src:stop()
        else
            src:setVolume(0)
            if src:isLooping() then
                src:setLooping(false)
            end
        end
    end
    if actually_stop then
        self.sound_instances[sound] = {}
    end
end

---@param sound string
---@param volume? number
---@param pitch? number
---@return love.Source
function Assets.playSound(sound, volume, pitch)
    self.sound_instances[sound] = self.sound_instances[sound] or {}
    local src
    local function play(v)
        src = self.newSound(sound)
        if v then
            src:setVolume(v)
        end
        if pitch then
            src:setPitch(pitch)
        end
        src:play()
        table.insert(self.sound_instances[sound], src)
    end
    if volume and volume > 1 then
        for _ = 1, math.floor(volume) do
            play(1)
        end
        if volume % 1 > 0 then
            play(volume % 1)
        end
    else
        play(volume)
    end
    return src
end

---@param sound string
---@param volume? number
---@param pitch? number
---@param actually_stop? boolean
---@return love.Source
function Assets.stopAndPlaySound(sound, volume, pitch, actually_stop)
    self.stopSound(sound, actually_stop)
    return self.playSound(sound, volume, pitch)
end

---@param music string
---@return string
function Assets.getMusicPath(music)
    -- TODO: Make this error once Music2 is updated.
    if not self.internalHas("music", music) then
        ---@diagnostic disable-next-line
        return nil, string.format("Attempt to fetch missing music '%s'", music)
    end
    return self.get("music", music)
end

---@param video string
---@return string
function Assets.getVideoPath(video)
    return self.get("video", video)
end

---@param video string
---@param load_audio? boolean
---@return love.Video
function Assets.newVideo(video, load_audio)
    return love.graphics.newVideo(self.getVideoPath(video), { audio = load_audio })
end

---@param id string
---@return love.Shader
function Assets.getShader(id)
    return self.get("shader", id).shader
end

function Assets.newShader(id)
    return love.graphics.newShader(self.get("shader", id).source)
end

return Assets
