local HometownDayNight, super = Class(Event)

function HometownDayNight:init(data,...)
    super.init(self,data,...)
	self.night = 0
	if Game:getFlag("hometown_time", "day") == "night" then
		self.night = 1
	end
	self.image_overlay = nil
	if not Game.world.map.data.properties["inside"] then
		self.palette = "world/town_palette"
		self.overlay = nil
		if Game:getFlag("hometown_time", "day") == "night" then
			self.overlay = HometownNightOverlay(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			self.overlay.color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
			self.overlay.alpha = 0.6
			self.overlay:setLayer(WORLD_LAYERS["above_events"])
			self.overlay:setParallax(0)
			self.overlay:addFX(MaskFX(function()
				return Game.world.menu
			end), "menu_mask").inverted = true
			self.overlay:addFX(MaskFX(function()
				if Game.world:isTextboxOpen() then
					return Game.world.cutscene.textbox
				else
					return nil
				end
			end), "textbox_mask").inverted = true
			self.overlay:addFX(MaskFX(function()
				if Game.world:hasCutscene() and Game.world.cutscene.choicebox then
					return Game.world.cutscene.choicebox
				else
					return nil
				end
			end), "choicebox_mask").inverted = true
			Game.stage:addChild(self.overlay)
		end
	elseif Game.world.map.data.properties["church"] then
		self.palette = "world/town_palette"
		self.overlay = nil
		if Game:getFlag("hometown_time", "day") == "night" then
			self.overlay = HometownNightOverlay(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			self.overlay.color = Utils.hexToRgb("#00042b")
			self.overlay.alpha = 0.5
			self.overlay:setLayer(WORLD_LAYERS["above_events"])
			self.overlay:setParallax(0)
			self.overlay:addFX(MaskFX(function()
				return Game.world.menu
			end), "menu_mask").inverted = true
			self.overlay:addFX(MaskFX(function()
				if Game.world:isTextboxOpen() then
					return Game.world.cutscene.textbox
				else
					return nil
				end
			end), "textbox_mask").inverted = true
			self.overlay:addFX(MaskFX(function()
				if Game.world:hasCutscene() and Game.world.cutscene.choicebox then
					return Game.world.cutscene.choicebox
				else
					return nil
				end
			end), "choicebox_mask").inverted = true
			Game.stage:addChild(self.overlay)
		end
	end
end

function HometownDayNight:onMapDone()
    ---@type Object[]
    self:setLayer(-10000)
    -- sanity check
	if not Game.world.map.data.properties["inside"] and not Game.world.map.data.properties["church"] then
		Game.world:addFX(BGPaletteFX(self.palette, self.night), "daynight_added")
	end
    self.done = true
end

function HometownDayNight:onRemove(parent)
	if not Game.world.map.data.properties["inside"] and not Game.world.map.data.properties["church"] then
		Game.world:removeFX("daynight_added")
	end
	if self.overlay then
		self.overlay:remove()
	end
	if self.image_overlay then
		self.image_overlay:remove()
	end
end

function HometownDayNight:onLoad()
    super.onLoad(self)
    self:onMapDone()
end
	
function HometownDayNight:update()
    super.update(self)
	if self.image_overlay then
		if Game.world.map.id == "light/hometown/secret_path" then
			self.image_overlay:setPosition(Game.world.camera.x*0, -Game.world.camera.y*0.9)
		else
			self.image_overlay:setPosition(-Game.world.camera.x*0.9, Game.world.camera.y*0)
		end
	end
end
	
function HometownDayNight:postLoad()
	super.postLoad(self)
	if Game:getFlag("hometown_time", "day") == "night" then
		if Game.world.map.image_layers["overlay"] then
			Game.world.map.image_layers["overlay"]:remove()
			self.image_overlay = Sprite("world/maps/hometown/graveyardover", 0, 0)
			self.image_overlay.wrap_texture_x = true
			self.image_overlay.wrap_texture_y = true
			self.image_overlay.color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
			self.image_overlay:addFX(MaskFX(function()
				return Game.world.menu
			end), "menu_mask").inverted = true
			self.image_overlay:addFX(MaskFX(function()
				if Game.world:isTextboxOpen() then
					return Game.world.cutscene.textbox
				else
					return nil
				end
			end), "textbox_mask").inverted = true
			self.image_overlay:addFX(MaskFX(function()
				if Game.world:hasCutscene() and Game.world.cutscene.choicebox then
					return Game.world.cutscene.choicebox
				else
					return nil
				end
			end), "choicebox_mask").inverted = true
			Game.stage:addChild(self.image_overlay)
		end
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.night_mode == 3 then
				value:remove()
			end
		end
	else
        for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.night_mode then
				value:remove()
			end
		end
	end
end

return HometownDayNight