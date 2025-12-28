---@class WorldCutscene : WorldCutscene
local WorldCutscene, super = Utils.hookScript(WorldCutscene)

function WorldCutscene:init(...)
    super.init(self, ...)

    self.force_texttagged = false
end

local function waitForTextbox(self) return not self.textbox or self.textbox:isDone() end

function WorldCutscene:text(...)
    if self.force_texttagged then
        return self:textTagged(...)
    end
    return super.text(self, ...)
end

function WorldCutscene:showNametag(text, options)
    options = options or {}

    if self.nametag then self.nametag:remove() end

    self.nametag = Nametag(text, options)
    self.nametag.layer = WORLD_LAYERS["textbox"]
    self.nametag:setParallax(0, 0)
    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = Game.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
       self.nametag.y = 185
    end
    Game.world:addChild(self.nametag)
    return self.nametag
end

function WorldCutscene:changeNametag(text)
    self.nametag:changeText(text)
end

function WorldCutscene:hideNametag()
    if self.nametag then
        self.nametag:remove()
        self.nametag = nil
    end
end

local function waitForGame(self) return (Game.minigame == nil) end
function WorldCutscene:startMinigame(game)
    Game:startMinigame(game)
    return self:wait(waitForGame)
end

--- A version of [WorldCutscene.text] that also creates a nametag alongside it.
---@overload fun(self: WorldCutscene, text: string, options?: table) : (finished:(fun():boolean), textbox: Textbox?)
---@overload fun(self: WorldCutscene, text: string, portrait?: string, options?: table) : (finished:(fun():boolean), textbox: Textbox?)
---@param text      string                      The text to be typed.
---@param portrait? string|nil                  The name of the character portrait to use for this textbox.
---@param actor?    Character|Actor|string|nil  The Character/Actor to be used for voice bytes and portraits, overriding the active cutscene speaker.
---@param options?  table                       A table definining additional properties to control the textbox.
---|"talk"         # If a `Character` instance is attached to the textbox, whether they should use their talk sprite in world. 
---|"top"          # Override for the default textbox position, defining whether the textbox should appear at the top of the screen.
---|"x"            # The x-offset of the dialgoue portrait.
---|"y"            # The y-offset of the dialogue portrait.
---|"reactions"    # A table of tables that define "reaction" dialogues. Each table defines the dialogue, x and y position of the face, actor and face sprite, in that order. x and y can be strings as well, referring to existing positions; x can be left, leftmid, mid, middle, rightmid, or right, and y can be top, mid, middle, bottommid, and bottom. Must be used in combination with a react text command.
---|"functions"    # A table defining additional functions that can be used in the text with the `func` text command. Each key, value pair will form the id to use with `func` and the function to be called, respectively.
---|"font"         # The font to be used for this text. Can optionally be defined as a table {font, size} to also set the text size.
---|"align"        # Sets the alignment of the text.
---|"skip"         # If false, the player will be unable to skip the textbox with the cancel key.
---|"advance"      # When `false`, the player cannot advance the textbox, and the cutscene will no longer suspend itself on the dialogue by default.
---|"auto"         # When `true`, the text will auto-advance after the last character has been typed.
---|"nametag"      # If set, use this for the nametag instead of the actor's name.
---|"nametag_font" # The font used by the nametag. Defaults to the actor's set font.
---@see WorldCutscene.text
function WorldCutscene:textTagged(text, portrait, actor, options)
    if type(actor) == "table" and not isClass(actor) then
        options = actor
        actor = nil
    end
    if type(portrait) == "table" then
        options = portrait
        portrait = nil
    end

    options = options or {}

    self:closeText()

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end

    self.textbox = Textbox(56, 344, width, height)
    self.textbox.layer = WORLD_LAYERS["textbox"]
    self.world:addChild(self.textbox)
    self.textbox:setParallax(0, 0)

    if type(actor) == "string" then
        actor = self:getCharacter(actor) or (Registry.getActor(actor) and Registry.createActor(actor)) or actor
    end

    local speaker = self.textbox_speaker
    if not speaker and isClass(actor) and actor:includes(Character) then
        speaker = actor.sprite
    end

    if options["talk"] ~= false then
        self.textbox.text.talk_sprite = speaker
    end

    actor = actor or self.textbox_actor
    if isClass(actor) and actor:includes(Character) then
        actor = actor.actor
    end
    if actor then
        self.textbox:setActor(actor)
    end

    if options.nametag or (actor and isClass(actor)) then
        self:showNametag(options.nametag or actor:getName(), {font = options.nametag_font or actor:getFont()})
    end

    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = self.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
       local bx, by = self.textbox:getBorder()
       self.textbox.y = by + 2
    end

    self.textbox.active = true
    self.textbox.visible = true
    self.textbox:setFace(portrait, options["x"], options["y"])

    if options["reactions"] then
        for id,react in pairs(options["reactions"]) do
            self.textbox:addReaction(id, react[1], react[2], react[3], react[4], react[5])
        end
    end

    if options["functions"] then
        for id,func in pairs(options["functions"]) do
            self.textbox:addFunction(id, func)
        end
    end

    if options["font"] then
        if type(options["font"]) == "table" then
            -- {font, size}
            self.textbox:setFont(options["font"][1], options["font"][2])
        else
            self.textbox:setFont(options["font"])
        end
    end

    if options["align"] then
        self.textbox:setAlign(options["align"])
    end

    self.textbox:setSkippable(options["skip"] or options["skip"] == nil)
    self.textbox:setAdvance(options["advance"] or options["advance"] == nil)
    self.textbox:setAuto(options["auto"])

    self.textbox:setText(text, function()
        self:hideNametag()
        self.textbox:remove()
        self:tryResume()
    end)

    local wait = options["wait"] or options["wait"] == nil
    if not self.textbox.text.can_advance then
        wait = options["wait"] -- By default, don't wait if the textbox can't advance
    end

    if wait then
        return self:wait(waitForTextbox)
    else
        return waitForTextbox, self.textbox, self.nametag
    end
end

function WorldCutscene:closeText()
    super.closeText(self)
    self:hideNametag()
end

function WorldCutscene:gonerKeyboard(options)
    local chosen_text
    local fade_rect = Rectangle(0, 0, Game.world.width, Game.world.height)
    fade_rect:setColor(COLORS.black)
    fade_rect.alpha = 0
    if options.fade then
        self.world:spawnObject(fade_rect, "below_ui")
        self.world.timer:tween(00.40, fade_rect, {alpha = 0.4}, "linear")
    end
    local keyboard = GonerKeyboard(options.length or -1, options.mode or "default", function(text)
        chosen_text = text
        if options.fade then
            fade_rect:fadeOutAndRemove(00.40)
        end
    end, function (key, _, _, kbd)
        if options.key_callback then
            options.key_callback(kbd.text,key,kbd,fade_rect)
        end
    end)
    keyboard.x = self.world.camera.x - (SCREEN_WIDTH/2)
    keyboard.y = self.world.camera.y - (SCREEN_HEIGHT/2)
    keyboard.layer = WORLD_LAYERS["ui"]

    self.world:addChild(keyboard)
    local waiter = function()
        return chosen_text ~= nil, chosen_text
    end
    if options.wait then
        return self:wait(waiter)
    else
        return waiter
    end
end

function WorldCutscene:warpBinInput(options)
    local action
    local wbi_ok = false
    local wbi = InputMenu(options.length)
    wbi.as_warp_bin_ui = false
    wbi.cancellable = false
    wbi.finish_cb = function(_action, input)
        wbi_ok = true
        action = input
    end
    wbi.key_callback = function(text, key)
        if options.key_callback then
            options.key_callback(text,key, wbi, Object())
        end
    end
    Game.world:spawnObject(wbi, "ui")
    local waiter = function() return wbi_ok, action end
    if options.wait then
        return self:wait(waiter)
    else
        return waiter
    end
end

function WorldCutscene:getUserText(length, mode, wait, fade, options)
    options = Utils.merge({
        length = length or -1,
        mode = mode or "default",
        wait = wait ~= false,
        fade = fade ~= false,
    }, options or {})
    if Input.usingGamepad() or (options.length == -1) or Kristal.Config["prefersGonerKeyboard"] then
        return self:gonerKeyboard(options)
    else
        return self:warpBinInput(options)
    end
end

function WorldCutscene:doki_text(text, actor, options)
    if type(actor) == "table" and not isClass(actor) then
        options = actor
        actor = nil
    end
    if type(portrait) == "table" then
        options = portrait
        portrait = nil
    end

    options = options or {}

    self:closeText()

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end
    if options["name"] then
        self.textbox = Doki_Textbox(15, 365, width, height, nil, nil, nil, options["name"])
        self.textbox.layer = WORLD_LAYERS["textbox"]
    else
        self.textbox = Doki_Textbox(15, 365, width, height)
        self.textbox.layer = WORLD_LAYERS["textbox"]
    end
    self.world:addChild(self.textbox)
    self.textbox:setParallax(0, 0)

    local speaker = self.textbox_speaker
    if not speaker and isClass(actor) and actor:includes(Character) then
        speaker = actor.sprite
    end

    if options["talk"] ~= false then
        self.textbox.text.talk_sprite = speaker
    end

    actor = actor or self.textbox_actor
    if isClass(actor) and actor:includes(Character) then
        actor = actor.actor
    end
    if actor then
        self.textbox:setActor(actor)
    end

    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = self.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
       local bx, by = self.textbox:getBorder()
       self.textbox.y = by + 2
    end

    self.textbox.active = true
    self.textbox.visible = true
    self.textbox:setFace(portrait, options["x"], options["y"])

    if options["reactions"] then
        for id,react in pairs(options["reactions"]) do
            self.textbox:addReaction(id, react[1], react[2], react[3], react[4], react[5])
        end
    end

    if options["functions"] then
        for id,func in pairs(options["functions"]) do
            self.textbox:addFunction(id, func)
        end
    end

    if options["font"] then
        if type(options["font"]) == "table" then
            -- {font, size}
            self.textbox:setFont(options["font"][1], options["font"][2])
        else
            self.textbox:setFont(options["font"])
        end
    end

    if options["align"] then
        self.textbox:setAlign(options["align"])
    end

    self.textbox:setSkippable(options["skip"] or options["skip"] == nil)
    self.textbox:setAdvance(options["advance"] or options["advance"] == nil)
    self.textbox:setAuto(options["auto"])

    self.textbox:setText(text, function()
        self.textbox:remove()
        self:tryResume()
    end)

    local wait = options["wait"] or options["wait"] == nil
    if not self.textbox.text.can_advance then
        wait = options["wait"] -- By default, don't wait if the textbox can't advance
    end

    if wait then
        return self:wait(waitForTextbox)
    else
        return waitForTextbox, self.textbox
    end
end

function WorldCutscene:board_text(text, options)
    options = options or {}

	if not self.textbox and self.board_texted then
		self.board_texted = false
	end
    self:closeText()

	local instant = self.board_texted or false
    self.textbox = board_textbox(128, 480, 384, 86, instant)
    self.textbox.layer = WORLD_LAYERS["textbox"]
    self.world:addChild(self.textbox)
    self.textbox:setParallax(0, 0)

    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = self.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
       self.textbox.y = -80
	   self.textbox.endy = 16
	   self.textbox.side = 0
    end
    self.textbox.active = true
    self.textbox.visible = true
	self.textbox.text.state["typing"] = false

    if options["functions"] then
        for id,func in pairs(options["functions"]) do
            self.textbox:addFunction(id, func)
        end
    end

    if options["font"] then
        if type(options["font"]) == "table" then
            -- {font, size}
            self.textbox:setFont(options["font"][1], options["font"][2])
        else
            self.textbox:setFont(options["font"])
        end
    end

    if options["align"] then
        self.textbox:setAlign(options["align"])
    end

    self.textbox:setSkippable(options["skip"] or options["skip"] == nil)
    self.textbox:setAdvance(options["advance"] or options["advance"] == nil)
    self.textbox:setAuto(options["auto"])

    self.textbox:setText(text, function()
		self.board_texted = true
        self.textbox:remove()
        self:tryResume()
    end)

    local wait = options["wait"] or options["wait"] == nil
    if not self.textbox.text.can_advance then
        wait = options["wait"] -- By default, don't wait if the textbox can't advance
    end

    if wait then
        return self:wait(waitForTextbox)
    else
        return waitForTextbox, self.textbox
    end
end

function WorldCutscene:resetBoardText()
	self.board_texted = false
end

function WorldCutscene:forceTextTagged(bool)
    self.force_texttagged = bool
end

function WorldCutscene:getPartyCharacterAtIndex(index)
    return self:getCharacter(Game.party[index].id)
end

function WorldCutscene:getPartyCharacters()
    local t = {}
    for i,v in ipairs(Game.party) do
        table.insert(t, self:getCharacter(v.id))
    end
    return t
end

function WorldCutscene:walkPartyTo(callback)
    local walks = {}
    for i,v in ipairs(self:getPartyCharacters()) do
        local x, y, time, facing, keep_facing, ease, after = callback(v, i)
        table.insert(walks, self:walkTo(v, x, y, time, facing, keep_facing, ease, after))
    end
    return function()
        for i,v in ipairs(walks) do
            if not v() then
                return false
            end
        end
        return true
    end
end

function WorldCutscene:slidePartyTo(callback)
    local slides = {}
    for i,v in ipairs(self:getPartyCharacters()) do
        local x, y, time, facing, keep_facing, ease, after = callback(v, i)
        table.insert(slides, self:slideTo(v, x, y, time, facing, keep_facing, ease, after))
    end
    return function()
        for i,v in ipairs(slides) do
            if not v() then
                return false
            end
        end
        return true
    end
end

function WorldCutscene:partyLook(dir)
    if not dir then dir = "down" end
    for i,v in ipairs(self:getPartyCharacters()) do
        v:setFacing(dir)
    end
end

function WorldCutscene:setPartySprites(sprites, speeds)
    for i,v in ipairs(Game.party) do
        if sprites[v.id] then
            self:setSprite(v.id, sprites[v.id], speeds and speeds[v.id])
        end
    end
end

function WorldCutscene:setPartyAnimations(anims)
    local all_anims = {}
    for i,v in ipairs(Game.party) do
        if anims[v.id] then
            table.insert(all_anims, self:setAnimation(v.id, anims[v.id]))
        end
    end
    return function()
        for i,v in ipairs(all_anims) do
            if not v() then
                return false
            end
        end
        return true
    end
end

function WorldCutscene:resetPartySprites()
    self:resetSprites()
end

function WorldCutscene:spinParty(speed)
    for i,v in ipairs(Game.party) do
        if type(speed) == "table" then
            self:spin(v, speed[v.id])
        else
            self:spin(v, speed)
        end
    end
end

function WorldCutscene:alertParty(duration, options)
    local waits = {}
    local options = options or {}
    local only_once = options.only_once
    for i,v in ipairs(self:getPartyCharacters()) do
        if only_once and i > 1 then
            options.play_sound = false
        end
        local _, w = self:alert(v, duration, options)
        table.insert(waits, w)
    end
    return function()
        for i,v in ipairs(waits) do
            if not v() then
                return false
            end
        end
        return true
    end
end

--[[

cutscene:textVariant("* Are you sure?", {
    susie = "genuine",
    dess = "condescending"
}, {
    priority={"susie", "dess"}
})

]]
function WorldCutscene:textVariant(text, portraits, options)
    local options = options or {}
    local priority = options.priority or {}
    if #priority == 0 then
        for actor,portrait in pairs(portraits) do
            table.insert(priority, actor)
        end
    end

    local possible_actors = {}
    for i,actor in ipairs(priority) do
        if portraits[actor] then
            table.insert(possible_actors, {actor=actor, portrait=portraits[actor]})
        end
    end

    for i,data in ipairs(possible_actors) do
        local actor = data.actor
        local portrait = data.portrait

        if (options["inparty"] and Game:hasPartyMember(actor)) or self:getCharacter(actor) then
            return self:text(text, portrait, actor, options)
        end
    end
end

function WorldCutscene:textIfExists(text, portrait, actor, options)
    local options = options or {}
    if (options["inparty"] and Game:hasPartyMember(actor)) or self:getCharacter(actor) then
        return self:text(text, portrait, actor, options)
    end
    return false
end

function WorldCutscene:textCond(cond, ...)
    if cond then return self:text(...) end
    return false
end

return WorldCutscene