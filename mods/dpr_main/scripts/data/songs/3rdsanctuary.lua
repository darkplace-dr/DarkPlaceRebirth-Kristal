local function addNote(notetime, notetype, noteend, noteanim, thatmysteriousfuckingarg4thatihate)
    thatmysteriousfuckingarg4thatihate = thatmysteriousfuckingarg4thatihate or false
    return {
        notetime = notetime;
        notetype = notetype;
        noteend = noteend or 0;
        noteanim = noteanim or 0;
        notealive = 1;
        notescore = 0;
    }
end

local function roundToBeat(arg0, arg1, arg2, arg3)
	local arg2 = arg2 or 4
	local arg3 = arg3 or 0
    if (arg2 <= 0) then
        arg2 = 1
	end
    
    local __mps = 60 / arg1 / arg2
    return (MathUtils.round((arg0 - arg3) / __mps) * __mps) + arg3
end

__lastBPMChange = {}
__lastTimeSignature = {}

local function initTimeSignature()
	local _initial_sig = 9
	local signature = {
		type = "signature";
		time = 0;
		change = _initial_sig;
	}
	__lastTimeSignature = signature
	return signature
end

local function addTimeSignature(signature, time)
	local _initial_bpm = _initial_bpm or 170
    local signature = {
		type = "signature";
        time = roundToBeat(time, #__lastBPMChange > 0 and __lastBPMChange.change or _initial_bpm, 4, #__lastTimeSignature > 0 and __lastTimeSignature.time or 0);
		change = signature;
    }
	__lastTimeSignature = signature
	return signature
end

local function initBPMChange()
	local _initial_bpm = _initial_bpm or 170
    local bpmchange = {
		type = "bpm";
        time = 0;
		change = _initial_bpm;
    }
	__lastBPMChange = bpmchange
	return bpmchange
end

local function addBPMChange(bpm, time)
	local _initial_bpm = _initial_bpm or 170
    local bpmchange = {
		type = "bpm";
        time = roundToBeat(time, #__lastBPMChange > 0 and __lastBPMChange.change or _initial_bpm, 4, #__lastBPMChange > 0 and __lastBPMChange.time or 0);
		change = bpm;
    }
	__lastBPMChange = bpmchange
	return bpmchange
end

local _bpm = 170
local _notespacing = 170 / _bpm
local _meter = _notespacing * 4

local function setPerformerAnimation(time, performer, animation, round_to_beat, beats)
    return {
		type = "function",
        time = round_to_beat and roundToBeat(time or 0, #__lastBPMChange > 0 and __lastBPMChange.change or _bpm, beats or 4) or (time or 0),
		triggered = false,
		callback = function()
			if Game.minigame then
				Game.minigame.charts[performer or 1].performer:setAnimation(animation or "ready")
			end
		end,
    }
end

local function setChartVariable(time, chart, variable, varset, round_to_beat, beats)
    return {
		type = "variable",
        time = round_to_beat and roundToBeat(time or 0, #__lastBPMChange > 0 and __lastBPMChange.change or _bpm, beats or 4) or (time or 0),
		triggered = false,
		use_minigame_target = true,
		use_minigame_charts = true,
		target = chart or 1,
		variable = variable or nil,
		var_set = varset or nil,
    }
end

local function setSongVariable(time, variable, varset, round_to_beat, beats)
    return {
		type = "variable",
        time = round_to_beat and roundToBeat(time or 0, #__lastBPMChange > 0 and __lastBPMChange.change or _bpm, beats or 4) or (time or 0),
		triggered = false,
		use_minigame_target = true,
		use_minigame_song = true,
		target = nil,
		variable = variable or nil,
		var_set = varset or nil,
    }
end

local function setPerformerVariable(time, performer, variable, varset, round_to_beat, beats)
    return {
		type = "variable",
        time = round_to_beat and roundToBeat(time or 0, #__lastBPMChange > 0 and __lastBPMChange.change or _bpm, beats or 4) or (time or 0),
		triggered = false,
		use_minigame_target = true,
		use_minigame_performers = true,
		target = performer or 1,
		variable = variable or nil,
		var_set = varset or nil,
    }
end

local _startdelay = roundToBeat(-(405 / _bpm), _bpm)

return {
    title = "3rd Sanctuary";
	score_flag_name = "3rdSanctuary";
    bpm = 170;
    notespeed = 120;
	signature = 9;
    track_length = 129;
	start_delay = roundToBeat(-(405 / _bpm), _bpm);
	scores = {28000, 32000, 36500, 38500, 41000};
    tracks = {
        BASE_TRACK = { music = "rhythm_game/rhythm_3rd_sanctuary_noguit" };
        lead = { music = "rhythm_game/rhythm_3rd_sanctuary_guit", replace = "BASE_TRACK" };
    };
	events = {
		initTimeSignature(),
        addTimeSignature(5.5, 12.7),
		setPerformerAnimation(_startdelay, 3, "rhythm_game/clap_wait", true),
		setPerformerAnimation(_startdelay - _meter * 0.5, 2, "rhythm_game/ready", true),
		setPerformerAnimation(_startdelay - _meter * 1.5, 1, "rhythm_game/ready", true)
	};
    notes = {
        lead = {
			addNote(0, 1, 0);
			addNote(0.18, 0, 0, 1);
			addNote(0.35, 0, 0);
			addNote(0.53, 0, 0, 1);
			addNote(0.71, 1, 0, 1);
			addNote(0.88, 1, 0, 1);
			addNote(1.06, 0, 0, 1);
			addNote(1.24, 0, 0);
			addNote(1.41, 1, 0);
			addNote(3.18, 1, 0, 1);
			addNote(3.35, 0, 0, 1);
			addNote(3.53, 0, 0);
			addNote(3.71, 0, 0, 1);
			addNote(3.88, 1, 0, 1);
			addNote(4.06, 1, 0, 1);
			addNote(4.24, 0, 0, 1);
			addNote(4.41, 0, 0);
			addNote(4.59, 1, 0);
			addNote(6.35, 1, 0, 1);
			addNote(6.53, 0, 0, 1);
			addNote(6.71, 0, 0);
			addNote(6.88, 0, 0, 1);
			addNote(7.06, 1, 0, 1);
			addNote(7.24, 1, 0, 1);
			addNote(7.41, 0, 0, 1);
			addNote(7.59, 0, 0);
			addNote(7.76, 1, 0);
			addNote(9.53, 1, 0, 1);
			addNote(9.71, 0, 0, 1);
			addNote(9.88, 0, 0);
			addNote(10.06, 0, 0, 1);
			addNote(10.24, 1, 0, 1);
			addNote(10.41, 1, 0, 1);
			addNote(10.59, 0, 0, 1);
			addNote(10.76, 0, 0);
			addNote(10.94, 1, 0);
			addNote(12.71, 1, 0, 1);
			addNote(12.88, 0, 0, 1);
			addNote(13.06, 0, 0);
			addNote(13.24, 0, 0, 1);
			addNote(13.41, 1, 0, 1);
			addNote(13.59, 1, 0, 1);
			addNote(13.76, 0, 0, 1);
			addNote(13.94, 0, 0);
			addNote(14.12, 1, 0);
			addNote(14.65, 1, 0, 1);
			addNote(14.82, 0, 0, 1);
			addNote(15, 0, 0);
			addNote(15.18, 0, 0, 1);
			addNote(15.35, 1, 0, 1);
			addNote(15.53, 1, 0, 1);
			addNote(15.71, 0, 0, 1);
			addNote(15.88, 0, 0);
			addNote(16.06, 1, 0);
			addNote(16.59, 1, 0, 1);
			addNote(16.76, 0, 0, 1);
			addNote(16.94, 0, 0);
			addNote(17.12, 0, 0, 1);
			addNote(17.29, 1, 0, 1);
			addNote(17.47, 1, 0, 1);
			addNote(17.65, 0, 0, 1);
			addNote(17.82, 0, 0);
			addNote(18, 1, 0);
			addNote(18.53, 1, 0, 1);
			addNote(18.71, 0, 0, 1);
			addNote(18.88, 0, 0);
			addNote(19.06, 0, 0, 1);
			addNote(19.24, 1, 0, 1);
			addNote(19.41, 1, 0, 1);
			addNote(19.59, 0, 0, 1);
			addNote(19.76, 0, 0);
			addNote(19.94, 1, 0, 1);
			addNote(20.47, 1, 0, 1);
			addNote(20.65, 0, 0, 1);
			addNote(20.82, 0, 0);
			addNote(21, 0, 0, 1);
			addNote(21.18, 1, 0, 1);
			addNote(21.35, 1, 0, 1);
			addNote(21.53, 0, 0, 1);
			addNote(21.71, 0, 0);
			addNote(21.88, 1, 0);
			addNote(22.41, 1, 0, 1);
			addNote(22.59, 0, 0, 1);
			addNote(22.76, 0, 0);
			addNote(22.94, 0, 0, 1);
			addNote(23.12, 1, 0, 1);
			addNote(23.29, 1, 0, 1);
			addNote(23.47, 0, 0, 1);
			addNote(23.65, 0, 0);
			addNote(23.82, 1, 0);
			addNote(24.35, 1, 0);
			addNote(24.53, 0, 0);
			addNote(24.71, 0, 0);
			addNote(24.88, 0, 0);
			addNote(25.06, 1, 0);
			addNote(25.24, 1, 0);
			addNote(25.41, 0, 0);
			addNote(25.59, 0, 0);
			addNote(25.76, 1, 0);
			addNote(26.29, 1, 0);
			addNote(26.47, 0, 0);
			addNote(26.65, 0, 0);
			addNote(26.82, 0, 0);
			addNote(27, 1, 0);
			addNote(27.18, 1, 0);
			addNote(27.35, 0, 0);
			addNote(27.53, 0, 0);
			addNote(27.71, 1, 0, 1);
			addNote(28.94, 0, 30.79);
			addNote(30.88, 0, 32.74);
			addNote(32.82, 1, 34.68);
			addNote(34.76, 1, 35.74);
			addNote(35.82, 1, 36.62);
			addNote(36.71, 1, 38.56);
			addNote(38.65, 0, 39.62);
			addNote(39.71, 0, 40.5);
			addNote(40.59, 1, 42.79);
			addNote(44.47, 0, 44.65);
			addNote(44.82, 0, 0);
			addNote(45, 1, 45.18);
			addNote(45.35, 1, 45.71);
			addNote(45.88, 0, 46.15);
			addNote(46.24, 1, 46.68);
			addNote(46.76, 0, 47.03);
			addNote(47.12, 1, 47.65);
			addNote(48, 1, 48.35);
			addNote(48.53, 0, 0);
			addNote(48.71, 1, 0);
			addNote(48.88, 0, 49.24);
			addNote(49.41, 1, 0);
			addNote(49.76, 1, 50.21);
			addNote(50.29, 0, 50.56);
			addNote(50.65, 0, 51);
			addNote(51.18, 0, 51.44);
			addNote(51.53, 1, 53.21);
			addNote(53.29, 1, 53.56);
			addNote(53.65, 0, 53.91);
			addNote(54, 1, 54.26, 1);
			addNote(54.35, 1, 54.62);
			addNote(54.71, 1, 54.97);
			addNote(55.06, 0, 56.38);
			addNote(56.47, 0, 0);
			addNote(56.65, 1, 0);
			addNote(56.82, 0, 0);
			addNote(57.18, 0, 0);
			addNote(57.53, 0, 0);
			addNote(57.88, 1, 0);
			addNote(58.24, 1, 0);
			addNote(58.59, 1, 0);
			addNote(58.76, 0, 0);
			addNote(58.94, 1, 0);
			addNote(59.12, 0, 0);
			addNote(59.29, 1, 0);
			addNote(59.47, 1, 0);
			addNote(59.65, 0, 0);
			addNote(59.82, 1, 0);
			addNote(60, 0, 0);
			addNote(60.18, 1, 0);
			addNote(60.35, 1, 0);
			addNote(60.53, 0, 0);
			addNote(60.71, 1, 0);
			addNote(60.88, 0, 0);
			addNote(61.06, 1, 0);
			addNote(61.24, 1, 0);
			addNote(61.41, 0, 0);
			addNote(61.59, 1, 0);
			addNote(61.76, 0, 0);
			addNote(61.94, 1, 0);
			addNote(62.12, 1, 0);
			addNote(62.29, 0, 0);
			addNote(62.47, 0, 0);
			addNote(62.65, 0, 0);
			addNote(62.82, 1, 0);
			addNote(63, 1, 0);
			addNote(63.18, 0, 0);
			addNote(63.35, 0, 0);
			addNote(63.53, 0, 0);
			addNote(63.71, 1, 0);
			addNote(63.88, 1, 0);
			addNote(64.06, 0, 0);
			addNote(64.24, 0, 0);
			addNote(64.41, 0, 0);
			addNote(64.59, 1, 0);
			addNote(64.76, 1, 0);
			addNote(64.94, 0, 0);
			addNote(65.12, 0, 0);
			addNote(65.29, 0, 0);
			addNote(65.47, 1, 0);
			addNote(65.65, 1, 0);
			addNote(65.82, 0, 0);
			addNote(66, 1, 0);
			addNote(66.18, 0, 0);
			addNote(66.35, 1, 0);
			addNote(66.53, 1, 0);
			addNote(66.71, 0, 0);
			addNote(66.88, 1, 0);
			addNote(67.06, 0, 0);
			addNote(67.24, 1, 0);
			addNote(67.41, 1, 0);
			addNote(67.59, 0, 0);
			addNote(67.76, 1, 0);
			addNote(67.94, 0, 0);
			addNote(68.12, 1, 0);
			addNote(68.29, 1, 0);
			addNote(68.47, 0, 0);
			addNote(68.65, 1, 0);
			addNote(68.82, 0, 0);
			addNote(69, 1, 0);
			addNote(69.18, 0, 0);
			addNote(69.35, 0, 0);
			addNote(69.53, 1, 0);
			addNote(69.71, 1, 0);
			addNote(69.88, 1, 0);
			addNote(70.06, 0, 0);
			addNote(70.24, 0, 0);
			addNote(70.41, 1, 0);
			addNote(70.59, 1, 0);
			addNote(70.76, 1, 0);
			addNote(70.94, 0, 0);
			addNote(71.12, 0, 0);
			addNote(71.29, 1, 0);
			addNote(71.47, 1, 0);
			addNote(71.65, 1, 0);
			addNote(71.82, 0, 0);
			addNote(72, 0, 0);
			addNote(72.18, 1, 0);
			addNote(72.35, 1, 0);
			addNote(72.53, 0, 0);
			addNote(72.88, 1, 0);
			addNote(73.06, 0, 0);
			addNote(73.24, 1, 0);
			addNote(73.41, 0, 0);
			addNote(73.59, 1, 0);
			addNote(73.76, 1, 0);
			addNote(73.94, 0, 0);
			addNote(74.12, 0, 0);
			addNote(74.29, 1, 0);
			addNote(74.82, 1, 0);
			addNote(75, 0, 0);
			addNote(75.18, 1, 0);
			addNote(75.35, 0, 0);
			addNote(75.53, 1, 0);
			addNote(75.71, 1, 0);
			addNote(75.88, 0, 0);
			addNote(76.06, 0, 0);
			addNote(76.24, 1, 0);
			addNote(76.76, 1, 0);
			addNote(76.94, 0, 0);
			addNote(77.12, 1, 0);
			addNote(77.29, 0, 0);
			addNote(77.47, 1, 0);
			addNote(77.65, 1, 0);
			addNote(77.82, 0, 0);
			addNote(78, 0, 0);
			addNote(78.18, 1, 0);
			addNote(78.53, 1, 0);
			addNote(78.71, 0, 0);
			addNote(78.88, 1, 0);
			addNote(79.06, 0, 0);
			addNote(79.24, 0, 0);
			addNote(79.41, 1, 0);
			addNote(79.59, 0, 0);
			addNote(79.76, 1, 0);
			addNote(79.94, 1, 0);
			addNote(80.65, 1, 0);
			addNote(80.82, 0, 0);
			addNote(81, 1, 0);
			addNote(81.18, 0, 0);
			addNote(81.35, 1, 0);
			addNote(81.53, 1, 0);
			addNote(81.71, 0, 0);
			addNote(81.88, 0, 0);
			addNote(82.06, 1, 0);
			addNote(82.59, 1, 0);
			addNote(82.76, 0, 0);
			addNote(82.94, 1, 0);
			addNote(83.12, 0, 0);
			addNote(83.29, 1, 0);
			addNote(83.47, 1, 0);
			addNote(83.65, 0, 0);
			addNote(83.82, 0, 0);
			addNote(84, 1, 0);
			addNote(84.53, 1, 0);
			addNote(84.71, 0, 0);
			addNote(84.88, 1, 0);
			addNote(85.06, 0, 0);
			addNote(85.24, 1, 0);
			addNote(85.41, 1, 0);
			addNote(85.59, 0, 0);
			addNote(85.76, 0, 0);
			addNote(85.94, 1, 0);
			addNote(86.29, 1, 0);
			addNote(86.38, 0, 0);
			addNote(86.47, 1, 86.74, 1);
			addNote(86.82, 0, 0, 1);
			addNote(86.91, 1, 0, 1);
			addNote(87, 0, 87.26);
			addNote(87.35, 1, 0, 1);
			addNote(87.53, 0, 0, 1);
			addNote(87.71, 0, 0);
			addNote(87.88, 0, 0, 1);
			addNote(88.06, 1, 88.5, 1);
			addNote(88.68, 1, 0);
			addNote(88.85, 0, 0);
			addNote(89.03, 0, 0);
			addNote(89.21, 1, 0);
			addNote(89.38, 1, 0);
			addNote(89.56, 0, 0);
			addNote(89.74, 0, 0);
			addNote(89.91, 0, 0);
			addNote(90.09, 1, 0);
			addNote(90.26, 0, 0);
			addNote(90.44, 1, 0);
			addNote(90.62, 1, 0);
			addNote(90.79, 0, 0);
			addNote(90.97, 0, 0);
			addNote(91.15, 1, 0);
			addNote(91.32, 1, 0);
			addNote(91.5, 1, 0);
			addNote(91.68, 0, 0);
			addNote(91.85, 1, 0);
			addNote(92.03, 0, 0, 1);
			addNote(92.21, 1, 0, 1);
			addNote(92.38, 0, 0, 1);
			addNote(92.74, 1, 0);
			addNote(92.91, 0, 0);
			addNote(93.09, 0, 0);
			addNote(93.26, 0, 0);
			addNote(93.44, 1, 0);
			addNote(93.62, 1, 0);
			addNote(93.79, 0, 0);
			addNote(93.97, 0, 0);
			addNote(94.15, 0, 0);
			addNote(94.32, 1, 0);
			addNote(94.5, 0, 0);
			addNote(94.68, 1, 0);
			addNote(94.85, 0, 0);
			addNote(95.03, 0, 0);
			addNote(95.21, 1, 0);
			addNote(95.38, 1, 0);
			addNote(95.56, 1, 0);
			addNote(95.74, 0, 0);
			addNote(95.91, 0, 0);
			addNote(96.09, 0, 0, 1);
			addNote(96.26, 1, 0, 1);
			addNote(96.44, 0, 0);
			addNote(96.79, 1, 0);
			addNote(96.97, 0, 0);
			addNote(97.15, 0, 0);
			addNote(97.32, 0, 0);
			addNote(97.5, 1, 0);
			addNote(97.68, 1, 0);
			addNote(97.85, 0, 0);
			addNote(98.03, 0, 0);
			addNote(98.21, 1, 0);
			addNote(98.38, 1, 0);
			addNote(98.56, 0, 0);
			addNote(98.74, 1, 0);
			addNote(98.91, 0, 0);
			addNote(99.09, 0, 0);
			addNote(99.26, 1, 0);
			addNote(99.44, 1, 0);
			addNote(99.62, 1, 0);
			addNote(99.79, 0, 0);
			addNote(99.97, 0, 0);
			addNote(100.15, 0, 0);
			addNote(100.32, 1, 0);
			addNote(100.5, 0, 0);
			addNote(100.85, 1, 0);
			addNote(101.03, 0, 0);
			addNote(101.21, 0, 0);
			addNote(101.38, 0, 0);
			addNote(101.56, 1, 0);
			addNote(101.74, 1, 0);
			addNote(101.91, 0, 0);
			addNote(102.09, 0, 0);
			addNote(102.26, 0, 0);
			addNote(102.44, 0, 0);
			addNote(102.62, 1, 0);
			addNote(102.79, 1, 0);
			addNote(102.97, 0, 0);
			addNote(103.15, 0, 0);
			addNote(103.32, 1, 0);
			addNote(103.5, 1, 0);
			addNote(103.68, 1, 0);
			addNote(103.85, 0, 0);
			addNote(104.03, 0, 0);
			addNote(104.21, 0, 0);
			addNote(104.38, 1, 0);
			addNote(104.56, 0, 0);
			addNote(104.91, 1, 0);
			addNote(105.09, 0, 0);
			addNote(105.26, 0, 0);
			addNote(105.44, 1, 0);
			addNote(105.62, 1, 0);
			addNote(105.79, 1, 107.65);
			addNote(108, 1, 108.26);
			addNote(108.35, 0, 108.62);
			addNote(109.06, 1, 0);
			addNote(109.24, 0, 0);
			addNote(109.41, 0, 0);
			addNote(109.59, 1, 0);
			addNote(109.76, 1, 0);
			addNote(109.94, 1, 110.29);
			addNote(110.47, 0, 110.82);
			addNote(111, 1, 111.88);
			addNote(112.06, 1, 112.32);
			addNote(112.41, 0, 112.68);
			addNote(113.03, 1, 0);
			addNote(113.21, 0, 0);
			addNote(113.38, 0, 0);
			addNote(113.56, 1, 0);
			addNote(113.74, 1, 0);
			addNote(113.91, 1, 115.77);
			addNote(116.12, 1, 116.38);
			addNote(116.47, 0, 116.74);
			addNote(117.18, 1, 0);
			addNote(117.35, 0, 0);
			addNote(117.53, 0, 0);
			addNote(117.71, 1, 0);
			addNote(117.88, 1, 0);
			addNote(118.06, 1, 118.41);
			addNote(118.59, 0, 118.94);
			addNote(119.12, 1, 120);
			addNote(120.18, 1, 120.44);
			addNote(120.53, 0, 120.79);
			addNote(121.24, 1, 0, 1);
			addNote(121.41, 1, 0);
			addNote(121.59, 0, 0);
			addNote(121.76, 1, 0);
			addNote(121.94, 1, 0, 1);
			addNote(122.12, 1, 123.97, 1);
			addNote(124.24, 1, 124.5);
			addNote(124.59, 0, 124.85);
			addNote(125.29, 1, 0);
			addNote(125.47, 1, 0);
			addNote(125.65, 0, 0);
			addNote(125.82, 1, 0);
			addNote(126, 1, 0);
			addNote(126.18, 1, 126.62);
			addNote(126.71, 0, 128.21);
			addNote(127.24, 1, 128.2);
			addNote(128.29, 1, 129);
			addNote(128.65, 0, 129);
        };
        drums = {
        };
		vocals = {
		};
    };
}