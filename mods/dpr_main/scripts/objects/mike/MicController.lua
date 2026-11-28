local MicController, super = Class(Object)

function MicController:init()
    super.init(self, 0, 0)
    
    self:setParallax(0, 0)
    
    self.mic_inputs = love.audio.getRecordingDevices()
    self.mic_names = {}
    
    for i = 1, #self.mic_inputs do
        local mic_name = self.mic_inputs[i]:getName() or "Microphone "..tostring(i)
        if mic_name and StringUtils.split(mic_name, "(", true)[2] then
            mic_name = StringUtils.split(mic_name, "(", true)[2]
            mic_name = StringUtils.sub(mic_name, 1, utf8.len(mic_name)-1)
        end
        self.mic_names[i] = mic_name
    end

    self.mic_record_in_channel = love.thread.getChannel("mic_record_in")
    self.mic_record_out_channel = love.thread.getChannel("mic_record_out")
    self.mic_record_in_channel:clear()
    self.mic_record_out_channel:clear()
	
    self.mic_thread = love.thread.newThread(Mod.info.path .. "/src/miccontroller/micrecordthread.lua")
	self.restart_mic_thread = false
    self.mic_sensitivity = 0.5
    self.mic_volume = 0
    self.mic_volume_real = 0
    self.invert_mic = false
    
    self.mic_id = -1
    self.font = Assets.getFont("main")
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
		self:stopRecordMic()
        self.cleaning_up = true
        if self.mic_inputs then
            for _, inputs in ipairs(self.mic_inputs) do
                inputs:release()
            end
        end
		if self.mic_thread then
			self.mic_thread:release()
		end
        collectgarbage()
    end
end

function MicController:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)
    if not self.cleaning_up then
		self:stopRecordMic()
        self.cleaning_up = true
        if self.mic_inputs then
            for _, inputs in ipairs(self.mic_inputs) do
                inputs:release()
            end
        end
		if self.mic_thread then
			self.mic_thread:release()
		end
        collectgarbage()
    end
end

function MicController:update()
    super.update(self)

    if self.cleaning_up then
        return
    end

    if not Game:getFlag("micActive", false) then
        return
    end

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

    else
		if self.mic_thread:isRunning() then
			while self.mic_record_out_channel:getCount() > 0 do
				self.mic_volume = MathUtils.clamp(self.mic_record_out_channel:pop() * math.max(0.01, self.mic_sensitivity) * 0.05, 0, 100)
			end
		else
            local thread_error = self.mic_thread:getError()
            if thread_error then
				error("Mic recorder thread failed:\n" .. thread_error) 
			elseif self.restart_mic_thread then
				self.mic_thread:start(self.mic_id)
				self.restart_mic_thread = false
			end
		end
	end
    self.mic_volume_real = self.mic_volume_real + ((self.mic_volume - self.mic_volume_real) * (0.25 ^ DTMULT))
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
            if mic_name and StringUtils.split(mic_name, "(", true)[2] then
                mic_name = StringUtils.split(mic_name, "(", true)[2]
                mic_name = StringUtils.sub(mic_name, 1, utf8.len(mic_name)-1)
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

    if Game:getFlag("micActive", false) and self.mic_inputs and self.mic_inputs[self.mic_id] then
		if self.mic_thread:isRunning() then
			self:stopRecordMic()
			self.restart_mic_thread = true
		else
			self.mic_thread:start(self.mic_id)
		end
    else
        self:stopRecordMic()
    end
end

function MicController:stopRecordMic()
    if self.cleaning_up then
        return
    end

	if self.mic_thread:isRunning() then
		self.mic_record_in_channel:push("stop")
	end
	self.restart_mic_thread = false
end

function MicController:draw()
    super.draw(self)
    
    if self.cleaning_up then
        return
    end

    if DEBUG_RENDER and (self.mic_thread:isRunning() or self.right_click_mic ~= 0) then
        love.graphics.setLineWidth(4)

        love.graphics.setColor(ColorUtils.mergeColor(COLORS.aqua, COLORS.black, 0.5))
        love.graphics.line(20, 20, 20+(200*0.1), 20)

        love.graphics.setColor(ColorUtils.mergeColor(COLORS.lime, COLORS.black, 0.5))
        love.graphics.line(20+(200*0.1), 20, 20+(200*0.6), 20)

        love.graphics.setColor(ColorUtils.mergeColor(COLORS.yellow, COLORS.black, 0.5))
        love.graphics.line(20+(200*0.6), 20, 20+(200*0.9), 20)

        love.graphics.setColor(ColorUtils.mergeColor(COLORS.red, COLORS.black, 0.5))
        love.graphics.line(20+(200*0.9), 20, 20+200, 20)

        love.graphics.setColor(COLORS.aqua)

        if self.mic_volume > 10 then
            love.graphics.setColor(COLORS.lime)
        end

        if self.mic_volume > 60 then
            love.graphics.setColor(COLORS.yellow)
        end

        if self.mic_volume > 90 then
            love.graphics.setColor(COLORS.red)
        end

        love.graphics.line(20, 20, 20+self.mic_volume*2, 20)
        love.graphics.setColor(1,1,1,1)
    end
end

return MicController