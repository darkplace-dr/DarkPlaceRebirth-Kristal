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
    self.palette_shader = Assets.getShader("palette")
    self.lut_shader = Assets.getShader("lut")
	self.palette_tex = self.palette and Assets.getTexture(self.palette) or nil
    self.luts = Assets.getFrames("world/luts/luts")
	self.lut_strength = 1
end

function HometownDayNight:postLoad()
    super.postLoad(self)
    self.done = true
    self.inside = self.world.map.data.properties["inside"]
    self.church = self.world.map.data.properties["church"]
    self.no_shadows = self.world.map.data.properties["no_shadows"]
    self.no_lut = self.world.map.data.properties["no_lut"]
	if not self.inside and not self.no_shadows then
		if (Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening") then
			self.shadows = SunShadows()
			self.shadows:setLayer(WORLD_LAYERS["below_ui"])
			Game.world.player:addFX(SelfShadowFX())
			for _, follower in ipairs(Game.world.followers) do
				follower:addFX(SelfShadowFX())
			end
			if Game:getFlag("hometown_time", "day") == "morning" then
				self.shadows.highlight_mode = 0
				self.shadows.colour_shadowblend = ColorUtils.hexToRGB("#0D0538")
				self.shadows.alpha_shadowblend = 0.3
				self.shadows.skew_amt = 45
				self.shadows.tile_layer_names = {"tiles_shadows_morning"}
				self.shadows.asset_layer_names = {"objects_shadows_morning"}
				self.shadows.cutout_tile_layer_names = {}
				self.shadows.cutout_asset_layer_names = {"objects_shadows_morning_cutout"}
				self.shadows:refreshCanvases()
			elseif Game:getFlag("hometown_time", "day") == "morning" then
				self.shadows.evening_mode = true
				self.shadows.highlight_mode = -1
				self.shadows.colour_shadowblend = ColorUtils.hexToRGB("#230023")
				self.shadows.alpha_shadowblend = 0.5
				self.shadows.skew_amt = -90
				self.shadows.tile_layer_names = {"tiles_shadows_evening"}
				self.shadows.asset_layer_names = {"objects_shadows_evening"}
				self.shadows.cutout_tile_layer_names = {}
				self.shadows.cutout_asset_layer_names = {"objects_shadows_evening_cutout"}
				self.shadows:refreshCanvases()
			end
			Game.world:addChild(self.shadows)
		end
		Game.world.map:getTileLayer("tiles_shadows_evening").visible = false
		local layer = Game.world.map.layers["objects_shadows_evening"]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj then obj.visible = false end
		end	
		layer = Game.world.map.layers["objects_shadows_evening_cutout"]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj then obj.visible = false end
		end	
		Game.world.map:getTileLayer("tiles_shadows_morning").visible = false
		layer = Game.world.map.layers["objects_shadows_morning"]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj then obj.visible = false end
		end	
		layer = Game.world.map.layers["objects_shadows_morning_cutout"]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj then obj.visible = false end
		end
	end
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
			if Game:getFlag("hometown_time", "day") == "morning" and value.sunrise_mode then
				value:remove()
			end
			if Game:getFlag("hometown_time", "day") == "evening" and value.sunset_mode then
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
    if self.shadows then
        self.shadows:remove()
    end
end

function HometownDayNight:fullDraw(...)
    self.main_canvas = love.graphics.getCanvas() -- Usually SCREEN_CANVAS, but not always.
    super.fullDraw(self)
end

function HometownDayNight:draw()
    super.draw(self)
    love.graphics.push()
    Draw.pushCanvasLocks()
    love.graphics.origin()
    local c = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    Draw.drawCanvas(self.main_canvas)
    Draw.popCanvas(true)
    love.graphics.clear(0, 0, 0, 1)
    if Game:getFlag("hometown_time", "day") == "night" then
		if (not self.inside) or self.church then
			love.graphics.setShader(self.palette_shader)
			self.palette_shader:send("palette_tex", self.palette_tex)
			local palw, palh = self.palette_tex:getWidth(), self.palette_tex:getHeight()
			self.palette_shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
			self.palette_shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
			self.palette_shader:send("palette_id", self.night)
		end
    elseif Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening" then
		if not self.inside and not self.no_lut then
		    love.graphics.setShader(self.lut_shader)
			self.lut_shader:send("strength", self.lut_strength)
			local lut_slot = 1
			if Game:getFlag("hometown_time", "day") == "evening" then
				lut_slot = 2
			end
			self.lut_shader:send("lut_tex", self.luts[lut_slot])
		end
	end
    Draw.drawCanvas(c)
    Draw.popCanvasLocks()
	love.graphics.setShader()
    love.graphics.pop()
    super.draw(self)
end

return HometownDayNight