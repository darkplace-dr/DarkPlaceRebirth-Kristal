local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:init()
    self:loadHooks()
    self:initTaunt()
    self:initBattleTaunt()
end

function lib:onRegistered()
    ---@type table<string, CodeBlock>
    self.codeblocks = {}

    for _,path,block in Registry.iterScripts("codeblocks", true) do
        assert(block ~= nil, '"codeblocks/'..path..'.lua" does not return value')
        block.id = block.id or path
        self.codeblocks[block.id] = block
    end
end

---@generic T
---@param id CodeBlock.`T`
---@return T
function lib:createCodeblock(id, data)
    local block = self.codeblocks[id]()
    if data then
        block:load(data)
    end
    return block
end

function lib:onPause()
    if Game.tutorial then
        PauseLib.paused = false
        Assets.playSound("ui_cant_select",1.5)
    end
end

function lib:save(data)
    if not MagicalGlassLib then
        data.magical_glass = self.mg_data_preserve
    end
end

function lib:load(data)
    if not MagicalGlassLib then
        self.mg_data_preserve = data.magical_glass
    end
end

function lib:preDraw()
    Assets.getShader("palette"):send("debug",DEBUG_RENDER and ((RUNTIME/0.3)%1>.5))
end

function lib:getSoulColor()
    local date = os.date("*t")
    if date.month == 4 and date.day == 1 then
        return unpack(COLORS.green)
    end
end

function lib:postUpdate()
    self:updateTaunt()
    self:updateBattleTaunt()

    if Game.save_name == "MERG" then
        for _, party in ipairs(Game.party) do
            if party.health > 1 then
                party.health = 1
            end
            if party.stats.health ~= 1 then
                party.stats.health = 1
            end
        end
        if Game.battle then
            Game.battle:targetAll()
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                enemy.current_target = "ALL"
            end
        end
    end

    for _, badge in ipairs(Game:getBadgeStorage()) do
        badge:update(badge.equipped)
    end

end

function lib:addEventTime(time_added)
    for k,_ in pairs(Game:getFlag("PROMISES", {})) do
        Game:getFlag("PROMISES")[k] = Game:getFlag("PROMISES")[k] - time_added
    end
    self:checkPromises()
end

function lib:addPromise(promise, event_time)
    Game:getFlag("PROMISES")[promise] = event_time
end

function lib:checkPromises()
    -- Step 1: Convert to sortable array of {key, value}
    local sorted = {}
    for k, v in pairs(Game:getFlag("PROMISES")) do
        table.insert(sorted, {key = k, value = v})
    end

    -- Step 2: Sort by value (ascending)
    table.sort(sorted, function(a, b)
        return a.value < b.value
    end)

    local promises_to_fulfill = {}
    -- Step 3: Loop through sorted array
    for i, pair in ipairs(sorted) do
        if pair.value <= 0 then
            table.insert(promises_to_fulfill, pair.key)
        end
    end
    
    local nextPromise
    function nextPromise()
        local cutscene_id = table.remove(promises_to_fulfill, 1)
        if not cutscene_id then return end
        Game:getFlag("PROMISES")[cutscene_id] = nil
        local cutscene = Game.world:startCutscene("promises." .. cutscene_id)
        cutscene:after(nextPromise)
    end
    
    nextPromise()
end

function lib:rollShiny(id, force)
    if (not Game:getFlag("SHINY") or Game:getFlag("SHINY")[id] == nil) or force then
        local roller = love.math.random(1, 100)
        -- Kristal.Console:log(id .. ": " .. roller)
        if not Game:getFlag("SHINY") then
            Game:setFlag("SHINY", {})
        end
        if roller == 66 then
            Game:getFlag("SHINY")[id] = true
        else
            Game:getFlag("SHINY")[id] = false
        end
    else
        Kristal.Console:log("Tried to roll shiny for " .. id .. ", but they were already rolled.")
    end
end

function lib:forceShiny(id, what)
    Game:getFlag("SHINY")[id] = (what ~= false)
end

function lib:loadHooks()
    if MagicalGlassLib then
        Utils.hook(LightEnemyBattler, "init", function(orig, self, actor, use_overlay)
            orig(self)
            self.service_mercy = 20
        end)
        Utils.hook(LightEnemyBattler, "registerMarcyAct", function(orig, self, name, description, party, tp, highlight, icons)
            if Game:getFlag("marcy_joined") then
                self:registerShortActFor("jamm", name, description, party, tp, highlight, icons)
                self.acts[#self.acts].color = {0, 1, 1}
            end
        end)
        Utils.hook(LightEnemyBattler, "registerShortMarcyAct", function(orig, self, name, description, party, tp, highlight, icons)
            if Game:getFlag("marcy_joined") then
                self:registerActFor("jamm", name, description, party, tp, highlight, icons)
                self.acts[#self.acts].color = {0, 1, 1}
            end
        end)
        Utils.hook(LightEnemyBattler, "onService", function(orig, self, spell) end)
        Utils.hook(LightEnemyBattler, "canService", function(orig, self, spell) return true end)

        Utils.hook(LightStatMenu, "draw", function(orig, self)
            orig(self)
            love.graphics.setFont(self.font)			
            local party = Game.party[self.party_selecting]
            if Game:getFlag("SHINY", {})[party.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
                Draw.setColor({235/255, 235/255, 130/255})
                love.graphics.print("\"" .. party:getName() .. "\"", 4, 8)
            end
            Draw.setColor(COLORS.white)
        end)
    end
end


function lib:isTauntingAvaliable()
    if self.let_me_taunt then return true end
    if Game:isSpecialMode("PEPPINO") then return true end

    for _,party in ipairs(Game.party) do
        if party:checkArmor("pizza_toque") then return true end
    end

    return false
end

--Overworld taunt
function lib:initTaunt()
    self.taunt_lock_movement = false
    --[[
    Utils.hook(Actor, "init", function(orig, self)
        orig(self)
        self.taunt_sprites = {}
    end)
    --]]
    Utils.hook(Player, "isMovementEnabled",
        ---@overload fun(orig:function, self:Player) : boolean
        function(orig, self)
            return not self.taunt_lock_movement and orig(self)
        end
    )

end

function lib:updateTaunt()
    if not (OVERLAY_OPEN or TextInput.active)
        and self:isTauntingAvaliable()
        and Input.pressed("taunt", false)
        and not self.taunt_lock_movement
        and (Game.state == "OVERWORLD" and Game.world.state == "GAMEPLAY"
            and not Game.world:hasCutscene() and not Game.lock_movement)
    then
        -- awesome workaround for run_anims
        Game.world.player:setState("WALK")
        Game.world.player.running = false
        for _, follower in ipairs(Game.world.followers) do
            if follower:getTarget() == Game.world.player and follower.state == "RUN" then
                follower.state_manager:setState("WALK")
                follower.running = false
            end
        end
        Game.world.player:resetFollowerHistory()
        self.taunt_lock_movement = true

        Assets.playSound("taunt", 0.5, Utils.random(0.9, 1.1))

        for _,chara in ipairs(Game.stage:getObjects(Character)) do
            if not chara.actor or not chara.visible then goto continue end

            -- workaround due to actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            local shine = Sprite("effects/taunt", chara:getRelativePos(chara.width/2, chara.height/2))
            shine:setOrigin(0.5, 0.5)
            shine:setScale(1)
            chara.layer = chara.layer + 0.1
            shine.layer = chara.layer - 0.1
            Game.world:addChild(shine)

            chara.sprite:set(Utils.pick(sprites))
            shine:play(1/30, false, function()
                shine:remove()
                chara:resetSprite()
                chara.layer = chara.layer - 0.1
            end)

            ::continue::
        end

        Game.world.timer:after(1/3, function()
            self.taunt_lock_movement = false
        end)
    end
end

--Battle taunt
function lib:initBattleTaunt()
    self.taunt_cooldown = 0
    self.state_blacklist = {
        "DEFENDINGBEGIN",
        "DEFENDING", -- handled by the soul itself, so this is ignored
        "DEFENDINGEND",
        "ENEMYDIALOGUE",
        "ATTACKING",
        "ACTIONS",
        "ACTIONSDONE",
        "INTRO",
        "TRANSITION",
        "TRANSITIONOUT"
    }
end

function lib:updateBattleTaunt()
    if
        Game:isTauntingAvaliable()
        and Input.pressed("taunt", false)
        and self.taunt_cooldown == 0
        and (Game.state == "BATTLE" and not Game.battle:hasCutscene())
        and not Utils.containsValue(Game.state_blacklist, Game.battle.state)
        and not (OVERLAY_OPEN or TextInput.active)
    then
        self.taunt_cooldown = 2.1

        Assets.playSound("taunt", 0.5, Utils.random(0.9, 1.1))

        for _,chara in ipairs(Game.battle.party) do
            if not chara.actor or chara.is_down then goto continue end

            -- workaround due of actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            local shine = Sprite("effects/taunt", chara:getRelativePos(chara.width/2, chara.height/2))
            shine:setOrigin(0.5, 0.5)
            shine:setScale(1)
            shine.layer = chara.layer - 0.1
            Game.battle:addChild(shine)

            chara:toggleOverlay(true)
            chara.overlay_sprite:setSprite(Utils.pick(sprites))
            shine:play(1/30, false, function()
                shine:remove()
                chara:toggleOverlay(false)
            end)

            ::continue::
        end

    end

    self.taunt_cooldown = Utils.approach(self.taunt_cooldown, 0, DT)
end

---@param world World
---@param name string
---@param data table
function lib:loadObject(world, name, data)
    if false then
    elseif name:lower() == "voidglass" then
        return VoidGlass(data.x, data.y, rect_data, data.properties["broken"])
    elseif name:lower() == "warpbin" then
        return WarpBin(data)
    elseif name:lower() == "superstar" then
        return SuperStar(data.x, data.y, data.width, data.height, data.properties)
    elseif name:lower() == "sprite" then
        local sprite = Sprite(data.properties["texture"], data.x, data.y)
        sprite:play(data.properties["speed"], true)
        sprite:setScale(data.properties["scalex"] or 2, data.properties["scaley"] or 2)
        sprite:setOrigin(data.properties["originx"] or 0, data.properties["originy"] or 0)
        return sprite
    end
end

function lib:onKeyPressed(key)
    if Game.state == "MINIGAME" then
        Game.minigame:onKeyPressed(key)
        return true
    end
end

return lib