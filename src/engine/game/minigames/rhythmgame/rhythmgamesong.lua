---@class RhythmGameSong: Class
---@field tracks RhythmGameSong.track[]
local RhythmGameSong, super = Class()

function RhythmGameSong:init(data)
    self.data = data
    data = data or {}
    self.tracks = {}
	self.orig_tracks = {}
	self.title = data.title or nil
	self.track_length = data.track_length	
	self.scores = data.scores or {14500, 18000, 22000, 25000, 28000}
    self.bpm = data.bpm
	self.signature = data.signature or 4
    self.events = data and data.events or {}
	self.timestamps = data.timestamps or {}
	self.lyrics_data = data.lyrics or {}
	self.has_multi_solos = data.has_multi_solos or false
	self.auto_brightness = data.auto_brightness or true
	self.solos_active = false
	self.solo_tracks = {}
	self.orig_solo_tracks = {}
	self.start_delay = data.start_delay or -1
	self.difficulty = data.difficulty or 5
	self.signature_data = {}
	self.bpm_data = {}
	self.signature_index = 1
	self.bpm_index = 1
	self.hue = 0
	self.smooth = false
	self.no_safety_mode = false
	self.siner = 0
	self.score_flag_name = data.score_flag_name or "PlaceholderSong"
	self.auto_insert_beat_event = true
    local tracks_names = TableUtils.removeDuplicates(TableUtils.getKeys(TableUtils.mergeMany(data.tracks, data.notes)))
    for i = 1, #(tracks_names) do
        local trackname = tracks_names[i]
        local trackdata = data.tracks[trackname]
        -- Copy because we will be modifying this!
        local notedata = TableUtils.copy(data.notes[trackname] or {}, true)
        ---@class RhythmGameSong.track
        local track = {
            name = trackname,
            source = trackdata and trackdata.music and love.audio.newSource(Assets.getMusicPath(trackdata.music), "stream");
            notes = notedata;
            replace = trackdata and trackdata.replace;
        }
        self.tracks[trackname] = track
        if self.tracks[trackname].source and trackname ~= "BASE_TRACK" then
            self.tracks[trackname].source:setVolume(0)
        end
		if self.has_multi_solos then 
			local solo_track = {
				name = trackname,
				source = trackdata and trackdata.music and love.audio.newSource(Assets.getMusicPath(trackdata.music), "stream");
				replace = trackdata and trackdata.replace;
			}
			self.solo_tracks[trackname] = solo_track
			if self.solo_tracks[trackname].source then
				self.solo_tracks[trackname].source:setVolume(0)
			end
		end
	end
	self.orig_tracks = TableUtils.copy(self.tracks, true)
	if self.has_multi_solos then 
		self.orig_solo_tracks = TableUtils.copy(self.solo_tracks, true)
	end
    self.notespeed = data.notespeed or 150
    self.notespacing = (data.notespacing or 60) / self.bpm
    self.meter = (data.meter or self.notespacing) * self.signature
	self.speed_modifier = data.speed_modifier or 1
    self.notespeed = self.notespeed * self.speed_modifier
    self.notespeed = MathUtils.roundToMultiple(self.notespeed, 30)
	self.beatstart = 0
	self.beat = false
	self.note_beats = false
	self.note_hit = false
	self.spotlight_color = {}
	self.spotlight_color[1] = ColorUtils.hexToRGB("#2D2D2D")
	self.spotlight_color[2] = ColorUtils.hexToRGB("#BD0F17")
	self.spotlight_color[3] = ColorUtils.hexToRGB("#4A7CE8")
	self.spotlight_color[4] = ColorUtils.hexToRGB("#79D7FF")
	self.floor_spotlight_data = {}
	for i = 0, 2 do
		table.insert(self.floor_spotlight_data, {
			x = 36 + (i * 190),
			floorY = 370,
			flip = false,
			siner = 0,
			init = false,
			center_angle = 15,
			range = 45,
			con = 0,
			light_color = ColorUtils.hexToRGB("#85A0E8"),
		})
	end
	self.note_color = {}
    self.note_color[1] = ColorUtils.hexToRGB("#01EA9E")
    self.note_color[2] = ColorUtils.hexToRGB("#17EEFF")
	self.pal_shader = Assets.getShader("palette")
	self.alpha = 1
	self.bg_con = 0
	self.bg_timer = 0
	self.stage_con = 0
	self.miss_timer = 0
	self.red_glow = 0
	self.palette_active = true
	self.palette_pos = 1
	self.chart_lerp = 0
	self.chart_ease = 0
	self.kchart_lerp = 0
	self.kchart_ease = 0
	self.show_chart = 1
	self.next_beat = 0
	self.beat_value = 0
	self.oldtrackpos = 0
	self.beat_offset = self.bpm / 2
	self.time_offset = 0
	self.offbeat = 0
end

function RhythmGameSong:cleanup()
    self.data = nil
	TableUtils.clear(self.tracks)
	TableUtils.clear(self.solo_tracks)
	self.tracks = {}
	self.solo_tracks = {}
	self.title = nil
	self.track_length = 0
    self.bpm = 230
	self.signature = 4
    self.events = {}
	self.timestamps = {}
	self.lyrics_data = {}
	self.has_multi_solos = false
	self.auto_brightness = true
	self.start_delay = -1
	self.difficulty = 5
	TableUtils.clear(self.signature_data)
	TableUtils.clear(self.bpm_data)
	self.signature_data = {}
	self.bpm_data = {}
end

function RhythmGameSong:resetSong()
	self:stop()
	self:seek(0)
	TableUtils.clear(self.tracks)
	TableUtils.clear(self.solo_tracks)
	self.tracks = {}
	self.solo_tracks = {}
	self.tracks = TableUtils.copy(self.orig_tracks, true)
	if self.has_multi_solos then 
		self.solo_tracks = TableUtils.copy(self.orig_solo_tracks, true)
	end
	self.title = self.data.title or nil
	self.track_length = self.data.track_length	
	self.scores = self.data.scores or {14500, 18000, 22000, 25000, 28000}
    self.bpm = self.data.bpm
	self.signature = self.data.signature or 4
    self.events = self.data and self.data.events or {}
	self.timestamps = self.data.timestamps or {}
	self.lyrics_data = self.data.lyrics or {}
	self.has_multi_solos = self.data.has_multi_solos or false
	self.auto_brightness = self.data.auto_brightness or true
	self.start_delay = self.data.start_delay or -1
	self.difficulty = self.data.difficulty or 5
    self.notespeed = self.data.notespeed or 150
    self.notespacing = (self.data.notespacing or 60) / self.bpm
    self.meter = (self.data.meter or self.notespacing) * self.signature
	self.speed_modifier = self.data.speed_modifier or 1
    self.notespeed = self.notespeed * self.speed_modifier
    self.notespeed = MathUtils.roundToMultiple(self.notespeed, 30)
	self.score_flag_name = self.data.score_flag_name or "PlaceholderSong"
	self.siner = 0
	self.signature_data = {}
	self.bpm_data = {}
	self.signature_index = 1
	self.bpm_index = 1
	self.hue = 0
	self.smooth = false
	self.no_safety_mode = false
	self.beatstart = 0
	self.beat = false
	self.note_beats = false
	self.note_hit = false
	self.alpha = 1
	self.bg_con = 0
	self.bg_timer = 0
	self.stage_con = 0
	self.miss_timer = 0
	self.red_glow = 0
	self.palette_active = true
	self.palette_pos = 1
	self.chart_lerp = 0
	self.chart_ease = 0
	self.kchart_lerp = 0
	self.kchart_ease = 0
	self.show_chart = 1
	self.next_beat = 0
	self.beat_value = 0
	self.oldtrackpos = 0
	self.beat_offset = self.bpm / 2
	self.time_offset = 0
	self.offbeat = 0
end

local function rectangle_points(mode,x,y,x2,y2)
    love.graphics.rectangle(mode, x, y, x2-x+1, y2-y+1)
end

local function fill_rectangle_points(x,y,x2,y2)
    return rectangle_points("fill", x, y, x2, y2)
end

function RhythmGameSong:getSpotlightColor(arg0)
    local _combreq = 15
    
    if (Game.minigame.fame >= 12000 and Game.minigame.charts[1].combo >= _combreq) then
        if (self.stage_con == 0) then
            self.stage_con = 2
            Assets.playSound("crowd_cheer_single", 0.7)
        end
        
        if (self.smooth) then
            if (arg0 == 0) then
                self.hue = (self.hue + 4 * DTMULT) % 255
			end
        elseif ((self.note_beats and self.note_hit) or self.beat) then
            self.hue = self.hue + 106.25
            self.hue = self.hue % 255
            self.beat = false
			self.note_hit = false
        end
        
        local _rainbow = (self.hue + (arg0 * 85)) % 255
        return {ColorUtils.HSVToRGB((_rainbow/255)%1, 43/255, 223/255)}
    end
    
    if (self.stage_con >= 1) then
        self.stage_con = 0
	end
    
    local _score = Game.minigame.fame + math.floor(Game.minigame.hold_score)
    local _col = ColorUtils.mergeColor(self.spotlight_color[2], self.spotlight_color[3], MathUtils.clamp(MathUtils.inverseLerp(3000, 4000, Game.minigame.fame), 0, 1))
    local _sscore = (_score - 4000) + (arg0 * 2000)
    
    if ((Game.minigame.fame + math.floor(Game.minigame.hold_score)) < 6000) then
        _col = ColorUtils.mergeColor(self.spotlight_color[1], _col, MathUtils.clamp(MathUtils.inverseLerp(0, 2000, _sscore), 0, 1))
    else
        _col = ColorUtils.mergeColor(_col, self.spotlight_color[4], MathUtils.clamp(MathUtils.inverseLerp(6000, 8000, _sscore), 0, 1))
	end
    
    return _col
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

function RhythmGameSong:eventCheck(trackpos, can_reverse, no_callbacks)
	local trackpos = trackpos or 0
	if (Game.minigame.loop and oldtrackpos > trackpos) then
		self.next_beat = ceilToBeat((trackpos + 0.001) - DT, self.bpm, 1, self.beat_offset * (60 / self.bpm))
	end
	self.oldtrackpos = trackpos
	local can_reverse = can_reverse or false
	local no_callbacks = no_callbacks or false
	for _, event in pairs(Game.minigame.events) do
		if event.on_beat and trackpos >= self.next_beat then
			if event.type == "function" and not no_callbacks then
				event.callback()
			elseif event.type == "variable" then
				local target = nil
				if event.use_minigame_target then
					if event.use_minigame_charts then
						target = Game.minigame.charts[event.target]
					elseif event.use_minigame_performers then
						target = Game.minigame.charts[event.target].performer
					elseif event.use_minigame_song then
						target = Game.minigame.song
					else
						target = Game.minigame
					end
				else
					target = event.target or Game.stage:getObject(event.target)
				end
				local variable = event.variable
				local var_set = event.var_set or nil
				if target and variable then
					target[variable] = var_set
				end
			end

			if ((self.signature % 1) == 0.5) then
				local _beat = 60 / self.bpm
				local _measure_length = self.signature * _beat
				local _barcount = math.floor(((trackpos - self.time_offset) + (_beat / 2)) / _measure_length)
				
				if ((_barcount % 2) == 1) then
					self.offbeat = _beat / 2
				else
					self.offbeat = 0
				end
			end
			
			self.next_beat = ceilToBeat(trackpos + 0.001, self.bpm, 1, (self.beat_offset * (60 / self.bpm)) - self.time_offset - self.offbeat)
		elseif not event.on_beat and event.time then
			if event.type == "function" and not no_callbacks then
				if not event.triggered and trackpos >= event.time then
					if event.callback and type(event.callback) == "function" then
						event.callback()
					end
					event.triggered = true
				elseif can_reverse and trackpos <= event.time and event.triggered then
					if event.reverse_callback and type(event.reverse_callback) == "function" then
						event.reverse_callback()
					elseif event.callback and type(event.callback) == "function" then
						event.callback()
					end
					event.triggered = false
				end
			elseif event.type == "variable" then
				if not event.triggered and trackpos >= event.time then
					local target = nil
					if event.use_minigame_target then
						if event.use_minigame_charts then
							target = Game.minigame.charts[event.target]
						elseif event.use_minigame_performers then
							target = Game.minigame.charts[event.target].performer
						elseif event.use_minigame_song then
							target = Game.minigame.song
						else
							target = Game.minigame
						end
					else
						target = event.target or Game.stage:getObject(event.target)
					end
					local variable = event.variable
					local var_set = event.var_set or nil
					if target and variable then
						target[variable] = var_set
					end
					event.triggered = true
				elseif can_reverse and trackpos <= event.time and event.triggered then
					local target = nil
					if event.use_minigame_target then
						if event.use_minigame_charts then
							target = Game.minigame.charts[event.target]
						elseif event.use_minigame_performers then
							target = Game.minigame.charts[event.target].performer
						elseif event.use_minigame_song then
							target = Game.minigame.song
						else
							target = Game.minigame
						end
					else
						target = event.target or Game.stage:getObject(event.target)
					end
					local variable = event.variable
					local var_set = event.reverse_var_set or nil
					if target and variable then
						target[variable] = var_set
					end
					event.triggered = false
				end
			end
		end
    end
    if (#self.signature_data > 1) then
        if (self.signature_index < #self.signature_data and trackpos > self.signature_data[self.signature_index + 1].time) then
            self.signature_index = self.signature_index + 1
            self.signature = self.signature_data[self.signature_index].change
            self.time_offset = math.max(#self.bpm_data > 1 and self.bpm_data[self.bpm_index].time or 0, self.signature_data[self.signature_index].time)
			for index, value in pairs(Game.minigame.charts) do
				if (value.confidence < 1) then
					value.conf_decay = 10
				end
			end
        elseif (can_reverse and self.signature_index > 0 and trackpos < self.signature_data[self.signature_index].time) then
            self.signature_index = self.signature_index - 1
            self.signature = self.signature_data[self.signature_index].change
            self.time_offset = math.max(#self.bpm_data > 1 and self.bpm_data[self.bpm_index].time or 0, self.signature_data[self.signature_index].time)
        end
    end
    if (#self.bpm_data > 1) then
        if (self.bpm_index < #self.bpm_data and trackpos > self.bpm_data[self.bpm_index + 1].time) then
            self.bpm_index = self.bpm_index + 1
            self.bpm = self.bpm_data[self.bpm_index].change
            self.notespacing = 60 / self.bpm
            self.meter = self.notespacing * self.signature
            self.time_offset = math.max(self.bpm_data[self.bpm_index].time, #self.signature_data > 1 and self.signature_data[self.signature_index].time or 0)
        elseif (can_reverse and self.bpm_index > 0 and trackpos < self.bpm_data[self.bpm_index].time) then
            self.bpm_index = self.bpm_index - 1
            self.bpm = self.bpm_data[self.bpm_index].change
            self.notespacing = 60 / self.bpm
            self.meter = self.notespacing * self.signature
            self.time_offset = math.max(self.bpm_data[self.bpm_index].time, #self.signature_data > 1 and self.signature_data[self.signature_index].time or 0)
        end
    end
end

function RhythmGameSong:start()
	for _, value in pairs(self.tracks) do
		if value.source then
			value.source:seek(0)
			value.source:play()
		end
	end
	if self.has_multi_solos then
		for _, value in pairs(self.solo_tracks) do
			if value.source then
				value.source:seek(0)
				value.source:play()
			end
		end
	end
end

function RhythmGameSong:stop()
	for _, value in pairs(self.tracks) do
		if value.source then
			value.source:stop()
		end
	end
	if self.has_multi_solos then
		for _, value in pairs(self.solo_tracks) do
			if value.source then
				value.source:stop()
			end
		end
	end
end

function RhythmGameSong:seek(t)
	if self.has_multi_solos and self.solos_active then
		for _, value in pairs(self.solo_tracks) do
			if value.source then
				value.source:seek(t)
			end
		end
	else
		for _, value in pairs(self.tracks) do
			if value.source then
				value.source:seek(t)
			end
		end
	end
end

function RhythmGameSong:tell()
	if Game.minigame.overrun < 0 then
		return Game.minigame.overrun
	end
	if self.has_multi_solos and self.solos_active then
		for _, value in pairs(self.solo_tracks) do
			if value.source then
				return value.source:tell()
			end
		end
	else
		for _, value in pairs(self.tracks) do
			if value.source then
				return value.source:tell()
			end
		end
	end
	return 0
end

function RhythmGameSong:getBPM()
    return self.bpm
end

function RhythmGameSong:getTimeSignature()
    return self.signature
end

function RhythmGameSong:secondsToYPos(seconds)
    return (seconds * self.notespeed)
end

function RhythmGameSong:beatToSeconds(beat)
    return beat * (60/self:getBPM())
end

function RhythmGameSong:secondsToBeat(seconds)
    return seconds*(self:getBPM()/60)
end

local function lengthDirX(length, dir)
    return math.cos(dir) * length
end

local function lengthDirY(length, dir)
    return math.sin(dir) * length
end

function RhythmGameSong:drawBackground()
	self.bg_timer = self.bg_timer + DTMULT
	local bg_tex = Assets.getFrames("minigames/rhythm_game/rhythmgame_bg")
	local bg_mask_tex = Assets.getFrames("minigames/rhythm_game/rhythmgame_bg_mask")
	local bg_overlay_tex = Assets.getFrames("minigames/rhythm_game/rhythmgame_bg_overlay")
	Draw.setColor(COLORS.black, 1)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	Draw.setColor(COLORS.white, self.alpha)
	if self.palette_active then
		self.palette_pos = MathUtils.approach(self.palette_pos, 1 - self.bg_con, 0.1 * DTMULT)
		Draw.pushShader(self.pal_shader)
		local pal_tex = Assets.getTexture("minigames/rhythm_game/rhythm_stage_palette")
		self.pal_shader:send("palette_tex", pal_tex)
		local palw, palh = pal_tex:getWidth(), pal_tex:getHeight()
		self.pal_shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
		self.pal_shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
		self.pal_shader:send("palette_id", self.palette_pos)
		Draw.draw(bg_tex[2], 0, 100)
		Draw.popShader()
		if (self.palette_pos == 0) then
			self.palette_active = false
		end
	else
		Draw.draw(bg_tex[self.bg_con + 1], 0, 100)
        love.graphics.setBlendMode("add", "alphamultiply")
		Draw.setColor(COLORS.white, 0.1 + (math.sin(self.bg_timer / 6) * 0.1 * (self.kchart_ease * 0.65)))
		Draw.draw(bg_tex[self.bg_con + 1], 0, 100)
        love.graphics.setBlendMode("alpha", "alphamultiply")
		Draw.setColor(COLORS.white, self.alpha * (self.kchart_ease * 0.65))
		Draw.draw(bg_mask_tex[2], 0, 100)
	end
	if self.stage_con >= 1 then
		Draw.setColor(self.spotlight_color[4], ((self.alpha * (self.stage_con - 1)) / 2) + 0.25)
		Draw.draw(bg_mask_tex[1], 0, 100)
		self.stage_con = MathUtils.approach(self.stage_con, 1, 0.05 * DTMULT)
	end
	if ((self.miss_timer > 0 or Game.minigame.fame <= 2000)) then-- and self.tutorial < 7) then
        love.graphics.setBlendMode("add", "alphamultiply")
		self.red_glow = self.miss_timer / 20		
		if (Game.minigame.fame <= 2000) then
			if (TableUtils.contains({"MAIN", "LOSETRANSITION"}, Game.minigame.state)) then
				self.siner = self.siner + DTMULT
			end			
			self.red_glow = self.red_glow + ((math.sin((self.siner / 20) * math.pi) * 0.25) + 0.25)
		end		
		Draw.setColor(self.spotlight_color[2], self.red_glow)
		Draw.draw(bg_mask_tex[1], 0, 100)
        love.graphics.setBlendMode("alpha", "alphamultiply")
	elseif (self.red_glow > 0) then
		self.red_glow = 0
	end
	love.graphics.stencil(function()
		love.graphics.clear()
		Draw.pushShader("Mask")
		Draw.draw(bg_overlay_tex[2], 0, 100)
		Draw.popShader()
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	for _, light in ipairs(self.floor_spotlight_data) do
		if light then
			if (not light.init) then
				light.init = true
				if (light.flip) then
					light.center_angle = -15
				end
			end
			if (light.con >= 2) then
				light.siner = light.siner + (light.flip and -DTMULT or DTMULT)
			end
			light.light_color = ColorUtils.hexToRGB("#85A0E8")
			if (self.red_glow > 0) then
				light.light_color = ColorUtils.mergeColor(ColorUtils.hexToRGB("#85A0E8"), ColorUtils.hexToRGB("#FF8186"), self.red_glow)
			end
			if (light.con > 0) then
				light.floorY = 370 + (math.cos(light.siner / 20) * (light.range / 2))
				Draw.setColor(light.light_color, 1)
				love.graphics.ellipse("fill", light.x + 90, light.floorY - 20 + 15, 90, 15)
			end
		end
	end
	love.graphics.setStencilTest()
	Draw.setColor(COLORS.white, 1)
end

function RhythmGameSong:drawOverlay()
	Draw.setColor(COLORS.white, self.alpha)
	local spotlight_tex = Assets.getFrames("minigames/rhythm_game/rhythmgame_spotlight")
	local popularity_tex = Assets.getFrames("minigames/rhythm_game/rhythmgame_popularity")
	local _inv_ease = self.chart_ease - 1
	local _ystart = 100 + 16
	Draw.draw(spotlight_tex[self.bg_con + 1], 16, _ystart - (50 * self.chart_ease))
	Draw.draw(spotlight_tex[self.bg_con + 1], SCREEN_WIDTH - 16, _ystart - (50 * self.chart_ease), 0, -1, 1)
	if self.chart_ease > 0 then	
		Draw.setColor(self.spotlight_color[3], 1)
		Draw.draw(popularity_tex[1], 60 + (110 * _inv_ease), _ystart - 60 - 30 + 4, 0, 1, 1, 44, 30)
		Draw.draw(popularity_tex[2], SCREEN_WIDTH - 60 - (110 * _inv_ease), _ystart - 60 - 30 + 4, 0, 1, 1, 44, 30)
		Draw.setColor(COLORS.white, self.alpha)
		Draw.draw(spotlight_tex[self.bg_con + 1], 16 + (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease))
		Draw.draw(spotlight_tex[self.bg_con + 1], SCREEN_WIDTH - 16 - (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease), 0, -1, 1)
		Draw.draw(spotlight_tex[self.bg_con + 1], 16 + (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease))
		Draw.draw(spotlight_tex[self.bg_con + 1], SCREEN_WIDTH - 16 - (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease), 0, -1, 1)
		local _col = self:getSpotlightColor(0)
		Draw.setColor(_col, 1)
		Draw.draw(spotlight_tex[6], 16, _ystart - (50 * self.chart_ease))
		Draw.draw(spotlight_tex[6], SCREEN_WIDTH - 16, _ystart - (50 * self.chart_ease), 0, -1, 1)
		if Game.minigame.fame >= 12000 then
			Draw.setColor(_col, 0.1)
			love.graphics.setBlendMode("add", "alphamultiply")
			Draw.draw(spotlight_tex[7], 16, _ystart - (50 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16, _ystart - (50 * self.chart_ease), 0, -1, 1)
			love.graphics.setBlendMode("alpha", "alphamultiply")
		end
		_col = self:getSpotlightColor(1)
		Draw.setColor(_col, 1)
		Draw.draw(spotlight_tex[6], 16 + (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease))
		Draw.draw(spotlight_tex[6], SCREEN_WIDTH - 16 - (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease), 0, -1, 1)
		if Game.minigame.fame >= 10000 then
			Draw.setColor(_col, 0.1)
			love.graphics.setBlendMode("add", "alphamultiply")
			Draw.draw(spotlight_tex[7], 16 + (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16 - (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease), 0, -1, 1)
			love.graphics.setBlendMode("alpha", "alphamultiply")
		end
		_col = self:getSpotlightColor(2)
		Draw.setColor(_col, 1)
		Draw.draw(spotlight_tex[6], 16 + (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease))
		Draw.draw(spotlight_tex[6], SCREEN_WIDTH - 16 - (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease), 0, -1, 1)
		if Game.minigame.fame >= 8000 then
			Draw.setColor(_col, 0.1)
			love.graphics.setBlendMode("add", "alphamultiply")
			Draw.draw(spotlight_tex[7], 16 + (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16 - (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease), 0, -1, 1)
			love.graphics.setBlendMode("alpha", "alphamultiply")
		end
		Draw.setColor(self.note_color[1], 1)
		local font = Assets.getFont("main")
		love.graphics.setFont(font)
		love.graphics.printfOutline("SCORE", 110 + (300 * _inv_ease), 467 - font:getHeight("SCORE")/2, 1, math.huge, "left", 0, 0.5, 0.5)
		local score = StringUtils.pad(tostring((Game.minigame.points + math.floor(Game.minigame.hold_score)) or 0), 6, true, "0")
		love.graphics.printfOutline(score, 20 + (200 * _inv_ease), 470 - font:getHeight(score))
		Draw.setColor(self.note_color[2], 1)
		love.graphics.printfOutline("MAX COMBO", 530 - (300 * _inv_ease) - font:getWidth("MAX COMBO")/2, 467 - font:getHeight("MAX COMBO")/2, 1, math.huge, "left", 0, 0.5, 0.5)
		local maxcombo = StringUtils.pad(tostring(Game.minigame.max_combo or 0), 6, true, "0")
		love.graphics.printfOutline(maxcombo, 620  - font:getWidth(maxcombo) - (200 * _inv_ease), 470 - font:getHeight(maxcombo))
		if (self.miss_timer > 0) then
			_col = self.spotlight_color[2]
			Draw.setColor(_col, self.miss_timer / 20)
			love.graphics.setBlendMode("add", "alphamultiply")
			Draw.draw(spotlight_tex[7], 16, _ystart - (50 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16, _ystart - (50 * self.chart_ease), 0, -1, 1)
			Draw.draw(spotlight_tex[7], 16 + (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16 - (110 * _inv_ease), _ystart + 60 - (30 * self.chart_ease), 0, -1, 1)
			Draw.draw(spotlight_tex[7], 16 + (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease))
			Draw.draw(spotlight_tex[7], SCREEN_WIDTH - 16 - (220 * _inv_ease), _ystart + 120 - (10 * self.chart_ease), 0, -1, 1)
			love.graphics.setBlendMode("alpha", "alphamultiply")
			self.miss_timer = self.miss_timer - DTMULT
		end
	end
	Draw.setColor(COLORS.white, 1)
end

return RhythmGameSong