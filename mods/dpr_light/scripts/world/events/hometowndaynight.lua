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
    self.palette_alpha_shader = Assets.getShader("palette_fakealpha")
    self.lut_shader = Assets.getShader("lut")
	self.palette_tex = self.palette and Assets.getTexture(self.palette) or nil
	self.ebott_pal = 0
    if Game:getFlag("hometown_time", "day") == "morning" then
        self.ebott_pal = 1
    end
    if Game:getFlag("hometown_time", "day") == "evening" then
        self.ebott_pal = 2
    end
    if Game:getFlag("hometown_time", "day") == "night" then
        self.ebott_pal = 3
    end
    self.luts = Assets.getFrames("world/luts/luts")
	self.lut_strength = 1
end

function HometownDayNight:onLoad()
    super.onLoad(self)
    self.inside = self.world.map.data.properties["inside"]
    self.church = self.world.map.data.properties["church"]
    self.school = self.world.map.data.properties["school"]
    self.no_shadows = self.world.map.data.properties["no_shadows"]
    self.no_lut = self.world.map.data.properties["no_lut"]
	if Game.world.map.image_layers["bg_evening"] then
		Game.world.map.image_layers["bg_evening"].alpha = 0
	end
	if Game.world.map.image_layers["bg_evening_overcast"] then
		Game.world.map.image_layers["bg_evening_overcast"].alpha = 0
	end
	if Game.world.map.image_layers["bg_evening_shadow"] then
		Game.world.map.image_layers["bg_evening_shadow"].alpha = 0
	end	
	if Game:getFlag("hometown_time", "day") == "evening" and self.world.map.id == "light/hometown/town_beach" then
		self:setLayer(Game.world:parseLayer("objects_evening_overlay"))
	end
	if not self.inside and not self.no_shadows and not self.school and not self.church then
		if Game.world.map.image_layers["bg_ebott"] then
			local overcast_alpha = 0
			if Game.stage.weather then
				for i, w in ipairs(Game.stage.weather) do
					if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
						overcast_alpha = (w.weathertimer / 120)
					end
				end
			end
			Game.world.map.image_layers["bg_ebott"]:addFX(PaletteFX("world/maps/ebott/palette_ebott", (self.ebott_pal * 2) + overcast_alpha, nil, nil, 1), "palette")
		end	
		if (Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening") then
			self.shadows = SunShadows()
			self.shadows:setLayer(WORLD_LAYERS["below_ui"])
			if Game:getFlag("hometown_time", "day") == "morning" then
				self.shadows.highlight_mode = 0
				self.shadows.colour_shadowblend = ColorUtils.hexToRGB("#0D0538")
				self.shadows.alpha_shadowblend = 0.3
				self.shadows.skew_amt = 45
				self.shadows.tile_layer_names = {"tiles_shadows_morning"}
				self.shadows.asset_layer_names = {"objects_shadows_morning"}
				self.shadows.cutout_tile_layer_names = {}
				self.shadows.cutout_asset_layer_names = {"objects_shadows_morning_cutout"}
				self.shadows.topcutout_asset_layer_names = {"objects_shadows_morning_topcutout"}
			elseif Game:getFlag("hometown_time", "day") == "evening" then
				self.shadows.evening_mode = true
				self.shadows.highlight_mode = -1
				self.shadows.colour_shadowblend = ColorUtils.hexToRGB("#230023")
				self.shadows.alpha_shadowblend = 0.5
				self.shadows.skew_amt = -90
				self.shadows.tile_layer_names = {"tiles_shadows_evening"}
				self.shadows.asset_layer_names = {"objects_shadows_evening"}
				self.shadows.cutout_tile_layer_names = {}
				self.shadows.cutout_asset_layer_names = {"objects_shadows_evening_cutout"}
				self.shadows.topcutout_asset_layer_names = {"objects_shadows_evening_topcutout"}
				local overcast_alpha = 1
				if Game.stage.weather then
					for i, w in ipairs(Game.stage.weather) do
						if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
							overcast_alpha = 1 - (w.weathertimer / 120)
						end
					end
				end
				if Game.world.map.image_layers["bg_evening"] then
					Game.world.map.image_layers["bg_evening"].alpha = overcast_alpha
				end
				if Game.world.map.image_layers["bg_evening_shadow"] then
					Game.world.map.image_layers["bg_evening_shadow"].alpha = overcast_alpha
				end	
				for _, obj in ipairs(Game.world.children) do
					if obj and obj.overcast_fade then obj.alpha = overcast_alpha end
				end
				if Game.world.map.image_layers["bg_evening_overcast"] then
					Game.world.map.image_layers["bg_evening_overcast"].alpha = 1
				end
				if Game.world.map.image_layers["overlay"] then
					Game.world.map.image_layers["overlay"]:setColor(ColorUtils.mergeColor(COLORS["maroon"], COLORS["purple"], 0.5))
				end
			end
			TableUtils.merge(self.shadows.obj_list, Game.stage:getObjects(NPC))
			TableUtils.merge(self.shadows.selfshadow_objects, self.shadows.obj_list)
			TableUtils.merge(self.shadows.selfshadow_objects, Game.world:getEvents("savepoint"))
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
		layer = Game.world.map.layers["objects_shadows_evening_topcutout"]
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
		layer = Game.world.map.layers["objects_shadows_morning_topcutout"]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj then obj.visible = false end
		end
	end
	if (not self.inside) or (self.church or self.school) then
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
	if self.inside then
		local overcast_alpha = 0
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					if w.type == "overcast" then
						overcast_alpha = (w.weathertimer / 120) * 0.5
					else
						overcast_alpha = (w.weathertimer / 120)
					end
				end
			end
		end
		local layer = Game.world.map.layers["objects_rain_windows"] or nil
		if layer then
			for _, obj in ipairs(Game.world.children) do
				if obj.layer == layer and obj then obj.alpha = overcast_alpha end
			end
		end
		layer = Game.world.map.layers["objects_rain_windows_night"] or nil
		if layer then
			for _, obj in ipairs(Game.world.children) do
				if obj.layer == layer and obj then obj.alpha = overcast_alpha end
			end
		end
	end
    if Game:getFlag("hometown_time", "day") ~= "night" then
		if Game.world.map.image_layers["room_night"] then
			Game.world.map.image_layers["room_night"].visible = false
		end
	end
end

function HometownDayNight:postLoad()
    super.postLoad(self)
    self.done = true
    self.inside = self.world.map.data.properties["inside"]
    self.church = self.world.map.data.properties["church"]
    self.school = self.world.map.data.properties["school"]
    self.no_shadows = self.world.map.data.properties["no_shadows"]
    self.no_lut = self.world.map.data.properties["no_lut"]
	if not self.inside and not self.no_shadows and not self.school and not self.church then
		if (Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening") then
			self.shadows:refreshCanvases()
			Game.world.player.self_shadow = true
			for _, follower in ipairs(Game.world.followers) do
				follower.self_shadow = true
			end
			for _, npc in ipairs(Game.stage:getObjects(Character)) do
				npc.self_shadow = true
			end
		end
	end
	for index, value in ipairs(Game.stage:getObjects(Object)) do
		if Game:getFlag("hometown_time", "day") == "day" and ((value.sunrise_mode or value.sunset_mode or value.night_mode) and not value.day_mode) then
			value:remove()
		end
		if Game:getFlag("hometown_time", "day") == "morning" and ((value.sunset_mode or value.day_mode or value.night_mode) and not value.sunrise_mode) then
			value:remove()
		end
		if Game:getFlag("hometown_time", "day") == "evening" and ((value.sunrise_mode or value.day_mode or value.night_mode) and not value.sunset_mode) then
			value:remove()
		end
		if Game:getFlag("hometown_time", "day") == "night" and ((value.day_mode or value.sunrise_mode or value.sunset_mode) and not value.night_mode) then
			value:remove()
		end
	end
	if Game.stage:hasWeather("rain") then
		for index, value in ipairs(Game.stage:getObjects(Object)) do
			if value.rain_mode == 0 then
				value:remove()
			end
		end
	else
		for index, value in ipairs(Game.stage:getObjects(Object)) do
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

function HometownDayNight:update()
	if Game.world.map.image_layers["bg_ebott"] then
		local overcast_alpha = 0
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					overcast_alpha = (w.weathertimer / 120)
				end
			end
		end
		Game.world.map.image_layers["bg_ebott"]:getFX("palette"):setPaletteIndex((self.ebott_pal * 2) + overcast_alpha)
	end	
	if Game:getFlag("hometown_time", "day") == "evening" then
		local overcast_alpha = 1
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					overcast_alpha = 1 - (w.weathertimer / 120)
				end
			end
		end
		if Game.world.map.image_layers["bg_evening"] then
			Game.world.map.image_layers["bg_evening"].alpha = overcast_alpha
		end
		if Game.world.map.image_layers["bg_evening_shadow"] then
			Game.world.map.image_layers["bg_evening_shadow"].alpha = overcast_alpha
		end
		for _, obj in ipairs(Game.world.children) do
			if obj and obj.overcast_fade then obj.alpha = overcast_alpha end
		end
	end
	if self.inside then
		local overcast_alpha = 0
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					if w.type == "overcast" then
						overcast_alpha = (w.weathertimer / 120) * 0.5
					else
						overcast_alpha = (w.weathertimer / 120)
					end
				end
			end
		end
		local layer = Game.world.map.layers["objects_rain_windows"] or nil
		if layer then
			for _, obj in ipairs(Game.world.children) do
				if obj.layer == layer and obj then obj.alpha = overcast_alpha end
			end
		end
		layer = Game.world.map.layers["objects_rain_windows_night"] or nil
		if layer then
			for _, obj in ipairs(Game.world.children) do
				if obj.layer == layer and obj then obj.alpha = overcast_alpha end
			end
		end
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
	local shader_active = false
    if Game:getFlag("hometown_time", "day") == "night" then
		if (not self.inside) or (self.church or self.school) then
			shader_active = true
			Draw.pushShader(self.palette_shader)
			self.palette_shader:send("palette_tex", self.palette_tex)
			local palw, palh = self.palette_tex:getWidth(), self.palette_tex:getHeight()
			self.palette_shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
			self.palette_shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
			self.palette_shader:send("palette_id", self.night)
		end
    elseif Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening" then
		if not self.inside and not self.no_lut and not self.church and not self.school and ((Game:getFlag("hometown_time", "day") == "morning" and not self.no_lut_morning) or (Game:getFlag("hometown_time", "day") == "evening" and not self.no_lut_evening)) then
			shader_active = true
		    Draw.pushShader(self.lut_shader)
			self.lut_shader:send("strength", self.lut_strength)
			local lut_slot = 1
			if Game:getFlag("hometown_time", "day") == "evening" then
				lut_slot = 2
			end
			self.lut_shader:send("lut_tex", self.luts[lut_slot])
		end
	end
    Draw.drawCanvas(c)
	if shader_active then Draw.popShader() end
	-- All this nonsense just so that the leaves created by the Noelle gate draw properly... (sigh)
    if Game:getFlag("hometown_time", "day") == "night" and Game.world:getEvent("noellegate") then
		local leaves = {}
		for _, obj in ipairs(Game.stage:getObjects(Sprite)) do
			if obj and obj.night_leaf_hack then
				table.insert(leaves, obj)
			end
		end
		if not self.inside and #leaves > 0 then
			Draw.pushShader(self.palette_alpha_shader)
			self.palette_alpha_shader:send("palette_tex", self.palette_tex)
			local palw, palh = self.palette_tex:getWidth(), self.palette_tex:getHeight()
			self.palette_alpha_shader:send("palette_uvs", {(1.0 / palw) * 0.5, (1.0 / palh) * 0.5, 1, 1})
			self.palette_alpha_shader:send("pixel_size", {1.0 / palw, 1.0 / palh})
			self.palette_alpha_shader:send("palette_id", self.night)
			love.graphics.stencil(function()
				Draw.pushShader("Mask")
				for _, chara in ipairs(Game.stage:getObjects(Character)) do
					love.graphics.push()
					love.graphics.origin()
					love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))
					if chara and chara.visible then
						chara:fullDraw()
					end
					love.graphics.pop()
				end
				Draw.popShader()
			end, "replace", 1)
			love.graphics.setStencilTest("less", 1)
			for _, leaf in ipairs(leaves) do
				if leaf and not leaf:isRemoved() then
					love.graphics.push()
					love.graphics.origin()
					love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))
					self.palette_alpha_shader:send("final_alpha", leaf.fake_alpha)
					leaf.visible = true
					leaf:fullDraw()
					leaf.visible = false
					love.graphics.pop()
				end
			end
			love.graphics.setStencilTest()
			Draw.popShader()
		end
	end
    Draw.popCanvasLocks()
    love.graphics.pop()
    super.draw(self)
end

return HometownDayNight