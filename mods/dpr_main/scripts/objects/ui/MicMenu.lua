local MicMenu, super = Class(Object)

function MicMenu:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self.parallax_x = 0
    self.parallax_y = 0

    self.draw_children_below = 0

    self.font = Assets.getFont("main")
    self.ja_font = Assets.getFont("ja_main")

    self.heart_sprite = Assets.getTexture("player/heart_centered")
    self.star_sprite = Assets.getTexture("ui/battle/sparestar")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")
	
	Mod.mic_controller:initMics()
	
	local yoff = 60
	if #Mod.mic_controller.mic_inputs + 3 > 11 then
		yoff = 30
	end

	self.menu_max = #Mod.mic_controller.mic_inputs + 3

    self.box = UIBox(30+32, 12+yoff+32, 580-64, 344-64)
    self.box.layer = -1
    self:addChild(self.box)

    -- MAIN, MIC_SELECT, SENSITIVITY
    self.state = "MAIN"

    self.selected_y = 1
    self.chosen_y = Mod.mic_controller.mic_id or 1
	if Mod.mic_controller.right_click_mic == 1 then
		self.chosen_y = self.menu_max - 2
	end
	if Mod.mic_controller.right_click_mic == 2 then
		self.chosen_y = self.menu_max - 1
	end
	
	self.mic_volume = 0
	self.mic_id = 1
	self.mic_wait = 0
	self.reload = 0
	
	self.buffer = 3
end

function MicMenu:update()
	local mic = Mod.mic_controller
	
	self.mic_wait = self.mic_wait - DTMULT
	self.buffer = self.buffer - DTMULT
	if self.mic_wait <= 0 then
		self.mic_volume = self.mic_volume + ((mic.mic_volume - self.mic_volume) * 0.25*DTMULT)
		self.mic_wait = 0
	end
	if self.buffer <= 0 then
		self.buffer = 0
	end
	
    if self.state == "MAIN" then
        if Input.pressed("cancel") and self.buffer <= 0 then
			Game:setFlag("microphone_id", mic.mic_id)
			Game:setFlag("microphone_right_click", mic.right_click_mic)
			Game:setFlag("microphone_sensitivity", mic.mic_sensitivity)
            self:remove()
            Game.world:closeMenu()
        end
		if Input.pressed("up", true) then
			self.selected_y = self.selected_y - 1
			if self.selected_y < 1 then
				self.selected_y = 3
			end
			Assets.playSound("ui_move")
		end
		if Input.pressed("down", true) then
			self.selected_y = self.selected_y + 1
			if self.selected_y > 3 then
				self.selected_y = 1
			end
			Assets.playSound("ui_move")
		end
        if Input.pressed("confirm") and self.buffer <= 0 then
            if self.selected_y == 1 then
				self.state = "MIC_SELECT"
            elseif self.selected_y == 2 then
                self.state = "SENSITIVITY"
            elseif self.selected_y == 3 then
				Game:setFlag("microphone_id", mic.mic_id)
				Game:setFlag("microphone_right_click", mic.right_click_mic)
				Game:setFlag("microphone_sensitivity", mic.mic_sensitivity)
                self:remove()
                Game.world:closeMenu()
            end
			self.selected_y = 1
			Assets.playSound("ui_select")
        end
    elseif self.state == "MIC_SELECT" then
        if Input.pressed("cancel") then
			mic.mic_id = self.mic_id
			if not mic.mic_recording then
				mic:startRecordMic()
			end
			self.selected_y = 1
            self.state = "MAIN"
        end
		if Input.pressed("up", true) then
			self.selected_y = self.selected_y - 1
			if self.selected_y < 1 then
				self.selected_y = self.menu_max
			end
			if Kristal.isConsole() or self.selected_y ~= self.menu_max - 1 then
				mic:startRecordMic(self.selected_y)
				if mic.mic_recording then
					self.mic_wait = 21
				end
			end
			Assets.playSound("ui_move")
		end
		if Input.pressed("down", true) then
			self.selected_y = self.selected_y + 1
			if self.selected_y > self.menu_max then
				self.selected_y = 1
			end
			if Kristal.isConsole() or self.selected_y ~= self.menu_max - 1 then
				mic:startRecordMic(self.selected_y)
				if mic.mic_recording then
					self.mic_wait = 21
				end
			end
			Assets.playSound("ui_move")
		end
        if Input.pressed("confirm") then
			if self.selected_y == self.menu_max then
				mic.mic_id = self.mic_id
				if not mic.mic_recording then
					mic:startRecordMic()
				end
				self.state = "MAIN"
				self.selected_y = 1
			elseif self.selected_y == self.menu_max - 2 and not Kristal.isConsole() then
				if mic.right_click_mic ~= 1 then
					mic.right_click_mic = 1
				else
					mic.right_click_mic = 0
				end
				if #mic.mic_inputs <= 0 and mic.right_click_mic == 0 then
					mic.right_click_mic = 2
				end
			elseif self.selected_y == self.menu_max - 1 and not Kristal.isConsole() then
				if mic.right_click_mic ~= 2 then
					mic.right_click_mic = 2
				else
					mic.right_click_mic = 0
				end
				if #mic.mic_inputs <= 0 and mic.right_click_mic == 0 then
					mic.right_click_mic = 1
				end
			else
				self.chosen_y = self.selected_y
				self.mic_id = self.chosen_y
				mic.right_click_mic = 0
			end
			Assets.playSound("ui_select")
        end
	elseif self.state == "SENSITIVITY" then
        if Input.pressed("confirm") then
			self.selected_y = 1
            self.state = "MAIN"
			Assets.playSound("ui_select")
        end 
		if Input.pressed("cancel") then
			self.selected_y = 1
            self.state = "MAIN"
        end
		self.reload = self.reload - DTMULT
		
		if self.reload < 0 then
			self.reload = -1
			if Input.down("left") then
				self.reload = 2
				mic.mic_sensitivity = Utils.approach(mic.mic_sensitivity, 0.035, 0.1)
			end
			if Input.down("right") then
				self.reload = 2
				mic.mic_sensitivity = Utils.approach(mic.mic_sensitivity, 4, 0.1)
			end
		end
    end

    super.update(self)
end

function MicMenu:draw()
    love.graphics.setFont(self.font)
	
	local mic = Mod.mic_controller
	
	Draw.setColor(1, 1, 1)
    if self.state == "MAIN" then
        love.graphics.print("Select Microphone", self.box.x - 32 + 48, self.box.y - 32 + 40  + 24)
        love.graphics.print("Adjust Sensitivity", self.box.x - 32 + 48, self.box.y - 32 + 40 + 24 + 30)
        love.graphics.print("Done", self.box.x - 32 + 48, self.box.y - 32 + 40  + 24 + 60)
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, self.box.x - 32 + 32, self.box.y - 32 + 40 + 40 + (self.selected_y - 1) * 30, 0, 1, 1, 7, 7)
	end 
	if self.state == "MIC_SELECT" then
		Draw.setColor(0.5, 0.5, 0.5)
        love.graphics.print("Volume", self.box.x - 32 + 580 - 140 + 80 - self.font:getWidth("Volume"), self.box.y - 32 + 20)
        love.graphics.print("Microphone", self.box.x - 32 + 48, self.box.y - 32 + 20)
		Draw.setColor(1, 1, 1)
		local menu_y = math.max(math.min(self.selected_y - 4, self.menu_max - 7), 1)
		for i = 1, self.menu_max do
			local str = ""
			if i >= menu_y and i < menu_y + 8 then
				if mic.right_click_mic == 0 then
					if self.chosen_y == i and #Mod.mic_controller.mic_inputs > 0 then
						str = " "
						Draw.setColor(1, 1, 1)
						Draw.draw(self.star_sprite, self.box.x - 32 + 46, self.box.y - 32 + 40 + 32 + (i-1)*30 + (menu_y-1)*30)
						Draw.setColor(Utils.hexToRgb("#FFFF40"))
					else
						Draw.setColor(1, 1, 1)
					end
				elseif i == self.menu_max - 2 and mic.right_click_mic == 1 then
					str = " "
					Draw.setColor(1, 1, 1)
					Draw.draw(self.star_sprite, self.box.x - 32 + 46, self.box.y - 32 + 40 + 32 + (i-1)*30 + (menu_y-1)*30)
					Draw.setColor(Utils.hexToRgb("#FFFF40"))
				elseif i == self.menu_max - 1 and mic.right_click_mic == 2 then
					str = " "
					Draw.setColor(1, 1, 1)
					Draw.draw(self.star_sprite, self.box.x - 32 + 46, self.box.y - 32 + 40 + 32 + (i-1)*30 + (menu_y-1)*30)
					Draw.setColor(Utils.hexToRgb("#FFFF40"))
				else
					Draw.setColor(1, 1, 1)
				end
				
				if i ~= self.menu_max then
					love.graphics.setFont(self.ja_font)
				else
					love.graphics.setFont(self.font)
				end
				
				if i == self.menu_max then
					love.graphics.print(str.."Done", self.box.x - 32 + 48, self.box.y - 32 + 40 + 40 + (i-1)*30 - (menu_y-1)*30)
				elseif i == self.menu_max - 2 and not Kristal.isConsole() then
					love.graphics.print(str.."Mouse Right-Click [Not Recommended]", self.box.x - 32 + 48, self.box.y - 32 + 40 + 24 + (i-1)*30 - (menu_y-1)*30)
				elseif i == self.menu_max - 1 and not Kristal.isConsole() then
					local input_str = Input.getText("cancel")
					if Input.usingGamepad() then
						input_str = " "
						local x_off = 0
						if mic.right_click_mic == 2 then
							x_off = 18
						end
						local r, g, b, a = love.graphics.getColor()
						Draw.setColor(1, 1, 1)
						Draw.draw(Input.getTexture("cancel"), self.box.x - 32 + 46 + x_off, self.box.y - 32 + 40 + 27 + (i-1)*30 - (menu_y-1)*30, 0, 2, 2)
						Draw.setColor(r,g,b,a)
					end
					love.graphics.print(str..input_str.." [Also Not Recommended]", self.box.x - 32 + 48, self.box.y - 32 + 40 + 24 + (i-1)*30 - (menu_y-1)*30)
				else
					local mic_name = "Test "..tostring(i-1)
					if mic.mic_names[i] then
						mic_name = mic.mic_names[i]
						local shortened = false
						while self.ja_font:getWidth(mic_name) > 300 do
							mic_name = Utils.sub(mic_name, 1, utf8.len(mic_name) - 1)
							shortened = true
						end
						if shortened then
							mic_name = mic_name.."..."
						end
					end
					love.graphics.print(str..mic_name, self.box.x - 32 + 48, self.box.y - 32 + 40 + 24 + (i-1)*30 - (menu_y-1)*30)
				end
				
				local volx = self.box.x - 32 + 580 - 140 + 1
				local voly = self.box.y - 32 + 40 + 40 + (i-1)*30 - (menu_y-1)*30 + 1
				local volw = 80
				if (Kristal.isConsole() and i < self.menu_max) or (not Kristal.isConsole() and i < self.menu_max - 2) then
					love.graphics.setLineWidth(4)
					if i == self.selected_y then
						if self.mic_wait <= 0 then
							love.graphics.setColor(Utils.mergeColor(COLORS["aqua"], COLORS["black"], 0.5))
							love.graphics.line(volx, voly, volx+(volw*0.1), voly)
							love.graphics.setColor(Utils.mergeColor(COLORS["lime"], COLORS["black"], 0.5))
							love.graphics.line(volx+(volw*0.1), voly, volx+(volw*0.6), voly)
							love.graphics.setColor(Utils.mergeColor(COLORS["yellow"], COLORS["black"], 0.5))
							love.graphics.line(volx+(volw*0.6), voly, volx+(volw*0.9), voly)
							love.graphics.setColor(Utils.mergeColor(COLORS["red"], COLORS["black"], 0.5))
							love.graphics.line(volx+(volw*0.9), voly, volx+volw, voly)
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
							love.graphics.line(volx, voly, volx+(self.mic_volume/100)*volw, voly)
							love.graphics.setColor(1,1,1,1)
						else
							love.graphics.setColor(1,1,1,1)
							love.graphics.setFont(self.font)
							love.graphics.print("Loading...", volx + 40 - self.font:getWidth("Loading...")/4, self.box.y - 32 + 40 + 32 + (i-1)*30 - (menu_y-1)*30, 0, 0.5, 0.5)
						end
					else
						love.graphics.setColor(COLORS["dkgray"])
						love.graphics.line(volx, voly, volx+volw, voly)
						love.graphics.setColor(1,1,1,1)
					end
				end
				
				Draw.setColor(Game:getSoulColor())
				if i == self.menu_max and i == self.selected_y then
					Draw.draw(self.heart_sprite, self.box.x - 32 + 32, self.box.y - 32 + 40 + 56 + (i-1)*30 - (menu_y-1)*30, 0, 1, 1, 7, 7)
				elseif i == self.menu_max - 2 and not Kristal.isConsole() and i == self.selected_y then
					Draw.draw(self.heart_sprite, self.box.x - 32 + 32, self.box.y - 32 + 40 + 40 + (i-1)*30 - (menu_y-1)*30, 0, 1, 1, 7, 7)
				elseif i == self.menu_max - 1 and not Kristal.isConsole() and i == self.selected_y then
					Draw.draw(self.heart_sprite, self.box.x - 32 + 32, self.box.y - 32 + 40 + 40 + (i-1)*30 - (menu_y-1)*30, 0, 1, 1, 7, 7)
				elseif i == self.selected_y then
					Draw.draw(self.heart_sprite, self.box.x - 32 + 32, self.box.y - 32 + 40 + 40 + (i-1)*30 - (menu_y-1)*30, 0, 1, 1, 7, 7)
				end
			end
		end
		
		love.graphics.setFont(self.font)
		if self.menu_max > 7 then
			love.graphics.setColor(COLORS["dkgray"])
			love.graphics.rectangle("fill", self.box.x - 32 + 580 - 29, self.box.y - 32 + 70, 5, 222)
			local nn = self.menu_max - 7
			local pagey = ((menu_y-1) / nn) * 222
			local pageh = 222 / math.max(1, self.menu_max - 7)
			love.graphics.setColor(1,1,1)
			love.graphics.rectangle("fill", self.box.x - 32 + 580 - 29, self.box.y - 32 + 70 + pagey, 5, pageh)
            local sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
            if menu_y-1 > 1 then
                Draw.draw(self.arrow_sprite, self.box.x - 32 + 580 - 33, self.box.y - 32 + 64 - sine_off, 0, 1, -1)
            end
            if menu_y-1 < self.menu_max - 8 then
                Draw.draw(self.arrow_sprite, self.box.x - 32 + 580 - 33, self.box.y - 32 + 298 + sine_off)
            end
		end
	end	
	if self.state == "SENSITIVITY" then
		Draw.setColor(1, 1, 1)
        love.graphics.print("Adjust Sensitivity", self.box.x - 32 + 580/2 - self.font:getWidth("Adjust Sensitivity")/2, self.box.y - 32 + 30)
		love.graphics.setColor(COLORS["dkgray"])
		local tri_points = {self.box.x - 32 + 86, self.box.y - 32 + 344/2 + 32, self.box.x - 32 + 580 - 96}
		love.graphics.polygon("fill", tri_points[1], tri_points[2], tri_points[3], tri_points[2], tri_points[3], tri_points[2] - 16)
		Draw.setColor(1, 1, 1)
		local ly = self.box.y - 32 + 344/2 + 32
		local lw = Utils.dist(self.box.x - 32 + 96, 0, self.box.x - 32 + 580 - 96, 0) 
		local lx = self.box.x - 32 + 96 + lw * (mic.mic_sensitivity/4)
		love.graphics.rectangle("fill", lx - 2, ly - 24, 5, 33)
	end
    if self.state ~= "MIC_SELECT" then
		if mic.mic_names[mic.mic_id] then
			local mic_name = mic.mic_names[mic.mic_id]
			local shortened = false
			while self.ja_font:getWidth(mic_name) > 600 do
				mic_name = Utils.sub(mic_name, 1, utf8.len(mic_name) - 1)
				shortened = true
			end
			if shortened then
				mic_name = mic_name.."..."
			end
			if mic.right_click_mic == 1 then
				mic_name = "Mouse Right-Click"
			elseif mic.right_click_mic == 2 then
				mic_name = Input.getText("cancel")
				if Input.usingGamepad() then
					mic_name = " "
					local r, g, b, a = love.graphics.getColor()
					Draw.setColor(0.5, 0.5, 0.5)
					Draw.draw(Input.getTexture("cancel"), self.box.x - 32 + 190, self.box.y - 32 + 344 - 46, 0, 1, 1)
					Draw.setColor(r,g,b,a)
				end
			end
			Draw.setColor(0.5, 0.5, 0.5)
			love.graphics.print("* Current Microphone:  ", self.box.x - 32 + 48, self.box.y - 32 + 344 - 48, 0, 0.5, 0.5)
			love.graphics.setFont(self.ja_font)	
			love.graphics.print(mic_name, self.box.x - 32 + 48 + self.font:getWidth("* Current Microphone:  ")/2, self.box.y - 32 + 344 - 48, 0, 0.5, 0.5)
			love.graphics.setFont(self.font)
		end
		love.graphics.setLineWidth(4)
		love.graphics.setColor(Utils.mergeColor(COLORS["aqua"], COLORS["black"], 0.5))
		love.graphics.line(self.box.x-32+80, self.box.y-32+280, self.box.x-32+80+(419*0.1), self.box.y-32+280)
		love.graphics.setColor(Utils.mergeColor(COLORS["lime"], COLORS["black"], 0.5))
		love.graphics.line(self.box.x-32+80+(419*0.1), self.box.y-32+280, self.box.x-32+80+(419*0.6), self.box.y-32+280)
		love.graphics.setColor(Utils.mergeColor(COLORS["yellow"], COLORS["black"], 0.5))
		love.graphics.line(self.box.x-32+80+(419*0.6), self.box.y-32+280, self.box.x-32+80+(419*0.9), self.box.y-32+280)
		love.graphics.setColor(Utils.mergeColor(COLORS["red"], COLORS["black"], 0.5))
		love.graphics.line(self.box.x-32+80+(419*0.9), self.box.y-32+280, self.box.x-32+80+419, self.box.y-32+280)
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
		love.graphics.line(self.box.x-32+80, self.box.y-32+280, self.box.x-32+80+(self.mic_volume/100)*419, self.box.y-32+280)
	end	
    Draw.setColor(1, 1, 1)

    super.draw(self)
end
return MicMenu