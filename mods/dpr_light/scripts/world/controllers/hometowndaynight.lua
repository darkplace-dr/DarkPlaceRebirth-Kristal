local HometownDayNight, super = Class(Event)

function HometownDayNight:init(data,...)
    super.init(self,data,...)
    local properties = data and data.properties or {}
    self.night = 0
    if Game:getFlag("hometown_time", "day") == "night" then
        self.night = 1
    end
    self.palette = properties["palette"] or "world/town_palette"
    self.force_palette = properties["palette"] ~= nil
    self.shader = Assets.getShader("palette")
	self.palette_tex = self.palette and Assets.getTexture(self.palette) or nil
end

function HometownDayNight:postLoad()
    super.postLoad(self)
    self:setLayer(-10000)
    self.done = true
    self.inside = self.world.map.data.properties["inside"]
    self.church = self.world.map.data.properties["church"]
    if (not self.inside) or self.church then
        self.overlay = nil
        if self.world.map.data.properties["church"] and self.night == 1 then
            self.night = 2
        end
        if Game:getFlag("hometown_time", "day") == "night" then
            self.overlay = HometownNightOverlay(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			if self.church and self.world.map.id ~= "light/hometown/church/main" then
				self.overlay.color = ColorUtils.hexToRGB("#00042B")
				self.overlay.alpha = 0.5 
			else
				self.overlay.color = ColorUtils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
				self.overlay.alpha = self.inside and 0.4 or 0.6
				if Game.world.map.image_layers["light"] then
					Game.world.map.image_layers["light"].visible = false
				end
			end
            self.overlay:setLayer(WORLD_LAYERS["below_ui"])
            self.overlay:setParallax(0)
            Game.world:addChild(self.overlay)
            self.callback = Callback{
                draw = function ()
                    love.graphics.setShader()
                end
            }
            self.callback:setLayer(WORLD_LAYERS["above_events"])
            Game.world:addChild(self.callback)
            if Game.world.map.image_layers["overlay"] then
                Game.world.map.image_layers["overlay"]:setColor(ColorUtils.mergeColor(COLORS["black"], COLORS["navy"], 0.5))
            end
        end
    end
	if Game:getFlag("hometown_time", "day") == "night" then
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.day_mode or value.sunrise_mode or value.sunset_mode then
				value:remove()
			end
		end
	else
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.night_mode then
				value:remove()
			end
			if Game:getFlag("hometown_time", "day") == "sunrise" and value.sunrise_mode then
				value:remove()
			end
			if Game:getFlag("hometown_time", "day") == "sunset" and value.sunset_mode then
				value:remove()
			end
		end
	end
	if Game.stage:hasWeather("rain") then
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.rain_mode == 0 then
				value:remove()
			end
		end
	else
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.rain_mode == 1 then
				value:remove()
			end
		end
	end
end

function HometownDayNight:onRemove(parent)
    if self.overlay then
        self.overlay:remove()
    end
    if self.callback then
        self.callback:remove()
    end
end

function HometownDayNight:draw()
    super.draw(self)
    if self.shader then
        love.graphics.setShader(self.shader)
		self.shader:send("palette_tex", self.palette_tex)
		self.shader:send("palette_dim", {self.palette_tex:getWidth(), self.palette_tex:getHeight()})
		self.shader:send("palette_id", self.night + 1)
    end
end

return HometownDayNight