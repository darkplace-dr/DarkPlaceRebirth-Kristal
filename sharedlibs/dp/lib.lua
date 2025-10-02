local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:init()
    self:loadHooks()
    self:initTaunt()
    self:initBattleTaunt()
end

function lib:postInit(new_file)
    if not new_file then
        self:checkSaveStatus()
    end
end

function lib:checkSaveStatus()
    local brenda = Game:getPartyMember("brenda")
    if not brenda:hasSpell("multiflare") then
        brenda:removeSpell("gammabeam")
        brenda:addSpell("multiflare")
        brenda:addSpell("powderkeg")
        print("[DP Lib] WARNING: Brenda does not have MultiFlare. Giving starting spells and removing GammaBeam. Save is likely from before her new spells were added.")
    end
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
        
        Utils.hook(LightEncounter, "addEnemy", function(orig, self, enemy, x, y, ...)
            local enemy_obj = orig(self, enemy, x, y, ...)
            
            if enemy_obj.milestone and enemy_obj.experience > 0 then
                self.milestone = true
            end
            
            return enemy_obj
        end)
    end
    
    Utils.hook(ActionButton, "select", function(orig, self)
        if Game.battle.encounter:onActionSelect(self.battler, self) then return end
        if Kristal.callEvent(KRISTAL_EVENT.onActionSelect, self.battler, self) then return end
        if self.type == "item" then
            Game.battle:clearMenuItems()
            for i,item in ipairs(Game.inventory:getStorage("items")) do
                Game.battle:addMenuItem({
                    ["name"] = item:getName(),
                    ["unusable"] = item.usable_in ~= "all" and item.usable_in ~= "battle",
                    ["description"] = item:getBattleDescription(),
                    ["data"] = item,
                    ["callback"] = function(menu_item)
                        Game.battle.selected_item = menu_item

                        if not item.target or item.target == "none" then
                            Game.battle:pushAction("ITEM", nil, menu_item)
                        elseif item.target == "ally" then
                            Game.battle:setState("PARTYSELECT", "ITEM")
                        elseif item.target == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "ITEM")
                        elseif item.target == "party" then
                            Game.battle:pushAction("ITEM", Game.battle.party, menu_item)
                        elseif item.target == "enemies" then
                            Game.battle:pushAction("ITEM", Game.battle:getActiveEnemies(), menu_item)
                        end
                    end
                })
            end
            if Game.inventory:hasItem("oddstone") then
                local item = Game.inventory:getItemByID("oddstone")
                Game.battle:addMenuItem({
                    ["name"] = item:getName(),
                    ["unusable"] = item.usable_in ~= "all" and item.usable_in ~= "battle",
                    ["description"] = item:getBattleDescription(),
                    ["data"] = item,
                    ["callback"] = function(menu_item)
                        Game.battle.selected_item = menu_item

                        if not item.target or item.target == "none" then
                            Game.battle:pushAction("ITEM", nil, menu_item)
                        elseif item.target == "ally" then
                            Game.battle:setState("PARTYSELECT", "ITEM")
                        elseif item.target == "enemy" then
                            Game.battle:setState("ENEMYSELECT", "ITEM")
                        elseif item.target == "party" then
                            Game.battle:pushAction("ITEM", Game.battle.party, menu_item)
                        elseif item.target == "enemies" then
                            Game.battle:pushAction("ITEM", Game.battle:getActiveEnemies(), menu_item)
                        end
                    end
                })
            end
            if #Game.battle.menu_items > 0 then
                Game.battle:setState("MENUSELECT", "ITEM")
            end
        elseif self.type == "spare" then
            local battle_leader = 1
            if self.battler == Game.battle.party[battle_leader] then

                self:spare_menu()

                local party = {}
                local party_up = {}
                for k,chara in ipairs(Game.party) do
                    if k < 4 and not Game.battle.party[k].is_down then
                        table.insert(party_up, chara.id)
                    end
                    if k < 4 then table.insert(party, chara.id) end
                end
                Game.battle:addMenuItem({
                    ["name"] = "Flee",
                    ["unusable"] = not Game.battle.encounter.flee,
                    ["description"] = Game.battle.encounter.flee and "" or "Can't\nEscape",
                    ["party"] = Game.battle.encounter.flee and party or {},
                    ["callback"] = function(menu_item)
                        if (love.math.random(1,100) < Game.battle.encounter.flee_chance) then
                            Game.battle:setState("FLEE")
                        else
                            Game.battle:setState("ENEMYDIALOGUE", "FLEE")
                            Game.battle.current_selecting = 0
                        end
                    end
                })
                Game.battle:setState("MENUSELECT", "SPARE")
            elseif Game.battle.back_row then

                self:spare_menu()

                Game.battle:setState("MENUSELECT", "SPARE")
            else
                Game.battle:setState("ENEMYSELECT", "SPARE")
            end
        elseif self.type == "skill" then
            Game.battle:clearMenuItems()

            for id, action in ipairs(self.battler.chara:getSkills()) do
                Game.battle:addMenuItem({
                    ["name"] = action[1],
                    ["description"] = action[2],
                    ["color"] = action[3],
                    ["callback"] = action[4]
                })
            end

            Game.battle:setState("MENUSELECT", "SKILL")
        elseif self.type == "tension" then
            Game.battle:pushAction("TENSION", nil, {tp = -32})
        else
            return orig(self)
        end
    end)
    
    Utils.hook(ActionButton, "hasSpecial", function(orig, self)
        if self.battler and self.type == "skill" then
            local has_tired = false
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                local has_pacify = false
                for _,spell in ipairs(self.battler.chara:getSpells()) do
                    if spell and spell:hasTag("spare_tired") then
                        if spell:isUsable(self.battler.chara) and spell:getTPCost(self.battler.chara) <= Game:getTension() then
                            has_pacify = true
                            break
                        end
                    end
                end
                return has_pacify
            end
        end
        return orig(self)
    end)
    
    Utils.hook(ActionButton, "spare_menu", function(orig, self)
        Game.battle:clearMenuItems()
        local sparable = false
        for k,v in pairs(Game.battle:getActiveEnemies()) do
            if v.mercy >= 100 then
                sparable = true
                break
            end
        end
        Game.battle:addMenuItem({
            ["name"] = "Spare",
            ["unusable"] = false,
            ["description"] = "",
            ["color"] = sparable and {1, 1, 0, 1} or {1, 1, 1, 1},
            ["callback"] = function(menu_item)
                Game.battle:setState("ENEMYSELECT", "SPARE")
            end
        })

        if Game.battle.back_row then

        local par_t = Game.party
        local chr = Game.battle.back_row.chara
        local lol = true
        local party = {}
        if chr.can_lead == false and Game.battle.current_selecting == 1 then lol = false end 
        if chr.health <= 0 then lol = false end

        if lol == false then
            party[1] = chr.id
        end

            local data = {}
            data.data = {}
            data.data.number = Game.battle.current_selecting
            print(data.data.number)
            Game.battle:addMenuItem({
                ["name"] = "Swap",
                ["unusable"] = not lol,
                ["description"] = "Swap\nParty\nMember",
                ["party"] = party,
                ["callback"] = function(menu_item)
                    --Game.party[4].act_num = Game.battle.current_selecting
                    Game.battle:pushAction("SWAP", nil, data)
                end
            })
        end
    end)
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
        local any_taunted = false

        for _,chara in ipairs(Game.stage:getObjects(Character)) do
            if not chara.actor or not chara.visible then goto continue end

            -- workaround due to actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            any_taunted = true

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

        if any_taunted then
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
            Game.world.timer:after(1/3, function()
                self.taunt_lock_movement = false
            end)

            Assets.playSound("taunt", 0.5, Utils.random(0.9, 1.1))
        end
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
    if name:lower() == "voidglass" then
        return VoidGlass(data.x, data.y, {data.width, data.height, data.polygon}, data.properties["broken"])
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

function lib:shouldWeIncreaseTheRateAtWhichYouGainNightmaresOrNot()
    for _, party in ipairs(Game.party or {}) do
        if party:checkArmor("the_mushroom_hat_that_increases_the_rate_at_which_you_gain_nightmares") then
            return true
        end
    end
    return false
end

return lib
