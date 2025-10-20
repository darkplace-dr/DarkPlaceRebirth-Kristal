--- Interactables are Overworld objects in Kristal that activate scripts, cutscenes, or text, when interacted with. \
--- `Interactable` is an [`Event`](lua://Event.init) - naming an object `interactable` on an `objects` layer in a map creates this object. \
--- See this object's Fields for the configurable properties on this object.
---
---@class Interactable : Event
---
---@field solid     boolean *[Property `solid`]* Whether the interactable is solid
---
---@field cutscene  string *[Property `cutscene`]* The name of a cutscene to start when interacting with this object
---@field script    string *[Property `script`]* The name of a script file to execute when interacting with this object
--- *[Property `text`]* A line of text to display when interacting with this object \
--- *[Property list `text`]* Several lines of text to display when interacting with this object \
--- *[Property multi-list `text`]* Several groups of lines of text to display on sequential interactions with this object - all of `text1_i` forms the first interaction, all of `text2_i` forms the second interaction etc...
---@field text string[] 
---
---@field set_flag string   *[Property `setflag`]* The name of a flag to set the value of when interacting with this object
---@field set_value any     *[Property `setvalue`]* The value to set the flag specified by [`set_flag`](lua://Interactable.set_flag) to (Defaults to `true`)
---
---@field once boolean      *[Property `once`]* Whether this event can only be interacted with once per save file (Defaults to `false`)
---
---@field interact_count number The number of times this interactable has been interacted with on this map load
---
---@overload fun(...) : Interactable
local Interactable, super = Utils.hookScript(Interactable)

function Interactable:init(x, y, shape, properties)
    shape = shape or {TILE_WIDTH, TILE_HEIGHT}
    super.init(self, x, y, shape)

    properties = properties or {}

    self.solid = properties["solid"] or false

    self.cutscene = properties["cutscene"]
    self.script = properties["script"]
    self.text = Utils.parsePropertyMultiList("text", properties)

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.once = properties["once"] or false

    self.interact_count = 0
	self.day_text = nil
	self.sunset_text = nil
	self.night_text = nil
	self.sunrise_text = nil
	self.rain_text = nil
	if properties["daytext"] or properties["daytext1"] then
		self.day_text = Utils.parsePropertyMultiList("daytext", properties)
	end
	if properties["sunsettext"] or properties["sunsettext1"] then
		self.sunset_text = Utils.parsePropertyMultiList("sunsettext", properties)
	end
	if properties["nighttext"] or properties["nighttext1"] then
		self.night_text = Utils.parsePropertyMultiList("nighttext", properties)
	end
	if properties["sunrisetext"] or properties["sunrisetext1"] then
		self.sunrise_text = Utils.parsePropertyMultiList("sunrisetext", properties)
	end
	if properties["raintext"] or properties["raintext1"] then
		self.rain_text = Utils.parsePropertyMultiList("raintext", properties)
	end
end

function Interactable:onInteract(player, dir)
    self.interact_count = self.interact_count + 1

    if self.script then
        Registry.getEventScript(self.script)(self, player, dir)
    end
    local cutscene
    if self.cutscene then
        cutscene = self.world:startCutscene(self.cutscene, self, player, dir)
    else
        cutscene = self.world:startCutscene(function(c)
            local text = self.text
			local time = Game:getFlag("hometown_time", nil)
			if self.day_text and time == "day" then
				text = self.day_text
			elseif self.sunset_text and time == "sunset" then
				text = self.sunset_text
			elseif self.night_text and time == "night" then
				text = self.night_text
			elseif self.sunrise_text and time == "sunrise" then
				text = self.sunrise_text
			end
			if self.rain_text and Game.stage:hasWeather("rain") then
				text = self.rain_text
			end
            local text_index = Utils.clamp(self.interact_count, 1, #text)
            if type(text[text_index]) == "table" then
                text = text[text_index]
            end
            for _,line in ipairs(text) do
                c:text(line)
            end
        end)
    end
    cutscene:after(function()
        self:onTextEnd()
    end)

    if self.set_flag then
        Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
    end

    self:setFlag("used_once", true)
    if self.once then
        self:remove()
    end

    return true
end

return Interactable