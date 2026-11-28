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
	local _initial_bpm = _initial_bpm or 200
    local signature = {
		type = "signature";
        time = roundToBeat(time, #__lastBPMChange > 0 and __lastBPMChange.change or _initial_bpm, 4, #__lastTimeSignature > 0 and __lastTimeSignature.time or 0);
		change = signature;
    }
	__lastTimeSignature = signature
	return signature
end

local function initBPMChange()
	local _initial_bpm = _initial_bpm or 200
    local bpmchange = {
		type = "bpm";
        time = 0;
		change = _initial_bpm;
    }
	__lastBPMChange = bpmchange
	return bpmchange
end

local function addBPMChange(bpm, time)
	local _initial_bpm = _initial_bpm or 200
    local bpmchange = {
		type = "bpm";
        time = roundToBeat(time, #__lastBPMChange > 0 and __lastBPMChange.change or _initial_bpm, 4, #__lastBPMChange > 0 and __lastBPMChange.time or 0);
		change = bpm;
    }
	__lastBPMChange = bpmchange
	return bpmchange
end

local _bpm = 200
local _notespacing = 60 / _bpm
local _meter = _notespacing * 4

local function setPerformerAnimation(time, performer, animation, round_to_beat, beats)
    return {
		type = "function",
        time = round_to_beat and roundToBeat(time or 0, #__lastBPMChange > 0 and __lastBPMChange.change or _bpm, beats) or (time or 0),
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
    title = "4rd Sanctuary";
	score_flag_name = "4rdSanctuary";
    bpm = 200;
    notespeed = 180;
	signature = 9;
    track_length = 79.2;
	start_delay = roundToBeat(-(405 / _bpm), _bpm);
	scores = {15500, 18500, 21000, 22500, 24000};
    tracks = {
        BASE_TRACK = { music = "rhythm_game/4rd_sanctuary_noguit" };
        lead = { music = "rhythm_game/4rd_sanctuary", replace = "BASE_TRACK" };
    };
	events = {
		initTimeSignature(),
        addTimeSignature(7, 10.8),
        addTimeSignature(4.5, 12.9),
        addTimeSignature(7, 14.25),
        addTimeSignature(4.5, 16.35),
        addTimeSignature(7, 17.7),
        addTimeSignature(4.5, 19.8),
        addTimeSignature(7, 21.15),
        addTimeSignature(5, 23.25),
        addTimeSignature(5.5, 24.75),
        addTimeSignature(5, 29.7),
        addTimeSignature(5.5, 31.2),
        addTimeSignature(6, 37.8),
        addTimeSignature(4.5, 39.6),
        addTimeSignature(6, 40.95),
        addTimeSignature(5.5, 42.75),
        addTimeSignature(6, 44.4),
        addTimeSignature(5.5, 46.2),
        addTimeSignature(6, 47.85),
        addTimeSignature(5.5, 49.65),
        addTimeSignature(6, 51.3),
        addTimeSignature(5, 53.1),
        addTimeSignature(6, 54.6),
        addTimeSignature(5.5, 56.4),
        addTimeSignature(6, 58.05),
        addTimeSignature(4, 59.85),
        addTimeSignature(9, 61.05),
        addTimeSignature(8.5, 66.45),
        addTimeSignature(19, 69),
        addTimeSignature(9, 74.7),
		setPerformerAnimation(_startdelay, 3, "rhythm_game/clap", true),
		setPerformerAnimation(_startdelay - _meter * 0.5, 2, "rhythm_game/ready", true),
		setPerformerAnimation(_startdelay - _meter * 1.5, 1, "rhythm_game/ready", true),
		setPerformerAnimation(28.4, 3, "rhythm_game/play", true, 1),
		setPerformerAnimation(33, 3, "rhythm_game/clap", true, 1),
		setPerformerAnimation(40.6, 3, "rhythm_game/play", true, 1),
		setPerformerAnimation(61.89, 3, "rhythm_game/clap", true, 1),
		setPerformerAnimation(62, 2, "rhythm_game/ready", true, 1),
		setSongVariable(69.1, "note_beats", true, true, 0.25),
		setSongVariable(75.8, "note_beats", false, true, 0.25)
	};
    notes = {
        lead = {
			addNote(0, 1, 0);
			addNote(0.15, 0, 0, 1);
			addNote(0.3, 0, 0);
			addNote(0.45, 0, 0, 1);
			addNote(0.6, 1, 0, 1);
			addNote(0.75, 1, 0, 1);
			addNote(0.9, 0, 0, 1);
			addNote(1.05, 0, 0);
			addNote(1.2, 1, 0);
			addNote(2.7, 1, 0, 1);
			addNote(2.85, 0, 0, 1);
			addNote(3, 0, 0);
			addNote(3.15, 0, 0, 1);
			addNote(3.3, 1, 0, 1);
			addNote(3.6, 1, 0, 1);
			addNote(3.75, 0, 0, 1);
			addNote(3.9, 0, 0);
			addNote(4.05, 1, 0);
			addNote(5.4, 1, 0, 1);
			addNote(5.55, 0, 0, 1);
			addNote(5.7, 0, 0);
			addNote(6, 0, 0, 1);
			addNote(6.15, 1, 0, 1);
			addNote(6.3, 1, 0, 1);
			addNote(6.45, 0, 0, 1);
			addNote(6.75, 0, 0);
			addNote(7.05, 1, 0);
			addNote(8.1, 1, 0, 1);
			addNote(9.3, 1, 0);
			addNote(9.45, 0, 0);
			addNote(9.6, 1, 0);
			addNote(10.8, 1, 0, 1);
			addNote(11.4, 1, 0, 1);
			addNote(11.55, 0, 0, 1);
			addNote(12, 1, 0, 1);
			addNote(12.15, 0, 0, 1);
			addNote(12.3, 0, 0);
			addNote(12.45, 1, 0);
			addNote(12.9, 1, 0, 1);
			addNote(13.35, 1, 0);
			addNote(13.5, 0, 0);
			addNote(13.65, 1, 0);
			addNote(13.8, 1, 0);
			addNote(13.95, 0, 0);
			addNote(14.1, 1, 0);
			addNote(14.25, 1, 0, 1);
			addNote(14.85, 1, 0, 1);
			addNote(15, 0, 0);
			addNote(15.45, 1, 0, 1);
			addNote(15.6, 0, 0, 1);
			addNote(15.75, 0, 0);
			addNote(15.9, 1, 0);
			addNote(16.35, 1, 0, 1);
			addNote(16.8, 1, 0, 1);
			addNote(16.95, 1, 0, 1);
			addNote(17.1, 0, 0, 1);
			addNote(17.25, 0, 0);
			addNote(17.4, 1, 0);
			addNote(17.55, 1, 0);
			addNote(17.7, 1, 0);
			addNote(18.3, 1, 0, 1);
			addNote(18.45, 0, 0, 1);
			addNote(18.9, 1, 0, 1);
			addNote(19.05, 0, 0, 1);
			addNote(19.2, 0, 0);
			addNote(19.35, 1, 0);
			addNote(19.8, 1, 0, 1);
			addNote(20.25, 1, 0);
			addNote(20.4, 0, 0);
			addNote(20.55, 1, 0);
			addNote(20.7, 1, 0);
			addNote(20.85, 0, 0);
			addNote(21, 1, 0);
			addNote(21.15, 1, 0, 1);
			addNote(21.75, 1, 0, 1);
			addNote(21.9, 0, 0, 1);
			addNote(22.35, 1, 0, 1);
			addNote(22.5, 0, 0, 1);
			addNote(22.65, 0, 0);
			addNote(22.8, 1, 0);
			addNote(23.25, 1, 0, 1);
			addNote(23.7, 1, 0, 1);
			addNote(23.85, 1, 0, 1);
			addNote(24, 0, 0, 1);
			addNote(24.15, 0, 0);
			addNote(24.3, 1, 0);
			addNote(24.45, 1, 0);
			addNote(24.75, 0, 24.97);
			addNote(25.05, 0, 25.27);
			addNote(25.35, 1, 0, 1);
			addNote(25.5, 0, 0);
			addNote(25.65, 0, 25.88);
			addNote(25.95, 1, 0);
			addNote(26.4, 0, 26.62);
			addNote(26.7, 0, 26.93, 1);
			addNote(27, 1, 0, 1);
			addNote(27.15, 0, 0);
			addNote(27.3, 0, 27.52);
			addNote(27.6, 1, 0);
			addNote(28.05, 0, 28.27);
			addNote(28.35, 0, 28.57);
			addNote(28.65, 1, 0, 1);
			addNote(28.8, 0, 0);
			addNote(28.95, 0, 29.17);
			addNote(29.25, 1, 0);
			addNote(29.7, 0, 30.07);
			addNote(30.15, 0, 0, 1);
			addNote(30.3, 1, 0, 1);
			addNote(30.45, 1, 30.82);
			addNote(30.9, 0, 31.12);
			addNote(31.2, 1, 31.57);
			addNote(31.65, 0, 31.88);
			addNote(31.95, 0, 32.32);
			addNote(32.4, 1, 32.62);
			addNote(32.85, 0, 33.07);
			addNote(33.15, 0, 33.38);
			addNote(33.45, 1, 0, 1);
			addNote(33.6, 0, 0);
			addNote(33.75, 0, 33.98);
			addNote(34.05, 1, 0);
			addNote(34.5, 0, 34.73);
			addNote(34.8, 0, 35.02);
			addNote(35.1, 1, 0, 1);
			addNote(35.25, 0, 0);
			addNote(35.4, 0, 35.62);
			addNote(35.7, 1, 0);
			addNote(36.15, 0, 36.38);
			addNote(36.45, 0, 36.67);
			addNote(36.75, 1, 0, 1);
			addNote(36.9, 0, 0);
			addNote(37.05, 0, 37.27);
			addNote(37.35, 1, 0);
			addNote(37.65, 1, 0);
			addNote(37.73, 0, 0, 1);
			addNote(37.8, 1, 38.02, 1);
			addNote(38.1, 0, 0, 1);
			addNote(38.17, 1, 0);
			addNote(38.25, 0, 38.48);
			addNote(38.55, 1, 0);
			addNote(38.7, 0, 0);
			addNote(38.85, 0, 0);
			addNote(39, 1, 0);
			addNote(39.15, 1, 39.38, 1);
			addNote(39.6, 0, 0);
			addNote(39.75, 0, 0);
			addNote(39.9, 1, 0);
			addNote(40.05, 1, 40.28, 1);
			addNote(40.5, 0, 0);
			addNote(40.65, 0, 0);
			addNote(40.8, 1, 0);
			addNote(41.1, 1, 0);
			addNote(41.25, 0, 0);
			addNote(41.4, 0, 0);
			addNote(41.55, 0, 0);
			addNote(41.7, 1, 0);
			addNote(41.85, 1, 43.2);
			addNote(43.65, 1, 43.88);
			addNote(43.95, 0, 44.17);
			addNote(44.55, 1, 0);
			addNote(44.7, 0, 0);
			addNote(44.85, 0, 0);
			addNote(45, 0, 0);
			addNote(45.15, 1, 0);
			addNote(45.3, 1, 45.6);
			addNote(45.75, 0, 46.05);
			addNote(46.2, 1, 46.8, 1);
			addNote(47.1, 1, 47.32);
			addNote(47.4, 0, 47.62);
			addNote(48, 1, 0);
			addNote(48.15, 0, 0);
			addNote(48.3, 0, 0);
			addNote(48.45, 0, 0);
			addNote(48.6, 1, 0);
			addNote(48.75, 1, 50.1);
			addNote(50.55, 1, 50.77);
			addNote(50.85, 0, 51.07);
			addNote(51.45, 1, 0);
			addNote(51.6, 0, 0);
			addNote(51.75, 0, 0);
			addNote(51.9, 0, 0);
			addNote(52.05, 1, 0);
			addNote(52.2, 1, 52.42);
			addNote(52.65, 0, 52.95);
			addNote(53.1, 1, 53.7, 1);
			addNote(54, 1, 54.22);
			addNote(54.3, 0, 54.6);
			addNote(54.75, 1, 0);
			addNote(54.9, 0, 0);
			addNote(55.05, 0, 0);
			addNote(55.2, 0, 0, 1);
			addNote(55.35, 1, 0, 1);
			addNote(55.5, 1, 56.85, 1);
			addNote(57.3, 1, 57.52, 1);
			addNote(57.6, 0, 57.82, 1);
			addNote(58.2, 1, 0);
			addNote(58.35, 0, 0);
			addNote(58.5, 0, 0, 1);
			addNote(58.65, 0, 0, 1);
			addNote(58.8, 1, 0, 1);
			addNote(58.95, 1, 59.17, 1);
			addNote(59.4, 0, 59.7, 1);
			addNote(59.85, 1, 60.45, 1);
			addNote(60.75, 1, 60.97);
			addNote(61.05, 1, 0);
			addNote(61.2, 0, 0);
			addNote(61.35, 0, 0);
			addNote(61.5, 0, 0);
			addNote(61.65, 1, 0);
			addNote(61.8, 1, 0);
			addNote(61.95, 0, 0);
			addNote(62.1, 0, 0);
			addNote(62.25, 1, 0);
			addNote(63.75, 1, 0, 1);
			addNote(63.9, 0, 0, 1);
			addNote(64.05, 0, 0);
			addNote(64.2, 0, 0, 1);
			addNote(64.35, 1, 0, 1);
			addNote(64.65, 1, 0, 1);
			addNote(64.8, 0, 0, 1);
			addNote(64.95, 0, 0);
			addNote(65.1, 1, 0);
			addNote(66.45, 1, 0, 1);
			addNote(66.6, 0, 0, 1);
			addNote(66.75, 0, 0);
			addNote(67.05, 0, 0, 1);
			addNote(67.2, 1, 0, 1);
			addNote(67.5, 1, 0, 1);
			addNote(67.65, 0, 0, 1);
			addNote(67.95, 0, 0);
			addNote(68.25, 1, 0);
			addNote(69, 1, 0, 1);
			addNote(69.15, 0, 0, 1);
			addNote(69.9, 0, 0);
			addNote(70.35, 0, 0);
			addNote(70.95, 0, 0);
			addNote(71.25, 0, 0);
			addNote(71.7, 0, 0);
			addNote(71.85, 0, 0);
			addNote(72.15, 0, 0);
			addNote(72.38, 0, 0);
			addNote(72.6, 0, 0);
			addNote(72.83, 0, 0);
			addNote(73.12, 0, 0);
			addNote(73.42, 1, 0, 1);
			addNote(75.9, 1, 0);
			addNote(76.05, 0, 0);
			addNote(76.2, 1, 0);
        };
        drums = {
			addNote(10.8, 1, 0);
			addNote(11.1, 0, 0);
			addNote(11.4, 1, 0);
			addNote(11.55, 1, 0);
			addNote(11.7, 0, 0);
			addNote(12, 0, 0);
			addNote(12.3, 1, 0);
			addNote(12.38, 1, 0);
			addNote(12.45, 1, 0);
			addNote(12.75, 0, 0);
			addNote(13.05, 1, 0);
			addNote(13.2, 1, 0);
			addNote(13.35, 0, 0);
			addNote(13.5, 0, 0);
			addNote(13.65, 0, 0);
			addNote(13.8, 0, 0);
			addNote(13.95, 0, 0);
			addNote(14.1, 0, 0);
			addNote(14.25, 1, 0);
			addNote(14.55, 0, 0);
			addNote(14.85, 1, 0);
			addNote(15, 1, 0);
			addNote(15.15, 0, 0);
			addNote(15.45, 0, 0);
			addNote(15.75, 1, 0);
			addNote(15.82, 1, 0);
			addNote(15.9, 1, 0);
			addNote(16.2, 0, 0);
			addNote(16.5, 1, 0);
			addNote(16.65, 1, 0);
			addNote(16.8, 0, 0);
			addNote(16.95, 0, 0);
			addNote(17.1, 0, 0);
			addNote(17.25, 0, 0);
			addNote(17.4, 0, 0);
			addNote(17.55, 0, 0);
			addNote(17.7, 1, 0);
			addNote(18, 0, 0);
			addNote(18.3, 1, 0);
			addNote(18.45, 1, 0);
			addNote(18.6, 0, 0);
			addNote(18.9, 0, 0);
			addNote(19.2, 1, 0);
			addNote(19.27, 1, 0);
			addNote(19.35, 1, 0);
			addNote(19.65, 0, 0);
			addNote(19.95, 1, 0);
			addNote(20.1, 1, 0);
			addNote(20.25, 0, 0);
			addNote(20.4, 0, 0);
			addNote(20.55, 0, 0);
			addNote(20.7, 0, 0);
			addNote(20.85, 0, 0);
			addNote(21, 0, 0);
			addNote(21.15, 1, 0);
			addNote(21.45, 0, 0);
			addNote(21.75, 1, 0);
			addNote(21.9, 1, 0);
			addNote(22.05, 0, 0);
			addNote(22.35, 0, 0);
			addNote(22.65, 1, 0);
			addNote(22.73, 1, 0);
			addNote(22.8, 1, 0);
			addNote(23.1, 0, 0);
			addNote(23.4, 1, 0);
			addNote(23.55, 1, 0);
			addNote(23.7, 0, 0);
			addNote(23.85, 0, 0);
			addNote(24, 0, 0);
			addNote(24.15, 0, 0);
			addNote(24.3, 0, 0);
			addNote(24.45, 0, 0);
			addNote(24.6, 1, 0);
			addNote(25.05, 0, 0);
			addNote(25.05, 1, 0);
			addNote(25.5, 1, 0);
			addNote(25.65, 0, 0);
			addNote(25.95, 0, 0);
			addNote(25.95, 1, 0);
			addNote(26.25, 1, 0);
			addNote(26.7, 1, 0);
			addNote(26.7, 0, 0);
			addNote(27.15, 1, 0);
			addNote(27.3, 0, 0);
			addNote(27.6, 0, 0);
			addNote(27.6, 1, 0);
			addNote(27.9, 1, 0);
			addNote(28.35, 1, 0);
			addNote(28.35, 0, 0);
			addNote(28.8, 1, 0);
			addNote(28.95, 0, 0);
			addNote(29.25, 0, 0);
			addNote(29.25, 1, 0);
			addNote(29.7, 1, 0);
			addNote(30, 0, 0);
			addNote(30.3, 1, 0);
			addNote(30.45, 1, 0);
			addNote(30.75, 0, 0);
			addNote(30.75, 1, 0);
			addNote(31.2, 1, 0);
			addNote(31.5, 0, 0);
			addNote(31.8, 1, 0);
			addNote(31.95, 1, 0);
			addNote(32.25, 1, 0);
			addNote(32.25, 0, 0);
			addNote(32.7, 1, 0);
			addNote(33.15, 1, 0);
			addNote(33.15, 0, 0);
			addNote(33.6, 1, 0);
			addNote(33.75, 0, 0);
			addNote(34.05, 0, 0);
			addNote(34.05, 1, 0);
			addNote(34.35, 1, 0);
			addNote(34.8, 1, 0);
			addNote(34.8, 0, 0);
			addNote(35.25, 1, 0);
			addNote(35.4, 0, 0);
			addNote(35.7, 0, 0);
			addNote(35.7, 1, 0);
			addNote(36, 1, 0);
			addNote(36.45, 1, 0);
			addNote(36.45, 0, 0);
			addNote(36.9, 1, 0);
			addNote(37.05, 0, 0);
			addNote(37.35, 0, 0);
			addNote(37.35, 1, 0);
			addNote(40.95, 1, 0);
			addNote(40.95, 0, 0);
			addNote(41.4, 0, 0);
			addNote(41.7, 1, 0);
			addNote(41.85, 1, 0);
			addNote(42.3, 0, 0);
			addNote(42.75, 1, 0);
			addNote(42.75, 0, 0);
			addNote(43.05, 0, 0);
			addNote(43.35, 1, 0);
			addNote(43.5, 1, 0);
			addNote(43.95, 0, 0);
			addNote(44.4, 0, 0);
			addNote(44.55, 1, 0);
			addNote(44.85, 0, 0);
			addNote(45.15, 1, 0);
			addNote(45.3, 1, 0);
			addNote(45.75, 0, 0);
			addNote(46.2, 1, 0);
			addNote(46.2, 0, 0);
			addNote(46.5, 0, 0);
			addNote(46.8, 1, 0);
			addNote(46.95, 1, 0);
			addNote(47.4, 0, 0);
			addNote(47.7, 0, 0);
			addNote(47.85, 1, 0);
			addNote(47.85, 0, 0);
			addNote(48.3, 0, 0);
			addNote(48.6, 1, 0);
			addNote(48.75, 1, 0);
			addNote(49.2, 0, 0);
			addNote(49.65, 1, 0);
			addNote(49.65, 0, 0);
			addNote(49.95, 0, 0);
			addNote(50.25, 1, 0);
			addNote(50.4, 1, 0);
			addNote(50.85, 0, 0);
			addNote(51.3, 0, 0);
			addNote(51.45, 1, 0);
			addNote(51.75, 0, 0);
			addNote(52.05, 1, 0);
			addNote(52.2, 1, 0);
			addNote(52.65, 0, 0);
			addNote(53.1, 1, 0);
			addNote(53.1, 0, 0);
			addNote(53.4, 0, 0);
			addNote(53.7, 1, 0);
			addNote(53.85, 1, 0);
			addNote(54.3, 0, 0);
			addNote(54.6, 1, 0);
			addNote(54.6, 0, 0);
			addNote(55.05, 0, 0);
			addNote(55.35, 1, 0);
			addNote(55.5, 1, 0);
			addNote(55.95, 0, 0);
			addNote(56.4, 1, 0);
			addNote(56.4, 0, 0);
			addNote(56.7, 0, 0);
			addNote(57, 1, 0);
			addNote(57.15, 1, 0);
			addNote(57.6, 0, 0);
			addNote(58.05, 0, 0);
			addNote(58.2, 1, 0);
			addNote(58.5, 0, 0);
			addNote(58.8, 1, 0);
			addNote(58.95, 1, 0);
			addNote(59.4, 0, 0);
			addNote(59.85, 1, 0);
			addNote(59.85, 0, 0);
        };
		vocals = {
			addNote(10.8, 1, 0);
			addNote(11.4, 1, 0);
			addNote(11.55, 1, 0);
			addNote(12.45, 1, 0);
			addNote(13.05, 1, 0);
			addNote(13.2, 1, 0);
			addNote(14.25, 1, 0);
			addNote(14.85, 1, 0);
			addNote(15, 1, 0);
			addNote(15.9, 1, 0);
			addNote(16.5, 1, 0);
			addNote(16.65, 1, 0);
			addNote(17.7, 1, 0);
			addNote(18.3, 1, 0);
			addNote(18.45, 1, 0);
			addNote(19.35, 1, 0);
			addNote(19.95, 1, 0);
			addNote(20.1, 1, 0);
			addNote(21.15, 1, 0);
			addNote(21.75, 1, 0);
			addNote(21.9, 1, 0);
			addNote(22.8, 1, 0);
			addNote(23.4, 1, 0);
			addNote(23.55, 1, 0);
			addNote(29.7, 0, 30.15);
			addNote(30.15, 1, 30.32);
			addNote(30.3, 2, 30.47);
			addNote(30.45, 1, 30.9);
			addNote(30.9, 1, 31.2);
			addNote(31.2, 1, 31.65);
			addNote(31.65, 0, 31.95);
			addNote(31.95, 0, 32.4);
			addNote(32.4, 1, 32.7);
			addNote(40.95, 1, 41.12);
			addNote(41.1, 0, 41.27);
			addNote(41.25, 1, 41.42);
			addNote(41.4, 1, 41.57);
			addNote(41.55, 2, 41.62);
			addNote(41.7, 2, 43.65);
			addNote(43.65, 1, 43.95);
			addNote(43.95, 0, 44.25);
			addNote(44.55, 1, 44.72);
			addNote(44.7, 0, 44.87);
			addNote(44.85, 1, 45.02);
			addNote(45, 2, 45.07);
			addNote(45.15, 2, 45.75);
			addNote(45.75, 0, 46.2);
			addNote(46.2, 1, 47.1);
			addNote(47.1, 1, 47.4);
			addNote(47.4, 0, 47.7);
			addNote(48, 1, 48.17);
			addNote(48.15, 0, 48.32);
			addNote(48.3, 1, 48.47);
			addNote(48.45, 1, 48.62);
			addNote(48.6, 2, 48.68);
			addNote(48.75, 2, 50.7);
			addNote(50.7, 1, 51);
			addNote(51, 0, 51.3);
			addNote(51.6, 1, 51.77);
			addNote(51.75, 0, 51.92);
			addNote(51.9, 1, 52.07);
			addNote(52.05, 2, 52.12);
			addNote(52.2, 2, 52.8);
			addNote(52.8, 0, 53.25);
			addNote(53.25, 1, 54.15);
			addNote(54.15, 1, 54.45);
			addNote(54.45, 0, 54.75);
			addNote(54.75, 1, 54.92);
			addNote(54.9, 0, 55.07);
			addNote(55.05, 1, 55.22);
			addNote(55.2, 1, 55.37);
			addNote(55.35, 2, 55.43);
			addNote(55.5, 2, 57.45);
			addNote(57.45, 1, 57.75);
			addNote(57.75, 0, 58.05);
			addNote(58.35, 1, 58.52);
			addNote(58.5, 0, 58.67);
			addNote(58.65, 1, 58.82);
			addNote(58.8, 2, 58.88);
			addNote(58.95, 2, 59.55);
			addNote(59.55, 0, 60);
			addNote(60, 1, 60.9);
			addNote(60.9, 1, 61.2);
		};
    };
}