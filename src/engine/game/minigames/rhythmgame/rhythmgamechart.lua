---@class RhythmGameChart: Object
---@field track RhythmGameSong.track
---@field song RhythmGameSong
local RhythmGameChart, super = Class(Object)

local a_single_pixel_data = love.image.newImageData(1,1)
a_single_pixel_data:setPixel(0, 0, {1,1,1,1})
RhythmGameChart.pixel = love.graphics.newImage(a_single_pixel_data)

function RhythmGameChart:init(instrument, index, position, track, song)
    super.init(self, 170 + ((((position+1)/2) - 1) * 300), 290, 80, 250)
    self.track = track
	self.orig_track = TableUtils.copy(track, true)
	self.position = position or 0
    self.party = Game.party[index or 1]
    self.origin_x = 0.5
    self.origin_y = 1
    self.remtrackpos = {0,0,0,0,0}
    self.song_initialized = 0
    self.loadsong = 1
    self.missnotetimer = 0
    self.missnotecon = 0
    self.invc = 0
    self.hurt_flash = 0
    self.minnote = 1
    self.trackpos = 0
    self.buffer = {0,0,0}
    self.pressedtimer = {10, 10, 10}
    self.song = song
    self.startoffset = 0
    self.lineA = 0
    self.lineB = 0
    self.oneAtATime = true
    self.hold_start = {0,0,0}
    self.hold_end = {0,0,0}
    self.heldnote = {nil,nil,nil}
    self.hold_score = 0
    self.score_scale = 2
    self.auto_play = instrument ~= 1
    self.combo = 0
    self.loop = false
    self.last_score = {0, 0, 0, 0, 0}
    self.chart_start = 0
    self.chart_end = 0
    self.goodScore = 0
    self.maxScore = 0
    self.track1 = -1
    self.track2 = -1
    self.track1_instance = -1
    self.track2_instance = -1
    self.instrument = MathUtils.clamp(instrument - 1, 0, 2)
    self.bottomy = -100
    self.note_hit_timer = {0,0,0}
    self.note_hit_score = {0,0,0}
    self.masher = 0
    self.con = -1
    self.mash_hit = -1
    self.mash_speed = 3
    self.cooldown = 0
    self.current_note = 1
    self.last_note = 0
    self.fade = 1
    self.notex = 1
    self.note_streak = 0
    self.trackstart = 0
    self.track_length = song.track_length or 135.652
    self.paused = false
    self.rhythmgame = -4
    -- TODO: Make accurate
    self.brightness = 1
    self.target_brightness = 1
    self.camy = 0
    self.camx = 0
	self.confidence = 1
	self.conf_decay = 0
	self.demo_mode = false
	self.clapping = false
	self.button_alpha = 9
	self.button_swap = false
	self.leftcheck = false
	self.rightcheck = false
end

local function rectangle_points(mode,x,y,x2,y2)
    love.graphics.rectangle(mode, x, y, x2-x+1, y2-y+1)
end

local function fill_rectangle_points(x,y,x2,y2)
    return rectangle_points("fill", x, y, x2, y2)
end

function RhythmGameChart:resetChart()
	TableUtils.clear(self.track)
	self.track = TableUtils.copy(self.orig_track, true)
    self.remtrackpos = {0,0,0,0,0}
    self.song_initialized = 0
    self.loadsong = 1
    self.missnotetimer = 0
    self.missnotecon = 0
    self.invc = 0
    self.hurt_flash = 0
    self.minnote = 1
    self.trackpos = 0
    self.buffer = {0,0,0}
    self.pressedtimer = {10, 10, 10}
    self.startoffset = 0
    self.lineA = 0
    self.lineB = 0
    self.oneAtATime = true
    self.hold_start = {0,0,0}
    self.hold_end = {0,0,0}
    self.heldnote = {nil,nil,nil}
    self.hold_score = 0
    self.score_scale = 2
    self.combo = 0
    self.loop = false
    self.last_score = {0, 0, 0, 0, 0}
    self.chart_start = 0
    self.chart_end = 0
    self.goodScore = 0
    self.maxScore = 0
    self.bottomy = -100
    self.note_hit_timer = {0,0,0}
    self.note_hit_score = {0,0,0}
    self.masher = 0
    self.con = -1
    self.mash_hit = -1
    self.mash_speed = 3
    self.cooldown = 0
    self.current_note = 1
    self.last_note = 0
    self.fade = 1
    self.notex = 1
    self.note_streak = 0
    self.trackstart = 0
    self.paused = false
    self.rhythmgame = -4
    self.brightness = 1
    self.target_brightness = 1
    self.camy = 0
    self.camx = 0
	self.confidence = 1
	self.conf_decay = 0
	self.demo_mode = false
	self.clapping = false
	self.button_alpha = 9
	self.button_swap = false
	self.leftcheck = false
	self.rightcheck = false
end

function RhythmGameChart:draw()
	if not TableUtils.contains(Game.minigame.rhythm_game_draw_states, Game.minigame.state) then 
		return
	end
    if (self.brightness ~= self.target_brightness) then
        self.brightness = MathUtils.approach(self.brightness, self.target_brightness, 0.025 * DTMULT)
    end
    self:drawBacking(self.song.notespeed, 40, DEBUG_RENDER)
    self:drawCombo(40)
	if self.button_alpha > 0 and not self.auto_play then
		local _buttonalpha = 1		
        if self.button_alpha > 0 then
            self.button_alpha = self.button_alpha - 0.05 * DTMULT
		end
		_buttonalpha = math.max(0, self.button_alpha)
		self:drawButtons(40, COLORS.white, _buttonalpha)
	end
    self:drawChart(self.song.notespeed, 40, DEBUG_RENDER)
	if TableUtils.contains({"LOSETRANSITION", "LOSE"}, Game.minigame.state) and not self.auto_play then
		love.graphics.setBlendMode("multiply", "premultiplied")
		Draw.setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.white, self.fade), 1)
		fill_rectangle_points(0, self.bottomy - 200, 80, self.bottomy + 50)
		love.graphics.setBlendMode("alpha", "alphamultiply")
	end
    self:drawBorder(40, DEBUG_RENDER)
end

function RhythmGameChart:drawCombo(centerx)
	if self.combo > 0 then
		local font = Assets.getFont("main")
		love.graphics.setFont(font)
		local _combotext = self.combo > 999 and "BIG" or tostring(self.combo)
        local combo_number_canvas = Draw.pushCanvas(font:getWidth(_combotext), font:getHeight(_combotext), { stencil = false })
        Draw.setColor(COLORS.white)
        love.graphics.print(_combotext, 0, 0, 0, 1, 1)
        Draw.popCanvas(true)
        local combo_text_canvas = Draw.pushCanvas(font:getWidth("COMBO"), font:getHeight("COMBO"), { stencil = false })
        love.graphics.print("COMBO", 0, 0, 0, 1, 1)
        Draw.popCanvas(true)
		local shader = Kristal.Shaders["GradientV"]
        Draw.pushShader(shader)
        Draw.setColor(COLORS.white, 0.25)
		local _topgray = ColorUtils.hexToRGB("#666666")
		local _midgray = ColorUtils.hexToRGB("#BBBBBB")
		local _bottomgray = ColorUtils.hexToRGB("#DDDDDD")
        shader:sendColor("from", _topgray)
        shader:sendColor("to", _midgray)
		Draw.draw(combo_number_canvas, centerx + 2 - ((font:getWidth(_combotext)/2)*(self.combo >= 100 and 1.75 or 2.5)), self.bottomy - 121, 0, self.combo >= 100 and 1.75 or 2.5, 2.5)
        shader:sendColor("from", _midgray)
        shader:sendColor("to", _bottomgray)
		Draw.draw(combo_text_canvas, centerx + 2 - font:getWidth("COMBO")/2, self.bottomy - 60, 0, 1, 1)
		Draw.popShader()
        Draw.setColor(COLORS.white, 1)
	end
end

function RhythmGameChart:drawButtons(centerx, color, alpha)
	local _swap = self.button_swap
	local _ll = _swap and "cancel" or "confirm"
	local _rr = _swap and "confirm" or "cancel"
	local _played = false
	Draw.setColor(color, alpha)
	if Input.usingGamepad() then
		local _played = self.note_hit_timer[1] > 0 and true or false
		local _input_spr = Input.getTexture(_ll)
		Draw.draw(_input_spr, centerx - 104 + (self.song.chart_ease * 34), self.bottomy - 8 + (_played and 2 or 0), 0, 2, 2)
		_played = self.note_hit_timer[2] > 0 and true or false
		_input_spr = Input.getTexture(_rr)
		Draw.draw(_input_spr, centerx + 81 - (self.song.chart_ease * 34), self.bottomy - 8 + (_played and 2 or 0), 0, 2, 2)
	else
		local _font = Assets.getFont("main")
		local _input_name = Input.getText(_ll)
		local _played = self.note_hit_timer[1] > 0 and true or false
		local _buttonx = centerx - 80 + (self.song.chart_ease * 34)
		local _buttony = self.bottomy - 16 + (_played and 2 or 0)
		Draw.setColor(_played and COLORS.yellow or COLORS.white, alpha)
		love.graphics.printfOutline(_input_name, _buttonx - _font:getWidth(_input_name), _buttony, 2)
		_input_name = Input.getText(_rr)
		_played = self.note_hit_timer[2] > 0 and true or false
		_buttonx = centerx + 82 - (self.song.chart_ease * 34)
		_buttony = self.bottomy - 16 + (_played and 2 or 0)
		Draw.setColor(_played and COLORS.yellow or COLORS.white, alpha)
		love.graphics.printfOutline(_input_name, _buttonx, _buttony, 2)
	end
	Draw.setColor(COLORS.white, 1)
end

function RhythmGameChart:drawBacking(notespeed, centerx, debug, mysteryunusedargument)
    love.graphics.setLineWidth(1)
    debug = debug or false
    mysteryunusedargument = mysteryunusedargument or 0

    self.brightness = self.brightness

    if (self.fade == 1 and self.brightness == 1) then
        Draw.setColor(COLORS.gray)
    else
        Draw.setColor(ColorUtils.mergeColor(COLORS.black, COLORS.gray, self.fade * self.brightness))
    end

    local _gray = ColorUtils.mergeColor(COLORS.black, COLORS.gray, self.brightness)
    Draw.setColor(COLORS.black)
    local _flash = 0
    local _ts = self.song:getTimeSignature()
    local _bpm = self.song:getBPM()
    local _posoffset = self.startoffset	
    local _rts = math.max(4, math.floor(self.song:getTimeSignature()))

    if (self.invc > 0 and self.fade == 1) then
        _flash = MathUtils.rangeMap(self.hurt_flash, 0, 6, 0, 1)
    end

    Draw.setColor(COLORS.black, 0.75)    
    -- fill_rectangle_points(10, 10, 20, 20)
    -- print(centerx - 40, self.bottomy - 200, centerx + 40, self.bottomy + 50)
    fill_rectangle_points(centerx - 40, self.bottomy - 200, centerx + 40, self.bottomy + 50)
    Draw.setColor(COLORS.black, 1)
    love.graphics.setBlendMode("alpha")
    local _lead = MathUtils.floorToMultiple(16, _ts)
    local _lead_num = _lead / _ts
    local whitebar = -1
    if (self.song.signature_index ~= 1 and self.song.bpm_index ~= 1) then
        _posoffset = math.max(self.song.bpm_data[self.song.bpm_index].time, self.song.signature_data[self.song.signature_index].time)
    elseif (self.song.signature_index ~= 1) then
        _posoffset = self.song.signature_data[self.song.signature_index].time
    elseif (self.song.bpm_index ~= 1) then
        _posoffset = self.song.bpm_data[self.song.bpm_index].time
	end
    local linegap = notespeed * self.song.notespacing
    local linestart = self.bottomy + (((self.trackpos - _posoffset) % (self.song.notespacing * _ts)) * notespeed)
    local whitebarstart = (self.bottomy - linegap) + (((self.trackpos - _posoffset) % (self.song.notespacing * _ts)) * notespeed)
    Draw.setColor(_gray)
    local liney = linestart
    local _bpm_changed = true
    local _next_bpm = _bpm
    local _next_bpm_time = -1
    
    if (#self.song.bpm_data > 1 and self.song.bpm_index < #self.song.bpm_data) then
        _next_bpm = self.song.bpm_data[self.song.bpm_index + 1].change
        _next_bpm_time = self.song.bpm_data[self.song.bpm_index + 1].time
        _bpm_changed = false
    end
    
    local nextBar = math.floor(self.trackpos / self.song.meter)
    local _ts_changed = true
    local _next_ts = _ts
    local _next_ts_time = -1
    
    if (#self.song.signature_data > 1 and self.song.signature_index < #self.song.signature_data) then
        _next_ts = self.song.signature_data[self.song.signature_index + 1].change
        _next_ts_time = self.song.signature_data[self.song.signature_index + 1].time
        _ts_changed = false
    end

    local _barcount = 0
    local _pregap = linegap
    
    if (self.song.bpm_index > 1 and ((self.trackpos + ((self.bottomy - liney) / notespeed)) - 0.5) < self.song.bpm_data[self.song.bpm_index].time) then
        _pregap = (60 / self.song.bpm_data[self.song.bpm_index - 1].change) * notespeed
	end
    
    if (self.song.signature_index > 1) then
        local _last_ts = _ts
        
        if ((self.trackpos - 0.5) < self.song.signature_data[self.song.signature_index].time) then
            _last_ts = self.song.signature_data[self.song.signature_index - 1].change
        end
		
        if ((_last_ts % 1) ~= 0) then
            liney = liney - (linegap / 2)
		end
    end
    
    for i = 0, _rts do
        liney = liney + _pregap
        
        if (not debug and (liney + 1) > (self.bottomy + 50)) then
            break
		end
        
        love.graphics.line(centerx - 40, liney, centerx + 40, liney)
    end
	
    liney = linestart
    local _eighths = (_ts % 1) == 0.5 and true or false
    local _oddts = false
    
    if (_eighths) then
        if (((self.trackpos - self.song.signature_data[self.song.signature_index].time) % (_ts * 2)) >= _ts) then
            _oddts = true
		end
    end
    
	if debug then
		love.graphics.setFont(Assets.getFont("main", 16))
	end
    for i = 0, math.max(20, _rts * 2) do
        if (i > 0) then
            liney = liney - linegap
		end
        if (not debug and (liney - 1) < (self.bottomy - 202)) then
            if (not (_eighths and _barcount <= 0 and ((liney - 1) + (linegap / 2)) > (self.bottomy - 202))) then
                break
			end
        elseif (not debug and (liney + 1) > (self.bottomy + 50)) then
            if (_barcount <= 0) then
                _barcount = _ts - 1
            else
                _barcount = _barcount - 1
            end
            goto continue
        end
        
        if (_barcount <= 0) then
            if (_eighths) then
                if (i ~= 0) then
                    liney = liney + (linegap / 2)
				end
            end
            
            fill_rectangle_points(centerx - 40, liney - 1, centerx + 40, liney + 1)
            local linetime = self.trackpos + ((self.bottomy - liney) / notespeed)
			
            if (debug) then
				love.graphics.print(tostring(math.floor(nextBar + (i / _ts) + 1)), centerx - 60, liney - 1 - 8, 0)
				love.graphics.print(tostring(math.floor(linetime)), centerx + 60, liney - 1 - 8)
			end
            
            if (not _ts_changed and (linetime + 0.5) > _next_ts_time) then
                _ts = _next_ts
                _ts_changed = true
            end
            
            if (not _bpm_changed and (linetime + 0.5) > _next_bpm_time) then
                if (debug) then
					local arrow_tex = Assets.getTexture("ui/arrow_9x9")
                    Draw.draw(arrow_tex, centerx + 100, (liney - 1 - 1) + 2, 0, (_next_bpm > _bpm) and -1 or 1, arrow_tex:getWidth()/2, arrow_tex:getHeight()/2)
					love.graphics.print(tostring(_next_bpm).." BPM", centerx + 110, liney - 1 - 8)
				end
                
                _bpm_changed = true
                _bpm = _next_bpm
                linegap = (60 / _bpm) * notespeed
            end
            
            _barcount = _ts - 1
        else
            _barcount = _barcount - 1
            love.graphics.line(centerx - 40, liney, centerx + 40, liney)
        end
        ::continue::
    end

    if (_flash > 0) then
        love.graphics.setBlendMode("add", "alphamultiply")
        local _flashCol = ColorUtils.mergeColor(COLORS.black, COLORS.red, _flash * self.fade * self.brightness, 0, 1)
        Draw.setColor(_flashCol, 1)
		
        love.graphics.setShader(Kristal.Shaders["GradientV"])
        love.graphics.setColor(COLORS.white)
        Kristal.Shaders["GradientV"]:sendColor("from", COLORS.black)
        Kristal.Shaders["GradientV"]:sendColor("to", _flashCol)
        love.graphics.draw(self.pixel, centerx - 40, self.bottomy - 200, 0, 81, 251)
		--ossafe_fill_rectangle_color(arg1 - 40, bottomy - 200, arg1 + 40, bottomy + 50, c_black, c_black, _flashCol, _flashCol, false);
        love.graphics.setBlendMode("alpha", "alphamultiply")
		love.graphics.setShader()
    end

    Draw.setColor(COLORS.white)
end

function RhythmGameChart:getNoteColor(n)
    if self.party.note_colors then
        return self.party.note_colors[n]
    end
    if self.party.icon_color then
        return self.party.icon_color
    end
    return self.party.color
end

function RhythmGameChart:drawBorder(arg0, arg1)
    local _bordercolor = self:getNoteColor(2)
    
    if (self.invc > 0) then
        _bordercolor = ColorUtils.mergeColor(self:getNoteColor(2), COLORS.red, self:damageFlash())
    end
    
    Draw.setColor(COLORS.black, 0.5)
    love.graphics.setLineStyle("rough")
    local w = 1
    love.graphics.setLineWidth(w*2)
    rectangle_points("line", arg0 - 40 + 2 - w, self.bottomy + 2 - 200 - w, arg0 + 40 + 2 + w, self.bottomy + 50 + 2 + w)
    Draw.setColor(ColorUtils.mergeColor(COLORS.black, _bordercolor, self.brightness), 1)
    if (not arg1 and not self.demo_mode) then
        local _hurt = (self.invc > 50 or self:damageFlash() > 0) and true or false
        local hoff = self.party.rhythm_icon_offset or 21
        local icon_texture = Assets.getTexture(self.party:getHeadIcons() .. "/" .. (_hurt and "head_hurt" or "head"))
		Draw.setColor(ColorUtils.mergeColor(COLORS.black, COLORS.white, self.brightness), 1)
        Draw.draw(icon_texture, arg0 - hoff - 20, self.bottomy - 234 + (self.party.head_icon_offset and self.party.head_icon_offset[2] or 0))
        local texture = Assets.getTexture(self.party.name_sprite)
		Draw.setColor(ColorUtils.mergeColor(COLORS.black, _bordercolor, self.brightness), 1)
        Draw.draw(texture, arg0 - hoff + 20, self.bottomy - 228)
    end
    local w = 1
    rectangle_points("line", arg0 - 40 - w, self.bottomy - 200 - w, arg0 + 40 + w, self.bottomy + 50 + w)
	
	if not arg1 and self.demo_mode then
		local font = Assets.getFont("main")
		love.graphics.setFont(font)
		love.graphics.printfOutline("DEMO", arg0 + 2 - font:getWidth("DEMO")/2, self.bottomy - 100 - font:getHeight("DEMO")/2, 1, math.huge, "left", 0, 1, 1)
	end
end

function RhythmGameChart:damageFlash(arg0)
	local arg0 = arg0 or false
    if (self.invc > 0) then
        if (arg0) then
			return MathUtils.rangeMap(self.hurt_flash, 0, 6, 0, 1)
        else
			return MathUtils.rangeMap(self.hurt_flash, 0, 6, 0, 1)
		end
    else
        return 0
	end
end

function RhythmGameChart:noteSkip(arg0)
	if (Game.minigame.solo_difficulty == -1) then return arg0 end
	
    if (Game.minigame.solo_difficulty < 3) then
        local _skiplength = Game.minigame.song.timestamps[4] - Game.minigame.song.timestamps[Game.minigame.solo_difficulty + 1]
        local _solodiff = Game.minigame.song.timestamps[Game.minigame.solo_difficulty + 1]
        
        if (self.trackpos <= _solodiff and arg0 >= Game.minigame.song.timestamps[4]) then
            arg0 = arg0 - _skiplength
        elseif (self.trackpos >= Game.minigame.song.timestamps[4] and arg0 <= _solodiff) then
            arg0 = arg0 + _skiplength
        end
    end
    
    if (Game.minigame.solo_difficulty > 1) then
        local _skiplength = Game.minigame.song.timestamps[Game.minigame.solo_difficulty] - Game.minigame.song.timestamps[1]
        local _solodiff = Game.minigame.song.timestamps[Game.minigame.solo_difficulty]
        
        if (self.trackpos <= Game.minigame.song.timestamps[1] and arg0 >= _solodiff) then
            arg0 = arg0 - _skiplength
        elseif (self.trackpos >= _solodiff and arg0 <= Game.minigame.song.timestamps[1]) then
            arg0 = arg0 + _skiplength
        end
    end
    
    return arg0
end

function RhythmGameChart:roundToBeat(arg0, arg1, arg2, arg3)
	local arg2 = arg2 or 4
	local arg3 = arg3 or 0
    if (arg2 <= 0) then
        arg2 = 1
	end
    
    local __mps = 60 / arg1 / arg2
    return (MathUtils.round((arg0 - arg3) / __mps) * __mps) + arg3
end

function RhythmGameChart:floorToBeat(arg0, arg1, arg2, arg3)
	local arg2 = arg2 or 4
	local arg3 = arg3 or 0
    if (arg2 <= 0) then
        arg2 = 1
	end
    
    local __mps = 60 / arg1 / arg2
    return (math.floor((arg0 - arg3) / __mps) * __mps) + arg3
end

function RhythmGameChart:ceilToBeat(arg0, arg1, arg2, arg3)
	local arg2 = arg2 or 4
	local arg3 = arg3 or 0
    if (arg2 <= 0) then
        arg2 = 1
	end
    
    local __mps = 60 / arg1 / arg2
    return (math.ceil((arg0 - arg3) / __mps) * __mps) + arg3
end

function RhythmGameChart:roundToOffbeat(arg0, arg1, arg3, arg3, arg4)
	local arg2 = arg2 or 1
	local arg3 = arg3 or 0.5
	local arg4 = arg4 or 0
    return self:roundToBeat(arg0, arg1, arg2, arg4 + (arg3 * (60 / arg1)))
end

function RhythmGameChart:floorToOffbeat(arg0, arg1, arg2, arg3, arg4)
	local arg2 = arg2 or 1
	local arg3 = arg3 or 0.5
	local arg4 = arg4 or 0
    return self:floorToBeat(arg0, arg1, arg2, arg4 + (arg3 * (60 / arg1)))
end

function RhythmGameChart:ceilToOffbeat(arg0, arg1, arg2, arg3, arg4)
	local arg2 = arg2 or 1
	local arg3 = arg3 or 0.5
	local arg4 = arg4 or 0
    return self:ceilToBeat(arg0, arg1, arg2, arg4 + (arg3 * (60 / arg1)))
end

function RhythmGameChart:noteLoop(arg0)
    if (arg0 < (track_length / 2)) then
        arg0 = arg0 + self:roundToBeat(self.track_length, self.song:getBPM())
    else
        arg0 = arg0 - self:roundToBeat(self.track_length, self.song:getBPM())
    end
    return arg0
end

function RhythmGameChart:drawChart(notespeed, centerx, arg2)
    local _hitspeed = (not arg2 and Game.minigame.pitch or 1) * DTMULT

    if (not arg2 and Game.minigame.state == "LOSE") then
        _hitspeed = 0
    end

    local _xstart = (self.instrument == 2) and 280 or 280
    local _xwidth = (self.instrument == 2) and 30 or 40
    local _beam = 0
    local _notecol = {}
    local _flash = 0
    local _altcolor = 0

    if (self.invc > 0) then
        _flash = self:damageFlash()
    end
    -- _flash = Utils.wave(Kristal.getTime() * math.pi * 2, 0, 1)
    _notecol[1] = ColorUtils.mergeColor(self:getNoteColor(1), COLORS.red, _flash)
    _notecol[1] = ColorUtils.mergeColor(COLORS.black, _notecol[1], self.brightness)
    _notecol[2] = ColorUtils.mergeColor(self:getNoteColor(2), COLORS.red, _flash)
    _notecol[2] = ColorUtils.mergeColor(COLORS.black, _notecol[2], self.brightness)
    _notecol[3] = ColorUtils.mergeColor(self:getNoteColor(3), COLORS.red, _flash)
    _notecol[3] = ColorUtils.mergeColor(COLORS.black, _notecol[3], self.brightness)

    local _yellow = ColorUtils.mergeColor(COLORS.black, ColorUtils.mergeColor(COLORS.yellow, COLORS.red, _flash), self.brightness)
    local _gold = ColorUtils.mergeColor(COLORS.black, ColorUtils.hexToRGB("#FFED72"), self.brightness)
    local _orange = ColorUtils.mergeColor(COLORS.black, ColorUtils.mergeColor(COLORS.orange, COLORS.red, _flash), self.brightness)
    local _white = ColorUtils.mergeColor(COLORS.black, ColorUtils.mergeColor(COLORS.white, COLORS.red, _flash), self.brightness)
    local _gray = ColorUtils.mergeColor(COLORS.black, ColorUtils.mergeColor(COLORS.gray, COLORS.red, _flash), self.brightness)

    if (self.instrument == 1) then
        local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_button")[3]
        Draw.setColor(_notecol[1])
        Draw.draw(texture, centerx - 20, self.bottomy, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
        Draw.setColor(_notecol[2])
        Draw.draw(texture, centerx + 20, self.bottomy, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
    end
	
    if (self.instrument == 0) then
		local _whiteness = ColorUtils.mergeColor(COLORS.black, COLORS.white, self.brightness)
        local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_button")
		Draw.setColor(COLORS.white)
		Draw.draw(texture[3], centerx - 20, self.bottomy, 0, 1, 1, texture[3]:getWidth()/2, texture[3]:getHeight()/2)
		Draw.draw(texture[3], centerx + 20, self.bottomy, 0, 1, 1, texture[3]:getWidth()/2, texture[3]:getHeight()/2)
		Draw.setColor(self:getNoteColor(4))
		Draw.draw(texture[1], centerx - 20, self.bottomy, 0, 1, 1, texture[1]:getWidth()/2, texture[1]:getHeight()/2)
		Draw.setColor(self:getNoteColor(5))
		Draw.draw(texture[1], centerx + 20, self.bottomy, 0, 1, 1, texture[1]:getWidth()/2, texture[1]:getHeight()/2)
		Draw.setColor(_whiteness, self.note_hit_timer[1] / 5)
		Draw.draw(texture[2], centerx - 20, self.bottomy, 0, 1, 1, texture[2]:getWidth()/2, texture[2]:getHeight()/2)
		Draw.setColor(_whiteness, self.note_hit_timer[2] / 5)
		Draw.draw(texture[2], centerx + 20, self.bottomy, 0, 1, 1, texture[2]:getWidth()/2, texture[2]:getHeight()/2)
		Draw.setColor(COLORS.white, 1)
    end

    if (self.instrument == 2) then
        Draw.setColor(COLORS.black)
        fill_rectangle_points(centerx - 40, self.bottomy - 2, centerx + 40, self.bottomy + 2)
        Draw.setColor(_orange)
        fill_rectangle_points(centerx - 40, self.bottomy - 1, centerx + 40, self.bottomy + 1)
	end
	
    if (self.instrument == 2 and not self.clapping) then
        for i=0,2 do
            _beam = Ease.inQuad(self.note_hit_timer[i+1] / 5, 0, 1, 1)

            if (self.note_hit_timer[i+1] > 0) then
                local gradframes = Assets.getFrames("minigames/rhythm_game/whitegradientdown_rhythm")
                Draw.setColor(_gold, 1)
                Draw.draw(gradframes[2], (centerx - 30) + (30 * i), self.bottomy - 4, 0, _beam * 0.75, 1, gradframes[2]:getWidth()/2, gradframes[2]:getHeight() - 4)
                Draw.setColor(_white, 1)
                Draw.draw(gradframes[3], (centerx - 30) + (30 * i), self.bottomy - 4, 0, _beam * 0.75, 1, gradframes[3]:getWidth()/2, gradframes[3]:getHeight() - 4)

                if (self.last_note ~= i and self.cooldown > 1) then
                    self.notex = MathUtils.clamp(self.last_note - i, 0, 1) * 6
                elseif (self.cooldown <= 1) then
                    self.notex = 0
                end

                self.last_note = i
                self.cooldown = 2
            end

            self.note_hit_timer[i+1] = self.note_hit_timer[i+1] - _hitspeed
        end

        if (self.cooldown > 0) then
            local arrow_tex = Assets.getFrames("minigames/rhythm_game/singing_arrow")[1]
			Draw.setColor((self.cooldown == 2) and _yellow or _white, MathUtils.clamp(self.cooldown, 0, 1))
            Draw.draw(arrow_tex, (centerx - 30) + (30 * self.last_note) + self.notex, self.bottomy + 3, 0, 1, 1, arrow_tex:getWidth()/2, 1)
			Draw.setColor(COLORS.white, 1)
            -- draw_sprite_ext(minigames/rhythm_game/custommenu_arrow, 0, (centerx - 30) + (30 * last_note) + self.notex, self.bottomy + 10, 1, 2, 180, _arrow, MathUtils.clamp(self.cooldown, 0, 1))
            self.notex = MathUtils.approach(self.notex, 0, 4 * DTMULT)
            self.cooldown = self.cooldown - (1/15) * DTMULT
        end
    else		
        for i=0, 1 do
            if (self.note_hit_timer[i+1] > 0) then
                _beam = Ease.inQuad(self.note_hit_timer[i+1] / 5, 0, 1, 1)

                local buttonframes = Assets.getFrames("minigames/rhythm_game/rhythmgame_button")
                local hitframes = Assets.getFrames("minigames/rhythm_game/rhythmgame_note_hit")
                local hitbigframes = Assets.getFrames("minigames/rhythm_game/rhythmgame_note_hit_big")
                local gradframes = Assets.getFrames("minigames/rhythm_game/whitegradientdown_rhythm")
                local _ease = self.note_hit_timer[i+1] / 5
                local _col = _white
                local _cool = false
                local _side = (i * 2) - 1
                local _cenx = centerx + (20 * _side)
                local _score = 0

                if (self.instrument == 0) then
                    _score = self.auto_play and 100 or self.note_hit_score[i+1]
                    _cool = _score >= 100
                    _col = _cool and _gold or _white
                end

                if (self.instrument == 2) then
                    _score = 100
                end
				
                if (self.instrument == 1) then
                    if (self.auto_play) then
                        _score = 100
                        _cool = true
                        _col = _gold
                    end
                    Draw.setColor(_white, self.note_hit_timer[i+1] / 5)
                    Draw.draw(buttonframes[2], _cenx, self.bottomy, 0, 1, 1, buttonframes[2]:getWidth()/2, buttonframes[2]:getHeight()/2)
                    -- draw_sprite_ext(minigames/rhythm_game/rhythmgame_button, 3, _cenx, self.bottomy, 1, 1, 0, _white, self.note_hit_timer[i] / 5)
                end

                if (self.instrument == 2) then
                    _cool = true
                    _col = _gold
                    _cenx = centerx
                    Draw.setColor(_white, self.note_hit_timer[i+1] / 5)
                    fill_rectangle_points(centerx - 40, self.bottomy - 2, centerx + 40, self.bottomy + 2)
                end
				
                if (not arg2 and (Game.minigame.fame or 0) >= 12000 and _score > 0) then
					if self.instrument ~= 2 then
						Draw.setColor(ColorUtils.mergeColor(_white, _col, 1 - _ease), _ease)
						Draw.draw(hitframes[(math.floor((1 - _beam) * 2.9) % #hitbigframes) + 1], _cenx, self.bottomy, 0, 2 - _beam, 2 - _beam, hitframes[3]:getWidth()/2, hitframes[3]:getHeight()/2)
						-- draw_sprite_ext(minigames/rhythm_game/rhythmgame_note_hit, (1 - _beam) * 2.9, _cenx + (_side * (1 - _ease) * 2), self.bottomy, 2 - _beam, 2 - _beam, 0, ColorUtils.mergeColor(_white, _col, 1 - _ease), _ease)
					else
						local _beam_scale = 1 - _beam
						Draw.setColor(ColorUtils.mergeColor(_white, _col, 1 - _ease), _ease)
						Draw.draw(hitbigframes[(math.floor((1 - _beam) * 2.9) % #hitbigframes) + 1], _cenx, self.bottomy, 0, (_beam_scale * 0.5) + 1, (_beam_scale * 0.5) + 1, hitbigframes[3]:getWidth()/2, hitbigframes[3]:getHeight()/2)
					end
				end

                if (self.instrument == 2) then
                    local  _beam_scale = 1 - _beam
					if _cool then
						Draw.setColor(_gold, MathUtils.clamp(_beam * 2, 0, 1))
						Draw.draw(gradframes[2], _cenx, self.bottomy, 0, 2, _beam_scale + 0.25, gradframes[2]:getWidth()/2, gradframes[2]:getHeight() - 4)
						--draw_sprite_ext(spr_whitegradientdown_rhythm, 1, _cenx, bottomy, 2, _beam_scale + 0.25, 0, _gold, clamp01(_beam * 2));
						Draw.setColor(_white, MathUtils.clamp(_beam * 2, 0, 1))
						Draw.draw(gradframes[3], _cenx, self.bottomy, 0, 2, _beam_scale + 0.25, gradframes[3]:getWidth()/2, gradframes[3]:getHeight() - 4)
						--draw_sprite_ext(spr_whitegradientdown_rhythm, 2, _cenx, bottomy, 2, _beam_scale + 0.25, 0, _white, clamp01(_beam * 2));
					else
						Draw.setColor(_white, MathUtils.clamp(_beam * 2, 0, 1))
						Draw.draw(gradframes[1], _cenx, self.bottomy, 0, 2, _beam_scale + 0.25, gradframes[1]:getWidth()/2, gradframes[1]:getHeight() - 4)
						--draw_sprite_ext(spr_whitegradientdown_rhythm, 2, _cenx, bottomy, 2, _beam_scale + 0.25, 0, _white, clamp01(_beam * 2));					
					end
                elseif (_cool) then
                    Draw.setColor(_gold)
                    Draw.draw(gradframes[2], _cenx, self.bottomy, 0, _beam, 1, gradframes[2]:getWidth()/2, gradframes[2]:getHeight() - 4)
                    -- draw_sprite_ext(minigames/rhythm_game/whitegradientdown_rhythm, 1, _cenx, self.bottomy, _beam, 1, 0, _gold, 1)
                    Draw.setColor(_white)
                    Draw.draw(gradframes[3], _cenx, self.bottomy, 0, _beam, 1, gradframes[3]:getWidth()/2, gradframes[3]:getHeight() - 4)
                    -- draw_sprite_ext(minigames/rhythm_game/whitegradientdown_rhythm, 2, _cenx, self.bottomy, _beam, 1, 0, _white, 1)
                else
                    Draw.setColor(_white)
                    Draw.draw(gradframes[1], _cenx, self.bottomy, 0, _beam, 1, gradframes[1]:getWidth()/2, gradframes[1]:getHeight() - 4)
                    -- draw_sprite_ext(minigames/rhythm_game/whitegradientdown_rhythm, 0, _cenx, self.bottomy, _beam, 1, 0, _white, 1)
                end

                self.note_hit_timer[i+1] = self.note_hit_timer[i+1] - _hitspeed
            end
        end
    end

    if (not arg2 and not self.paused) then
        love.graphics.stencil(function ()
            fill_rectangle_points(centerx - 40, self.bottomy + 50, centerx + 40, self.bottomy - 200)

        end)
        love.graphics.setStencilTest("greater", 0)
    end

    local _looper = not arg2 and ((Game.minigame.loop and (self.instrument ~= 0 or tutorial ~= 1)) or (self.chart_end > self.track_length and #self.track.notes > 0 and self.track.notes[1].notetime < self.chart_start))
    local _loopcheck = false
    local _averagetimeunit = ((self.trackpos - self.remtrackpos[1]) + (self.remtrackpos[1] - self.remtrackpos[2]) + (self.remtrackpos[2] - self.remtrackpos[3])) / 3
	local _end_buffer = self.trackpos - (3.6 * _averagetimeunit)

    if (not arg2 and self.instrument == 0 and Game.minigame.hardmode) then
        _end_buffer = self.trackpos - (2.4 * _averagetimeunit)
    end

    local notei = math.max(self.minnote - 8, 0)

    while (notei < #(self.track and self.track.notes or {})) do
        notei = notei+1
        local note = self.track.notes[notei]
        local _notetime = note.notetime
        local _notealive = note.notealive
        local _notescore = note.notescore
        local _noteend = note.noteend
        if (not arg2 and self.instrument ~= 1 and self.song.has_multi_solos) then
            _notetime = self:noteSkip(self.track.notes[notei].notetime)

            if (_noteend > 0) then
                _noteend = self:noteSkip(_noteend)
            end
        elseif (_loopcheck) then
            _notetime = self:noteLoop(self.track.notes[notei].notetime)

            if (_notetime > (self.track_length / 2)) then
                _notealive = 1
                _notescore = 0
            else
                _notealive = 0
                
                if (notei >= (#self.charts[3].track.notes - 5)) then
                    _notescore = self.last_score[notei - (#self.track.notes - 5)]
                end
                
                if (_noteend > 0) then
                    _noteend = self:noteLoop(_noteend)
                end
            end
        else
        end

        local notey = (self.bottomy - (self.song:secondsToYPos(_notetime))) + (self.song:secondsToYPos(self.trackpos))
        local _topy = 0 - 20

        if (notey < _topy) then
            if (_looper and not _loopcheck and self.trackpos < 4 and #self.track.notes > 9) then
                _loopcheck = true
                notei = #self.track.notes - 9
                goto continue
            end

            break
        end
		if self.instrument ~= 2 and note.notetype == 2 then
			goto continue
		end
        if (notey >= _topy and (notei >= self.minnote or _notescore <= 0 or (_loopcheck and _notealive))) then
            _end_buffer = self.trackpos - 0.12000000000000001
            
            if (not arg2 and self.instrument == 0 and Game.minigame.hardmode) then
                _end_buffer = self.trackpos - 0.08666666666666667
            end
            
            if (not _loopcheck and _notetime < _end_buffer) then
                if (self.track.notes[notei].notescore <= 0 and self.track.notes[notei].notealive == 1 and self.fade == 1) then
                    self.missnotecon = 1
                    
                    if (self.instrument == 0 and not arg2) then
                        Game.minigame.miss = Game.minigame.miss + 1
                    end
                end
                
                self.track.notes[notei].notealive = 0
                self.minnote = notei + 1
            end
            
            if (_notealive == 1) then
                Draw.setColor(_notecol[note.notetype + 1])
            else
                Draw.setColor(_gray)
            end
            
            if (_notescore >= 100) then
                Draw.setColor(_yellow)
            elseif (_notescore >= 30) then
                Draw.setColor(_orange)
            end
            
            if (_notealive == 1 or _notescore <= 0) then
                if (_notescore < 0 and _noteend > 0 and _notealive == 0) then
                    _notetime = _notetime - self.track.notes[notei].notescore
                    notey = (self.bottomy - (self.song:secondsToYPos(_notetime))) + (self.song:secondsToYPos(self.trackpos))
                    _notescore = 0
                end
                
                if (note.noteanim > 0 and arg2) then
                    local _oldcolor = {love.graphics.getColor()}
                    Draw.setColor(_yellow)
                    love.graphics.circle("fill", (centerx - 20 - 15) + (note.notetype * 40), notey, 3)
                    love.graphics.circle("fill", (centerx - 20) + 15 + (note.notetype * 40), notey, 3)
                    Draw.setColor(_oldcolor)
                end
				
				if self.instrument == 2 and _noteend == 0 then
					self:drawNoteClap(centerx, notey, note.notetype)
				else
					self:drawNote(centerx, notey, note.notetype)
				end
                
                if (arg2 and self.paused and self.do_refresh) then
                    local _xleft = centerx
                    
                    if (self.instrument == 2) then
                        _xleft = _xleft - 15
                    else
                        _xleft = _xleft + 5
                    end
                    
                    local _node = instance_create((_xleft - _xwidth) + (note.notetype * _xwidth) + 15, notey, obj_rhythmgame_editor_note_node)
                    _node.depth = depth + 1
                    _node.noteindex = notei
                    
                    if (self.instrument == 2) then
                        _node.image_xscale = 1.375
                    end
                end
                
                if (_noteend > 0) then
                    local notelength = (_noteend - _notetime) * self.song.notespeed
                    --local notelength = - ((self.song:secondsToYPos((_notetime))) - (self.song:secondsToYPos(_noteend)))
                    self:drawNoteLong(centerx, notey, note.notetype, notelength, false)
                end
            end
        end

        if (_looper and not _loopcheck and (notei + 1) == #self.track.notes and self.trackpos > (self.track_length - 4)) then
            notei = -1
            _loopcheck = true
        end
        ::continue::

        
    end
    local _note_count = (self.instrument ~= 2) and 2 or 3
    for i=1, _note_count do
        if (self.hold_end[i] > 0) then
            local note_end = (self.hold_end[i] - self.trackpos) * self.song.notespeed
            --local note_end = - ((self.song:secondsToYPos(self.trackpos)) - (self.song:secondsToYPos(self.hold_end[i])))
            Draw.setColor(_orange)
            self:drawNoteLong(centerx, self.bottomy, i-1, note_end, true)
            Draw.setColor(_yellow)
            self:drawNote(centerx, self.bottomy, i-1)
        end
    end
    
    if (not arg2 and not self.paused) then
    end
    love.graphics.setStencilTest()

    love.graphics.setStencilTest()
end

function RhythmGameChart:drawNote(centerx, ypos, notex, arg3)
    arg3 = arg3 or 0
    assert(centerx and ypos and notex)
    if (self.instrument == 2) then
        centerx = (centerx - 30) + (notex * 30)
        
        if (self.paused) then
            fill_rectangle_points(centerx - 10, ypos - 3, centerx + 10, ypos + 3)
        else
            local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_heldnote")[1]
            Draw.draw(texture, centerx, ypos, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
        end
    elseif (self.instrument == 1 and notex == 2) then
        fill_rectangle_points(centerx - 45, ypos - 1, centerx + 45, ypos + 1)
    else
        centerx = (centerx - 20) + (notex * 40)
        local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_note")[1]
        Draw.draw(texture, centerx, ypos, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
    end
end

function RhythmGameChart:drawNoteClap(centerx, ypos, notex, arg3)
    arg3 = arg3 or 0
    assert(centerx and ypos and notex)
    local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_note_big")[1]
    Draw.draw(texture, centerx, ypos, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
end

function RhythmGameChart:drawNoteLong(centerx, bottomy, i, note_end, held)
    --centerx, bottomy, i, note_end, held
    if (self.instrument == 2) then
        centerx = (centerx - 30) + (i * 30)
        local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_heldnote")[1]
        Draw.draw(texture, centerx, bottomy - note_end, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
        Draw.draw(texture, centerx, bottomy, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
    else
        centerx = (centerx - 20) + (i * 40)
    end
    
    fill_rectangle_points(centerx - 3, bottomy - note_end, centerx + (self.instrument == 2 and 4 or 3), bottomy)
    
    if (held) then
        local _endColor = ColorUtils.mergeColor(COLORS.yellow, COLORS.orange, MathUtils.clamp(MathUtils.inverseLerp(bottomy, bottomy - 40, bottomy - note_end), 0, 1))
        _endColor = ColorUtils.mergeColor(COLORS.black, _endColor, self.brightness)
        local _startColor = ColorUtils.mergeColor(COLORS.black, COLORS.yellow, self.brightness)
        
        if (self.instrument == 2) then
            Draw.setColor(_endColor)

            local texture = Assets.getFrames("minigames/rhythm_game/rhythmgame_heldnote")[1]
            Draw.draw(texture, centerx, bottomy - note_end, 0, 1, 1, texture:getWidth()/2, texture:getHeight()/2)
        end
        
        love.graphics.setShader(Kristal.Shaders["GradientV"])
        love.graphics.setColor(COLORS.white)
        Kristal.Shaders["GradientV"]:sendColor("from", _endColor)
        Kristal.Shaders["GradientV"]:sendColor("to", _startColor)
        love.graphics.draw(self.pixel, centerx - 3, bottomy - note_end, 0, 7, note_end + 1)
        -- ossafe_fill_rectangle_color(centerx - 3, bottomy - note_end, centerx + 3, bottomy, _endColor, _endColor, _startColor, _startColor, false)
        love.graphics.setShader()
    end
end

function RhythmGameChart:update()
    super.update(self)
	if not TableUtils.contains(Game.minigame.rhythm_game_update_states, Game.minigame.state) then 
		return
	end
    self.trackpos = Game.minigame.trackpos
    local _timeunit = self.trackpos - self.remtrackpos[1]
    local _averagetimeunit = ((self.trackpos - self.remtrackpos[1]) + (self.remtrackpos[1] - self.remtrackpos[2]) + (self.remtrackpos[2] - self.remtrackpos[3])) / 3
    self.remtrackpos[5] = self.remtrackpos[4]
    self.remtrackpos[4] = self.remtrackpos[3]
    self.remtrackpos[3] = self.remtrackpos[2]
    self.remtrackpos[2] = self.remtrackpos[1]
    self.remtrackpos[1] = self.trackpos
	
	for i = 1, 3 do
		self.pressedtimer[i] = self.pressedtimer[i] + DTMULT
		self.buffer[i] = self.buffer[i] - DTMULT
	end
    self.hold_score = 0
	
    if (self.hurt_flash > 0) then
        self.hurt_flash = self.hurt_flash - DTMULT
	end
	
    self.invc = self.invc - DTMULT
	
    if (self.fade > 0 and self.fade < 1) then
        self.fade = self.fade - 0.02 * DTMULT
	end
	
	if self.auto_play then
		if Game.minigame.overrun == 0 then
			self:handleAutoplay(_averagetimeunit)
		end
	else
		self:handleInput(_averagetimeunit)
	end
	
    if (self.missnotecon == 1) then
		if not self.auto_play then
			Game.minigame.missnotecon = 1
		else
			self.combo = 0
			self.invc = 60
        
			if (self.fade >= 1) then
				self.hurt_flash = 6
			end
		end
        self.missnotecon = 0
    end
end

function RhythmGameChart:handleAutoplay(_averagetimeunit)
	if not (self.track and self.track.notes) then return end
    local averagetimeunit = _averagetimeunit or 0
	local targetnotes = {}
    local foundnotes = false
    
    for i = self.minnote, self.minnote + 1 do
        if not (self.track and self.track.notes[i]) then break end
		
        if math.abs(self.track.notes[i].notetime - self.trackpos) < 0.12
		or self.track.notes[i].notetime - self.trackpos < 0 then
			foundnotes = true
            table.insert(targetnotes, self.track.notes[i])
        else
            break
		end
    end
	
    --[[if (self.con >= 0 and self.party.id == "susie") then
        self.masher = self.masher - DTMULT
        
        if (self.masher <= 0) then
            if (self.con < 3) then
                mash_hit = con;
            elseif (con == 5) then
                self.mash_hit = 0;
                con = 6;
            elseif (con == 6) then
                self.mash_hit = 1;
                con = 5;
            elseif (con == 7) then
                self.mash_hit = MathUtils.random(0,3);
            elseif (con >= 8) then
                self.mash_hit = self.con - 5;
            end
			
            self.masher = self.mash_speed
        end
    end]]
	local _notestop = false
	for i = 1, (self.instrument == 2 and 3 or 2) do
		local checkpress = false
        local holdpress = false
        if (self.mash_hit == i and not self.auto_play) then
            if (self.fade > 0) then
                self.song.miss_timer = 10
                
                if (self.fade == 1) then
					Game.minigame.missnotecon = 1	
					
					if (Game.minigame.fame > 3000) then
						Game.minigame.fixed_penalty = 200
					--[[else if (song_id == 1) then
						Game.minigame.fixed_penalty = 100]]
					else
						Game.minigame.fixed_penalty = -1
                    end
                    
                    self.missnotecon = 1
                end
                
                --[[if (obj_rhythmgame.song_id != 1)
                    snd_play_volume(rhythm_battle_snare, clamp01(self.fade))]]
            end
            
            checkpress = true
            
            if self.performer then
                if (self.mash_hit == 0) then
                    self.performer:setAnimation("rhythm_game/play_left")
                end
                if (self.mash_hit == 1) then
                    self.performer:setAnimation("rhythm_game/play_right")
                end                
                if (self.mash_hit == 2) then
                    self.performer:setAnimation("rhythm_game/play_mid")
                end                
                if (self.mash_hit == 3) then
                    self.performer:setAnimation("rhythm_game/drumsticks")
                end                
                if (self.mash_hit == 4) then
                    self.performer:setAnimation("rhythm_game/drumsticks_happy")
                end                
				self.performer:playedNote()
            end
            
            self.mash_hit = -1
        end
        
        if (self.hold_end[i] > 0) then
            if (self.hold_end[i] < self.trackpos) then
                if (self.trackpos >= self.hold_start[i]) then
                    local chainPoints = (math.floor(((math.min(self.hold_end[i], self.trackpos) - self.hold_start[i]) / self.song.meter) * 40) * 10) + 50
                    Game.minigame.total_score = Game.minigame.total_score + chainPoints
                    self.score_scale = 4
                    Game.minigame.total_fame = Game.minigame.total_fame + chainPoints
                    
                    if (self.instrument == 2) then
						self.performer:setAnimation(self.performer.idle)
                        _notestop = true
                    end
                    
                    if (self.fade == 1) then
                        if (self.instrument == 2) then
							local _fame_increase = 0
                            --local _fame_increase = (self.song.id == 0 and self.trackpos < 37.56) and 100 or 0
                            Game.minigame.fame = MathUtils.approach(Game.minigame.fame, Game.minigame.max_fame, _fame_increase)
                        end
                        
                        self.combo = self.combo + 1
                    end
                end
                
                self.hold_end[i] = 0
            elseif (self.trackpos >= self.hold_start[i]) then
                if (self.score_scale < 2.5) then
                    self.score_scale = self.score_scale + 0.4 * DTMULT
				end
                
                if (self.note_hit_timer[i] <= 1) then
                    self.note_hit_timer[i] = 3
				end
                
                if (self.instrument == 2 and (self.trackpos - self.hold_start[i]) > (1/15)) then
                    if (self.performer:getAnimation() == self.performer.idle) then
						self.performer:setAnimation(self.performer.mid)
					end
                end
            end
        end
        
        if (checkpress and self.buffer[i] <= 0) then
            self.note_hit_timer[i] = 5
            self.pressedtimer[i] = 0
            self.buffer[i] = 2
        end
        
        local _simul = 0
        local _play_note = true
        
        if (foundnotes and self.confidence < 1) then
            _play_note = (MathUtils.random(1) < math.pow(self.confidence, self.combo + 1 + self.conf_decay)) and true or false
        end
		
        if (self.conf_decay > 0) then
            self.conf_decay = MathUtils.approach(self.conf_decay, 0, 0.15 * DTMULT)
		end
        if ((self.pressedtimer[i] < 3 or _play_note) and foundnotes and self.fade == 1) then
            for notei = 1, #targetnotes do
                if (targetnotes[notei].notetype == i - 1 and targetnotes[notei].notealive == 1) then
                    local leniency = 1.6
                    
                    if (targetnotes[notei].notetime <= (self.trackpos + averagetimeunit)) then
						targetnotes[notei].notescore = 100
                            
						if (self.instrument == 2 and targetnotes[notei].noteend > 0) then
							if (not _notestop) then
								self.performer:setAnimation(self.performer.mid)
							end
						end
                            
						if (self.instrument == 1) then
							if (_simul == 1) then
								self.performer:setAnimation("rhythm_game/play_left")
								_simul = _simul + 1
							elseif (targetnotes[notei].noteanim == 1) then
								if (i == 1) then
									self.performer:setAnimation("rhythm_game/play_left")
								end
                                        
								if (i == 2) then
									self.performer:setAnimation("rhythm_game/play_mid")
								end
							else
								if (i == 1) then
									self.performer:setAnimation("rhythm_game/play_mid")
								end
                                        
								if (i == 2) then
									self.performer:setAnimation("rhythm_game/play_right")
								end
                                        
								_simul = _simul + 1
							end
							self.performer:playedNote()
						end
					else
						break
					end
                    
                    Game.minigame.total_score = Game.minigame.total_score + targetnotes[notei].notescore
                    Game.minigame.total_fame = Game.minigame.total_fame + targetnotes[notei].notescore
                    self.score_scale = math.min(4, self.score_scale + (targetnotes[notei].notescore / 100))
                    
                    if (targetnotes[notei].notescore >= 40 and targetnotes[notei].noteend > 0) then
                        self.hold_start[i] = targetnotes[notei].notetime
                        self.hold_end[i] = targetnotes[notei].noteend
                        
                        if (self.instrument == 2) then
                            self.clapping = false
						end
                    elseif (targetnotes[notei].notescore >= 40) then
                        if (self.fade == 1) then
                            self.combo = self.combo + 1
						end
                        
                        if (self.instrument == 2) then
                            self.clapping = true
						end
                    end
                    
                    if (targetnotes[notei].notescore > 0) then
						if (self.instrument == 2) then
							self.note_hit_timer[1] = 0
							self.note_hit_timer[2] = 0
							self.note_hit_timer[3] = 0
							self.note_hit_timer[i] = 3
						end
                        self.note_hit_timer[i] = 5
						
						self.note_streak = self.note_streak + 1
                    end
					targetnotes[notei].notealive = 0
				end
			end
		end
    end
end

function RhythmGameChart:handleInput(_averagetimeunit)
	if not (self.track and self.track.notes) then return end
	local averagetimeunit = _averagetimeunit or 0
	local targetnotes = {}
    local foundnotes = false
    local _notetime = 0
    
    for i = self.minnote, self.minnote + 1 do
        if not (self.track and self.track.notes[i]) then break end
		local _notetime = self.track.notes[i].notetime - self.trackpos
		
        if (Game.minigame.hardmode) then
            if (_notetime >= -0.2 and _notetime <= 0.12) then
				foundnotes = true
				table.insert(targetnotes, self.track.notes[i])
			else
				break
			end
		else
			if math.abs(_notetime) < 0.12
			or _notetime < 0 then
				foundnotes = true
				table.insert(targetnotes, self.track.notes[i])
			else
				break
			end
		end
    end
	
	local _notestop = false
	for i = 1, (self.instrument == 2 and 3 or 2) do
		local checkpress = false
        local holdpress = false
        if i == 1 then
            holdpress = (Input.down("confirm") or Input.down("left")) and true or false
            checkpress = (Input.pressed("confirm") or Input.pressed("left") or (holdpress and not self.leftcheck)) and true or false
            self.leftcheck = holdpress
        end
        if i == 2 then
            holdpress = (Input.down("cancel") or Input.down("right")) and true or false
            checkpress = (Input.pressed("cancel") or Input.pressed("right") or (holdpress and not self.rightcheck)) and true or false
            self.rightcheck = holdpress
        end
		
		if TableUtils.contains({"LOSETRANSITION", "LOSE"}, Game.minigame.state) then
			checkpress = false
			holdpress = false
		end
		
        if (checkpress) then
			if (i == 1) then
				self.performer:setAnimation("rhythm_game/play")
			else
				self.performer:setAnimation("rhythm_game/play_high")
			end
                
            self.performer:playedNote()
		end
		
        if (self.hold_end[i] > 0) then
            if (self.hold_end[i] < self.trackpos or not holdpress) then
                local _holdpos = self.trackpos
                local _notedone = false
                
                if (self.trackpos >= (self.hold_end[i] - (averagetimeunit * 3))) then
                    _holdpos = math.max(self.hold_end[i], _holdpos)
				end
                
                local chainPoints = 0
                
                if (_holdpos >= self.hold_end[i]) then
                    chainPoints = MathUtils.round(((self.hold_end[i] - self.hold_start[i]) / (self.song.notespacing * 4)) * 4) * 10
                else
                    chainPoints = math.floor(((_holdpos - self.hold_start[i]) / (self.song.notespacing * 4)) * 4) * 10
				end
                
                if (_holdpos >= self.hold_end[i]) then
                    self.score_scale = 4
                    chainPoints = chainPoints * 2
                    chainPoints = math.max(10, chainPoints)
                    self.note_hit_timer[i] = 4
                else
					if self.track then
						Game.minigame:setTrackActive(self.track.name, false)
					end
                    self.heldnote[i].notescore = self.hold_start[i] - self.trackpos
                end
                
                self.heldnote[i] = nil
                Game.minigame.total_score = Game.minigame.total_score + chainPoints
                
                --if (tutorial == 0) then
                    Game.minigame.fame = Game.minigame.fame + (chainPoints * Game.minigame.fame_mul)
                    Game.minigame.total_fame = Game.minigame.total_fame + (chainPoints * Game.minigame.fame_mul)
                --end
                
                Game.minigame.points = Game.minigame.points + chainPoints
                Game.minigame.max_combo = math.max(self.combo, Game.minigame.max_combo)
                
                if (#self.heldnote > (1 - (i - 1)) + 1 and self.heldnote[(1 - (i - 1)) + 1] ~= nil and math.abs(self.hold_end[i] - self.hold_start[(1 - (i - 1)) + 1]) > 0.1 and not math.abs(self.hold_start[i] - self.hold_start[(1 - (i - 1)) + 1]) < 0.1) then
                    if (self.performer:getAnimation() == "rhythm_game/play_high") then
                        if (i == 2) then
							self.performer:setAnimation("rhythm_game/play")
						else
							self.performer:setAnimation("rhythm_game/play_high_hold")
						end
					else
						self.performer:setAnimation("rhythm_game/play_high")
					end
                end
                
                self.hold_end[i] = 0
            elseif (self.trackpos >= self.hold_start[i]) then
				self.performer:setFrame(1)
                Game.minigame.hold_score = Game.minigame.hold_score + math.floor(((self.trackpos - self.hold_start[i]) / (self.song.notespacing * 4)) * (40 * DTMULT))
                
                if (self.score_scale < 2.5) then
                    self.score_scale = self.score_scale + 0.4 * DTMULT
				end
                
                if (self.note_hit_timer[i] <= 1) then
                    self.note_hit_timer[i] = 3
				end
            end
		end
		
		if (checkpress and self.buffer[i] <= 0) then
			self.note_hit_timer[i] = 5
			self.note_hit_score[i] = 0
			self.pressedtimer[i] = 0
			self.buffer[i] = 2
		end	
			
		local _firstnote = true
		local _earlypunish = false
		local _press_buffer = Game.minigame.hardmode and 0 or 3
		
		if (self.pressedtimer[i] <= _press_buffer and foundnotes) then
			self.bonus = (Game.minigame.hardmode and Game.minigame.fame >= 12000) and 10 or 0
			
			for notei = 1, #targetnotes do
				if (targetnotes[notei].notetype == i - 1 and targetnotes[notei].notealive == 1) then
					local _leniency = 1.6
					local _famegain = 0
					local _noteaccuracy = targetnotes[notei].notetime - self.trackpos
					
					if (math.abs(_noteaccuracy) < (averagetimeunit * _leniency)) then
						targetnotes[notei].notescore = 100 + self.bonus
						_famegain = 100
						Game.minigame.great = Game.minigame.great + 1
					elseif (not Game.minigame.hardmode or math.abs(_noteaccuracy) < (averagetimeunit * 2.4)) then
						targetnotes[notei].notescore = 50 + self.bonus
						
						if (Game.minigame.fame < 5950) then
							_famegain = 60
						else
							_famegain = 50
						end
						
						Game.minigame.good = Game.minigame.good + 1
					elseif (Game.minigame.hardmode and _firstnote and self.pressedtimer[i] == 0) then
						if (self.trackpos < targetnotes[notei].notetime) then
							targetnotes[notei].notescore = 0
							targetnotes[notei].notealive = 0
							self.missnotecon = 1
							Game.minigame.miss = Game.minigame.miss + 1
							local miss_sound = {"guitarerror", "guitarerror2"}
							Assets.playSound(miss_sound[MathUtils.randomInt(1, 3)])
						else
							goto continue
						end
					else
						break
					end
					
					self.song.note_hit = false
					Game.minigame.total_score = Game.minigame.total_score + targetnotes[notei].notescore
					
					if (self.missnotecon == 1) then
						self.last_note_score = -2
					else
						self.last_note_score = targetnotes[notei].notescore
					end
					
					Game.minigame.fame = Game.minigame.fame + (_famegain * Game.minigame.fame_mul)
					Game.minigame.total_fame = Game.minigame.total_fame + (_famegain * Game.minigame.fame_mul)
					
					Game.minigame.points = Game.minigame.points + targetnotes[notei].notescore
					self.score_scale = math.min(4, self.score_scale + (targetnotes[notei].notescore / 100))
					
					if (targetnotes[notei].noteanim > 0) then
						if (i == 2) then
							self.performer:setAnimation("rhythm_game/play_high_hold")
						end
					end
					
					if (targetnotes[notei].notescore >= 40 and targetnotes[notei].noteend > 0) then
						self.hold_start[i] = targetnotes[notei].notetime
						self.hold_end[i] = targetnotes[notei].noteend
						self.heldnote[i] = targetnotes[notei]
					end
					
					if (targetnotes[notei].notescore >= 40) then
						self.combo = self.combo + 1
						Game.minigame.max_combo = math.max(self.combo, Game.minigame.max_combo)
						self.song.note_hit = true
					end
					
					targetnotes[notei].notealive = 0
					self.note_hit_score[i] = targetnotes[notei].notescore
					self.pressedtimer[i] = 4
					
					if self.track then
						Game.minigame:setTrackActive(self.track.name, true)
					end
					
					_firstnote = false
					break
				end
			end
		elseif (self.pressedtimer[i] == 0 and self.missnotecon ~= 1 and not Game.minigame.song_done and (Game.minigame.hardmode or _notetime == 0 or _notetime > ((_press_buffer / 30) + 0.12))) then
			local guitar_sound = {"guitarpickup3", "guitarpickup4", "guitarpickup1", "guitarpickup2"}
			Assets.playSound(guitar_sound[MathUtils.randomInt(1, 3) + ((i - 1) * 2)])
		end
		::continue::
    end
end

function RhythmGameChart:getNote(lane)
    for i = self.minnote, self.minnote + 1 do
        if not (self.track and self.track.notes[i]) then break end
        if self.track.notes[i].notetype == lane - 1
            and self.track.notes[i].notescore == 0
            and math.abs(self.track.notes[i].notetime - self.trackpos) < 0.1 then
            return self.track.notes[i], i
        end
    end
end

function RhythmGameChart:tryHitNote(lane)
    local note, noteindex = self:getNote(lane)
    if not note then
        if self.track then
            Game.minigame:setTrackActive(self.track.name, false)
        end
        return
    end
    self.note_hit_timer[lane] = 4
    note.score = 10
    self.hold_end[lane] = note.noteend
    if note.noteend > 0 then
        self.hold_start[lane] = note.notestart
    end
    note.notescore = 100
    note.notealive = false
    if self.track then
        Game.minigame:setTrackActive(self.track.name, true)
    end
    return note
end

return RhythmGameChart