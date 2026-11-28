---@class RhythmGameSongSelectMenu : Object
---@overload fun(...) : RhythmGameSongSelectMenu
local RhythmGameSongSelectMenu, super = Class(Object)

function RhythmGameSongSelectMenu:init()
    super.init(self, 0, 0, 540, 360)

    self.parallax_x = 0
    self.parallax_y = 0
    self.layer = WORLD_LAYERS["ui"]
    self.draw_children_below = 0

    self.box = UIBox(50, 60, self.width, self.height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    ---@type love.Font
    self.font = Assets.getFont("main")
    self.font_2 = Assets.getFont("plain")

    self.heart_tex = Assets.getTexture("player/heart_menu")
    self.heart_x = 66
	self.heart_y = 0

    self.none_text = "---"
    self.none_preview = "default"
    self.song_entry = {
		name = nil,
		song = nil,
		special_type = nil,
		no_hard_mode = nil,
		has_hardmode_chart = false,
		preview_song = nil,
		locked = nil,
		scores = nil,
		score_flag_name = nil,
		unlock_flag = nil,
		composer = nil,
		released = nil,
		chart = nil,
    }

    self.songs = modRequire("scripts.rhythmgame_song_list")

    self.pages = {}
    self.page_index = 1
    self.songs_per_page = 7
    self.selected_index = {}
    for page = 1, math.ceil(#self.songs / self.songs_per_page) do
        local start_index = 1 + (page-1) * self.songs_per_page
        self.pages[page] = {unpack(self.songs, start_index, math.min(start_index + self.songs_per_page - 1, #self.songs))}
        self.selected_index[page] = 1
    end
	self.preview_song_sounds = {}
	for index, song in pairs(self.songs) do
		if song.preview_song then
			Assets.stopSound(song.preview_song)
			local preview_snd = Assets.newSound(song.preview_song)
			preview_snd:setLooping(true)
			preview_snd:setVolume(0)
			preview_snd:setPitch(0.5)
			preview_snd:play()
			preview_snd:pause()
			self.preview_song_sounds[index] = {source = preview_snd, volume = 0, ideal_volume = 0, paused = true, duration = preview_snd:getDuration()}
		else
			self.preview_song_sounds[index] = nil
		end
	end
	self.heart_target_x = 66
    self.heart_target_y = self:calculateHeartTargetY()
    self.heart_y = self.heart_target_y
    self.state = "SELECTING" -- "SELECTING", "CHOICE"
	self.choice_selection = 1
	self.removing = false
	self.world_music_vol = Game.world.music and Game.world.music.volume or 0
	self.heartbeat_scale = 2
	self.heartbeat_last_trackpos = 0
	self.heartbeat_next_beat = 0
	self.heartbeat_tween = nil
end

function RhythmGameSongSelectMenu:getRank(thresholds, points)
    local rank = 0
    local rank_letters = {"Z", "C", "B", "A", "S", "T"}
    
    if (points >= thresholds[5]) then
        return rank_letters[6]
    end
	
    for i = 1, 6 do
        if (points < thresholds[i]) then
            rank = i
            break
        end
    end
    
    return rank_letters[rank]
end

function RhythmGameSongSelectMenu:draw()
	if self.removing then return end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.printf("RHYTHM GAME", 0 + 50, -17 + 60, self.width, "center")
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", -16 + 50, 20 + 60, self.width+32, 1)

    local page = self.pages[self.page_index]

    love.graphics.setLineWidth(1)
    -- draw the first line
    love.graphics.setColor(0, 0.4, 0)
    love.graphics.rectangle("line", 2 + 50, 40 + 60, 240, 1)

    for i = 1, self.songs_per_page do
        local song = page[i] or self.song_entry
        local name = song.name or self.none_text
        if song.locked then 
            name = string.rep("?", utf8.len(name))
        end
        love.graphics.setColor(1, 1, 1)

        if not song.song or song.locked then
            love.graphics.setColor(0.5, 0.5, 0.5)
        end

        local scale_x = math.min(math.floor(196 / self.font:getWidth(name) * 100) / 100, 1)
        love.graphics.print(name, 40 + 50, 40 + 40 * (i - 1) + 3 + 60, 0, scale_x, 1)
        love.graphics.setColor(1, 1, 1)

        love.graphics.setColor(0, 0.4, 0)
        love.graphics.rectangle("line", 2 + 50, 40 + 40 * i + 60, 240, 1)
    end
    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.setFont(self.font_2)
    love.graphics.printf("Page "..self.page_index.."/"..#self.pages, -16 + 50, (43 + 40 * (self.songs_per_page - 1)) + 60 + 60, 276, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)

    local info_area_sep_padding = 40
    local info_area_sep_a = (self.width - 300 + info_area_sep_padding)/info_area_sep_padding
    love.graphics.setColor(1, 1, 1, info_area_sep_a)
    love.graphics.rectangle("line", 300 - info_area_sep_padding + 50, 20 + 60, 1, 356)
    love.graphics.setColor(1, 1, 1)

    local song = page[self.selected_index[self.page_index]] or self.song_entry
	if song then
		if song.special_type == "SOUND_CHECK" then
			love.graphics.print("How about a\nSOUND CHECK?\nThis one's just for\npractice!", 280 + 50, 124 + 50, 0, 1, 1)
		else
			if song.no_hard_mode then
				local rank_title_txt = "RANK"
				local rank_title_w = self.font:getWidth(rank_title_txt)
				local rank_txt = Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0) > 0 and self:getRank(song.scores, Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0)) or "-"
				local rank_w = self.font:getWidth(rank_txt)
				love.graphics.print(rank_title_txt, 410 + 50 - rank_title_w/2, 40 + 60 + 8, 0, 1, 0.5)
				Draw.setColor(COLORS.yellow)
				love.graphics.print(rank_txt, 410 + 50 - (rank_w/2)*1.5, 40 + 60 + 32, 0, 1.5, 1.5)
				Draw.setColor(COLORS.white)
				
				love.graphics.print("HIGH SCORE", 280 + 50, 155 + 50 + 8, 0, 0.5, 0.5)
				local score_txt = tostring(Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0))
				local score_w = self.font:getWidth(score_txt)
				love.graphics.print(score_txt, 540 + 50 - score_w, 155 + 50, 0, 1, 1)
			else
				local rank_title_txt = "RANK"
				local rank_title_w = self.font:getWidth(rank_title_txt)
				local difficulty_txt = "(NORMAL)"
				local difficulty_w = self.font:getWidth(difficulty_txt)
				local rank_txt = Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0) > 0 and self:getRank(song.scores, Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0)) or "-"
				local rank_w = self.font:getWidth(rank_txt)
				love.graphics.print(rank_title_txt, 340 + 50 - rank_title_w/2, 40 + 60, 0, 1, 0.5)
				love.graphics.print(difficulty_txt, 340 + 50 - difficulty_w/4, 40 + 60 + 16, 0, 0.5, 0.5)
				Draw.setColor(COLORS.yellow)
				love.graphics.print(rank_txt, 340 + 50 - (rank_w/2)*1.5, 40 + 60 + 32, 0, 1.5, 1.5)
				Draw.setColor(COLORS.white)
				difficulty_txt = "(HARD)"
				difficulty_w = self.font:getWidth(difficulty_txt)
				rank_txt = Game:getFlag("Rhythm" .. song.score_flag_name .. "HardPoints", 0) > 0 and self:getRank(song.scores, Game:getFlag("Rhythm" .. song.score_flag_name .. "HardPoints", 0)) or "-"
				rank_w = self.font:getWidth(rank_txt)
				love.graphics.print(rank_title_txt, 480 + 50 - rank_title_w/2, 40 + 60, 0, 1, 0.5)
				love.graphics.print(difficulty_txt, 480 + 50 - difficulty_w/4, 40 + 60 + 16, 0, 0.5, 0.5)
				Draw.setColor(COLORS.orange)
				love.graphics.print(rank_txt, 480 + 50 - (rank_w/2)*1.5, 40 + 60 + 32, 0, 1.5, 1.5)
				Draw.setColor(COLORS.white)
				
				love.graphics.print("HIGH SCORE (NORMAL)", 280 + 50, 140 + 50 + 8, 0, 0.5, 0.5)
				local score_txt = tostring(Game:getFlag("Rhythm" .. song.score_flag_name .. "Points", 0))
				local score_w = self.font:getWidth(score_txt)
				love.graphics.print(score_txt, 540 + 50 - score_w, 140 + 50, 0, 1, 1)
				love.graphics.print("HIGH SCORE (HARD)", 280 + 50, 170 + 50 + 8, 0, 0.5, 0.5)
				score_txt = tostring(Game:getFlag("Rhythm" .. song.score_flag_name .. "HardPoints", 0))
				score_w = self.font:getWidth(score_txt)
				love.graphics.print(score_txt, 540 + 50 - score_w, 170 + 50, 0, 1, 1)
			end
		end
        local info_font = self.font
        local info_scale = 0.5
        love.graphics.setFont(info_font)
        local info_pad = 7
        local info_w = (267 - info_pad*2 - 1) / info_scale
        local info = string.format(
            "Composer: %s\nReleased: %s\nChart: %s",
            song.composer or "N/A",
            song.released or "N/A",
            song.chart or "N/A"
        )
        local _, info_lines = info_font:getWrap(info, info_w)
        local info_y_off = info_font:getHeight() * #info_lines * info_scale
        love.graphics.printf(info, 313 + info_pad, 340 + 85 - info_y_off, info_w, "left", 0, info_scale, info_scale)
	end
    if self.state == "CHOICE" then
        local name = song.name or self.none_text
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 379, SCREEN_WIDTH, 101)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.line(0, 377, SCREEN_WIDTH, 377)

		Draw.setColor(PALETTE["world_text"])
		local play_text = "Play \"".. song.name .."\"?"
		love.graphics.print(play_text, SCREEN_WIDTH/2 - self.font:getWidth(play_text)/2, 390)

		if song.no_hard_mode then
			if self.choice_selection == 1 then
				Draw.setColor(COLORS.yellow)
			end
			love.graphics.print("Play", 160, 430)

			if self.choice_selection == 1 then
				Draw.setColor(PALETTE["world_text"])
			else
				Draw.setColor(COLORS.yellow)
			end
			love.graphics.print("Do Not", 400, 430)
		else
			if self.choice_selection == 1 then
				Draw.setColor(COLORS.yellow)
			end
			love.graphics.print("Play (Normal)", 60, 430)

			if self.choice_selection == 2 then
				Draw.setColor(COLORS.yellow)
			else
				Draw.setColor(PALETTE["world_text"])
			end
			love.graphics.print("Play (Hard)", 300, 430)
			
			if self.choice_selection == 3 then
				Draw.setColor(COLORS.yellow)
			else
				Draw.setColor(PALETTE["world_text"])
			end
			love.graphics.print("Do Not", 520, 430)
		end
    end

	Draw.setColor(Game:getSoulColor())
	Draw.draw(self.heart_tex, self.heart_x, self.heart_y, 0, self.heartbeat_scale, self.heartbeat_scale, self.heart_tex:getWidth()/2, self.heart_tex:getHeight()/2)

    love.graphics.setColor(1, 1, 1)

    super.draw(self)
end

function RhythmGameSongSelectMenu:update()
	for _, song in pairs(self.preview_song_sounds) do
		if song then
			if song.source then
				song.volume = MathUtils.approach(song.volume, song.ideal_volume, 0.1 * DTMULT)
				if song.volume <= 0 and not song.paused then
					song.source:pause()
					song.paused = true
				elseif song.volume > 0 and song.paused then
					song.source:play()
					song.paused = false
				end
			end
			if song.source:getVolume() ~= song.volume then
				song.source:setVolume(song.volume)
			end
		end
	end
	local song = self.preview_song_sounds[self.selected_index[self.page_index]] or nil
	local mus_vol = self.world_music_vol
	if song and song.source and song.ideal_volume > 0 then
		mus_vol = self.world_music_vol - (song.ideal_volume * self.world_music_vol)
	end
	if Game.world.music.volume ~= mus_vol then
		Game.world.music:setVolume(MathUtils.approach(Game.world.music.volume, mus_vol, 0.1 * DTMULT))
	end
	for _, song in pairs(self.preview_song_sounds) do
		if song then
			song.ideal_volume = 0
		end
	end
	if self.removing then
		self.box.visible = false
		if song.volume <= 0 then
			self:remove()
		end
		return
	end
    local function warpIndex(index)
        return MathUtils.wrap(index, 1, self.songs_per_page + 1)
    end

    if not OVERLAY_OPEN then
        -- close menu
        if Input.pressed("cancel", false) and not Game.minigame then
			if self.state == "CHOICE" then
				self.state = "SELECTING"
			else
				Assets.stopAndPlaySound("ui_cancel_small")
				Game.world:closeMenu()
			end
            return
        end

        -- start rhythm game
        if Input.pressed("confirm", false) and not Game.minigame then
            local song = self.pages[self.page_index][self.selected_index[self.page_index]] or self.song_entry
            if not song.locked or Game:getFlag(song.unlock_flag) == true then
				if self.state == "CHOICE" then
					if self.choice_selection ~= (song.no_hard_mode and 2 or 3) then
						Game:startMinigame("rhythmgame", song.song .. ((self.choice_selection == 2 and song.has_hardmode_chart) and "_hard" or ""), (self.choice_selection == 2 and true or false))
						Game.world:closeMenu()
						for _, song in pairs(self.preview_song_sounds) do
							if song then
								song.volume = 0
							end
						end
					else
						self.state = "SELECTING"
					end
				else
					local song = self.songs[self.selected_index[self.page_index]] or self.song_entry
					if song.no_hard_mode and self.choice_selection >= 2 then
						self.choice_selection = 2
					end
					self.state = "CHOICE"
				end
            else
                Assets.stopAndPlaySound("ui_cant_select")
            end
        end

        -- page left
        if Input.pressed("left", true) and not Game.minigame then
			if self.state == "CHOICE" then
				local song = self.songs[self.selected_index[self.page_index]] or self.song_entry
				self.choice_selection = MathUtils.wrap(self.choice_selection - 1, 1, (song.no_hard_mode and 3 or 4))
			else
				if #self.pages == 1 then
					Assets.playSound("ui_cant_select")
				else
					Assets.playSound("ui_move")
				end
				self.page_index = self.page_index - 1
			end
        end
        -- page right
        if Input.pressed("right", true) and not Game.minigame then
			if self.state == "CHOICE" then
				local song = self.songs[self.selected_index[self.page_index]] or self.song_entry
				self.choice_selection = MathUtils.wrap(self.choice_selection + 1, 1, (song.no_hard_mode and 3 or 4))
			else
				if #self.pages == 1 then
					Assets.playSound("ui_cant_select")
				else
					Assets.playSound("ui_move")
				end
				self.page_index = self.page_index + 1
			end
        end
        self.page_index = MathUtils.wrap(self.page_index, 1, #self.pages + 1)

        local page = self.pages[self.page_index]
        -- move up
        if Input.pressed("up", true) and not Game.minigame and self.state ~= "CHOICE" then
            Assets.playSound("ui_move")
            self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] - 1)
            while not page[self.selected_index[self.page_index]] do
                self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] - 1)
            end
        end
        -- move down
        if Input.pressed("down", true) and not Game.minigame and self.state ~= "CHOICE" then
            Assets.playSound("ui_move")
            self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] + 1)
            while not page[self.selected_index[self.page_index]] do
                self.selected_index[self.page_index] = warpIndex(self.selected_index[self.page_index] + 1)
            end
        end
		if self.preview_song_sounds[self.selected_index[self.page_index]] then
			self.preview_song_sounds[self.selected_index[self.page_index]].ideal_volume = 1
		end
    end

    --soul positions
	if self.state == "CHOICE" then
		local song = self.songs[self.selected_index[self.page_index]] or self.song_entry
		if song.no_hard_mode then
			if self.choice_selection == 1 then
				self.heart_target_x = 138
			else
				self.heart_target_x = 378
			end
		else
			if self.choice_selection == 1 then
				self.heart_target_x = 38
			elseif self.choice_selection == 2 then
				self.heart_target_x = 278
			else
				self.heart_target_x = 498
			end
		end
		self.heart_target_y = 446
    else
		self.heart_target_x = 66
		self.heart_target_y = self:calculateHeartTargetY()
		if math.abs(self.heart_target_y - self.heart_y) <= 2 then
			self.heart_y = self.heart_target_y
		end	
	end
    self.heart_x = self.heart_x + (self.heart_target_x - self.heart_x) / 2 * DTMULT
    self.heart_y = self.heart_y + (self.heart_target_y - self.heart_y) / 2 * DTMULT
	self:calculateHeartBeat((self.songs[self.selected_index[self.page_index]] or nil), (self.preview_song_sounds[self.selected_index[self.page_index]] or nil))
end

local function ceilToBeat(arg0, arg1, arg2, arg3)
	local arg2 = arg2 or 4
	local arg3 = arg3 or 0
    if (arg2 <= 0) then
        arg2 = 1
	end
    
    local __mps = 60 / arg1 / arg2
    return (math.ceil((arg0 - arg3) / __mps) * __mps) + arg3
end

function RhythmGameSongSelectMenu:calculateHeartBeat(song, preview_song)
    if song and preview_song then
		if preview_song.paused then return end
		local trackpos = preview_song.source:tell()
		local bpm, signature, bpm_time, signature_time = 0, 0, 0, 0
		if song.preview_bpm and type(song.preview_bpm) == "table" then
			bpm = song.preview_bpm[1].bpm
			bpm_time = song.preview_bpm[1].time
			for _, bpmchange in pairs(song.preview_bpm) do
				if trackpos >= bpmchange.time then
					bpm = bpmchange.bpm
					bpm_time = bpmchange.time
				else
					break
				end
			end
		else
			bpm = song.preview_bpm or 230
		end
		if song.preview_sig and type(song.preview_sig) == "table" then
			signature = song.preview_sig[1].sig
			signature_time = song.preview_sig[1].time
			for _, signaturechange in pairs(song.preview_sig) do
				if trackpos >= signaturechange.time then
					signature = signaturechange.sig
					signature_time = signaturechange.time
				else
					break
				end
			end
		else
			signature = song.preview_sig or 4
		end
		local initial_bpm = 230
		if song.preview_bpm and type(song.preview_bpm) == "table" then
			initial_bpm = song.preview_bpm[1].bpm
		else
			initial_bpm = song.preview_bpm or 230
		end
		local time_offset = 0
		if song.preview_bpm and song.preview_sig and type(song.preview_bpm) == "table" and type(song.preview_sig) == "table" then
			time_offset = math.max(bpm_time, signature_time)
		elseif song.preview_bpm and type(song.preview_bpm) == "table" then
			time_offset = bpm_time
		elseif song.preview_sig and type(song.preview_sig) == "table" then
			time_offset = signature_time
		end
		if (self.heartbeat_last_trackpos > trackpos) then
			self.heartbeat_next_beat = ceilToBeat((trackpos + 0.001) - DT, bpm, 1, (initial_bpm / 2) * (60 / bpm)) 
		end
		self.heartbeat_last_trackpos = trackpos
		if (trackpos >= self.heartbeat_next_beat) then
			local offbeat = 0
			if ((signature % 1) == 0.5) then
				local _beat = 60 / bpm
				local _measure_length = signature * _beat
				local _barcount = math.floor(((trackpos - time_offset) + (_beat / 2)) / _measure_length)
				
				if ((_barcount % 2) == 1) then
					offbeat = _beat / 2
				else
					offbeat = 0
				end
			end
			self.heartbeat_next_beat = ceilToBeat(trackpos + 0.001, bpm, 1, ((initial_bpm / 2) * (60 / bpm)) - time_offset - offbeat) 
			self.heartbeat_scale = 2.4
			if self.heartbeat_tween then
				Game.world.timer:cancel(self.heartbeat_tween)
				self.heartbeat_tween = nil
			end
			self.heartbeat_tween = Game.world.timer:tween(12/30, self, { heartbeat_scale = 2 }, "out-quad")			
		end
	end
end

function RhythmGameSongSelectMenu:calculateHeartTargetY(i)
    if i == nil then i = self.selected_index[self.page_index] end
    return 120 + 40 * (i - 1)
end

function RhythmGameSongSelectMenu:onRemove()
	super.onRemove(self)
	for _, song in pairs(self.preview_song_sounds) do
		if song and song.source then
			song.source:stop()
		end
	end
	Game.world.music:setVolume(self.world_music_vol)
end

function RhythmGameSongSelectMenu:close()
    Game.world.menu = nil
	for _, song in pairs(self.preview_song_sounds) do
		if song then
			song.ideal_volume = 0
		end
	end
	self.removing = true
end

return RhythmGameSongSelectMenu