require("love.data")
require("love.audio")
require("love.sound")
_Class = require("src.lib.hump.class")
Class = require("src.utils.class")
ClassUtils = require("src.utils.classutils")
MathUtils = require("src.utils.mathutils")

local mic_inputs = love.audio.getRecordingDevices()
local mic_id = ...
local mic_values = {}
local us = 0
local us_old = -1
local in_channel = love.thread.getChannel("mic_record_in")
local out_channel = love.thread.getChannel("mic_record_out")

if not mic_inputs[mic_id] then return end
mic_inputs[mic_id]:start(600, 8000, 8)
while true do
    local message = in_channel:pop()
    if message == "stop" then
		if mic_inputs[mic_id] then
			mic_inputs[mic_id]:stop()
		end
		break
	end
	
    if mic_inputs[mic_id]:getSampleCount() >= 600 then
        local mic_data = mic_inputs[mic_id]:getData()

		if mic_data then
			for i = 1, 600 do
				mic_values[i] = mic_data:getSample(i)*32768
			end

			mic_inputs[mic_id]:start(600, 8000, 8)
			mic_data:release()
		end
	end

	for i = 1, 600 do
		local alpha = 0.003
		us = mic_values[i] or 0
		us = math.abs(us)
		if us_old == -1 then
			us_old = us
		end
		us = (alpha * us) + ((1 - alpha) * us_old)
		us_old = us
	end
	out_channel:push(us)
end