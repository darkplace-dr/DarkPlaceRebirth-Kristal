--99, 126, 135

local WeatherHandler, super = Class(Object)

function WeatherHandler:init(typer, sfx, child, intensity, overlay)
    super.init(self)
    self.parallax_x, self.parallax_y = 0, 0
    self.type = typer
    self:setLayer(WORLD_LAYERS["below_ui"])

    self.raintimer = -1
    self.raintimerthres = 0
    self.rainnumber = ""
    self.raintimerreset = true

    self.snowtimer = 0
    self.snowtimerthres = 0
    self.snownumber = ""
    self.snowtimerreset = true
    self.snowcount = 0

    self.thundertimer = 150
    self.thundertimerreset = false

    self.windtimer = 120
    self.windtimerreset = true

    self.dusttimer = 0
    self.dusttimerthres = 0
    self.dustnumber = ""
    self.dusttimerreset = true

	self.weathertimer = 0
	self.wrap_up = false
	self.rainsplash = false
	self.genspeed = 2
	self.gen = 0
	self.dropwait = 30
	self.droptimer = 0
	self.dropcount = 0
	self.max_particles = 120

    self.sfx = sfx

    self.addto = child or Game.stage:getWeatherParent()
    --if type(self.type) == "table" then self.both = true end
    self.weathersounds = Music()
    self.weathersounds_indoor = Music()
    if self.type == "rain" or self.type == "rain_prewarmed" or self.type == "thunder" then
		if self.sfx then
			self.weathersounds:play("raining", 0, 1)
			self.weathersounds_indoor:play("raining_in_church2", 0, 1)
		end
	end
    
    self.intensity = intensity or 1

    self.pause = false

    self.haveoverlay = overlay
    self:postInit()
	
	self.prewarm = true
	self.cam_x = 0
	self.cam_y = 0
	self.inside = false
	self.faded_in = false
	self.stop_gen = false
end

function WeatherHandler:postInit()
	if self.haveoverlay and not self.skip then
		self:addOverlay()
	end
	if self.prewarm or self.type == "rain_prewarmed" then
		self.prewarm = true
		self.weathertimer = 120
		self.rainsplash = true
		if self.sfx and not self.skip then
			self.weathersounds:setVolume(0.5)
		end
		if self.type == "rain_prewarmed" then
			self.type = "rain"
		end
	end
end

function WeatherHandler:update()
    super.update(self)
    --[[if #Game.stage.overlay > 0 then for i, o in ipairs(Game.stage.overlay) do
        print(o.type, (o.handler.addto == Game.world and "World" or "Battle"))
    end end]]
	if self.wrap_up then
		self.weathertimer = self.weathertimer - DTMULT
		if self.weathertimer < 0 then
			for i, o in ipairs(Game.stage.overlay) do
				if o.type == self.type then
					o:remove()
				end
            end
			self:remove()
		end
		if self.weathertimer < 100 then
			self.stop_gen = true
		end
	else
		self.weathertimer = self.weathertimer + DTMULT
		if self.weathertimer >= 120 then
			self.weathertimer = 120
		end
		if self.weathertimer >= 10 and not self.faded_in then
			self.weathersounds:fade(0.5, 110/30)
			self.faded_in = true
		end
	end
    if not self.pause and not self.stop_gen then
        if self.type == "rain" or self.type == "rain_prewarmed" or self.type == "thunder" or self.type == "cd" then
			if self.weathertimer < 120 and not self.wrap_up then
				self.gen = math.floor(Utils.lerp(self.genspeed - 20, self.genspeed, self.weathertimer/120))
			else
				self.gen = self.genspeed
			end
			if self.weathertimer >= 100 then
				self.rainsplash = true
			end
			if self.weathertimer < 120 then
				self.droptimer = self.droptimer + 1
				if self.droptimer >= self.dropwait then
					self.droptimer = 0
					self.dropwait = math.max(self.dropwait * 0.75, 2)
				end
			end
			self.dropcount = #Game.stage:getObjects(RainPiece)
			if self.raintimer >= 0 and self.dropcount < self.max_particles then

				if not self.prewarm then
					local ydiff = math.abs(self.cam_y - Game.world.camera.y)
					if self.dropcount < self.genspeed * 25 then
						self.gen = self.gen + ydiff
					elseif self.dropcount > self.genspeed * 30 then
						self.gen = self.gen - ydiff
					end
				end

                local amount = math.max(self.gen, 1)
                if self.type == "thunder" then amount = amount + 1 end

				if self.prewarm then
					amount = amount * 25
				end

                local speedmult = self.intensity
                if self.type == "thunder" then speedmult = speedmult + 1 end

                for i = 1, amount do
                    self.raintimer = self.gen
                    local number = "rain_"..tostring(love.math.random(1, 10))
                    if self.type == "cd" then number = Utils.pick({"cat", "dog"}) end
					local x, y
					if self.prewarm then
						x = love.math.random(0,720) - 64
						y = love.math.random(-SCREEN_HEIGHT*1.5-76, -76+556)
					else
						local side_random = love.math.random(0,720) - 64
						local foff = math.random(0,10 * (speedmult*20))
						x = side_random + (foff * (speedmult*10))
						y = -(foff * (speedmult*20))
					end
					local worldx, worldy = self:getRelativePos(x, y, self.addto)
					local rain = RainPiece(number, worldx, worldy, (speedmult * 2) * 10, self)

                    self.addto:addChild(rain)
                end
				self.dropcount = self.dropcount + amount
				
				self.prewarm = false
				
				self.timer = self.gen
            end
            self.raintimer = self.raintimer + 1 * DTMULT
            --print(self.raintimer, self.raintimerthres)
        end

        if self.type == "snow" then
            if self.snowtimerreset then
                self.snowtimerreset = false
                self.snowtimerthres = math.random(5, 10)
                self.snowcount = Utils.clamp(math.random(Utils.round(2 * self.intensity), Utils.round(4 * self.intensity)), 2, 20)

            elseif self.snowtimer >= self.snowtimerthres then

                self.snowtimer = 0
                self.snowtimerreset = true

                for i = self.snowcount, 1, -1 do
                    local number = Utils.pick({"a", "b", "c", "d", "e"})
                    local speed = Utils.clamp(Utils.random(Utils.round(3 * self.intensity), Utils.round(6 * self.intensity)), 3, 14)
                    local rotspeed = Utils.random(0.5, 6)
                    local sinerspeed = Utils.random(0.6, 4)
                    local lifespan = Utils.random(70, 120)
                    local x = math.random(SCREEN_WIDTH * - 0.25, SCREEN_WIDTH * 1.25)
                    local y = math.random(40, 60)
                    local worldx, worldy = self:getRelativePos(x, 0 - y, self.addto)
                    local snow = SnowPiece(number, worldx, worldy, speed, rotspeed, sinerspeed, lifespan, self)
                    self.addto:addChild(snow)
                end

            end
            self.snowtimer = self.snowtimer + 1 * DTMULT
            --print(self.raintimer, self.raintimerthres)
        end

        if self.type == "thunder" then
            if self.thundertimerreset == true then
                self.thundertimerreset = false
                if self.intensity == 1 then 
                    self.thundertimer = 30 * math.random(8, 11)
                else
                    self.thundertimer = 30 * math.random(8 - self.intensity, 11 - self.intensity)
                end
            end

            if self.thundertimer <= 0 then
                Game.stage.timer:script(function(wait)

                    local first = self.addto:addChild(ThunderFlash(self))
                    wait(0.4)
                    first:remove()

                    self.addto:addChild(ThunderFlash(self))
                    wait(0.5)
                    Assets.stopAndPlaySound("thunder", 0.5, 0.6)
                end)
                --self.addto:addChild(ThunderFlash())
                self.thundertimerreset = true
            end

            self.thundertimer = self.thundertimer - DTMULT
        end

        if self.type == "wind" then
            --print("its going to wind in".. self.windtimer)
            if self.windtimerreset == true then
                self.windtimerreset = false

                if self.intensity == 1 then 
                    self.windtimer = 30 * math.random(6, 14)
                else
                    self.windtimer = 30 * math.random(6 - self.intensity, 14 - self.intensity)
                end
            end

            if self.windtimer <= 0 then
                self.windtimerreset = true
                --print("WOO OHOOO WIND YESS!! IM SO HAPPY")
                local ammount = math.random(1, 7)
                for i = ammount, 1, -1 do
                    Assets.stopAndPlaySound("wind", 0.8, 1.2)
                    Game.stage.timer:script(function(wait)
                        wait(1.5)
                        local speed = Utils.random(15, 19)
                        local y = math.random(SCREEN_HEIGHT * - 0.5, SCREEN_HEIGHT * 0.25)
                        local x = math.random(40, 60) + (i * 120)
                        local worldx, worldy = self:getRelativePos(SCREEN_WIDTH + x, y, self.addto)
                        local leaf = LeafPiece(worldx, worldy, speed, self)
                        self.addto:addChild(leaf)

                    end)
                end
            end

            self.windtimer = self.windtimer - 1 * DTMULT
        end

        if self.type == "volcanic" then
            if self.dusttimerreset then
                self.dusttimerreset = false
                self.dusttimer = math.random(5, 6)
            elseif self.dusttimer <= 0 then

                self.dusttimerreset = true
                local ammount = math.random(3, 5)
                for i = ammount, 1, -1 do

                    local letter = Utils.pick({"a", "b", "c", "d", "e"})
                    local speed = Utils.random(15, 19)
                    local y = math.random(0, SCREEN_HEIGHT)
                    local x = math.random(40, 60) + (i * 120)
                    local worldx, worldy = self:getRelativePos(SCREEN_WIDTH + x, y, self.addto)
                    local dust = DustPiece(letter, worldx, worldy, speed, self)
                    self.addto:addChild(dust)

                end

            end
            self.dusttimer = self.dusttimer - 1 * DTMULT
            --print(self.raintimer, self.raintimerthres)
        end


    else
        if self.type == "thunder" then
            if self.thundertimerreset == true then
                self.thundertimerreset = false
                if self.intensity == 1 then 
                    self.thundertimer = 30 * math.random(8, 11)
                else
                    self.thundertimer = 30 * math.random(8 - self.intensity, 11 - self.intensity)
                end
            end

            if self.thundertimer <= 0 then
                Game.stage.timer:script(function(wait)

                    Assets.stopAndPlaySound("thunder", 0.2, 0.3)
                end)
                --self.addto:addChild(ThunderFlash())
                self.thundertimerreset = true
            end

            self.thundertimer = self.thundertimer - 1 * DTMULT
        end
    end

    if self.haveoverlay then
        local number = 0
        for i, overlay in ipairs(Game.stage.overlay) do
            if overlay[1] == self then number = 1 end
        end
        if number == 0 then self:addOverlay() end
    end
	
	self.cam_y = Game.world.camera.y
end 

function WeatherHandler:onRemove()
    self.weathersounds:stop()
    self.weathersounds = nil
    for i, child in ipairs(self.addto.children) do
        child:removeFX("wave_fx")
    end
end

function WeatherHandler:addOverlay()
    local overlay = self.addto:addChild(WeatherOverlay(self.type, self))
    table.insert(Game.stage.overlay, {self, overlay})
    return overlay
end

return WeatherHandler