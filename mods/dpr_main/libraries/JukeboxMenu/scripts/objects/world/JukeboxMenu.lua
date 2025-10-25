-- The util functions below are duplicated from utils_general purposefully
-- in preparation to any sort of standalone release in the future

-- Gets the index of an item in a 2D table
---@return any? i
---@return any? j
local function getIndex2D(t, value)
    for i,r in pairs(t) do
        local j = TableUtils.getIndex(r, value)
        if j then
            return i, j
        end
    end
    return nil, nil
end

---@param ... any # Extra parameters to cond()
local function evaluateCond(data, ...)
    local result = true

    if data.cond then
        result = data.cond(...)
    elseif data.flagcheck then
        local inverted, flag = StringUtils.startsWith(data.flagcheck, "!")

        local flag_value = Game.flags[flag]
        local expected_value = data.flagvalue
        local is_true
        if expected_value ~= nil then
            is_true = flag_value == expected_value
        elseif type(result) == "number" then
            is_true = flag_value > 0
        else
            is_true = flag_value
        end

        if is_true then
            result = not inverted
        else
            result = inverted
        end
    end

    return result
end

---@class JukeboxMenu : Object
---@overload fun(...) : JukeboxMenu
local JukeboxMenu, super = Class(Object)

---@class JukeboxMenu.Song
---@field name string?
---@field file string?
---@field bpm number?
---@field composer string?
---@field released string?
---@field origin string?
---@field locked boolean|string|nil
---@field album string?
---@field _locked_explicit boolean?

JukeboxMenu.MAX_WIDTH = 540
JukeboxMenu.SONG_INFO_AREA_X = 264 - 1
JukeboxMenu.MIN_WIDTH = JukeboxMenu.MAX_WIDTH - JukeboxMenu.SONG_INFO_AREA_X - 1 - 36
JukeboxMenu.MIN_HEIGHT = 360

JukeboxMenu.HEAD_HR_START_Y = 20
JukeboxMenu.HEAD_HR_H = 4
JukeboxMenu.HEAD_HR_END_Y = JukeboxMenu.HEAD_HR_START_Y + JukeboxMenu.HEAD_HR_H
JukeboxMenu.ENTRY_START_X = 2
JukeboxMenu.ENTRY_START_Y = JukeboxMenu.HEAD_HR_END_Y + 16
JukeboxMenu.ENTRY_PAD_X = 6
JukeboxMenu.ENTRY_HEART_START_X = JukeboxMenu.ENTRY_PAD_X - 1 + (9 * 2 / 2) -- width of player/heart_menu is 9px
JukeboxMenu.ENTRY_W = 240
JukeboxMenu.ENTRY_H = 40

JukeboxMenu.SONGS_PER_PAGE = 7

function JukeboxMenu:init(simple)
    if simple == nil then simple = Kristal.getLibConfig("JukeboxMenu", "useSimpleModeByDefault") end
    super.init(self, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, self.MIN_HEIGHT)

    self.parallax_x = 0
    self.parallax_y = 0
    self.layer = WORLD_LAYERS["ui"]
    self:setOrigin(0.5, 0.5)
    self.draw_children_below = 0

    self.show_duration_bar = Kristal.getLibConfig("JukeboxMenu", "showDurationBar")
    if self.show_duration_bar then
        self.height = self.height + 40
    end

    self.box = UIBox(0, 0, 0, self.height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)
    self:setWidth(simple and self.MIN_WIDTH or self.MAX_WIDTH)

    self.font = Assets.getFont("main")
    self.font_2 = Assets.getFont("plain")

    self.heart = Sprite("player/heart_menu")
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(2)
    self.heart.layer = 1
    self.heart.x = self.ENTRY_START_X + self.ENTRY_HEART_START_X
    self:addChild(self.heart)

    self.music_note = Assets.getTexture("ui/music_note")

    ---@type JukeboxMenu.Song
    self.default_song = {
        name = "---",
        file = nil,
        composer = "---",
        released = "---",
        origin = "---",
        locked = nil,
        album = "default"
    }

    self:_buildSongs()

    self.album_art_dir = Kristal.getLibConfig("JukeboxMenu", "albumArtDirectory")
    self.default_album_art = Assets.getTexture(self.album_art_dir .. self.default_song.album)

    self.timer = self:addChild(Timer())
    self.info_collpasible = not simple and Kristal.getLibConfig("JukeboxMenu", "infoCollapsible")
    self.info_accordion_timer_handle = nil

    self.color_playing_song = Kristal.getLibConfig("JukeboxMenu", "indicatePlayingSongWithNameColor")
    self.show_music_note = Kristal.getLibConfig("JukeboxMenu", "indicatePlayingSongWithMusicNote")
end

---@private
function JukeboxMenu:_buildSongs()
    self.songs = {} ---@type JukeboxMenu.Song[]

    local old_list_ok, old_list = pcall(modRequire, "scripts.jukebox_songs")
    if old_list_ok and old_list ~= nil then
        self.songs = TableUtils.merge(self.songs, old_list)
    end

    self.songs = TableUtils.merge(self.songs, Kristal.modCall("getJukeboxSongs") or {})

    for lib_id, _ in Kristal.iterLibraries() do
        local lib_songs = Kristal.libCall(lib_id, "getJukeboxSongs")
        if lib_songs ~= nil then
            self.songs = TableUtils.merge(self.songs, lib_songs)
        end
    end

    for _,song in pairs(self.songs) do
        if song.locked == nil then
            song.locked = not evaluateCond(song, self)
        else
            song._locked_explicit = true
        end
    end

    self.song_by_file = {}
    for _,song in pairs(self.songs) do
        if song.file then
            assert(not self.song_by_file[song.file], "Duplicate song entry for file "..song.file)
            self.song_by_file[song.file] = song
        end
    end
end

function JukeboxMenu:setWidth(w)
    self.width = w
    self.box.width = w
end

function JukeboxMenu:onAddToStage(stage)
    super.onAddToStage(self, stage)

    if self.info_collpasible and Kristal.getLibConfig("JukeboxMenu", "rememberCollpaseState") then
        self:setWidth(Game:getFlag("jukebox_menu_collpased", false) and self.MIN_WIDTH or self.MAX_WIDTH)
    end

    self.heart:setColor(Game:getSoulColor())

    ---@type JukeboxMenu.Song[][]
    self.pages = {}
    ---@type integer
    self.cur_page = 1
    ---@type integer[]
    self.page_cursor = {}
    for page = 1, math.ceil(#self.songs / self.SONGS_PER_PAGE) do
        local start_index = 1 + (page-1) * self.SONGS_PER_PAGE
        self.pages[page] = {unpack(self.songs, start_index, math.min(start_index + self.SONGS_PER_PAGE - 1, #self.songs))}
        self.page_cursor[page] = 1
    end

    if Kristal.getLibConfig("JukeboxMenu", "navigateToPlayingSongAtInit") then
        local playing_song = self:getPlayingEntry()
        if playing_song then
            local i, j = getIndex2D(self.pages, playing_song)
            if j then
                self.cur_page = i
                self.page_cursor[self.cur_page] = j
            end
        end
    end

    self.heart_target_y = self:calculateHeartTargetY()
    self.heart.y = self.heart_target_y
end

---@param music Music?
---@param ignore_locked boolean?
---@return JukeboxMenu.Song?
function JukeboxMenu:getPlayingEntry(music, ignore_locked)
    music = music or Game.world.music
    if not music then
        return nil
    end

    local song = self.song_by_file[music.current]
    if song and (ignore_locked or not song.locked) then
        return song
    end
end

function JukeboxMenu:draw()
    Draw.pushScissor()
    local padding_size = 16
    local padding_adj = padding_size + 2 -- HACK because working with UIBoxes is annoying
    Draw.scissor(-padding_adj, -padding_adj, self.width+padding_adj*2, self.height+padding_adj*2)

    love.graphics.setColor(COLORS.white)
    love.graphics.setFont(self.font)
    love.graphics.printf("JUKEBOX", 0, -padding_size - 1, self.width, "center")
    love.graphics.setLineWidth(self.HEAD_HR_H)
    love.graphics.rectangle("line", -padding_size, self.HEAD_HR_START_Y, self.width + (padding_size*2), 1)
    love.graphics.setLineWidth(1)

    local page = self.pages[self.cur_page]

    -- draw the first line
    love.graphics.setColor(0, 0.4, 0)
    local entry_start_x = self.ENTRY_START_X
    local entry_start_y = self.ENTRY_START_Y
    local entry_w = self.ENTRY_W
    local entry_h = self.ENTRY_H
    love.graphics.rectangle("line", entry_start_x, entry_start_y, entry_w, 1)
    local playing_song = self:getPlayingEntry((Game.world.music and Game.world.music:isPlaying()) and Game.world.music)
    for i = 1, self.SONGS_PER_PAGE do
        local song = page[i] or self.default_song

        local name = song.name or self.default_song.name
        if song.locked then name = "Locked" end

        love.graphics.setColor(COLORS.white)
        local is_being_played
        if not song.file or song.locked then
            love.graphics.setColor(COLORS.gray)
        elseif song == playing_song then
            is_being_played = true
            if self.color_playing_song then
                love.graphics.setColor(COLORS.yellow)
            end
        end

        local entry_name_start = self.ENTRY_PAD_X - 1 + (9 * 2) + 15
        local entry_name_max_w = entry_w - entry_name_start - self.ENTRY_PAD_X
        local entry_name_scale_x = math.min(math.floor(entry_name_max_w / self.font:getWidth(name) * 100) / 100, 1)
        love.graphics.print(name, entry_start_x + entry_name_start, entry_start_y + entry_h * (i - 1) + 1 + 2, 0, entry_name_scale_x, 1)
        love.graphics.setColor(COLORS.white)

        if self.show_music_note and is_being_played then
            love.graphics.setColor(1, 1, 1, math.abs(self:calculateHeartTargetY(i) - self.heart.y) / entry_h)
            love.graphics.draw(self.music_note,
                entry_start_x + self.ENTRY_HEART_START_X,
                self:calculateHeartTargetY(i) + (math.sin(Kristal.getTime() * 4) * 2),
                0, 1, 1,
                self.music_note:getWidth()/2, self.music_note:getHeight()/2
            )
        end

        love.graphics.setColor(0, 0.4, 0)
        love.graphics.rectangle("line", entry_start_x, entry_start_y + entry_h * i, entry_w, 1)
    end
    love.graphics.setColor(COLORS.white)

    local page_indicator_y = entry_start_y + entry_h * self.SONGS_PER_PAGE + 24 - 1
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.setFont(self.font_2)
    love.graphics.printf("Page "..self.cur_page.."/"..#self.pages, 0, page_indicator_y, self.MIN_WIDTH + 2*2, "center")
    love.graphics.setColor(COLORS.white)
    love.graphics.setFont(self.font)

    local info_area_sep_padding = 3
    love.graphics.setLineWidth(info_area_sep_padding + 1)
    local info_area_sep_a = (self.width - self.SONG_INFO_AREA_X + info_area_sep_padding)/(self.MIN_WIDTH + info_area_sep_padding)
    love.graphics.setColor(1, 1, 1, info_area_sep_a)
    love.graphics.rectangle("line", self.SONG_INFO_AREA_X - info_area_sep_padding, self.HEAD_HR_START_Y, 1, self.MIN_HEIGHT - 4)
    love.graphics.setColor(COLORS.white)

    local song = page[self.page_cursor[self.cur_page]] or self.default_song

    local infosect_w = self.MAX_WIDTH - self.SONG_INFO_AREA_X - info_area_sep_padding
    local album_art_path = (song.file and song.album and not song.locked) and song.album or self.default_song.album
    local album_art = Assets.getTexture(self.album_art_dir .. album_art_path) or self.default_album_art
    local album_art_def_size = 250
    local album_art_end_y = self.HEAD_HR_END_Y + 14 - 1 + album_art_def_size
    love.graphics.draw(
        album_art,
        self.SONG_INFO_AREA_X + infosect_w/2 + 10, album_art_end_y - album_art_def_size/2,
        0, 1, 1, album_art:getWidth()/2, album_art:getHeight()/2)

    local info_font = self.font
    local info_scale = 0.5
    love.graphics.setFont(info_font)
    local info_pad = 7
    local info_w = (infosect_w - info_pad*2 - 1) / info_scale
    local info = string.format(
        "Composer: %s\nReleased: %s\nOrigin: %s",
        song.composer or self.default_song.composer,
        song.released or self.default_song.released,
        song.origin or self.default_song.origin
    )
    local _, info_lines = info_font:getWrap(info, info_w)
    local info_yoff = info_font:getHeight() * #info_lines * info_scale
    love.graphics.printf(info, self.SONG_INFO_AREA_X + info_pad, album_art_end_y + 85 - info_yoff, info_w, "left", 0, info_scale, info_scale)

    if self.show_duration_bar then
        local music_always = Game.world.music
        local duration_hr_y = page_indicator_y + self.font_2:getHeight() + 20 + 1
        local duration_hr_h = 4
        love.graphics.setLineWidth(duration_hr_h)
        local duration_x, duration_y = 6, duration_hr_y + duration_hr_h + 12
        local duration_w, duration_h = self.width - duration_x * 2, 6
        local duration_needle_h_bump = 2
        local duration_loop_mark_w = duration_h / 2

        love.graphics.rectangle("line", -padding_size, duration_hr_y, self.width + (padding_size*2), 1)

        love.graphics.setColor(COLORS.dkgray)
        love.graphics.rectangle("fill", duration_x, duration_y, duration_w, duration_h)

        local function getDuration(_music) -- too pussy to make this an actual extension
            return (_music.source_intro and _music.source_intro:getDuration() or 0) + _music.source:getDuration()
        end

        if music_always.source_intro then
            local duration_loop_mark_percent = music_always.source_intro:getDuration() / getDuration(music_always)
            -- i hate doing math
            local duration_loop_mark_x = duration_loop_mark_percent * (duration_w - duration_loop_mark_w)
            duration_loop_mark_x = duration_loop_mark_x + (duration_h - duration_loop_mark_w) / 2
            duration_loop_mark_x = math.floor(duration_loop_mark_x)
            Draw.setColor(COLORS.gray)
            love.graphics.rectangle("fill", duration_x + duration_loop_mark_x, duration_y, duration_loop_mark_w, duration_h)
        end

        local duration_needle_percent = MathUtils.clamp(music_always:tell() / getDuration(music_always), 0, 1)
        local duration_needle_x = math.floor(duration_needle_percent * (duration_w - duration_h))
        Draw.setColor(COLORS.white)
        love.graphics.rectangle("fill", duration_x + duration_needle_x, duration_y - duration_needle_h_bump, duration_h, duration_h + duration_needle_h_bump*2)
    end

    Draw.popScissor()

    super.draw(self)
end

function JukeboxMenu:update()
    local function warpIndex(index)
        return MathUtils.wrapIndex(index, self.SONGS_PER_PAGE)
    end

    if not OVERLAY_OPEN then
        --close menu
        if Input.pressed("cancel", false) then
            Assets.playSound("ui_cancel_small")
            Game.world:closeMenu()
            return
        end

        --play song
        if Input.pressed("confirm", false) then
            local song = self.pages[self.cur_page][self.page_cursor[self.cur_page]] or self.default_song

            if not song._locked_explicit then
                song.locked = not evaluateCond(song, self)
            end

            if not song.locked and song.file then
                Game.world.music:play(song.file, 1)
                Kristal.callEvent("onJukeboxPlay", song)
            else
                Assets.playSound("error")
            end
        end

        --page left
        if Input.pressed("left", true) then
            if #self.pages == 1 then
                Assets.playSound("ui_cant_select")
            else
                Assets.playSound("ui_move")
            end
            self.cur_page = self.cur_page - 1
        end
        --page right
        if Input.pressed("right", true) then
            if #self.pages == 1 then
                Assets.playSound("ui_cant_select")
            else
                Assets.playSound("ui_move")
            end
            self.cur_page = self.cur_page + 1
        end
        self.cur_page = MathUtils.wrapIndex(self.cur_page, #self.pages)

        local page = self.pages[self.cur_page]
        --move up
        if Input.pressed("up", true) then
            Assets.playSound("ui_move")
            self.page_cursor[self.cur_page] = warpIndex(self.page_cursor[self.cur_page] - 1)
            while not page[self.page_cursor[self.cur_page]] do
                self.page_cursor[self.cur_page] = warpIndex(self.page_cursor[self.cur_page] - 1)
            end
        end
        --move down
        if Input.pressed("down", true) then
            Assets.playSound("ui_move")
            self.page_cursor[self.cur_page] = warpIndex(self.page_cursor[self.cur_page] + 1)
            while not page[self.page_cursor[self.cur_page]] do
                self.page_cursor[self.cur_page] = warpIndex(self.page_cursor[self.cur_page] + 1)
            end
        end

        if self.info_collpasible and Input.pressed("menu", false) then
            local dest_width = MathUtils.xor(self.width > self.MIN_WIDTH, self.info_accordion_timer_handle and self.info_accordion_timer_handle.direction)
                and self.MIN_WIDTH or self.MAX_WIDTH
            --[[Log:print(self.width, self.width > self.MIN_WIDTH,
                not not self.info_reveal_timer_handle, self.info_reveal_timer_handle and self.info_reveal_timer_handle.direction,
                dest_width)]]
            Assets.stopAndPlaySound("wing")
            if self.info_accordion_timer_handle then
                self.timer:cancel(self.info_accordion_timer_handle)
            end
            self.info_accordion_timer_handle = self.timer:approach(1/3.5,
                self.width, dest_width,
                function(value)
                    self:setWidth(math.floor(value))
                end,
                "out-sine",
                function()
                    self.info_accordion_timer_handle = nil
                end
            )
            local collpased = dest_width == self.MIN_WIDTH
            ---@diagnostic disable-next-line: inject-field
            self.info_accordion_timer_handle.direction = collpased
            if Kristal.getLibConfig("JukeboxMenu", "rememberCollpaseState") then
                Game:setFlag("jukebox_menu_collpased", collpased)
            end
        end
    end

    --soul positions
    self.heart_target_y = self:calculateHeartTargetY()
    if math.abs(self.heart_target_y - self.heart.y) <= 2 then
        self.heart.y = self.heart_target_y
    end
    self.heart.y = self.heart.y + (self.heart_target_y - self.heart.y) / 2 * DTMULT

    super.update(self)
end

function JukeboxMenu:calculateHeartTargetY(i)
    if i == nil then i = self.page_cursor[self.cur_page] end
    return self.ENTRY_START_Y + self.ENTRY_H * (i - 1) + self.ENTRY_H/2
end

function JukeboxMenu:close()
    Game.world.menu = nil
    self:remove()
end

function JukeboxMenu:onRemoveFromStage(_)
    if self.info_accordion_timer_handle then
        self.timer:cancel(self.info_accordion_timer_handle)
    end
end

return JukeboxMenu
