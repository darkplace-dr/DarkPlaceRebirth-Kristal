local HometownDayNight, super = Class(Event)

function HometownDayNight:init(data,...)
    super.init(self,data,...)
	self.night = 0
	if Game:getFlag("hometown_time", "day") == "night" then
		self.night = 1
	end
	if not Game.world.map.data.properties["inside"] then
		---@type table<string, Class[]>
		local class_lists = {
			map_objects = {TileLayer, TileObject, Sprite},
		}
		class_lists.default = {World}
		self.classes = class_lists[data.properties.class_set or "default"]
		self.palette = "world/town_palette"
		self.shaded = {}
		self.overlay = nil
		if Game:getFlag("hometown_time", "day") == "night" then
			self.overlay = HometownNightOverlay(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			self.overlay.color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
			self.overlay.alpha = 0.6
			self.overlay:setLayer(WORLD_LAYERS["above_events"])
			self.overlay:setParallax(0)
			Game.world:addChild(self.overlay)
		end
	end
end

function HometownDayNight:onMapDone()
    ---@type Object[]
    self:setLayer(-10000)
    -- sanity check
	if not Game.world.map.data.properties["inside"] then
		for keya, class_a in ipairs(self.classes) do
			for keyb, class_b in ipairs(self.classes) do
				assert(keya == keyb or not class_a:includes(class_b), string.format(
					"%s is listed even though it includes %s", Utils.dump(class_a), Utils.dump(class_b)
				))
			end
		end
		for _, class in ipairs(self.classes) do
			for index, value in ipairs(Game.world.stage:getObjects(class)) do
				if Game.world.map.image_layers["overlay"] == value then return end
				value:addFX(BGPaletteFX(self.palette, self.night), "daynight_added")
				table.insert(self.shaded, value)
			end
		end
	end
    self.done = true
end

-- called by hook
function HometownDayNight:onAddSibling(obj)
    if not self.done then return end
	if not Game.world.map.data.properties["inside"] then
		for _, class in ipairs(self.classes) do
			if obj:includes(class) and not obj:getFX("daynight_added") then
				obj:addFX(BGPaletteFX(self.palette, self.night), "daynight_added")
				table.insert(self.shaded, obj)
				break
			end
		end
	end
end

function HometownDayNight:onRemove(parent)
	if not Game.world.map.data.properties["inside"] then
		if self.shaded then
			for index, value in ipairs(self.shaded) do
				value:removeFX("daynight_added")
			end
		end
		if self.overlay then
			self.overlay:remove()
		end
	end
end

function HometownDayNight:onLoad()
    super.onLoad(self)
    self:onMapDone()
end
	
function HometownDayNight:postLoad()
	super.postLoad(self)
	if Game:getFlag("hometown_time", "day") == "night" then
		if Game.world.map.image_layers["overlay"] then
			Game.world.map.image_layers["overlay"].color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
		end
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.night_mode == 2 then
				value:removeFX("daynight_added")
			end
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