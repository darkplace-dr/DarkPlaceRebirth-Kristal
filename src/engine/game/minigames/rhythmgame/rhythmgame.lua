---@class RhythmGame : Minigame
---@field song Song
local RhythmGame, super = Class("Minigame")

local a_single_pixel_data = love.image.newImageData(1,1)
a_single_pixel_data:setPixel(0, 0, {1,1,1,1})
RhythmGame.pixel = love.graphics.newImage(a_single_pixel_data)

function RhythmGame:init(song, hardmode)
    super.init(self)
	
	self.song_data = song
    if isClass(song) then
		self.song = song
    else
		self.song = LightnersLiveLib:createSong(song)
    end
    self.name = "Lightners Live" .. (self.song.title and " - " .. self.song.title or "") .. (hardmode and " (Hard)" or "")

    ---@type RhythmGameChart[]
    self.charts = {
        self:addChild(RhythmGameChart(1, 1, 2, self.song.tracks.lead, self.song));
        self:addChild(RhythmGameChart(2, 2, 1, self.song.tracks.drums, self.song));
        self:addChild(RhythmGameChart(3, 3, 3, self.song.tracks.vocals, self.song));
    }
	self.events = {}
	for _, chart in pairs(self.charts) do
		if chart then
			local xpos = 0
			if chart.position == 1 then
				xpos = 124
			elseif chart.position == 2 then
				xpos = 321
			elseif chart.position == 3 then
				xpos = 505
			end
			chart.performer = RhythmGamePerformer(xpos, 396, chart)
			if chart.instrument == 0 then
				chart.performer:setAnimation("rhythm_game/ready")
			elseif chart.instrument == 1 then
				chart.performer.animspeed = 3
			elseif chart.instrument == 2 then
				chart.performer.animspeed = 0.5
				chart.performer.loop = true
			end
			self:addChild(chart.performer)
		end
	end
	self.remtrackpos = {}
	self.hardmode = hardmode or false
	self.points = 0
	self.fame_mul = 1
    self.fame = 6000
	self.total_fame = 6000
	self.max_fame = 12000
	self.max_combo = 0
	self.total_score = 0
	self.hold_score = 0
	self.score_scale = 2
	self.max_score = 25000
	self.miss = 0
	self.good = 0
	self.great = 0
    self.overrun = (self.song.start_delay or 0)
	self.lyrics_font = Assets.getFont("main", 16)
    self.lyric_data = {}
	self.line_switch = 0
	self.lyric_canvas = {nil, nil}
	self.lyric_canvas[1] = love.graphics.newCanvas(SCREEN_WIDTH, 100)
	self.lyric_canvas[2] = love.graphics.newCanvas(SCREEN_WIDTH, 100)
	self.current_lyric = ""
	self.censored_lyric = ""
	self.clean_lyric = ""
	self.lyrics_index = 1
	self.lyric_start_index = 1
	self.update_lyrics = false
	self.censor_lyrics = false
	self.solo_difficulty = -1
	self.solo_con = 0
	self.loop = false
	self.song_done = false
	self.trackstart = 0
	self.trackpos = 0
	self.instant_start = false
	self.paused = false
	self.muted = false
	self.muted_time = 0
	self.safety_pos = 0
	self.safety_timer = 0
	self.safety_mode = false
	self.smooth_timer = 0
    self.game_won = false
	self.rewind = false
	self.rewind_start = 0
	self.rewind_timer = 0
	self.state = "INIT"
	self.state_timer = 0
	self.orchhit_pitch = 1
	self.countdown_timer = 0
	self.countdown_text = 3
	self.rhythm_game_update_states = {"MAIN", "RESULTSTRANSITION", "LOSETRANSITION"}
	self.rhythm_game_draw_states = {"MAIN", "RESULTSTRANSITION", "LOSETRANSITION"}
	self.canceltimer = 0
	self.canceltime = 15
	self.instruction_lerp = 0
	self.fixed_penalty = 0
	self.hurt_counter = 0
	self.missnotecon = 0
	self.pitch = 1
	self.fade = 1
    self.results_music = Music()
	self.results_bg_speed = 1
	self.results_bg_speed_max = 3
	self.results_bg_speed_y = 1
	self.results_bg_speed_y_max = 3
	self.results_bg_x_extra = 0
	self.results_bg_y = -SCREEN_WIDTH
	self.results_bouncebuff = 0
	self.results_bouncecount = 0
	self.results_current_points = 0
	self.results_grade = "?-RANK"
	self.results_grade_con = 0
	self.results_rank = 0
	self.results_star_anim = 0
	self.results_star_anim_speed = 0.5
	self.results_reachedend_draw_triangle_siner = 0
	self.results_done = false
	self.results_fade = 0
	self.lose_screenshot = nil
	self.lose_tone_saturation = 1
	self.lose_tone_brightness = 1
	self.lose_tone_factor = 0
	self.lose_grayalpha = 0
	self.lose_blackalpha = 0
	self.lose_staticalpha = 0
	self.lose_staticindex = 0
	self.lose_draw_menu = false
	self.lose_menu_choice = 1
end

function RhythmGame:pauseWorldMusic()
    if Game.world.music:isPlaying() then
        self.resume_world_music = true
        Game.world.music:pause()
    end
end

function RhythmGame:postInit()
    self:pauseWorldMusic()
	Game.minigame:setState("INITBLACK")
end

function RhythmGame:preEndCleanup()
    for _, value in pairs(self.charts) do
        if value then
			if value.performer then
				value.performer:remove()
			end
			value:remove()
		end
    end
    for _, value in pairs(self.song.tracks) do
        if value.source then
			value.source:stop()
			value.source:release()
        end
    end
	if self.song.has_multi_solos then
		for _, value in pairs(self.song.solo_tracks) do
			if value.source then
				value.source:stop()
				value.source:release()
			end
		end
	end
	if self.results_music then
		self.results_music:remove()
	end
	self.lyric_canvas[1]:release()
	self.lyric_canvas[2]:release()
	self.lyric_canvas = {nil, nil}
	self.song:cleanup()
	if self.resume_world_music then
		Game.world.music:resume()
		self.resume_world_music = false
	end
end

function RhythmGame:setState(state)
    local last_state = self.state
    self.state = state
    self.state_timer = 0
    self:onStateChange(last_state, state)
end

function RhythmGame:onStateChange(old, new)
    if new == "MAIN" then
		for _, value in pairs(self.charts) do
			if value then
				if value.party.id == "ralsei" then
					self.censor_lyrics = true
				elseif value.party.id == "susie" and not value.demo_mode then
					value.confidence = 0.96
				end
			end
		end
		if self.song then
			self.song.bpm_data = {}
			self.song.signature_data = {}
			self.events = TableUtils.copy(self.song.events, true)
			for _, event in ipairs(self.song.events) do
				if event.type == "bpm" then
					table.insert(self.song.bpm_data, {change = event.change, time = event.time})
				elseif event.type == "signature" or event.type == "ts" then
					table.insert(self.song.signature_data, {change = event.change, time = event.time})
				elseif event.triggered then
					event.triggered = false
				end
			end
			if self.song.auto_insert_beat_event then
				table.insert(self.events, {type = "variable", on_beat = true, time = 0, target = self.song, variable = "beat", var_set = true})
			end
			if self.song.auto_brightness then
				table.insert(self.events, {type = "variable", 0 - self.song.meter, target = self.charts[1], variable = "target_brightness", var_set = 0.75})
				table.insert(self.events, {type = "variable", 0 - self.song.meter, target = self.charts[3], variable = "target_brightness", var_set = 0.75})
			end
			self.song.bg_con = 1
			for _, light in ipairs(self.song.floor_spotlight_data) do
				if light then
					light.con = 2
				end
			end
		end
    elseif new == "INITBLACK" then
		Assets.playSound("locker")
    elseif new == "COUNTDOWN" then
		Assets.playSound("orchhit", 1, 1)
    elseif new == "TRANSITION" then
		Assets.playSound("bell")
    elseif new == "TRANSITIONOUT" then
		if self.results_music and self.results_music:isPlaying() then
			self.results_music:stop()
		end
		self:endMinigame()
		Game.world.fader:fadeIn(nil, { alpha = 1, color = COLORS.black, music = false })
    elseif new == "RESULTSWAIT" then
		self.results_bg_speed = self.results_bg_speed - 20
    elseif new == "RESULTS" then
		Assets.playSound("closet_impact")
		self:shake(12)
    elseif new == "LOSETRANSITION" then
		Assets.playSound("closet_impact")
    elseif new == "LOSE" then
		Game.stage.timer:tween(1, self, { lose_tone_saturation = 0.1 }, "out-quad")
		Game.stage.timer:tween(1, self, { lose_tone_factor = 0.5 }, "out-quad")
		Game.stage.timer:after(1 / 30, function()
			Game.stage.timer:tween(15 / 30, self, { lose_staticalpha = 0.015 }, "linear")
		end)
		Game.stage.timer:after(2 / 30, function()
			Game.stage.timer:tween(15 / 30, self, { lose_grayalpha = 0.35 }, "linear")
		end)
		Game.stage.timer:after(15 / 30, function()
			self.lose_draw_menu = true
		end)
	end
end

function RhythmGame:emergencyReload()
	if self.song.tracks.BASE_TRACK.source:isPlaying() or self.song_done then return end
    if (self.trackpos <= 0) then
        self.trackpos = 0.1
	end
	self.remtrackpos[1] = self.trackpos
    self.song:start()
	self:seek(self.remtrackpos[1])
end

function RhythmGame:resultsTimerSkip(start, _end)
	local skip = false
	if self.state_timer > start + 5 and self.state_timer < _end - 1 then
		if Input.down("menu") then
			skip = true
		end
	end	
	if self.state_timer > start + 1 and self.state_timer < _end - 1 then
		if Input.pressed("confirm") then
			skip = true
		end
	end	
	if skip then
		self.state_timer = _end - 1
		skip = false
	end
end

function RhythmGame:drawResultsSprite(sprite, x, y, r, sx, sy, ox, oy, kx, ky)
    local old_color = { love.graphics.getColor() }
    local shadcolor = ColorUtils.hexToRGB("#060B3C")
    local shadalph = 0.65
    local shadoff = 2
    Draw.setColor(shadcolor, shadalph)
    Draw.draw(sprite, x + shadoff, y + shadoff, r, sx, sy, ox, oy, kx, ky)	
    Draw.setColor(unpack(old_color))
    Draw.draw(sprite, x, y, r, sx, sy, ox, oy, kx, ky)
end

function RhythmGame:drawResultsText(text, x, y, r, sx, sy, ox, oy, kx, ky)
    local old_color = { love.graphics.getColor() }
    local shadcolor = ColorUtils.hexToRGB("#060B3C")
    local shadalph = 0.65
    local shadoff = 2
    Draw.setColor(shadcolor, shadalph)
    love.graphics.print(text, x + shadoff, y + shadoff, r, sx, sy, ox, oy, kx, ky)	
    Draw.setColor(unpack(old_color))
    love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end

function RhythmGame:resetSong()
	self.song:resetSong()
	for _, value in pairs(self.charts) do
		value:resetChart()
		local performer = value.performer
		if performer then
			performer.idle = "rhythm_game/ready"
			performer.mid = "rhythm_game/play"
			performer.looped_frame = 1
			performer.animspeed = 1
			performer.animlead = 0
			performer.main_speed = 0
			performer.shakeamt = 0
			performer.shakereduct = 2
			performer.on = 1
			performer.ontimer = 0
			performer.visible = false
			performer:setAnimation("rhythm_game/idle")
			if value.instrument == 0 then
				performer:setAnimation("rhythm_game/ready")
			elseif value.instrument == 1 then
				performer.animspeed = 3
			elseif value.instrument == 2 then
				performer.animspeed = 0.5
				performer.loop = true
			end
		end
	end
	self.overrun = (self.song.start_delay or 0)
	self.instant_start = false
	self.fade = 1
	self.pitch = 1
	self.instruction_lerp = 0
	self.fixed_penalty = 0
	self.hurt_counter = 0
	self.missnotecon = 0
	self.lose_screenshot = nil
	self.lose_tone_saturation = 1
	self.lose_tone_brightness = 1
	self.lose_tone_factor = 0
	self.lose_grayalpha = 0
	self.lose_blackalpha = 0
	self.lose_staticalpha = 0
	self.lose_staticindex = 0
	self.lose_draw_menu = false
	self.lose_menu_choice = 1
	self.orchhit_pitch = 1
	self.countdown_text = 3
	self.points = 0
	self.fame_mul = 1
	self.fame = 6000
	self.total_fame = 6000
	self.max_fame = 12000
	self.max_combo = 0
	self.total_score = 0
	self.hold_score = 0
	self.score_scale = 2
	self.max_score = 25000
	self.miss = 0
	self.good = 0
	self.great = 0
	self.line_switch = 0
	self.current_lyric = ""
	self.censored_lyric = ""
	self.clean_lyric = ""
	self.lyrics_index = 1
	self.lyric_start_index = 1
	self.update_lyrics = false
	self.lyric_canvas[1] = Draw.pushCanvas(640, 100)
	love.graphics.clear()
	Draw.popCanvas(true)
	self.lyric_canvas[2] = Draw.pushCanvas(640, 100)
	love.graphics.clear()
	Draw.popCanvas(true)
	self.solo_difficulty = -1
	self.solo_con = 0
	self.loop = false
	self.song_done = false
	self.trackstart = 0
	self.trackpos = 0
	self.instant_start = false
	self.paused = false
	self.muted = false
	self.muted_time = 0
	self.safety_pos = 0
	self.safety_timer = 0
	self.safety_mode = false
	self.smooth_timer = 0
	self.game_won = false
	self.rewind = false
	self.rewind_start = 0
	self.rewind_timer = 0
end

function RhythmGame:update()
	self.state_timer = self.state_timer + DTMULT
	if not TableUtils.contains(self.rhythm_game_update_states, Game.minigame.state) then 
		if Game.minigame.state == "INITBLACK" then
			if self.state_timer >= 30 then
				Game.minigame:setState("COUNTDOWN")
			end
		elseif Game.minigame.state == "COUNTDOWN" then
			self.countdown_timer = self.countdown_timer + DTMULT
			if self.countdown_timer >= 30 then
				self.countdown_text = self.countdown_text - 1
				self.countdown_timer = 0
				if self.countdown_text <= 0 then
					Game.minigame:setState("TRANSITION")
				else
					Assets.playSound("orchhit", 1, 1 + (self.orchhit_pitch / 16))
					self.orchhit_pitch = self.orchhit_pitch + 1
				end
			end
		elseif Game.minigame.state == "TRANSITION" then
			if self.state_timer >= 30 then
				self:changeWindowTitle()
				Game.minigame:setState("MAIN")
			end
		elseif Game.minigame.state == "RESULTSWAIT" then
			self:resultsTimerSkip(1, 24)
			if self.state_timer >= 24 then
				self:setState("RESULTS")
			end
		elseif Game.minigame.state == "RESULTS" then
			self:resultsTimerSkip(1, 28)
			if math.floor(self.state_timer) == 28 then
				Assets.playSound("punchmed")
			end
			self:resultsTimerSkip(28, 42)
			if math.floor(self.state_timer) == 42 then
				Assets.playSound("punchmed")
			end
			self:resultsTimerSkip(42, 56)
			if math.floor(self.state_timer) == 56 then
				Assets.playSound("punchmed")
			end
			self:resultsTimerSkip(56, 70)
			if math.floor(self.state_timer) == 70 then
				Assets.playSound("punchmed")
			end
			self:resultsTimerSkip(70, 84)
			if math.floor(self.state_timer) == 84 then
				Assets.playSound("punchmed")
			end
			self:resultsTimerSkip(84, 98)
			if math.floor(self.state_timer) > 98 then
				if self.results_current_points < math.floor(self.points) then
					self.results_current_points = self.results_current_points + math.floor(200 * DTMULT)
					if self.results_current_points % 400 == 0 then
						Assets.stopAndPlaySound("bump")
					end
					if (Input.down("menu") and self.results_current_points > math.floor(100 * DTMULT)) or Input.pressed("confirm") then
						self.results_current_points = math.floor(self.points)
					end
				end
				if self.results_current_points > math.floor(self.points) then
					self.results_current_points = math.floor(self.points)
				end
			end
			self:resultsTimerSkip(98, 112)
			if math.floor(self.state_timer) > 112 then
				if self.results_current_points == math.floor(self.points) and self.results_grade_con == 0 then
					self.results_grade_con = 0.05
					local del = 14
					if Input.down("menu") then
						del = 1
					end
					Game.stage.timer:after(del / 30, function()
						self.results_grade_con = 0.1
					end)
				end
			end
			if self.results_grade_con == 0.1 then
				local drumrolldelay = 40
				local del = drumrolldelay + 28
				if Input.down("menu") then
					drumrolldelay = 1
					del = 2
				end
				Game.stage.timer:after(drumrolldelay / 30, function()
					if self.points == 0 then
						self.results_grade = "NO RANK"
						self.results_rank = 0
						Assets.playSound("splat")
					elseif self.points < self.song.scores[1] then
						self.results_grade = "Z-RANK"
						self.results_rank = 0
						Assets.playSound("splat")
					elseif self.points >= self.song.scores[1] and self.points < self.song.scores[2] then
						self.results_grade = "C-RANK"
						self.results_rank = 1
						Assets.playSound("splat")
					elseif self.points >= self.song.scores[2] and self.points < self.song.scores[3] then
						self.results_grade = "B-RANK"
						self.results_rank = 2
						Assets.playSound("coin")
					elseif self.points >= self.song.scores[3] and self.points < self.song.scores[4] then
						self.results_grade = "A-RANK"
						self.results_rank = 3
						Assets.playSound("coin")
					elseif self.points >= self.song.scores[4] and self.points < self.song.scores[5] then
						self.results_grade = "S-RANK"
						self.results_rank = 4
						Assets.playSound("punchmed")
						Assets.playSound("applause_single")
					elseif self.points >= self.song.scores[5] then
						self.results_grade = "T-RANK"
						self.results_rank = 5
						Assets.playSound("punchmed")
						Assets.playSound("applause_single")
					end
					self.results_grade_con = 1
				end)
				Game.stage.timer:after(del / 30, function()
					Game.stage.timer:after(1 / 30, function()
						Assets.playSound("board_text_end")
					end)
					if self.results_rank == 0 then
						self.results_music:play("deltarune/tv_changingroom")
					else
						self.results_music:play("deltarune/nes_intro_extended_part2")		
						Assets.playSound("crowd_cheer_single")			
					end
					self.results_grade_con = 2
				end)
				Assets.playSound("drumroll")
				self.results_grade_con = 0.2
			end
			if self.results_grade_con >= 2 then
				if not self.results_done then
					if Input.pressed("confirm") or Input.pressed("cancel") or Input.pressed("menu") then 
						Assets.stopSound("board_text_end")
						Assets.stopSound("crowd_cheer_single")
						Assets.playSound("explosion_mmx")
						if math.floor(self.points) > Game:getFlag("Rhythm" .. self.song.score_flag_name .. (self.hardmode and "HardPoints" or "Points"), 0) then
							Game:setFlag("Rhythm" .. self.song.score_flag_name .. (self.hardmode and "HardPoints" or "Points"), math.floor(self.points))
						end
						if self.max_combo >= #self.song.tracks.lead.notes then
							Game:setFlag("Rhythm" .. self.song.score_flag_name .. (self.hardmode and "HardFullClear" or "FullClear"), true)
						end
						self.results_music:fade(0, 1)
						self.results_done = true
					end
				end
			end
			if self.results_done then
				self.results_fade = self.results_fade + DTMULT
				if self.results_fade >= 30 then
					self:setState("TRANSITIONOUT")
				end
			end
		elseif Game.minigame.state == "LOSE" then
			if self.lose_draw_menu then
				if Input.pressed("up") then
					if self.lose_menu_choice == 2 then
						self.lose_menu_choice = 1
						Assets.playSound("ui_move")
					end
				end
				if Input.pressed("down") then
					if self.lose_menu_choice == 1 then
						self.lose_menu_choice = 2
						Assets.playSound("ui_move")
					end
				end
				if Input.pressed("confirm") then
					self.lose_draw_menu = false
					Assets.playSound("badexplosion")
					Game.stage.timer:tween(1, self, { lose_blackalpha = 1 }, "linear", function()
						self.lose_blackalpha = 0
						if self.lose_menu_choice == 1 then
							self:resetSong()
							self:setState("COUNTDOWN")
						else
							self:endMinigame()
							Game.world.fader:fadeIn(nil, { alpha = 1, color = COLORS.black, music = false })
						end
					end)
				end
			end
		end
		super.update(self)
		return
	else
		if Game.minigame.state == "LOSETRANSITION" then
			self.fade = MathUtils.approach(self.fade, 0, 0.05 * DTMULT)
			self.pitch = self.fade
			if self.fade == 0 then
				self.lose_screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
				self.song:stop()
				Game.minigame:setState("LOSE")
			end
		elseif Game.minigame.state == "RESULTSTRANSITION" then
			if self.state_timer > 10 and Input.down("menu") then
				self.state_timer = 60
			end
			self.results_bg_y = Ease.outBounce(self.state_timer, -SCREEN_WIDTH, SCREEN_WIDTH, 60)
			self.results_bouncebuff = self.results_bouncebuff - DTMULT
			if self.results_bg_y > -6 then
				if self.results_bouncebuff <= 0 then
					self.results_bouncecount = self.results_bouncecount + 1
					Assets.playSound("impact", 1 - (self.results_bouncecount / 8), 1)
				end
				self.results_bouncebuff = 3
			end
			if self.state_timer >= 60 then
				self:setState("RESULTSWAIT")
			end
		end
	end
    local timescale = (DT / BASE_DT)
	if self.pitch > 0 then
		for _, value in pairs(self.song.tracks) do
			if value.source then
				value.source:setPitch(self.pitch * timescale)
			end
		end
		if self.song.has_multi_solos then
			for _, value in pairs(self.song.solo_tracks) do
				if value.source then
					value.source:setPitch(self.pitch * timescale)
				end
			end
		end
	end
    if self.overrun < 0 then
        self.overrun = MathUtils.approach(self.overrun, 0, DT * self.pitch)
        self.trackpos = self.overrun
        if self.overrun == 0 then
			self.instant_start = true
            self.song:start()
			Game.minigame:setTrackActive(self.charts[1].track.name, true)
        end
    else
		if self.overrun == 0 and not self.instant_start then
			self.instant_start = true
			self.song:start()
			Game.minigame:setTrackActive(self.charts[1].track.name, true)
		end
        if (not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state) and not self.song_done and not self.paused and not self.song.tracks.BASE_TRACK.source:isPlaying() and self.trackpos < (self.song.track_length - 0.5)) then
            self:emergencyReload()
            return
        end
        
		--[[if timescale <= 1 then
			if (self.muted and self.muted_time ~= self:tell()) then
				self.muted = false
			end
			
			local _posdiff = self:tell() - self.trackpos
			
			if (not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state)) and not self.paused and _posdiff == 0 and self.trackpos < (self.song.track_length - 0.5)) then
				self.safety_timer = self.safety_timer + DTMULT
				
				if (self.safety_timer >= 20) then
					if (not self.safety_mode) then
						self.safety_mode = true
						self.muted = true
						self.muted_time = self:tell()
					end
				end
			elseif (not self.paused and math.abs(_posdiff) > 0.05 and math.abs(_posdiff) < 0.5 and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state)) and not self.song.no_safety_mode and not self.muted) then
				if (self.smooth_timer == 0) then
					self.smooth_timer = 6
					self.safety_mode = true
					self.safety_pos = self.trackpos
				else
					self.smooth_timer = self.smooth_timer - DTMULT
				end
				
				if (self.smooth_timer == 0) then
					self.safety_mode = false
				end
			elseif (self.smooth_timer > 0) then
				self.safety_pos = self:tell()
				self.safety_mode = false
				self.safety_timer = 0
				self.smooth_timer = 0
			elseif (self.safety_timer > 0 and _posdiff ~= 0) then
				self.safety_timer = 0
			end
			
			if (self.safety_mode and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state)) then
				if (self.smooth_timer > 0 and not self.muted) then
					self.safety_pos = self.safety_pos + DT
					self.trackpos = MathUtils.rangeMap(6, 0, self.safety_pos, self:tell(), self.smooth_timer)
				else
					self.trackpos = self.trackpos + DT
				end
				
				if (self.loop and self.trackpos >= self.song.track_length) then
					self.trackpos = self.trackpos - self.song.track_length
				end
			elseif (not self.loop and self.song_done and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state)) then
				self.trackpos = self.trackpos + DT
				
				if (self.trackpos > (self.song.track_length + (self.song.meter * 4))) then
					self.trackpos = self.trackpos - (self.song.meter * 2)
				end
			elseif (self:tell() == 0 and self:tell() < self.trackpos and self.trackpos > (self.song.track_length - 4)) then
				self.trackpos = self.song.track_length
			elseif (self.rewind) then
				self.trackpos = MathUtils.lerp(self.rewind_start, 0, self.rewind_timer / 30)
				self.rewind_timer = self.rewind_timer + DTMULT
			else
				self.trackpos = self:tell()
			end
		else--]] -- Simpler version that doesn't break when fast-forwarding
			if (not self.loop and self.song_done and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, self.state)) then
				self.trackpos = self.trackpos + DT * self.pitch
				
				if (self.trackpos > (self.song.track_length + (self.song.meter * 4))) then
					self.trackpos = self.trackpos - (self.song.meter * 2)
				end
			elseif (self:tell() == 0 and self:tell() < self.trackpos and self.trackpos > (self.song.track_length - 4)) then
				self.trackpos = self.song.track_length
			elseif (self.rewind) then
				self.trackpos = MathUtils.lerp(self.rewind_start, 0, self.rewind_timer / 30)
				self.rewind_timer = self.rewind_timer + DTMULT
			else
				self.trackpos = self:tell()
			end
		--end
		
		if self.song.has_multi_solos then
			if (self.solo_con == 0 and self.trackpos >= self.song.timestamps[1] - 2) then
				if (self.solo_difficulty < 1) then
					if (self.fame >= 10000) then
						self.solo_difficulty = 3
					elseif (self.fame >= 6000) then
						self.solo_difficulty = 2
					else
						self.solo_difficulty = 1
					end
				end				
				self.song.tracks.lead.notes = TableUtils.merge(self.song.tracks.lead.notes, self.song.tracks.lead_solo.notes[self.solo_difficulty])
				self.song.tracks.lead.notes = TableUtils.merge(self.song.tracks.lead.notes, self.song.tracks.lead_finale.notes)
				local _track_offset = self.song.timestamps[self.solo_difficulty] - (self.song.timestamps[1] - self.trackpos)
				if (self.solo_difficulty == 0) then
					_track_offset = self.trackpos
				end
				if (not self.safety_mode or self.smooth_timer > 0 or timescale > 1) then
					self:seek(_track_offset, true)
				end
				self.solo_con = 1
			elseif (self.solo_con == 1 and self.trackpos >= self.song.timestamps[1]) then
				if (self.solo_difficulty ~= 0) then
					if (self.safety_mode and timescale <= 1) then
						self.trackpos = self.trackpos + (self.song.timestamps[self.solo_difficulty] - self.song.timestamps[1])
					else
						self.trackpos = self:tell(true)
						self:seek(self.trackpos, false)
					end
				end        
				self:setSoloActive(true)
				self.solo_con = 2
			elseif (self.solo_con == 2 and self.trackpos >= self.song.timestamps[self.solo_difficulty + 1] - 2) then
			    local _track_offset = self.song.timestamps[4] - (self.song.timestamps[self.solo_difficulty + 1] - self.trackpos)
				if (not self.safety_mode or self.smooth_timer > 0 or timescale > 1) then
					self:seek(_track_offset, false)
				end
				self.solo_con = 3
			elseif (self.solo_con == 3 and self.trackpos >= self.song.timestamps[self.solo_difficulty + 1]) then
				if (self.safety_mode and timescale <= 1) then
					if (self.solo_difficulty < 4) then
						self.trackpos = self.trackpos + (self.song.timestamps[4] - self.song.timestamps[self.solo_difficulty + 1])
					end
				else
					self.trackpos = self:tell(false)
				end        
				self:setSoloActive(false)
				self.solo_con = 4
			end
		end
	end
	self.song.chart_lerp = MathUtils.approach(self.song.chart_lerp, self.song.show_chart, 0.05 * DTMULT)
    self.song.chart_ease = Ease.outQuad(self.song.chart_lerp, 0, 1, 1)
    self.song.kchart_lerp = self.song.chart_lerp
    self.song.kchart_ease = self.song.chart_ease
    for index, value in pairs(self.charts) do
		local _inv_ease = self.song.chart_ease - 1
		value.bottomy = 200 + (300 * _inv_ease)
    end
    if (self.lyrics_index <= #self.song.lyrics_data and self.trackpos > self.song.lyrics_data[self.lyrics_index].time) then
		while ((self.lyrics_index + 1) <= #self.song.lyrics_data and self.trackpos > self.song.lyrics_data[self.lyrics_index + 1].time) do
			self.lyrics_index = self.lyrics_index + 1
		end
            
		self.current_lyric = self.song.lyrics_data[self.lyrics_index].lyrics
		if self.censor_lyrics then
			self.censored_lyric = self.song.lyrics_data[self.lyrics_index].censored_lyrics
		else
			self.censored_lyric = self.current_lyric
		end
		self.clean_lyric = self:cleanLyric(self.current_lyric)
		self.lyrics_index = self.lyrics_index + 1
		self.update_lyrics = true
	end
    if self.overrun == 0 then
		self.song:eventCheck(self.trackpos, false, false)
	end
	
    if (self.loop and self.trackpos < self.charts[1].remtrackpos[4] and self.trackpos < 2 and self.charts[1].remtrackpos[4] > (self.track_length / 2)) then
		for index, value in ipairs(self.charts) do
			if (value.maxnote >= 5) then
				value.last_score[1] = value.notescore[maxnote - 4]
			end
			
			if (value.maxnote >= 4) then
				value.last_score[2] = value.notescore[maxnote - 3]
			end
			
			if (value.maxnote >= 3) then
				value.last_score[3] = value.notescore[maxnote - 2]
			end
			
			if (value.maxnote >= 2) then
				value.last_score[4] = value.notescore[maxnote - 1]
			end
			
			if (value.maxnote >= 1) then
				value.last_score[5] = value.notescore[maxnote]
			end
			
			value.minnote = 0
			value.remtrackpos[5] = -1
			value.remtrackpos[4] = value.remtrackpos[4] - self.song.track_length
			value.remtrackpos[3] = value.remtrackpos[3] - self.song.track_length
			value.remtrackpos[2] = value.remtrackpos[2] - self.song.track_length
			value.remtrackpos[1] = value.remtrackpos[1] - self.song.track_length
			self.looptimer = self.song.track_length
			
			--[[if (tutorial ~= 1)
			{
				var _notealive = (tutorial < 5) ? 1 : 0;
				
				for (i = 0; i < maxnote; i++)
				{
					if (loop_start > 0)
					{
						if (notetime[i] < loop_start)
							continue;
						else
							loop_start = 0;
					}
					
					notealive[i] = _notealive;
					notescore[i] = 0;
				}
			}]]
		end
    elseif (not self.song_done and (self.trackpos >= self.song.track_length and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, Game.minigame.state))) then
        if (self.fame > 0) then
            self.game_won = true
		end
        
        self.song_done = true
		if Game.minigame.state == "MAIN" then
			Game.minigame:setState("RESULTSTRANSITION")
		end
    end
	if Input.down("menu") and self.state == "MAIN" then
		self.canceltimer = self.canceltimer + DTMULT
		
		if (self.canceltimer >= self.canceltime) then
			if Game.minigame.state == "MAIN" then
				Game.minigame:setState("LOSETRANSITION")
			end
		end
	else
		self.canceltimer = 0
	end
	if (self.instruction_lerp < 1) then
		self.instruction_lerp = self.instruction_lerp + 0.1 * DTMULT
	end
	Game.minigame.fame = MathUtils.clamp(Game.minigame.fame, 0, Game.minigame.max_fame)
	if (self.missnotecon == 1 and not TableUtils.contains({"LOSETRANSITION", "LOSE"}, Game.minigame.state)) then
		local _susie = self.fixed_penalty ~= 0 and true or false
		
		if (not _susie and self.charts[1].invc <= 0) then
			Assets.playSound("hurt", 0.6, 0.9)
			
			if (_susie and self.fixed_penalty > 0) then
				if (self.charts[2].fade < 1 or self.fame > 2000) then
					self.fame = self.fame - self.fixed_penalty
					self.total_fame = self.total_fame - self.fixed_penalty
				end
			else
				local _penalty = ((self.fame <= 2000) and 100 or 200) * self.song.difficulty * self.fame_mul
				
				if (_susie and self.charts[1].fade == 1) then
					if (self.fame <= 2000) then
						_penalty = 0
					else
						_penalty = math.min(_penalty, self.fame - 2000)
					end
				end
				
				self.fame = self.fame - _penalty
				self.total_fame = self.total_fame - _penalty
				
				if (self.fame < 0) then
					if Game.minigame.state == "MAIN" then
						Game.minigame:setState("LOSETRANSITION")
					end
				end
			end
		end
		
		if (not _susie) then
			self.charts[1].combo = 0
		
			Game.minigame:setTrackActive(self.charts[1].track.name, false)
		end
		
		self.missnotecon = 2
		self.missnotetimer = 0
		
		if (not _susie and self.charts[1].invc <= 0) then
			self.hurt_counter = self.hurt_counter + 1
			self.song.miss_timer = 10
			
			if (self.charts[1].fade == 1) then
				self.charts[1].hurt_flash = 12
			end
			
			--[[with (performer)
				shakeamt = 10;]]
			
			if (self.hardmode) then
				self.charts[1].invc = 20
			else
				self.charts[1].invc = 60
			end
		end
		
		self.fixed_penalty = 0
	end
    super.update(self)
end

local function rectangle_points(mode,x,y,x2,y2)
    love.graphics.rectangle(mode, x, y, x2-x+1, y2-y+1)
end

local function fill_rectangle_points(x,y,x2,y2)
    return rectangle_points("fill", x, y, x2, y2)
end

function RhythmGame:drawQuitPrompt()
	local _font = Assets.getFont("main")
	love.graphics.setFont(_font)
	local _timer_tex = Assets.getFrames("ui/timer/timer")
	local easelerp = math.pow(self.instruction_lerp-1, 3) + 1
	local space = 28
	local xloc = -210 + 720 - (easelerp * 100)
	local yloc = 380 + 56
	local butoffset = 4
	local reddening = MathUtils.clamp(self.canceltimer / (self.canceltime * 1.2), 0, 1)
	local redcol = ColorUtils.mergeColor(COLORS.white, COLORS.red, reddening)
	if Input.usingGamepad() then
		local buttspr = Input.getTexture("menu")
		local str = "Hold      : Quit"
		local strwidth = _font:getWidth(str)
		Draw.setColor(redcol, 1)
		love.graphics.printfOutline(str, xloc - strwidth, yloc, 1)
		local strwithspace = " "..str
		local butxpos = xloc - _font:getWidth(strwithspace)
		local holdstr = " Hold "
		local holdstrwidth = _font:getWidth(holdstr)
		local butxoff = butxpos
        butxoff = butxoff + holdstrwidth
        butxpos = butxpos + 4
		Draw.draw(buttspr, butxoff, yloc + butoffset, 0, 2, 2)
		Draw.setColor(redcol, self.canceltimer/8)
		Draw.draw(_timer_tex[1 + math.floor(MathUtils.clamp((28 - ((self.canceltimer / self.canceltime) * 28)), 0, 28))], butxpos - 32, yloc + 4, 0, 2, 2)
	else
		local str = "Hold "..Input.getText("menu").." : Quit"
		local strwidth = _font:getWidth(str)
		Draw.setColor(redcol, self.canceltimer/8)
		Draw.draw(_timer_tex[1 + math.floor(MathUtils.clamp((28 - ((self.canceltimer / self.canceltime) * 28)), 0, 28))], xloc - MathUtils.round(strwidth) - 28 - 8, yloc + 3, 0, 2, 2)
		Draw.setColor(redcol, 1)
		love.graphics.printfOutline(str, xloc - strwidth, yloc, 1)
	end
	Draw.setColor(COLORS.white, 1)
end

function RhythmGame:draw()
	if not TableUtils.contains(self.rhythm_game_draw_states, Game.minigame.state) then 
		love.graphics.push()
		love.graphics.origin()
		if TableUtils.contains({"INITBLACK", "TRANSITION"}, Game.minigame.state) then
			Draw.setColor(COLORS.black)
			love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		elseif Game.minigame.state == "COUNTDOWN" then
			Draw.setColor(COLORS.black)
			love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Draw.setColor(COLORS.white)
			if self.countdown_text > 0 then
				local font = Assets.getFont("main")
				love.graphics.setFont(font)
				love.graphics.print(tostring(self.countdown_text), SCREEN_WIDTH/2 - font:getWidth(tostring(self.countdown_text))*1.5, SCREEN_HEIGHT/2-50, 0, 3, 3)
			end
		elseif TableUtils.contains({"RESULTSWAIT", "RESULTS"}, Game.minigame.state) then
			Draw.setColor(COLORS.white, 1)
			local star_bg_tex = Assets.getFrames("ui/tv_starbgtile/starbgtile")
			self.results_star_anim = self.results_star_anim + self.results_star_anim_speed * DTMULT
			self.results_bg_speed = self.results_bg_speed - self.results_bg_speed_max * DTMULT
			self.results_bg_speed_y = self.results_bg_speed_y + self.results_bg_speed_y_max * DTMULT
			if self.results_bg_speed < -SCREEN_WIDTH then
				self.results_bg_speed = self.results_bg_speed + SCREEN_WIDTH
			end
			if self.results_bg_speed_y > -SCREEN_HEIGHT then
				self.results_bg_speed_y = self.results_bg_speed_y - SCREEN_HEIGHT
			end
			Draw.drawWrapped(star_bg_tex[math.floor(self.results_star_anim % #star_bg_tex) + 1], true, true, self.results_bg_speed, self.results_bg_speed_y, 0, 2, 2);
			local font = Assets.getFont("8bit")
			love.graphics.setFont(font)
			if Game.minigame.state == "RESULTS" then
				local yy = 93
				local horizontalmargin = 140
				local indent = 40
				local leftx = horizontalmargin + self.graphics.shake_x
				local rightx = SCREEN_WIDTH - horizontalmargin + self.graphics.shake_x
				local midx = SCREEN_WIDTH/2 + self.graphics.shake_x
				local mspace = 32
				local title = "CONCERT RESULTS"
				self:drawResultsText(title, midx - font:getWidth(title)/2, yy)
				self:drawResultsSprite(self.pixel, midx - MathUtils.round(font:getWidth(title)/2) - 10, yy + 9, 0, -80, 2)
				self:drawResultsSprite(self.pixel, midx + MathUtils.round(font:getWidth(title)/2) + 10 - 2, yy + 9, 0, 80, 2)
				if self.state_timer > 28 then
					Draw.setColor(ColorUtils.hexToRGB("#FF3396"), 1)
					local misnot = "MISSED NOTES"
					self:drawResultsText(misnot, leftx, yy + mspace * 1)
					local num = tostring(MathUtils.round(self.miss))
					self:drawResultsText(num, rightx - font:getWidth(num), yy + mspace * 1)
				end
				if self.state_timer > 42 then
					Draw.setColor(COLORS.white, 1)
					local normnotes = "NORMAL NOTES"
					self:drawResultsText(normnotes, leftx, yy + mspace * 2)
					local num = tostring(MathUtils.round(self.good))
					self:drawResultsText(num, rightx - font:getWidth(num), yy + mspace * 2)
				end
				if self.state_timer > 56 then
					Draw.setColor(COLORS.yellow, 1)
					local golno = "GOLD NOTES"
					self:drawResultsText(golno, leftx, yy + mspace * 3)
					local num = tostring(MathUtils.round(self.great))
					self:drawResultsText(num, rightx - font:getWidth(num), yy + mspace * 3)
				end
				if self.state_timer > 70 then
					Draw.setColor(COLORS.white, 1)
					local longcom = "LONGEST COMBO"
					self:drawResultsText(longcom, leftx, yy + mspace * 4)
					local num = tostring(MathUtils.round(self.max_combo))
					self:drawResultsText(num, rightx - font:getWidth(num), yy + mspace * 4)
					if self.max_combo >= #self.song.tracks.lead.notes then
						Draw.setColor(COLORS.yellow, 1)
						local fullclear = "FULL CLEAR!"
						self:drawResultsText(fullclear, rightx - 30, yy + 20 + mspace * 4, -math.rad(20), 0.5, 0.5)
					end
				end
				if self.state_timer > 84 then
					Draw.setColor(COLORS.white, 1)
					local totalscore = "TOTAL SCORE"
					self:drawResultsText(totalscore, leftx, yy + mspace * 5)
				end
				if self.state_timer > 98 then
					Draw.setColor(COLORS.white, 1)
					local num = tostring(MathUtils.round(self.results_current_points))
					self:drawResultsText(num, rightx - font:getWidth(num), yy + mspace * 5)
				end
				if self.results_grade_con >= 1 then
					local shadcolor = ColorUtils.hexToRGB("#060B3C")
					local shadalph = 0.65
					local shadoff = 2
					Draw.setColor(shadcolor, shadalph)
					love.graphics.print(self.results_grade, SCREEN_WIDTH/2 + shadoff - (font:getWidth(self.results_grade)/2)*3, yy + (mspace * 6) + shadoff + 10, 0, 3, 3)
					Draw.setColor(COLORS.white, 1)
					local text_canvas = Draw.pushCanvas(font:getWidth(self.results_grade), font:getHeight(self.results_grade), { stencil = false })
					love.graphics.print(self.results_grade, 0, 0, 0, 1, 1)
					Draw.popCanvas(true)
					local shader = Kristal.Shaders["GradientV"]
					Draw.pushShader(shader)
					shader:sendColor("from", COLORS.yellow)
					shader:sendColor("to", COLORS.white)
					Draw.draw(text_canvas, SCREEN_WIDTH/2 - (font:getWidth(self.results_grade)/2)*3, yy + (mspace * 6) + 10, 0, 3, 3)
					Draw.popShader()
				end
				if self.results_grade_con >= 2 then
					local pressanybutton = "PRESS ANY BUTTON"
					self.results_reachedend_draw_triangle_siner = self.results_reachedend_draw_triangle_siner + 0.3 * DTMULT
					local _flashcol = ColorUtils.mergeColor(COLORS.white, COLORS.yellow, 0.4 + math.sin(self.results_reachedend_draw_triangle_siner) / 3)
					Draw.setColor(_flashcol, 1)
					self:drawResultsText(pressanybutton, SCREEN_WIDTH/2 - font:getWidth(pressanybutton)/2, yy + mspace * 8.5)
				end
			end
			Draw.setColor(COLORS.black, self.results_fade / 30)
			fill_rectangle_points(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Draw.setColor(COLORS.white, 1)
		elseif self.state == "LOSE" then
			local static_tex = Assets.getFrames("ui/static/static_effect")
			local lightColor = ColorUtils.hexToRGB("#A2B6C7")
			local darkColor = ColorUtils.hexToRGB("#493F5F")
			local shader = Assets.getShader("tone")
			Draw.pushShader(shader)
			shader:send("saturation", self.lose_tone_saturation)
			shader:send("brightness", self.lose_tone_brightness)
			shader:send("tone_factor", self.lose_tone_factor)
			shader:sendColor("tone_dark", darkColor)
			shader:sendColor("tone_light", lightColor)
			Draw.draw(self.lose_screenshot)
			Draw.popShader()
			Draw.setColor(COLORS.gray, self.lose_grayalpha)
			fill_rectangle_points(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Draw.setColor(COLORS.white, self.lose_staticalpha)
			self.lose_staticindex = self.lose_staticindex + 0.25 * DTMULT
			Draw.drawWrapped(static_tex[math.floor((self.lose_staticindex - 0.5) % #static_tex) + 1], true, true, 0, 0, 0, 2, 2)
			Draw.drawWrapped(static_tex[math.floor(self.lose_staticindex % #static_tex) + 1], true, true, 0, 0, 0, 2, 2)
			if self.lose_draw_menu then
				local heart_tex = Assets.getTexture("player/heart_outline2")
				Draw.setColor(Game:getSoulColor())
				Draw.draw(heart_tex, 277, self.lose_menu_choice == 1 and 206 or 238)
				Draw.setColor(self.lose_menu_choice == 1 and COLORS.yellow or COLORS.white)
				love.graphics.printfOutline("Retry", 300, 200, 2)
				Draw.setColor(self.lose_menu_choice == 2 and COLORS.yellow or COLORS.white)
				love.graphics.printfOutline("Quit", 300, 232, 2)
			end
			Draw.setColor(COLORS.black, self.lose_blackalpha)
			fill_rectangle_points(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Draw.setColor(COLORS.white, 1)
		end
		super.draw(self)
		love.graphics.pop()
		return
	end
    self.song:drawBackground()
    super.draw(self)
	if (self.current_lyric ~= "" and self.song.tracks.vocals and #self.song.lyrics_data > 0) then
		local _len = StringUtils.len(self.clean_lyric)
		local _len2, _ = 0
		
		if StringUtils.contains(self.clean_lyric, "\n") then
			_len, _ = string.find(self.clean_lyric, "\n", 1) - 1
			_len2 = StringUtils.len(self.clean_lyric) - (_len + 1)
		end
		
		local _textx = 320
		local _texty = 420
		local _maxlength = #self.lyric_data
		local _current_note = math.max(1, _maxlength)
		local _lerp = 1
		love.graphics.setFont(self.lyrics_font)
		
		if (self.update_lyrics) then
			local _lyric_start_time = math.max(0, self.song.lyrics_data[self.lyrics_index - 1].time)
			
			for i = self.lyric_start_index, #self.song.tracks.vocals.notes do
				if ((_lyric_start_time + 0.03) < self.song.tracks.vocals.notes[i].noteend) then
					self.lyric_start_index = i
					break
				end
			end
			
			local _hspace = 16
			self:drawLyricTextMonospace(_textx, _texty, self.censored_lyric, _hspace, 36, _len, true, 2, 2, _len2)
			_maxlength = #self.lyric_data
			_current_note = math.max(1, _maxlength)
			self.lyric_canvas[1] = Draw.pushCanvas(640, 100)
			love.graphics.clear()
			Draw.setColor(COLORS.white)
			self:drawLyricTextMonospace(320, 50, self.current_lyric, _hspace, 36, _len, false, 2, 2, _len2)
			Draw.popCanvas(true)
			self.lyric_canvas[2] = Draw.pushCanvas(640, 100)
			love.graphics.clear()
			self:drawLyricTextMonospace(320, 50, self.censored_lyric, _hspace, 36, _len, false, 2, 2, _len2)
			Draw.popCanvas(true)
			self.update_lyrics = false
		end
		
		for i = 1, _maxlength do
			local _index = i - 1 + self.lyric_start_index
			
			if (_index >= #self.song.tracks.vocals.notes + 1) then
				break
			end
			
			if (self.trackpos < self.song.tracks.vocals.notes[_index].noteend) then
				_current_note = MathUtils.clamp(i, 1, _maxlength)
				_lerp = MathUtils.clamp(MathUtils.inverseLerp(self.song.tracks.vocals.notes[_index].notetime, self.song.tracks.vocals.notes[_index].noteend, self.trackpos), 0, 1)
				break
			end
		end
		
		local _progress = MathUtils.lerp(self.lyric_data[_current_note].start, self.lyric_data[_current_note]._end, _lerp)
		
		if (_current_note <= 1 and self.trackpos < self.song.tracks.vocals.notes[self.lyric_start_index].notetime) then
			_progress = _textx - 320
		end
		
		love.graphics.stencil(function()
			love.graphics.clear()
			if (_len2 > 0) then
				if (_current_note < self.line_switch) then
					fill_rectangle_points(_progress, _texty - 48, _textx + 320, _texty)
					fill_rectangle_points(_textx - 320, _texty, _textx + 320, _texty + 48)
				else
					fill_rectangle_points(_progress, _texty, _textx + 320, _texty + 48)
				end
			else
				fill_rectangle_points(_progress, _texty - 24, _textx + 320, _texty + 24)
			end
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(COLORS.black)
		Draw.draw(self.lyric_canvas[1], _textx - 2, _texty, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[1], _textx + 2, _texty, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[1], _textx, _texty - 2, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[1], _textx, _texty + 2, 0, 1, 1, 320, 50)
		Draw.setColor(COLORS.white)
		Draw.draw(self.lyric_canvas[1], _textx, _texty, 0, 1, 1, 320, 50)
		love.graphics.stencil(function()
			love.graphics.clear()
			if (_len2 > 0) then
				if (_current_note < self.line_switch) then
					fill_rectangle_points(_textx - 320, _texty - 48, _progress, _texty)
				else
					fill_rectangle_points(_textx - 320, _texty - 48, _textx + 320, _texty)
					fill_rectangle_points(_textx - 320, _texty, _progress, _texty + 48)
				end
			else
				fill_rectangle_points(_textx - 320, _texty - 24, _progress, _texty + 24)
			end
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(COLORS.white)
		Draw.draw(self.lyric_canvas[2], _textx - 2, _texty, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[2], _textx + 2, _texty, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[2], _textx, _texty - 2, 0, 1, 1, 320, 50)
		Draw.draw(self.lyric_canvas[2], _textx, _texty + 2, 0, 1, 1, 320, 50)
		Draw.setColor(COLORS.blue)
		Draw.draw(self.lyric_canvas[2], _textx, _texty, 0, 1, 1, 320, 50)
		love.graphics.setStencilTest()
	end
    for _, value in pairs(self.charts) do
        if value then
			if value.performer then
				value.performer.visible = true
				value.performer:fullDraw()
				value.performer.visible = false
			end
		end
	end
	self.song:drawOverlay()
	if self.state == "RESULTSTRANSITION" then
		Draw.setColor(COLORS.white, 1)
		local star_bg_tex = Assets.getFrames("ui/tv_starbgtile/starbgtile")
		local _x, _y = 0, 0
		self.results_star_anim = self.results_star_anim + self.results_star_anim_speed * DTMULT
		self.results_bg_x_extra = self.results_bg_x_extra - 3 * DTMULT
		for i = 1, 6 do
			for j = 1, 5 do
				Draw.draw(star_bg_tex[math.floor(self.results_star_anim % #star_bg_tex) + 1], (_x * 160) + self.results_bg_x_extra, (_y * 160) + self.results_bg_y - 320, 0, 2, 2);
				_y = _y + 1;
			end
			_x = _x + 1;
			_y = 0;
		end    
	else
		if self.state ~= "LOSETRANSITION" then
			self:drawQuitPrompt()
		end
	end
end

function RhythmGame:cleanLyric(text)
	local final_lyric = ""
	local i = 1
    while i < StringUtils.len(text) + 1 do
        local _letter = StringUtils.sub(text, i, i)
        if (_letter == "[") then
            i = i + 3
            _letter = StringUtils.sub(text, i, i)
        elseif (_letter == "]") then
            goto continue
        end
        
        if (_letter ~= "-") then
			final_lyric = final_lyric .. _letter
		end
		::continue::
		i = i + 1
    end
	return final_lyric
end

function RhythmGame:drawLyricTextMonospace(x, y, text, hspace, vspace, length, timing, xscale, yscale, linearg, halignment, valignment)
	local _halignment = halignment or "center"
	local _valignment = valignment or "middle"
	local linearg = linearg or -1
	local length = length or -1
    local _length = (length > 0) and length or StringUtils.len(text)
    local _writex = x
    local _writey = y
    local hspace = hspace or 8
    local vspace = vspace or 18
    local _width = _length * hspace
    local _hspace = hspace
    local _vspace = vspace
    local _height = self.lyrics_font:getHeight(text) * yscale
    local _linebreak = StringUtils.contains(text, "\n") and string.find(text, "\n", 1) or 0
    local _single = false
    
    if (_linebreak > 0) then
        _writey = _writey - ((_vspace / 2) - 6)
        
        if (length == 0) then
            _length = length - 1
        end
		
        if (linearg == 0) then
            _width = (_linebreak - 1) * hspace
		end
    end
    
    local _timing = timing or false
    
    if (_timing) then
        self.lyric_data = {}
        self.line_switch = 0
    end
    
    local _index = 1
    local _midword = false
    
    if (_halignment == "center") then
        _writex = _writex + ((-_width / 2) + (hspace / 2))
    elseif (_halignment == "right") then
        _writex = _writex + (-_width + hspace)
	end    
    if (_valignment == "middle") then
        _writey = _writey + (-_height / 2)
    elseif (_valignment == "bottom") then
        _writey = _writey + (-_height)
	end
    
    local _scale = 1
    local _prealign = true
    
	local i = 1
    while i < StringUtils.len(text) + 1 do
        local _letter = StringUtils.sub(text, i, i)
        
        if (_prealign) then
            if (_letter == " ") then
                _length = _length - 1
                _writex = _writex - hspace
                goto continue
            else
                _prealign = false
            end
        end
        
        if (_letter == "[") then
            i = i + 1
            local _subscale = tonumber(StringUtils.sub(text, i, i))
            i = i + 2
            local _subcount = 0
            
            for i2 = i, StringUtils.len(text) do
                local _subletter = StringUtils.sub(text, i2, i2)
                
                if (_subletter == "]") then
                    break
                elseif (_subletter ~= "-") then
                    _subcount = _subcount + 1
				end
            end
            
            _scale = _subscale / _subcount
            _hspace = hspace * _scale
            _writex = _writex + (-(hspace / 2) + (_hspace / 2))
            _letter = StringUtils.sub(text, i, i)
        elseif (_letter == "]") then
            _scale = 1
            _writex = _writex + ((-_hspace / 2) + (hspace / 2))
            _hspace = hspace
            goto continue
        end
        
        if (_letter == " ") then
            if (_midword and _timing) then
				if _index ~= #self.lyric_data then
					table.insert(self.lyric_data, {start = 0, _end = 1})
				end
                self.lyric_data[_index]._end = (_writex - (_hspace / 2)) + 2
                _index = _index + 1
                _midword = false
            end
        elseif (_letter == "-") then
            if (_timing) then
				if _index ~= #self.lyric_data then
					table.insert(self.lyric_data, {start = 0, _end = 1})
				end
                self.lyric_data[_index]._end = (_writex - (_hspace / 2)) + 2
                _index = _index + 1
				if _index ~= #self.lyric_data then
					table.insert(self.lyric_data, {start = 0, _end = 1})
				end
                self.lyric_data[_index].start = (_writex - (_hspace / 2)) + 2
            end
            goto continue
        elseif (_letter == "\n") then
            if (_timing) then
                if (_midword) then
                    _midword = false
					if _index ~= #self.lyric_data then
						table.insert(self.lyric_data, {start = 0, _end = 1})
					end
                    self.lyric_data[_index]._end = (_writex - (_hspace / 2)) + 6
                    _index = _index + 1
                end                
                self.line_switch = _index
            end            
            _writey = y + ((_vspace / 2) - 6)
            
            if (linearg > 0) then
                _length = linearg
            else
                _length = ((length > 0) and length or StringUtils.len(text)) - _linebreak
			end
            
            _width = _length * hspace
            _writex = (x - (_width / 2)) + (hspace / 2)
            goto continue
        else
			if (not _midword and _timing) then
				if _index ~= #self.lyric_data then
					table.insert(self.lyric_data, {start = 0, _end = 1})
				end
                self.lyric_data[_index].start = _writex - (_hspace / 2) - 2
                _midword = true
            end
            
			if (not _timing) then
				love.graphics.print(_letter, _writex - ((self.lyrics_font:getWidth(_letter) * (_scale * xscale))/2), _writey, 0, _scale * xscale, yscale)
			end
		end
        _writex = _writex + _hspace
		::continue::
		i = i + 1
    end
    
    if (_midword and _timing) then
		if _index ~= #self.lyric_data then
			table.insert(self.lyric_data, {start = 0, _end = 1})
		end
        self.lyric_data[_index]._end = (_writex - (hspace / 2)) + 6
    end
end

function RhythmGame:tell(_use_solo)
    if self.overrun < 0 then
        return self.overrun
    end
	local use_solo = self.song.solos_active
	if _use_solo ~= nil then
		use_solo = _use_solo
	end
	if self.song.has_multi_solos and use_solo then
		for _, value in pairs(self.song.solo_tracks) do
			if value.source then
				return value.source:tell()
			end
		end
	else
		for _, value in pairs(self.song.tracks) do
			if value.source then
				return value.source:tell()
			end
		end
	end
    return 0
end

function RhythmGame:seek(t, _use_solo)
    if self.overrun < 0 and not self.instant_start then
		self.instant_start = true
        self.song:start()
        self.overrun = 0
    end
	local use_solo = self.song.solos_active
	if _use_solo ~= nil then
		use_solo = _use_solo
	end
	if self.song.has_multi_solos and use_solo then
		for _, value in pairs(self.song.solo_tracks) do
			if value.source then
				value.source:seek(t)
			end
		end
	else
		for _, value in pairs(self.song.tracks) do
			if value.source then
				value.source:seek(t)
			end
		end
	end
end

function RhythmGame:setTrackActive(trackid, active)
    local track = assert((self.song.has_multi_solos and self.song.solos_active) and self.song.solo_tracks[trackid] or self.song.tracks[trackid], "Unknown track: "..trackid)
    if track.replace then
        self:setTrackActive(track.replace, not active)
    end
    if not track.source then return end
    track.source:setVolume(active and 1 or 0)
end

function RhythmGame:setSoloActive(active)
	if not self.song.has_multi_solos then return end
	for index, value in pairs(self.song.tracks) do
		if self.song.solo_tracks[index] and self.song.solo_tracks[index].source then
			if active then
				self.song.solo_tracks[index].source:setVolume(value.source:getVolume())
				value.source:setVolume(0)
			else
				value.source:setVolume(self.song.solo_tracks[index].source:getVolume())
				self.song.solo_tracks[index].source:setVolume(0)
			end
		end
	end
	self.song.solos_active = active
end

return RhythmGame