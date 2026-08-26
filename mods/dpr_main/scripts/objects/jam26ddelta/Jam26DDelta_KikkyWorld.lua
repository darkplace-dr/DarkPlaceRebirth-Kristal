--- The `World` Object manages everything relating to the overworld in Kristal. \
--- A globally available instance of `World` is stored in [`Game.world`](lua://Game.world).
---
---@class Jam26DDelta_KikkyWorld : Object
---
---@field state             string                          The current state that this `World` is in - should never be set manually, see [`Jam26DDelta_KikkyWorld:setState()`](lua://World.setState) instead
---@field state_manager     StateManager                    An object that manages the state of this `World`
---
---@field music             Music                           The `Music` instance that controls audio playback for this `World`
---
---@field map               Map                             The currently loaded map instance
---
---@field camera            Camera                          The camera object used to display the world
---
---@field player            Player                          The player character
---@field soul              OverworldSoul                   The soul of the player
---
---@field battle_borders    table                           *(unused? See [`Map.battle_borders`](lua://Map.battle_borders))*
---
---@field transition_fade   number                          *(unused?)*
---
---@field in_battle         boolean                         Whether the player is currently in a world battle set through [`Jam26DDelta_KikkyWorld:setBattle()](lua://World.setBattle) (affects the visibility of world battle content)
---@field in_battle_area    boolean                         Whether the player is currently standing inside a battlearea of the map (affects the visibility of world battle content)
---@field battle_alpha      number                          The current alpha value of world battle content
---
---@field bullets           WorldBullet[]                   A table of currently active bullets
---@field followers         Follower[]                      A table of all followers currently present in the world
---
---@field cutscene          WorldCutscene?                  The `WorldCutscene` object of the currently active cutscene, if present
---
---@field conroller_parent  Object                          The object that all controllers are parented to
---
---@field fader             Jam26DDelta_KikkyFader
---
---@field timer             Timer
---
---@field can_open_menu     boolean                         Whether the player can open their menu
---
---@field menu              LightMenu|DarkMenu?             The Menu object of the menu, if it is open
---
---@field calls             table<[string, string]>   A list of calls available on the cell phone in the Light World CELL menu
---
---@field door_delay        number                          *(Used internally)* Timer variable for door transition sounds
---
---@field healthbar         HealthBar
---
---@overload fun(map?: string) : World
local Jam26DDelta_KikkyWorld, super = Class(Object)

---@param map? string    The optional name of a map to initially load with the world
function Jam26DDelta_KikkyWorld:init(map, type, x, y, offx, offy, swidth, sheight, gwidth, gheight)
    super.init(self)
	self.type = type or 0
    self.world = self
    Game.world.kikky_world = self
    Game.board = self
	self.screen_width = swidth or 384
	self.screen_height = sheight or 256
	self.game_width = gwidth or 384
	self.game_height = gheight or 256
	self.camera = Camera(self, 0,0,self.game_width,self.game_height)
    -- states: GAMEPLAY, FADING, MENU
    self.state = "" -- Make warnings shut up, TODO: fix this
    self.state_manager = StateManager("GAMEPLAY", self, true)
    self.state_manager:addState("GAMEPLAY")
    self.state_manager:addState("FADING")
    self.state_manager:addState("MENU")

    self.map = Map(self)

    self.width = self.map.width * self.map.tile_width
    self.height = self.map.height * self.map.tile_height

    self:moveCamera((x or 0), (y or 0))
    self.off_x, self.off_y = offx or 128, offy or 64

    self.player = nil
    self.soul = nil

    self.battle_borders = {}

    self.transition_fade = 0

    self.in_battle = false
    self.in_battle_area = false
    self.battle_alpha = 0

    self.bullets = {}
    self.followers = {}

    self.cutscene = nil

    self.controller_parent = Object()
    self.controller_parent.layer = WORLD_LAYERS["bottom"] - 1
    self.controller_parent.persistent = true
    self.controller_parent.world = self
    self:addChild(self.controller_parent)

    self.fader = Jam26DDelta_KikkyFader()
    self.fader.layer = WORLD_LAYERS["above_ui"]
    self.fader.persistent = true
    self:addChild(self.fader)

    self.timer = Timer()
    self.timer.persistent = true
    self:addChild(self.timer)

    self.can_open_menu = true

    self.menu = nil

    self.debug_select = false

    self.calls = {}

    self.door_delay = 0

    if map then
        self:loadMap(map)
    end

	self.rafting = false
	self.targets_can_update_cam = true
	self.swapping_grid = false
	self.grayregion = nil
	self.chromstrength = 0.25
	self.crt_glitch = 0
	self.crt_glitchstrength = 0
	self.crttimer = 0
	self.crtshader = Assets.getShader("crt_ch3")
	self.font = Assets.getFont("8bit")
	self.nochange = false
	self.screencolor = COLORS.black
	self.newcolor = COLORS.black
	self.screenalpha = 0.5
	self.colorchange = 0
	self.colorchangetime = 5
	self.doomed = false
	self.gameplay_active = false
end

--- Heals a member of the party
---@param target    string|PartyMember  The party member to heal
---@param amount    number              The amount of HP to restore
---@param text?     string              An optional text to display when HP is resotred in the Light World, before the HP restoration message
function Jam26DDelta_KikkyWorld:heal(target, amount, text)
    return
end

--- Hurts the party member `battler` by `amount`, or hurts the whole party for `amount`
---@overload fun(self: World, amount: number)
---@param battler   Character|string    The Character to hurt
---@param amount    number              The amount of damage to deal
---@return boolean  killed  Whether all targetted characters were knocked out by this damage
function Jam26DDelta_KikkyWorld:hurtParty(battler, amount)
    return false
end

--- Changes the state of the world
---@param state string
function Jam26DDelta_KikkyWorld:setState(state)
    self.state_manager:setState(state)
end

--- Opens the main overworld menu
---@param menu?     LightMenu|DarkMenu  An optional menu instance to open
---@param layer?    number  The layer to create the menu on (defaults to `WORLD_LAYERS["ui"]` or `600`)
---@return (DarkMenu|LightMenu)?
function Jam26DDelta_KikkyWorld:openMenu(menu, layer)
	return
end

--- Creates the main overworld menu if it does not exist \
--- *The [event](lua://KRISTAL_EVENT) `createMenu` is called by this function, which can return a custom menu to use instead of the default Light/Dark menu*
---@return LightMenu|DarkMenu
function Jam26DDelta_KikkyWorld:createMenu()
    return nil
end

--- Closes the menu
function Jam26DDelta_KikkyWorld:closeMenu()
    return
end

--- Runs whenever the menu is closed
function Jam26DDelta_KikkyWorld:afterMenuClosed()
    return
end

--- Sets the value of a cell flag (a special flag which normally starts at -1 and increments by 1 at the start of every call, named after the call cutscene)
---@param name  string  The name of the flag to set
---@param value integer The value to set the flag to
function Jam26DDelta_KikkyWorld:setCellFlag(name, value)
    return
end

--- Gets the value of a cell flag (a special flag which normally starts at -1 and increments by 1 at the start of every call, named after the call cutscene)
---@param name      string
---@param default?  integer
---@return integer
function Jam26DDelta_KikkyWorld:getCellFlag(name, default)
    return
end

--- Registers a phone call in the Light World CELL menu
---@param name  string          The name of the call as it will show in the CELL menu
---@param scene string          The cutscene to play when the call is selected
function Jam26DDelta_KikkyWorld:registerCall(name, scene)
    return
end

--- Replaces a phone call in the Light World CELL menu with another
---@param name  string          The name of the call as it will show in the CELL menu
---@param index integer         The index of the call to replace
---@param scene string          The cutscene to play when the call is selected
function Jam26DDelta_KikkyWorld:replaceCall(name, index, scene)
    return
end

--- Shows party member health bars
function Jam26DDelta_KikkyWorld:showHealthBars()
    return
end

--- Hides party member health bars
function Jam26DDelta_KikkyWorld:hideHealthBars()
    return
end

--- Called whenever the state of the world changes
---@param old string
---@param new string
function Jam26DDelta_KikkyWorld:onStateChange(old, new)
end

---@param key string
function Jam26DDelta_KikkyWorld:onKeyPressed(key)
end

--- Checks whether there is currently a textbox open
---@return boolean
function Jam26DDelta_KikkyWorld:isTextboxOpen()
    return (self:hasCutscene() and self.cutscene.textbox and self.cutscene.textbox.stage ~= nil) or 
	(Game.world:hasCutscene() and Game.world.cutscene.textbox and Game.world.cutscene.textbox.stage ~= nil)
end

--- Gets the collision map for the world
---@param enemy_check?  boolean     Whether to include the enemy collision map (defaults to `false`)
---@return Collider[]
function Jam26DDelta_KikkyWorld:getCollision(enemy_check)
    local col = {}
    for _,collider in ipairs(self.map.collision) do
        table.insert(col, collider)
    end
    if enemy_check then
        for _,collider in ipairs(self.map.enemy_collision) do
            table.insert(col, collider)
        end
    end
    for _,child in ipairs(self.children) do
        if child.solid_collider and child.solid then
            table.insert(col, child.solid_collider)
        elseif child.collider and child.solid then
            table.insert(col, child.collider)
        end
    end
    return col
end

--- Checks whether the input `collider` is colliding with anything in the world
---@param collider      Collider    The collider to check collision for
---@param enemy_check?  boolean     Whether to include the enemy collision map in the check
---@return boolean  collided    Whether a collision was found
---@return Object?  with        The object that was collided with
function Jam26DDelta_KikkyWorld:checkCollision(collider, enemy_check)
    Object.startCache()
    for _,other in ipairs(self:getCollision(enemy_check)) do
        if collider:collidesWith(other) and collider ~= other then
            Object.endCache()
            return true, other.parent
        end
    end
    Object.endCache()
    return false
end

--- Checks whether the input `collider` is colliding with anything in the world
---@param collider      Collider    The collider to check collision for
---@param enemy_check?  boolean     Whether to include the enemy collision map in the check
---@return boolean  collided    Whether a collision was found
---@return Object?  with        The object that was collided with
function Jam26DDelta_KikkyWorld:checkCameraBlockerCollision(collider)
    Object.startCache()
    for _,other in ipairs(self.map.camera_blocker_area) do
        if collider:collidesWith(other) and collider ~= other then
            Object.endCache()
            return true, other.parent
        end
    end
    Object.endCache()
    return false
end

--- Whether the world has a currently active cutscene
---@return boolean?
function Jam26DDelta_KikkyWorld:hasCutscene()
    return self.cutscene and not self.cutscene.ended
end

--- Starts a cutscene in the world
---@overload fun(self: World, id: string, ...)
---@param group string  The name of the group the cutscene is a part of
---@param id    string  The id of the cutscene 
---@param ...   any     Additional arguments that will be passed to the cutscene function
---@return WorldCutscene?   The cutscene object that was created
function Jam26DDelta_KikkyWorld:startCutscene(group, id, ...)
    if self.cutscene and not self.cutscene.ended then
        local cutscene_name = ""
        if type(group) == "string" then
            cutscene_name = group
            if type(id) == "string" then
                cutscene_name = group.."."..id
            end
        elseif type(group) == "function" then
            cutscene_name = "<function>"
        end
        error("Attempt to start a cutscene "..cutscene_name.." while already in cutscene "..self.cutscene.id)
    end
    if Kristal.Console.is_open then
        Kristal.Console:close()
    end
    self.cutscene = WorldCutscene(self, group, id, ...)
    return self.cutscene
end

--- Stops the current cutscene \
--- An error will be thrown when trying to stop a cutscene if none are active
function Jam26DDelta_KikkyWorld:stopCutscene()
    if not self.cutscene then
        error("Attempt to stop a cutscene while none are active.")
    end
    self.cutscene:onEnd()
    coroutine.yield(self.cutscene)
    self.cutscene = nil
end

--- Shows a textbox with the input `text`
---@param text      string|string[]
---@param after?    fun(cutscene: WorldCutscene)    A callback to run when the textbox is closed, receiving the cutscene instance used to display the text
function Jam26DDelta_KikkyWorld:showText(text, after)
    if type(text) ~= "table" then
        text = {text}
    end
    self:startCutscene(function(cutscene)
        for _,line in ipairs(text) do
            cutscene:text(line)
        end
        if after then
            after(cutscene)
        end
    end)
end

--- Spawns the player into the world
---@overload fun(self: World, x: number, y: number, chara: string|Actor, party?: string)
---@overload fun(self: World, marker: string, chara: string|Actor, party?: string)
---@param ... unknown   Arguments detailing how the player spawns
---|"x, y, chara"   # The co-ordinates of the player spawn and the Actor (instance or id) to use for the player
---|"marker, chara" # The marker name to spawn the player at and the Actor (instance or id) to use for the player
---@param party? string The party member ID associated with the player

function Jam26DDelta_KikkyWorld:spawnPlayer(...)
    local args = {...}
    local x, y = 0, 0
    local chara = "jam26ddelta_kikky"
    local party

    if type(chara) == "string" then
        chara = Registry.createActor(chara)
    end

    local facing = "down"

    if #args > 0 then
        if type(args[1]) == "number" then
            x, y = args[1], args[2]
            chara = args[3] or chara
            party = args[4]
        elseif type(args[1]) == "string" then
            x, y = self.map:getMarker(args[1])
            chara = args[2] or chara
            party = args[3]
        end
    end


    if self.player then
        facing = self.player.facing
        self:removeChild(self.player)
    end

    self.player = Jam26DDelta_KikkyPlayer(chara, x, y)
    self.player.world = self
    self.player.layer = self.map.object_layer
    self.player:setFacing(facing)
    self:addChild(self.player)
end

function Jam26DDelta_KikkyWorld:spawnFollower(...)
    return nil
end

--- Gets the `Character` in the world of a party member
---@param party string|PartyMember  The party member to get the character for
---@return Character?
function Jam26DDelta_KikkyWorld:getPartyCharacter(party)
    return nil
end

--- Gets the `Follower` or `Player` of a character currently in the party
---@param party string|PartyMember  The party member to get the character for
---@return Player|Follower?
function Jam26DDelta_KikkyWorld:getPartyCharacterInParty(party)
    return nil
end

--- Removes a follower
---@param chara string|Follower The `Follower` or the follower's actor id to remove
---@return Follower follower The follower that was removed
function Jam26DDelta_KikkyWorld:removeFollower(chara)
    return nil
end


--- Spawns characters in the world for the current party
---@param marker?   string|{x: number, y: number}                               The marker or co-ordinates to spawn the player at
---@param party?    (PartyMember|string)[]                                      A table of party members to spawn (Defaults to [`Game.party`](lua://Game.party))    
---@param extra?    (Follower|Actor|string|[Follower|Actor|string,integer])[]   Additional followers to add that are not in the party (defaults to [`Game.temp_followers`](lua://Game.temp_followers))
---@param facing?   "up"|"down"|"left"|"right"                                  The direction the party should be facing when they spawn
function Jam26DDelta_KikkyWorld:spawnParty(marker, party, extra, facing)
    if type(marker) == "table" then
        self:spawnPlayer(marker[1], marker[2], "jam26ddelta_kikky")
    else
        self:spawnPlayer(marker or "spawn", "jam26ddelta_kikky")
    end
end

--- Spawns a new `WorldBullet` to the world
---@overload fun(self: World, bullet: WorldBullet)
---@param bullet?   string  The bullet to add to the world, if left unspecified, spawns the basic `WorldBullet`
---@param ...       any     Additional arguments to pass to the bullet's init() function
---@return WorldBullet bullet The newly created bullet
function Jam26DDelta_KikkyWorld:spawnBullet(bullet, ...)
    ---@diagnostic disable param-type-mismatch
    local new_bullet
    if isClass(bullet) and bullet:includes(WorldBullet) then
        new_bullet = bullet
    elseif Registry.getWorldBullet(bullet) then
        new_bullet = Registry.createWorldBullet(bullet, ...)
    else
        local x, y = ...
        table.remove(arg, 1)
        table.remove(arg, 1)
        new_bullet = WorldBullet(x, y, bullet, unpack(arg))
    end
    new_bullet.layer = WORLD_LAYERS["bullets"]
    new_bullet.world = self
    table.insert(self.bullets, new_bullet)
    if not new_bullet.parent then
        self:addChild(new_bullet)
    end
    return new_bullet
    ---@diagnostic enable param-type-mismatch
end

--- Spawns a new NPC object in the world
---@param actor         string|Actor    The actor to use for the new NPC, either an id string or an actor object
---@param x             number          The x-coordinate to place the NPC at
---@param y             number          The y-coordinate to place the NPC at
---@param properties?   table           A table of additional properties for the new NPC. Supports all the same values as an `npc` map event
---@return NPC npc The newly created npc.
function Jam26DDelta_KikkyWorld:spawnNPC(actor, x, y, properties)
    return self:spawnObject(NPC(actor, x, y, properties))
end

--- Spawns an object to the world
---@param obj Object            The object to add to the world
---@param layer? string|number  The layer to place the object on
---@return Object
function Jam26DDelta_KikkyWorld:spawnObject(obj, layer)
    obj.layer = self:parseLayer(layer)
    self:addChild(obj)
    return obj
end

--- Gets a specific character currently present in the world
---@param id        string  The actor id of the character to search for
---@param index?    number  The character's index, if they have multiple instances in the world. (Defaults to `1`)
---@return Character|nil chara The character instance, or `nil` if it was not found
function Jam26DDelta_KikkyWorld:getCharacter(id, index)
    local party_member = Game:getPartyMember(id)
    local i = 0
    for _,chara in ipairs(Game.stage:getObjects(Character)) do
        if chara.actor.id == id or (party_member and chara.party and chara.party == party_member.id) then
            i = i + 1
            if not index or index == i then
                return chara
            end
        end
    end
end

--- Gets the action box instance for a member of the party
---@param party_member string|PartyMember
---@return OverworldActionBox?
function Jam26DDelta_KikkyWorld:getActionBox(party_member)
    return nil
end

--- Creates a reaction text on a party member's healthbar (usually used for equipment and items)
---@param party_member  string|PartyMember  The party member who will react
---@param text          string              The text to display for the reaction
---@param display_time? number              The display time, in seconds, of the reaction (defaults to 5/3 seconds)
function Jam26DDelta_KikkyWorld:partyReact(party_member, text, display_time)
    return
end

--- Gets a specific event present in the current map
---@param id string|number  The unique numerical id of an event OR the text id of an event type to get the first instance of
---@return Event event The event instnace, or `nil` if it was not found
function Jam26DDelta_KikkyWorld:getEvent(id)
    return self.map:getEvent(id)
end

--- Gets a list of all instances of one type of event in the current maps
---@param name? string The text id of the event to search for, fetches every event if `nil`
---@return Event[] events A table containing every instance of the event in the current map
function Jam26DDelta_KikkyWorld:getEvents(name)
    return self.map:getEvents(name)
end

--- Disables following for all of the player's current followers
function Jam26DDelta_KikkyWorld:detachFollowers()
    return
end

--- Enables following for all of the player's current followers and causes them to walk to their positions
---@param return_speed? number The walking speed of the followers while they return to the player
function Jam26DDelta_KikkyWorld:attachFollowers(return_speed)
    return
end
--- Enables following for all of the player's current followers, and immediately teleports them to their positions
function Jam26DDelta_KikkyWorld:attachFollowersImmediate()
    return
end

--- Parses a variable-type layer specification into a recognised layer
---@param layer?    number|string
---@return number
function Jam26DDelta_KikkyWorld:parseLayer(layer)
    return (type(layer) == "number" and layer)
            or WORLD_LAYERS[layer]
            or self.map.layers[layer]
            or self.map.object_layer
end

--- Sets up several variables for a new map
---@param map? Map|string|table The Map object, name, or data to load
---@param ... unknown           Additional arguments that will be passed forward into Map:onEnter()
function Jam26DDelta_KikkyWorld:setupMap(map, ...)
    for _,child in ipairs(self.children) do
        if not child.persistent then
            self:removeChild(child)
        end
    end
    for _,child in ipairs(self.controller_parent.children) do
        if not child.persistent then
            self.controller_parent:removeChild(child)
        end
    end

    self:updateChildList()

    self.healthbar = nil
    self.followers = {}

    if isClass(map) then
        self.map = map
    elseif type(map) == "string" then
        self.map = Registry.createMap(map, self, ...)
    elseif type(map) == "table" then
        self.map = Map(self, map, ...)
    else
        self.map = Map(self, nil, ...)
    end

    self.map:load()

    local dark_transitioned = self.map.light ~= Game:isLight()

    Game:setLight(self.map.light)

    self.width = self.map.width * self.map.tile_width
    self.height = self.map.height * self.map.tile_height

    self.battle_fader = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.battle_fader:setParallax(0, 0)
    self.battle_fader:setColor(0, 0, 0)
    self.battle_fader.alpha = 0
    self.battle_fader.layer = self.map.battle_fader_layer
    self.battle_fader.debug_select = false
    self:addChild(self.battle_fader)

    self.in_battle = false
    self.in_battle_area = false
    self.battle_alpha = 0
end

--- Loads into a new map file.
---@overload fun(self: World, map: string, x: number, y: number, facing?: string, callback?: string, ...: any)
---@overload fun(self: World, map: string, marker?: string, facing?: string, callback?: string, ...: any)
---@param map       string      The name of the map file to load
---@param x         number      The x-coordinate the player will spawn at in the new map
---@param y         number      The y-coordinate the player will spawn at in the new map
---@param marker?   string      The name of the marker the player will spawn at in the new map (Defaults to `"spawn"`)
---@param facing?   string      The direction the party should be facing when they spawn in the new map
---@param callback? fun()       A callback to run once the map has finished loading (Post Map:onEnter())
---@param ... unknown           Additional arguments that will be passed forward into Map:onEnter()
function Jam26DDelta_KikkyWorld:loadMap(...)
    local args = {...}
    -- x, y, facing, callback
    local map = table.remove(args, 1)
    local marker, x, y, facing, callback
    if type(args[1]) == "string" then
        marker = table.remove(args, 1)
    elseif type(args[1]) == "number" then
        x = table.remove(args, 1)
        y = table.remove(args, 1)
    else
        marker = "spawn"
    end
    if args[1] then
        facing = table.remove(args, 1)
    end
    if args[1] then
        callback = table.remove(args, 1)
    end

    if self.map then
        self.map:onExit()
    end

    self:setupMap(map, unpack(args))

    if self.map.markers["spawn"] then
        local spawn = self.map.markers["spawn"]
    end

    if marker then
        self:spawnParty(marker, nil, nil, facing)
    else
        self:spawnParty({x, y}, nil, nil, facing)
    end

    self:setState("GAMEPLAY")

    for _,event in ipairs(self.map.events) do
        if event.postLoad then
            event:postLoad()
        end
    end

    self.map:onEnter()

    if callback then
        callback(self.map)
    end
end

--- Transitions the music from the current track to the `next`
---@overload fun(self: World, music: string)
---@param music     string                                              The name of the file to play next
---@param next      {music?: string, volume?: number, pitch?: number}   The filename, volume, and pitch of the next track
---@param fade_out? boolean                                             Whether to fade out the currently playing track before playing the next track
function Jam26DDelta_KikkyWorld:transitionMusic(next, fade_out)
    Game.world:transitionMusic(next, fade_out)
end

--[[
    Possible argument formats:
        - Target table
            e.g. ({map = "mapid", marker = "markerid", facing = "down"})
        - Map id, [ spawn X, spawn Y, [facing] ]
            e.g. ("mapid")
                 ("mapid", 20, 5)
                 ("mapid", 30, 40, "down")
        - Map id, [ marker, [facing] ]
            e.g. ("mapid", "markerid")
                 ("mapid", "markerid", "up")
]]
local function parseTransitionTargetArgs(...)
    local args = {...}
    if #args == 0 then return {} end
    if type(args[1]) ~= "table" or isClass(args[1]) then
        local target = {map = args[1]}
        if type(args[2]) == "number" and type(args[3]) == "number" then
            target.x = args[2]
            target.y = args[3]
            if type(args[4]) == "string" then
                target.facing = args[4]
            end
        elseif type(args[2]) == "string" then
            target.marker = args[2]
            if type(args[3]) == "string" then
                target.facing = args[3]
            end
        end
        return target
    else
        return args[1]
    end
end

--- Transitions from the world into a shop
---@param shop      string|Shop The shop to enter
---@param options?  table       An optional table of [`leave_options`](lua://Shop.leave_options) for exiting the shop
function Jam26DDelta_KikkyWorld:shopTransition(shop, options)
    self:fadeInto(function()
        Game:enterShop(shop, options)
    end)
end

--- Loads a new map and starts the transition effects for world music, borders, and the screen as a whole
---@overload fun(self: World, map: string, ...: any)
---@param ... any   Additional arguments that will be passed into Jam26DDelta_KikkyWorld:loadMap()
---@see World - Jam26DDelta_KikkyWorld:loadMap() 
function Jam26DDelta_KikkyWorld:mapTransition(...)
    local args = {...}
    local map = args[1]
    if type(map) == "string" then
        local map = Registry.createMap(map)
        if not map.keep_music then
            self:transitionMusic(Kristal.callEvent(KRISTAL_EVENT.onMapMusic, self.map, self.map.music) or map.music, true)
        end
        local dark_transition = map.light ~= Game:isLight()
        local map_border = map:getBorder(dark_transition)
        if map_border then
            Game:setBorder(Kristal.callEvent(KRISTAL_EVENT.onMapBorder, self.map, map_border) or map_border, 1)
        end
    end
    self:fadeInto(function()
        self:loadMap(Utils.unpack(args))
    end)
end

--- Fades the world out and into another piece of content
---@param callback fun()    The callback that is run in the middle of the fade (fully faded out) to load the next piece of content
function Jam26DDelta_KikkyWorld:fadeInto(callback)
    self:setState("FADING")
    Game.fader:transition(callback)
end

--- Gets the object that the camera is currently targetting
---@return Object|nil
function Jam26DDelta_KikkyWorld:getCameraTarget()
    if self.camera.target and self.camera.target.stage then
        return self.camera.target
    else
        return self.player
    end
end

--- Sets the object the camera should target
---@param target Object?
function Jam26DDelta_KikkyWorld:setCameraTarget(target)
    self.camera.target = target
end

--- Sets whether the camera should be attached to its target for each axis
---@param attached_x? boolean   Whether the camera's x-axis position should follow its target
---@param attached_y? boolean   Whether the camera's y-axis position should follow its target
function Jam26DDelta_KikkyWorld:setCameraAttached(attached_x, attached_y)
    self.camera:setAttached(attached_x, attached_y)
end

--- Sets whether the camera should follow its target on the x-axis
---@param attached? boolean
function Jam26DDelta_KikkyWorld:setCameraAttachedX(attached) self:setCameraAttached(attached, self.camera.attached_x) end
--- Sets whether the camera should follow its target on the y-axis
---@param attached? boolean
function Jam26DDelta_KikkyWorld:setCameraAttachedY(attached) self:setCameraAttached(self.camera.attached_y, attached) end

---@param x? number
---@param y? number
---@param friction? number
function Jam26DDelta_KikkyWorld:shakeCamera(x, y, friction)
    self.camera:shake(x, y, friction)
end

function Jam26DDelta_KikkyWorld:sortChildren()
    Object.startCache()
    local positions = {}
    for _,child in ipairs(self.children) do
        local x, y = child:getSortPosition()
        positions[child] = {x = x, y = y}
    end
    table.stable_sort(self.children, function(a, b)
        local a_pos, b_pos = positions[a], positions[b]
        local ax, ay = a_pos.x, a_pos.y
        local bx, by = b_pos.x, b_pos.y
        -- Sort children by Y position, or by follower index if it's a follower/player (so the player is always on top)
        return a.layer < b.layer or
              (a.layer == b.layer and (math.floor(ay) < math.floor(by) or
              (math.floor(ay) == math.floor(by) and (b == self.player or
              (a:includes(Follower) and b:includes(Follower) and b.index < a.index)))))
    end)
    Object.endCache()
end

---@param parent Object
function Jam26DDelta_KikkyWorld:onRemove(parent)
    super.onRemove(self, parent)
    Game.world.kikky_world = nil
end

--- Sets whether the player is currently in battle - cannot override being inside a battle area
---@param value boolean
function Jam26DDelta_KikkyWorld:setBattle(value)
    self.in_battle = value
end

--- Whether the player is currently in a world battle
---@return boolean
function Jam26DDelta_KikkyWorld:inBattle()
    return self.in_battle or self.in_battle_area
end

function Jam26DDelta_KikkyWorld:update()
	if self.type == 1 then
		if not self.nochange then
			if self.colorchange > 0 then
				self.screencolor = ColorUtils.mergeColor(self.newcolor, self.screencolor, self.colorchange / self.colorchangetime)
				self.colorchange = self.colorchange - DTMULT
			end
		end
		for _,chara in ipairs(Game.stage:getObjects(Character)) do
			local hfx = chara:getFX("highlight")
			if hfx then
				hfx.alpha = self.screenalpha
				hfx.color = self.screencolor
			end
		end
	end
    if self.state == "GAMEPLAY" then
        -- Object collision
        local collided = {}
        local exited = {}
        Object.startCache()
        for _,obj in ipairs(self.children) do
            if not obj.solid and (obj.onCollide or obj.onEnter or obj.onExit) then
                for _,char in ipairs(self.stage:getObjects(Character)) do
                    if obj:collidesWith(char) then
                        if not obj:includes(OverworldSoul) then
                            table.insert(collided, {obj, char})
                        end
                    elseif obj.current_colliding and obj.current_colliding[char] then
                        table.insert(exited, {obj, char})
                    end
                end
            end
        end
        Object.endCache()
        for _,v in ipairs(collided) do
            if v[1].onCollide then
                v[1]:onCollide(v[2], DT)
            end
            if not v[1].current_colliding then
                v[1].current_colliding = {}
            end
            if not v[1].current_colliding[v[2]] then
                if v[1].onEnter then
                    v[1]:onEnter(v[2])
                end
                v[1].current_colliding[v[2]] = true
            end
        end
        for _,v in ipairs(exited) do
            if v[1].onExit then
                v[1]:onExit(v[2])
            end
            v[1].current_colliding[v[2]] = nil
        end
    end

    if self:inBattle() then
        self.battle_alpha = math.min(self.battle_alpha + (0.08 * DTMULT), 1)
    else
        self.battle_alpha = math.max(self.battle_alpha - (0.08 * DTMULT), 0)
    end

    local half_alpha = self.battle_alpha * 0.52

    for _,v in ipairs(self.followers) do
        v.sprite:setColor(1 - half_alpha, 1 - half_alpha, 1 - half_alpha, 1)
    end

    for _,battle_border in ipairs(self.map.battle_borders) do
        battle_border.alpha = self.battle_alpha
    end
    if self.battle_fader then
        self.battle_fader:setColor(0, 0, 0, half_alpha)
    end

    if (self.door_delay > 0) then
        self.door_delay = math.max(self.door_delay - DT, 0)
    end
    self.map:update()

    -- Always sort
    self.update_child_list = true
    super.update(self)

    -- Update cutscene after updating objects
    if self.cutscene then
        if not self.cutscene.ended then
            self.cutscene:update()
            if self.stage == nil then
                return
            end
        else
            self.cutscene = nil
        end
    end
    if self.player then
        self:cameraUpdate()
    end
end

function Jam26DDelta_KikkyWorld:fullDraw(...)
    self.main_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    super.fullDraw(self)
    Draw.popCanvas(true)
    Draw.setColor(1, 1, 1)
end

function Jam26DDelta_KikkyWorld:draw()
    -- Draw background
    Draw.setColor(self.map.bg_color or {0, 0, 0, 0})
    love.graphics.rectangle("fill", 0, 0, self.map.width * self.map.tile_width, self.map.height * self.map.tile_height)
    Draw.setColor(1, 1, 1)

    super.draw(self)

    self.map:draw()
	
    if DEBUG_RENDER then
        for _,collision in ipairs(self.map.collision) do
            collision:draw(0, 0, 1, 0.5)
        end
        for _,collision in ipairs(self.map.enemy_collision) do
            collision:draw(0, 1, 1, 0.5)
        end
    end
end

function Jam26DDelta_KikkyWorld:cameraUpdate() -- this whole thing scares me
	local target = self.player
	if self.targets_can_update_cam then
		target = self:getCameraTarget()
	end
    if target then
        local px = target.x
        local py = target.y
        local grid_w = self.game_width * 2
        local grid_h = self.game_height

        local xa = math.floor((px + 15) / grid_w) * grid_w + self.game_width / 2
        local ya = math.floor((py + 8) / grid_h) * grid_h + self.game_height - 80

        local xb = math.floor((px - 15) / grid_w) * grid_w + self.game_width / 2
        local yb = math.floor((py - 24) / grid_h) * grid_h + self.game_height - 80
        
        local x1,y1,x2,y2 = self:getAreaBounds()

        if not self.swapping_grid and not Game.lock_movement then
            local x = math.floor(px / grid_w) * grid_w + self.game_width / 2
            local y = math.floor(py / grid_h) * grid_h + self.game_height - 80
            if px < x1 then
                self:shiftGrid("left")
            elseif px > x2 then
                self:shiftGrid("right")
            elseif py < y1 then
                self:shiftGrid("up")
            elseif py > y2 then
                self:shiftGrid("down")
            end
            --self.swapping_grid = true
            --Game.lock_movement = true
        end
    end
end

---@param direction facing
function Jam26DDelta_KikkyWorld:shiftGrid(direction, after)
    Game.lock_movement = true
    local x, y = self.area_column, self.area_row
    if direction == "up" then
        y = y - 1
    elseif direction == "down" then
        y = y + 1
    elseif direction == "right" then
        x = x + 1
    elseif direction == "left" then
        x = x - 1
    end
    local cx, cy = self:getAreaCenter(x, y)
	local xx, yy = self:getAreaPosition(x, y)
	local c, r = self:getArea(xx, yy)
	local x1, y1, x2, y2 = self:getAreaBounds(c,r)
    if direction == "up" then
		self.timer:tween(0.5, self:getCameraTarget(), {y = y2})
    elseif direction == "down" then
		self.timer:tween(0.5, self:getCameraTarget(), {y = y1})
    elseif direction == "right" then
		self.timer:tween(0.5, self:getCameraTarget(), {x = x1})
    elseif direction == "left" then
		self.timer:tween(0.5, self:getCameraTarget(), {x = x2})
    end
	self.future_area_column, self.future_area_row = x, y
	self.swapping_grid = true
	self.camera:panTo(cx, cy, 0.5, "linear", function ()
        if after and after(self) then return end
        Game.lock_movement = false
		self.swapping_grid = false
		self.player.cambuff = 2
        self.area_column, self.area_row = x, y
        if direction == "up" then
            self:snapPlayer("bottom", self:getAreaPosition(x, y))
        elseif direction == "down" then
            self:snapPlayer("top", self:getAreaPosition(x, y))
        elseif direction == "right" then
            self:snapPlayer("left", self:getAreaPosition(x, y))
        elseif direction == "left" then
            self:snapPlayer("right", self:getAreaPosition(x, y))
        end
    end)
end

function Jam26DDelta_KikkyWorld:swap_grid(x, y)
    local cx, cy = self:getArea(x, y)
    self:moveCamera(cx, cy)
end

---@param x integer
---@param y integer
function Jam26DDelta_KikkyWorld:moveCamera(x, y) --Faking the camera again
    local cam_x = (x + 0.5) * self.game_width
    local cam_y = (y + 0.5) * self.game_height
    self.camera.x = cam_x
    self.camera.y = cam_y
    self.area_column, self.area_row = x, y
	self.future_area_column, self.future_area_row = x, y
end

---@param x integer
---@param y integer
---@return number, number
function Jam26DDelta_KikkyWorld:getAreaCenter(x,y)
    return (x + 0.5) * self.game_width,
           (y + 0.5) * self.game_height
end

function Jam26DDelta_KikkyWorld:getArea(x, y)
    local w = self.game_width
    local h = self.game_height

    local col = math.floor(x / w)
    local row = math.floor(y / h)
    return col, row
end

function Jam26DDelta_KikkyWorld:snapPlayer(dir, x, y)
    local c, r = self:getArea(x, y)
    local x1, y1, x2, y2 = self:getAreaBounds(c,r)
	local target = self.player
	if self.targets_can_update_cam then
		target = self:getCameraTarget()
	end
    if dir == "left" then
        target.x = x1
    elseif dir == "right" then
        target.x = x2
    elseif dir == "top" then
        target.y = y1
    elseif dir == "bottom" then
        target.y = y2
    end

    for _, i in ipairs(self.followers) do
        i.history = {}
        i.physics.move_path = nil
        i.pathing = false
        i.x = self.player.x
        i.y = self.player.y
    end
end

---@param x integer Row of area to get bounds of
---@param y integer Column of area to get bounds of
---@return number, number, number, number
---@overload fun(self:self): number, number, number, number
function Jam26DDelta_KikkyWorld:getAreaBounds(x, y)
    if not x then
        x, y = self.area_column, self.area_row
    end
    local x1, y1 = self:getAreaPosition(x, y)
    local x2, y2 = self:getAreaPosition(x + 1, y + 1)
    local px = 8
    x1, y1 = x1 + 16, y1 + 32
    x2, y2 = x2 - 16, y2 - 0
    return x1,y1,x2,y2
end

---@param x integer Row of area to get bounds of
---@param y integer Column of area to get bounds of
---@return number, number
function Jam26DDelta_KikkyWorld:getAreaPosition(x, y)
    if not x then
        x, y = self.area_column, self.area_row
    end
    assert(x == math.floor(x), "Non-integer x value passed: "..x)
    assert(y == math.floor(y), "Non-integer y value passed: "..y)
    return x * self.game_width, y * self.game_height
end

function Jam26DDelta_KikkyWorld:canDeepCopy()
    return false
end

function Jam26DDelta_KikkyWorld:drawMask()
    love.graphics.origin()
    love.graphics.rectangle("fill",self.x,self.y,self.screen_width,self.screen_height)
end

--- Returns the nearest valid pathfinding node, based on the map's `node_size`.
--- 
--- `x` and `y` must be relative to this World.
--- @param x number X position, relative to world
--- @param y number Y position, relative to world
--- @return table<number> node_pos 2D Vector of node pos. Nil if no valid nodes are within a 1 node radius of this position.
function Jam26DDelta_KikkyWorld:getNearestNode(x, y)
    local node_size = self:getPathfinderNodeSize()

    return { Utils.round(x/node_size), Utils.round(y/node_size) }
end

--- Returns the nearest valid pathfinding node, based on the map's `node_size`.
--- 
--- `x` and `y` must be relative to this World.
--- @param x number X position, relative to world
--- @param y number Y position, relative to world
--- @param collider Collider|nil Hitbox to check collision with.
--- @param range number A range of nodes to search within. Defaults to 1.
--- @return table<number>|nil node_pos 2D Vector of node pos. Nil if no valid nodes are within a 1 node radius of this position.
function Jam26DDelta_KikkyWorld:getNearestValidNode(x, y, collider, range)
    local node = self:getNearestNode(x, y)

    if (self:nodeIsValid(node[1], node[2], collider)) then
        return node
    elseif (collider and collider) then
        local current = nil
        local score = 999
        local get_score = function (score_x, score_y) return math.abs(score_x) + math.abs(score_y) end
        for off_x = -range, range, 1 do
            for off_y = -range, range, 1 do
                if (not (off_x == 0 and  off_y == 0)) then
                    local new_node = { node[1] + off_x, node[2] + off_y }
                    local valid = self:nodeIsValid(new_node[1], new_node[2], collider)
                    local new_score = get_score(off_x, off_y)
                    if (valid and (new_score < score)) then
                        current = new_node
                        score = new_score
                        if (score == 1) then return current end
                    end
                end
            end
        end
        return current
    end

    -- for off_x = -1, 1, 1 do
    --         for off_y = -1, 1, 1 do
    --             if (not (off_x == 0 and  off_y == 0) and math.abs(off_x) ~= math.abs(off_y)) then
    --                 local new_node = { node[1] + off_x, node[2] + off_y }
    --                 local valid = self:nodeIsValid(new_node[1], new_node[2], ref_collider)
    --                 if (valid) then
    --                     return new_node
    --                 end
    --             end
    --         end
    --     end
    
    return nil
end

---@param x number
---@param y number
---@param collider Collider
---@return number original_x
---@return number original_y
function Jam26DDelta_KikkyWorld:centerOnNode(x, y, collider)
    local world_pos = self:nodePosToWorld(x, y)

    local original_offset_x = collider.x
    local original_offset_y = collider.y
    local relative_pos_x, relative_pos_y = self:getRelativePos(world_pos[1], world_pos[2], collider.parent)
    collider.x = relative_pos_x - (original_offset_x / 2)
    collider.y = relative_pos_y - (original_offset_y / 2)
    return original_offset_x, original_offset_y
end

---@param x number
---@param y number
---@param collider Collider
function Jam26DDelta_KikkyWorld:nodeIsValid(x, y, collider)
    if (collider) then
        local og_x, og_y = self:centerOnNode(x, y, collider)
        local collided = self:checkCollision(collider, false) or not self:inBounds(self:nodePosToWorld(x, y))
        collider.x = og_x
        collider.y = og_y
        return not collided
    end
    return true
end

---@param x number
---@param y number
---@return table<number> world_pos
---@overload fun(x: table<number>): table<number>
function Jam26DDelta_KikkyWorld:nodePosToWorld(x, y)
    if (type(x) == "table") then
        y = x[2]
        x = x[1]
    end
    local node_size = self:getPathfinderNodeSize()
    return { x * node_size, y * node_size }
end

---@return number size
function Jam26DDelta_KikkyWorld:getPathfinderNodeSize()
    return self.map and self.map.pathfinder_node_size or Pathfinder:getConfig("default_node_size") or 40
end

---@overload fun(x: table<number>): boolean
function Jam26DDelta_KikkyWorld:inBounds(x, y)
    if (type(x) == "table") then
        y = x[2]
        x = x[1]
    end
    return x <= (self.map.width * self.map.tile_width) and x >= 0 and y <= (self.map.height * self.map.tile_height) and y >= 0
end

---Takes in two Node positions and finds a valid path between them. Uses the A* pathfinding algorithm.
---@param x number
---@param y number
---@param target_x number
---@param target_y number
---@param collider Collider
---@return table path
function Jam26DDelta_KikkyWorld:findPathTo(x, y, target_x, target_y, collider)

    local path = Luafinding(Vector(x, y), Vector(target_x, target_y), function (pos) return self:nodeIsValid(pos.x, pos.y, collider) end):GetPath() or {}
    if #path == 0 then Kristal.Console:log("But it was empty...") end
    local world_path = {}

    for index, value in ipairs(path) do
        local world_pos = self:nodePosToWorld(value.x, value.y)
        table.insert(world_path, world_pos)
    end

    return world_path


    -- local path = {}
    -- if (x == target_x and y == target_y) then return path end

    -- local compose = function (vec_x, vec_y)
    --     return tostring(vec_x)..","..tostring(vec_y)
    -- end

    -- local decompose = function (vecstring)
    --     local split = Utils.splitFast(vecstring, ",")
    --     return { tonumber(split[1]), tonumber(split[2]) }
    -- end

    -- local came_from = {}
    -- came_from[compose(x, y)] = compose(x, y)
    -- local frontier = PriorityQueue()
    -- frontier:put( {x, y}, 0 )
    -- local cost_so_far = {}
    -- cost_so_far[compose(x, y)] = 0

    -- local heuristic = function (current_x, current_y)
    --     return math.abs(target_x - current_x) + math.abs(target_y - current_y)
    -- end
    -- -- todo: maybe implement this if its worthwhile
    -- local movement_cost = function (node_x, node_y, next_x, next_y)
    --     --return math.abs(Utils.dist(node_x, node_y, next_x, next_y))
    -- end
    
    -- local max_nodes_searched = 100
    -- local nodes_counted = 0
    
    -- while (not frontier:empty()) and not (nodes_counted >= max_nodes_searched) do
    --     local current = frontier:popLeast()
    --     if (current[1] == target_x and current[2] == target_y) then
    --         break
    --     end
    --     local neighbors = self:getValidNeighbors(current[1], current[2], collider)
    --     if (#neighbors > 0) then
    --         for index, value in ipairs(neighbors) do
    --             local new_cost = (cost_so_far[compose(current[1], current[2])] or 1) + 1 -- movement_cost(current[1][1], current[1][2])
    --             if (not cost_so_far[compose(value[1], value[2])]) then --or new_cost < cost_so_far[compose(value[1], value[2])]) then
    --                 local priority = new_cost + heuristic(value[1], value[2])
    --                 frontier:put (value, priority)
    --                 came_from[compose(value[1], value[2])] = compose(current[1], current[2])
    --             end
    --         end
    --     end
    --     nodes_counted = nodes_counted + 1
    -- end

    -- if (not came_from[compose(target_x, target_y)]) then 
    --     Kristal.Console:log("Pathfinding failure, target not in final path...")
    --     return path
    -- end
    -- local current = {target_x, target_y}
    
    -- while ((current[1] ~= x and current[2] ~= y)) do
    --     local node = decompose(came_from[compose(current[1], current[2])])
    --     current = node
    --     table.insert(path, #path + 1, self:nodePosToWorld(node))
    -- end
    -- return Utils.reverse(path)

end


--- Returns all allowed pathfinding node neighbors.
--- 
--- `x` and `y` must be relative to this World.
--- @param x number X position, relative to world
--- @param y number Y position, relative to world
--- @return table node_positions
function Jam26DDelta_KikkyWorld:getNeighbors(x, y)
    local node = {x, y}
    local neighbors = {}

    for off_x = -1, 1, 1 do
        for off_y = -1, 1, 1 do
            if (not (off_x == 0 and  off_y == 0)) then
                local new_node = { node[1] + off_x, node[2] + off_y }
                table.insert(neighbors, new_node)
            end
        end
    end
    
    
    return neighbors
end

--- Returns all valid pathfinding node neighbors.
--- 
--- `x` and `y` must be relative to this World.
--- @param x number X position, relative to world
--- @param y number Y position, relative to world
--- @param collider Collider|nil Hitbox to check collision with.
--- @param range number A range of nodes to search within. Defaults to 1.
--- @return table node_positions
function Jam26DDelta_KikkyWorld:getValidNeighbors(x, y, collider, range)
    local node = {x, y}
    local neighbors = {}
    if not range then range = 1 end

    for off_x = -range, range, 1 do
        for off_y = -range, range, 1 do
            if (not (off_x == 0 and  off_y == 0)) then
                local new_node = { node[1] + off_x, node[2] + off_y }
                local valid = self:nodeIsValid(new_node[1], new_node[2], collider)
                if (valid) then
                    table.insert(neighbors, new_node)
                end
            end
        end
    end
    
    
    return neighbors
end

return Jam26DDelta_KikkyWorld