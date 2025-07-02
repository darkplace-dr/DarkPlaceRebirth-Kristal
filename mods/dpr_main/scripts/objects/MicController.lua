local MicController, super = Class(Object)

function MicController:init()
    super.init(self, 0, 0)
	
	self:setParallax(0, 0)
	
	self.mic_inputs = love.audio.getRecordingDevices()
	self.mic_names = {}
	for i = 1, #self.mic_inputs do
		local mic_name = self.mic_inputs[i]:getName() or "Microphone "..tostring(i)
		if mic_name and Utils.split(mic_name, "(", true)[2] then
			mic_name = Utils.split(mic_name, "(", true)[2]
			mic_name = Utils.sub(mic_name, 1, utf8.len(mic_name)-1)
		end
		self.mic_names[i] = mic_name
	end
	self.mic_recording = false

	self.mic_data = nil
	self.mic_sensitivity = 0.5
	self.mic_values = {}
	self.lerp_mic_volume = 0
	self.mic_volume = 0
	self.mic_volume_real = 0
	self.invert_mic = false
	
	self.us_old = -1
	
	self.mic_collect_timer = 0
	self.mic_timer = 0
	self.mic_id = -1
	self.font = Assets.getFont("main")
	self.mic_sample = 0
	self.cleaning_up = false
	
	self.right_click_mic = 0
	if #self.mic_inputs <= 0 then
		self.right_click_mic = 1
	end
	self.right_shoulder = false
	self.left_shoulder = false
	if Kristal.isConsole() then
		self.right_shoulder = true
		self.left_shoulder = true
		for aliasname, lalias in pairs(Input.gamepad_bindings) do
			for keyindex, lkey in ipairs(lalias) do
				if Utils.equal(lkey, "gamepad:rightshoulder") then
					self.right_shoulder = false
				end
				if Utils.equal(lkey, "gamepad:leftshoulder") then
					self.left_shoulder = false
				end
			end
		end
	end
end

function MicController:onRemove(parent)
	super.onRemove(self, parent)
	if not self.cleaning_up then
		self.cleaning_up = true
		self:stopRecordMic()
		if self.mic_inputs then
			for _, inputs in ipairs(self.mic_inputs) do
				inputs:release()
			end
		end
		collectgarbage()
	end
end

function MicController:onRemoveFromStage(stage)
	super.onRemoveFromStage(self, stage)
	if not self.cleaning_up then
		self.cleaning_up = true
		self:stopRecordMic()
		if self.mic_inputs then
			for _, inputs in ipairs(self.mic_inputs) do
				inputs:release()
			end
		end
		collectgarbage()
	end
end

function MicController:update()
	super.update(self)
	if self.cleaning_up then
		return
	end
	if not Game:getFlag("mic_active", false) then
		return
	end
	self.mic_timer = self.mic_timer + DTMULT
	self.mic_collect_timer = self.mic_collect_timer + DTMULT
	if Kristal.isConsole() then
		if Input.keyDown("gamepad:rightshoulder") and self.right_shoulder then
			self.mic_volume = 100
		elseif Input.keyDown("gamepad:leftshoulder") and self.left_shoulder then
			self.mic_volume = 100
		else
			self.mic_volume = 0
		end
	elseif self.right_click_mic == 1 then
		if Input.mouseDown(2) then
			self.mic_volume = 100
		else
			self.mic_volume = 0
		end
	elseif self.right_click_mic == 2 then
		if Input.down("cancel") then
			self.mic_volume = 100
		else
			self.mic_volume = 0
		end
	elseif self.mic_recording then
		if self.mic_collect_timer >= 4 then
			self:collectMicValues()
			self.mic_sample = self.mic_sample + 1
			if self.mic_sample >= 5 then
				self.mic_sample = 0
			end
			self.mic_collect_timer = 0
		end
		if self.mic_timer >= 1 then
			for i = 0, #self.mic_values do
				local alpha = 0.036*2
				local us = self.mic_values[i] or 0
				us = math.abs(us)
				if self.us_old == -1 then
					self.us_old = us
				end
				us = (alpha * us) + ((1 - alpha) * self.us_old)
				self.us_old = us
				self.lerp_mic_volume = Utils.clamp(us * math.max(0.01, self.mic_sensitivity) * 0.05, 0, 100)
			end
			self.mic_timer = 0
		end
		self.mic_volume = Utils.lerp(self.mic_volume, self.lerp_mic_volume, DTMULT)
	end
	self.mic_volume_real = self.mic_volume_real + ((self.mic_volume - self.mic_volume_real) * 0.25*DTMULT)
end

function MicController:initMics()
	if self.cleaning_up then
		return
	end
	self:stopRecordMic()
	if self.mic_inputs then
		for _, inputs in ipairs(self.mic_inputs) do
			inputs:release()
		end
	end
	self.mic_inputs = love.audio.getRecordingDevices()
	self.mic_names = {}
	if #self.mic_inputs <= 0 then
		self.mic_id = -1
		if self.right_click_mic == 0 then
			self.right_click_mic = 1
		end
	else
		if self.mic_id > #self.mic_inputs then
			self.mic_id = #self.mic_inputs
		end
		for i = 1, #self.mic_inputs do
			local mic_name = self.mic_inputs[i]:getName() or "Microphone"..tostring(i)
			if mic_name and Utils.split(mic_name, "(", true)[2] then
				mic_name = Utils.split(mic_name, "(", true)[2]
				mic_name = Utils.sub(mic_name, 1, utf8.len(mic_name)-1)
			end
			self.mic_names[i] = mic_name
		end
		self:startRecordMic()
	end
	if self.mic_id > #self.mic_inputs then
		self.mic_id = #self.mic_inputs
	end
end

function MicController:startRecordMic(id)
	if self.cleaning_up then
		return
	end
	if id then
		self.mic_id = id
	end
	if Game:getFlag("mic_active", false) and self.mic_inputs and self.mic_inputs[self.mic_id] then
		if self.mic_data then
			self.mic_data:release()
			self.mic_data = nil
		end
		self.mic_recording = self.mic_inputs[self.mic_id]:start(1, 8000, 8)
	else
		self:stopRecordMic()
	end
end

function MicController:stopRecordMic()
	if not self.cleaning_up and self.mic_inputs[self.mic_id] then
		self.mic_inputs[self.mic_id]:stop()
	end
	self.mic_recording = false
	if self.mic_data then
		self.mic_data:release()
		self.mic_data = nil
	end
end

function MicController:collectMicValues()
	if self.cleaning_up then
		return
	end
	if self.mic_recording then
		self.mic_data = self.mic_inputs[self.mic_id]:getData()
		if self.mic_data then
			self.mic_values[self.mic_sample] = self.mic_data:getSample(0)*32768
			self.mic_data:release()
			self.mic_recording = self.mic_inputs[self.mic_id]:start(1, 8000, 8)
		end
	end
end

function MicController:draw()
	super.draw(self)
	if self.cleaning_up then
		return
	end
	if DEBUG_RENDER and (self.mic_recording or self.right_click_mic ~= 0) then
		love.graphics.setLineWidth(4)
		love.graphics.setColor(Utils.mergeColor(COLORS["aqua"], COLORS["black"], 0.5))
		love.graphics.line(20, 20, 20+(200*0.1), 20)
		love.graphics.setColor(Utils.mergeColor(COLORS["lime"], COLORS["black"], 0.5))
		love.graphics.line(20+(200*0.1), 20, 20+(200*0.6), 20)
		love.graphics.setColor(Utils.mergeColor(COLORS["yellow"], COLORS["black"], 0.5))
		love.graphics.line(20+(200*0.6), 20, 20+(200*0.9), 20)
		love.graphics.setColor(Utils.mergeColor(COLORS["red"], COLORS["black"], 0.5))
		love.graphics.line(20+(200*0.9), 20, 20+200, 20)
		love.graphics.setColor(COLORS["aqua"])
		if self.mic_volume > 10 then
			love.graphics.setColor(COLORS["lime"])
		end
		if self.mic_volume > 60 then
			love.graphics.setColor(COLORS["yellow"])
		end
		if self.mic_volume > 90 then
			love.graphics.setColor(COLORS["red"])
		end
		love.graphics.line(20, 20, 20+self.mic_volume*2, 20)
		love.graphics.setColor(1,1,1,1)
	end
end

return MicController