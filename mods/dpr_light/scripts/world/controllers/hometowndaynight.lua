local HometownDayNight, super = Class(Event)

function HometownDayNight:init(data,...)
    super.init(self,data,...)
    ---@type table<string, Class[]>
    local class_lists = {
        map_objects = {TileLayer, TileObject, Sprite},
    }
    class_lists.default = class_lists.map_objects
    self.classes = class_lists[data.properties.class_set or "default"]
	self.palette = "world/town_palette"
    self.shaded = {}
	self.night = 0
	self.overlay = nil
	if Game:getFlag("hometown_time", "day") == "night" then
		self.night = 1
		self.overlay = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		self.overlay.color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
		self.overlay.alpha = 0.6
		self.overlay:setLayer(WORLD_LAYERS["below_ui"])
		self.overlay:setParallax(0)
		Game.world:addChild(self.overlay)
	end
end

function HometownDayNight:onMapDone()
    ---@type Object[]
    self:setLayer(-10000)
    -- sanity check
    for keya, class_a in ipairs(self.classes) do
        for keyb, class_b in ipairs(self.classes) do
            assert(keya == keyb or not class_a:includes(class_b), string.format(
                "%s is listed even though it includes %s", Utils.dump(class_a), Utils.dump(class_b)
            ))
        end
    end
    for _, class in ipairs(self.classes) do
        for index, value in ipairs(Game.world.stage:getObjects(class)) do
            value:addFX(BGPaletteFX(self.palette, self.night), "daynight_added")
            table.insert(self.shaded, value)
        end
    end
    self.done = true
end

-- called by hook
function HometownDayNight:onAddSibling(obj)
    if not self.done then return end
    for _, class in ipairs(self.classes) do
        if obj:includes(class) and not obj:getFX("daynight_added") then
            obj:addFX(BGPaletteFX(self.palette, self.night), "daynight_added")
            table.insert(self.shaded, obj)
            break
        end
    end
end

function HometownDayNight:onRemove(parent)
    for index, value in ipairs(self.shaded) do
        value:removeFX("daynight_added")
    end
	if self.overlay then
		self.overlay:remove()
	end
end

function HometownDayNight:onLoad()
    super.onLoad(self)
    self:onMapDone()
	if Game:getFlag("hometown_time", "day") == "night" then
		if Game.world.map.image_layers["overlay"] then
			Game.world.map.image_layers["overlay"].color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
		end
	end
end

return HometownDayNight