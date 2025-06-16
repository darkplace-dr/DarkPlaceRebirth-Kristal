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
            self.overlay:setLayer(WORLD_LAYERS["below_ui"])
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
            Game.world:addChild(self.overlay)
            self.callback = Callback{
                draw = function ()
                    love.graphics.setShader()
                end
            }
            self.callback:setLayer(WORLD_LAYERS["above_events"])
            Game.world:addChild(self.callback)
            ---@type love.Shader
            self.shader = BGPaletteFX(self.palette, self.night).shader
			if Game.world.map.image_layers["overlay"] then
				Game.world.map.image_layers["overlay"].color = Utils.mergeColor(COLORS["black"], COLORS["navy"], 0.5)
				Game.world.map.image_layers["overlay"]:addChild(self.callback)
				Game.world:addChild(Game.world.map.image_layers["overlay"])
			end
        end
    end
	if Game:getFlag("hometown_time", "day") == "night" then
		for index, value in ipairs(Game.world.stage:getObjects(Object)) do
			if value.day_mode then
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

function HometownDayNight:postLoad()
    super.postLoad(self)
    self:setLayer(-10000)
    self.done = true
end
-- what
function HometownDayNight:onAddSibling(obj) end

function HometownDayNight:onRemove(parent)
    if not Game.world.map.data.properties["inside"] then
        if self.shaded then
            for index, value in ipairs(self.shaded) do
                value:removeFX("daynight_added")
            end
        end
    end
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
    end
end

return HometownDayNight