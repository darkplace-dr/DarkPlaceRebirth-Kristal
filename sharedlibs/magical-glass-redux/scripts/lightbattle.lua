local LightBattle, super = Class(Object)

function LightBattle:init()
    super.init(self)

    self.light = true
    self.forced_victory = false
    self.debug_wave = false
    self.ended = false

    self.party = {}

    -- states: BATTLETEXT, TRANSITION, ACTIONSELECT, MENUSELECT, ENEMYSELECT, PARTYSELECT
    -- ENEMYDIALOGUE, DEFENDING, DEFENDINGEND, VICTORY, TRANSITIONOUT, ATTACKING, FLEEING, FLEEFAIL
    -- BUTNOBODYCAME

    self.state = "NONE"
    self.substate = "NONE"

    self.post_battletext_state = "ACTIONSELECT"

    self.tension = false
    self.hp_display = nil
    self.max_hp_display = nil

    self.fader = Fader()
    self.fader.layer = LIGHT_BATTLE_LAYERS["top"]
    self.fader.alpha = 1
    self:addChild(self.fader)

    self.enemy_world_characters = {}

    self.money = 0
    self.xp = 0

    self.used_violence = false

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.spare_sound = Assets.newSound("vaporized")

    self.encounter_context = nil

    self.offset = 0

    self.textbox_timer = 0
    self.use_textbox_timer = true

    self:createPartyBattlers()

    self.camera = Camera(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.cutscene = nil

    self.current_selecting = 0

    self.turn_count = 0

    self.arena = nil
    self.soul = nil

    self.music = Music()

    self.resume_world_music = false

    self.transitioned = false

    self.mask = ArenaMask(Utils.lerp(LIGHT_BATTLE_LAYERS["below_bullets"], LIGHT_BATTLE_LAYERS["bullets"], 0.5))
    self:addChild(self.mask)

    self.timer = Timer()
    self:addChild(self.timer)

    self.character_actions = {}

    self.selected_character_stack = {}
    self.selected_action_stack = {}

    self.current_actions = {}
    self.short_actions = {}
    self.current_action_index = 1
    self.processed_action = {}
    self.processing_action = false
    self.last_button_type = ""

    self.attackers = {}
    self.normal_attackers = {}
    self.auto_attackers = {}

    self.attack_done = false
    self.cancel_attack = false
    self.auto_attack_timer = 0
    self.auto_attacker_index = 0

    self.post_battletext_func = nil
    self.post_battletext_state = "ACTIONSELECT"

    self.battletext_table = nil
    self.battletext_index = 1

    self.current_menu_x = 1
    self.current_menu_y = 1
    self.current_menu_columns = nil
    self.current_menu_rows = nil

    self.menuselect_cursor_memory = {}
    self.enemyselect_cursor_memory = {}
    self.partyselect_cursor_memory = {}

    self.enemies = {}
    self.enemies_index = {}
    self.enemy_dialogue = {}
    self.enemies_to_remove = {}
    self.defeated_enemies = {}

    self.seen_encounter_text = false

    self.waves = {}
    self.menu_waves = {}
    self.finished_waves = false
    self.finished_menu_waves = false

    self.state_reason = nil
    self.substate_reason = nil

    self.menu_items = {}
    self.pager_menus = {"ITEM"}

    self.xactions = {}

    self.selected_enemy = 1
    self.selected_spell = nil
    self.selected_xaction = nil
    self.selected_item = nil

    self.should_finish_action = false
    self.on_finish_action = nil

    self.background_fade_alpha = 0
    
    self.soul_speed_bonus = 0

    self.wave_length = 0
    self.wave_timer = 0
    self.menu_wave_length = 0
    self.menu_wave_timer = 0

    self.darkify_fader = Fader()
    self.darkify_fader.layer = LIGHT_BATTLE_LAYERS["below_arena"]
    self:addChild(self.darkify_fader)
    
    self.multi_mode = Kristal.getLibConfig("magical-glass", "multi_always_on") or #self.party > 1
end

function LightBattle:isPagerMenu()
    for _,menu in ipairs(self.pager_menus) do
        if menu == self.state_reason then
            return true
        end
    end
    return false
end

function LightBattle:toggleSoul(soul)
    if not self.soul then
        self:spawnSoul(self.arena:getCenter())
    end
    if soul then
        self.soul.collidable = true
        self.soul.visible = true
    else
        self.soul.collidable = false
        self.soul.visible = false
    end
end

function LightBattle:createPartyBattlers()
    for i = 1, math.min(3, #Game.party) do
        local battler = LightPartyBattler(Game.party[i])
        table.insert(self.party, battler)
    end
end

function LightBattle:postInit(state, encounter)
    local check_encounter
    if type(encounter) == "string" then
        check_encounter = MagicalGlassLib:getLightEncounter(encounter)
    else
        check_encounter = encounter
    end
    
    if check_encounter:includes(Encounter) then
        error("Attempted to use Encounter in a LightBattle. Convert the encounter \"" .. check_encounter.id .. "\" file to a LightEncounter")
    end
    
    self.state = state
    
    self.tension = Kristal.getLibConfig("magical-glass", "light_battle_tp") or not Game:isLight()

    if type(encounter) == "string" then
        self.encounter = MagicalGlassLib:createLightEncounter(encounter)
    else
        self.encounter = encounter
    end

    if Game.world.music:isPlaying() and self.encounter.music then
        self.resume_world_music = true
        Game.world.music:pause()
    end

    if self.encounter.queued_enemy_spawns then
        for _,enemy in ipairs(self.encounter.queued_enemy_spawns) do
            table.insert(self.enemies, enemy)
            table.insert(self.enemies_index, enemy)
            self:addChild(enemy)
        end
    end

    if state == "TRANSITION" then
        self.encounter:onSoulTransition()
    else
        self.encounter:onNoTransition()
    end

    if self.encounter.event then
        self.tension = false
    end

    self.arena = LightArena(SCREEN_WIDTH/2, 320)
    self.arena.layer = LIGHT_BATTLE_LAYERS["ui"] - 1
    self:addChild(self.arena)

    self.battle_ui = LightBattleUI()
    self:addChild(self.battle_ui)

    self.tension_bar = LightTensionBar(25, 55, true)
    self.tension_bar.visible = self.tension
    self:addChild(self.tension_bar)

    if Game.encounter_enemies then
        for _,from in ipairs(Game.encounter_enemies) do
            if not isClass(from) then
                local enemy = self:parseEnemyIdentifier(from[1])
                from[2].battler = enemy
                self.enemy_world_characters[enemy] = from[2]
            else
                for _,enemy in ipairs(self.enemies) do
                    if enemy.actor and from.actor and (enemy.actor.id == from.actor.id or enemy.actor:getName() == from.actor:getName()) then
                        from.battler = enemy
                        self.enemy_world_characters[enemy] = from
                        break
                    end
                end
            end
        end
    end

    if self.encounter_context and self.encounter_context:includes(ChaserEnemy) then
        for _,enemy in ipairs(self.encounter_context:getGroupedEnemies(true)) do
            enemy:onEncounterStart(enemy == self.encounter_context, self.encounter)
        end
    end

    if not self.encounter:onBattleInit() then
        self:setState(state)
    end
end

function LightBattle:onRemove(parent)
    super.onRemove(self, parent)

    self.music:remove()
end

function LightBattle:isWorldHidden()
    return true
end

function LightBattle:spawnSoul(x, y)
    local bx, by = self:getSoulLocation()
    x = x or bx
    y = y or by
    local color = {self.encounter:getSoulColor()}
    if not self.soul then
        self.soul = self.encounter:createSoul(x, y, color)
        self.soul.alpha = 1
        self.soul.sprite:set("player/heart_light")
        self:addChild(self.soul)
    end
end

function LightBattle:swapSoul(object)
    if self.soul then
        self.soul:remove()
    end
    object:setPosition(self.soul:getPosition())
    object.layer = self.soul.layer
    self.soul = object
    self:addChild(object)
end

function LightBattle:resetAttackers()
    if #self.attackers > 0 then
        self.attackers = {}
        self.normal_attackers = {}
        self.auto_attackers = {}
        self.auto_attacker_index = 0
        if self.battle_ui.attacking then
            self.battle_ui:endAttack()
        end
    end
end

function LightBattle:getSoulLocation(always_player)
    if self.soul and not always_player then
        return self.soul:getPosition()
    else
        return 49 - 1, 455 - 1
    end
end

function LightBattle:setState(state, reason)
    local old = self.state
    self.state = state
    self.state_reason = reason
    self:onStateChange(old, self.state)
end

function LightBattle:setSubState(state, reason)
    local old = self.substate
    self.substate = state
    self.substate_reason = reason
    self:onSubStateChange(old, self.substate)
end

function LightBattle:getState()
    return self.state
end

function LightBattle:onSubStateChange(old, new) end

function LightBattle:registerXAction(party, name, description, tp)
    local act = {
        ["name"] = name,
        ["description"] = description,
        ["party"] = party,
        ["color"] = {self.party[self:getPartyIndex(party)].chara:getLightXActColor()},
        ["tp"] = tp or 0,
        ["short"] = false
    }

    table.insert(self.xactions, act)
end

function LightBattle:getEncounterText()
    return self.encounter:getEncounterText()
end

function LightBattle:processCharacterActions()
    if self.state ~= "ACTIONS" then
        self:setState("ACTIONS", "DONTPROCESS")
    end

    self.current_action_index = 1

    local order = {"SAVE", "ACT", {"SPELL", "ITEM", "SPARE"}}

    for lib_id,_ in pairs(Mod.libs) do
        order = Kristal.libCall(lib_id, "getLightActionOrder", order, self.encounter) or order
    end
    order = Kristal.modCall("getLightActionOrder", order, self.encounter) or order

    table.insert(order, "SKIP")

    for _,action_group in ipairs(order) do
        if self:processActionGroup(action_group) then
            self:tryProcessNextAction()
            return
        end
    end

    self:setSubState("NONE")
    self:setState("ATTACKING")
end

function LightBattle:processActionGroup(group)
    if type(group) == "string" then
        local found = false
        for i,battler in ipairs(self.party) do
            local action = self.character_actions[i]
            if action and action.action == group then
                found = true
                self:beginAction(action)
            end
        end
        for _,action in ipairs(self.current_actions) do
            self.character_actions[action.character_id] = nil
        end
        return found
    else
        for i,battler in ipairs(self.party) do
            local action = self.character_actions[i]
            if action and Utils.containsValue(group, action.action) then
                self.character_actions[i] = nil
                self:beginAction(action)
                return true
            end
        end
    end
end

function LightBattle:tryProcessNextAction(force)
    if self.state == "ACTIONS" and not self.processing_action then
        if #self.current_actions == 0 then
            self:processCharacterActions()
        else
            while self.current_action_index <= #self.current_actions do
                local action = self.current_actions[self.current_action_index]
                if not self.processed_action[action] then
                    self.processing_action = action
                    if self:processAction(action) then
                        self:finishAction(action)
                    end
                    return
                end
                self.current_action_index = self.current_action_index + 1
            end
        end
    end
end

function LightBattle:getCurrentActing()
    local result = {}
    for _,action in ipairs(self.current_actions) do
        if action.action == "ACT" then
            table.insert(result, action)
        end
    end
    return result
end

function LightBattle:beginAction(action)
    local battler = self.party[action.character_id]
    local enemy = action.target

    -- Add the action to the actions table, for group processing
    table.insert(self.current_actions, action)

    -- Set the state
    if self.state == "ACTIONS" then
        self:setSubState(action.action)
    end

    -- Call mod callbacks for adding new beginAction behaviour
    if Kristal.callEvent(MG_EVENT.onLightBattleActionBegin, action, action.action, battler, enemy) then
        return
    end

    if action.action == "ACT" then
        -- Play the ACT animation by default
        --battler:setAnimation("battle/act")
        -- Enemies might change the ACT animation, so run onActStart here
        enemy:onActStart(battler, action.name)
    end
end

function LightBattle:retargetEnemy()
    for _,other in ipairs(self.enemies) do
        if not other.done_state then
            return other
        end
    end
end

function LightBattle:processAction(action)
    local battler = self.party[action.character_id]
    local party_member = battler.chara
    local enemy = action.target

    self.current_processing_action = action

    if enemy and enemy.done_state then
        enemy = self:retargetEnemy()
        action.target = enemy
        if not enemy then
            if action.action == "AUTOATTACK" then
                self:finishAction(action)
            end
            return true
        end
    end

    -- Call mod callbacks for onBattleAction to either add new behaviour for an action or override existing behaviour
    -- Note: non-immediate actions require explicit "return false"!
    local callback_result = Kristal.modCall("onLightBattleAction", action, action.action, battler, enemy)
    if callback_result ~= nil then
        return callback_result
    end
    for lib_id,_ in pairs(Mod.libs) do
        callback_result = Kristal.libCall(lib_id, "onLightBattleAction", action, action.action, battler, enemy)
        if callback_result ~= nil then
            return callback_result
        end
    end

    self.current_selecting = 0

    if action.action == "SPARE" then

        if battler.manual_spare then
            local worked = enemy:canSpare()
            enemy:onMercy(battler)
            if not worked then
                enemy:mercyFlash()
            end
            self:battleText(enemy:getSpareText(battler, worked))
            self:finishAction(action)
        else
            local success = false
            local tired = false
            local active = false
            for _,act_enemy in ipairs(self:getActiveEnemies()) do
                active = true
                if act_enemy:canSpare() then
                    success = true
                end
                if act_enemy.tired then
                    tired = true
                end
                act_enemy:onMercy(battler)
            end
            
            if Game.battle.multi_mode and active then
                if success then
                    self:battleText("* " .. battler.chara:getNameOrYou() .. " spared the enemies.")
                else
                    local text = "* " .. battler.chara:getNameOrYou() .. " spared the enemies.\n* But none of the enemies' names were [color:"..Utils.rgbToHex(MagicalGlassLib.spare_color).."]"..MagicalGlassLib.spare_color_name.."[color:reset]..."
                    if tired then
                        local found_spell = nil
                        for _,party in ipairs(Game.battle.party) do
                            for _,spell in ipairs(party.chara:getSpells()) do
                                if spell:hasTag("spare_tired") then
                                    found_spell = spell
                                    break
                                end
                            end
                            if found_spell then
                                text = {text, "* (Try using "..party.chara:getName().."'s [color:blue]"..found_spell:getCastName().."[color:reset].)"}
                                break
                            end
                        end
                        if not found_spell then
                            text = {text, "* (Try using [color:blue]ACTs[color:reset].)"}
                        end
                    end
                    self:battleText(text)
                end
            end

            self:finishAction(action)
        end
        
        return false

    elseif action.action == "SAVE" then
        enemy:onSave(battler)
        self:finishAction(action)
        
        return false
    elseif action.action == "ATTACK" then
        local lane
        for _,ilane in ipairs(self.battle_ui.attack_box.lanes) do
            if ilane.battler == battler then
                lane = ilane
                break
            end
        end

        if lane.attacked then

            if action.target and action.target.done_state then
                enemy = self:retargetEnemy()
                action.target = enemy
                if not enemy then
                    self.cancel_attack = true
                    self:finishAction(action)
                    return
                end
            end

            local weapon = battler.chara:getWeapon() or Registry.createItem(battler.chara:getLightNoWeaponAnimation()) -- allows attacking without a weapon
            local damage = 0
            local crit

            if enemy then
                if not action.force_miss and action.points > 0 then
                    damage, crit = enemy:getAttackDamage(action.damage or 0, lane, action.points or 0, action.stretch)
                    damage = Utils.round(damage)

                    if damage < 0 then
                        damage = 0
                    end

                    local result = weapon:onLightAttack(battler, enemy, damage, action.stretch, crit)
                    if result or result == nil then
                        self:finishAction(action)
                    end
                else
                    local result = weapon:onLightMiss(battler, enemy, true, nil, false)
                    if result or result == nil then
                        self:finishAction(action)
                    end
                end
            end

        end

        return false
        
    elseif action.action == "AUTOATTACK" then
        if action.target and action.target.done_state then
            enemy = self:retargetEnemy()
            action.target = enemy
            if not enemy then
                self.cancel_attack = true
                self:finishAction(action)
                return
            end
        end
        
        local weapon = battler.chara:getWeapon() or Registry.createItem(battler.chara:getLightNoWeaponAnimation()) -- allows attacking without a weapon
        local damage = 0
        local crit
        
        if enemy then
            if not action.force_miss and action.points > 0 then
                local stretch = action.points / 150
                damage, crit = enemy:getAttackDamage(action.damage or 0, battler, action.points or 0, stretch)
                damage = Utils.round(damage)

                if damage < 0 then
                    damage = 0
                end

                local result = weapon:onLightAttack(battler, enemy, damage, stretch, crit)
                if result or result == nil then
                    self:finishAction(action)
                end
            else
                local result = weapon:onLightMiss(battler, enemy, true, nil, false)
                if result or result == nil then
                    self:finishAction(action)
                end
            end
        end

        return false

    elseif action.action == "ACT" then
        local self_short = false
        self.short_actions = {}
        for _,iaction in ipairs(self.current_actions) do
            if iaction.action == "ACT" then
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                if ienemy then
                    local act = ienemy and ienemy:getAct(iaction.name)

                    if (act and act.short) or (ienemy:getXAction(ibattler) == iaction.name and ienemy:isXActionShort(ibattler)) then
                        table.insert(self.short_actions, iaction)
                        if ibattler == battler then
                            self_short = true
                        end
                    end
                end
            end
        end

        if self_short and #self.short_actions > 1 then
            local short_text = {}
            for _,iaction in ipairs(self.short_actions) do
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                local act_text = ienemy:onShortAct(ibattler, iaction.name)
                if act_text then
                    table.insert(short_text, act_text)
                end
            end

            self:shortActText(short_text)
        else
            local text = enemy:onAct(battler, action.name)
            if text then
                self:setActText(text)
            end
        end

        return false

    elseif action.action == "SKIP" then
        return true

    elseif action.action == "SPELL" then
        self.battle_ui:clearEncounterText()

        -- The spell itself handles the animation and finishing
        action.data:onLightStart(battler, action.target)

        return false
    elseif action.action == "ITEM" then
        local item = action.data
        if item.instant then
            self:finishAction(action)
        else
            local result = item:onLightBattleUse(battler, action.target)
            if result or result == nil then
                self:finishAction(action)
            end
        end
        return false

    elseif action.action == "DEFEND" then
        battler.defending = true
        return false
    else
        -- we don't know how to handle this...
        Kristal.Console:warn("Unhandled battle action: " .. tostring(action.action))
        return true
    end
end

function LightBattle:getCurrentAction()
    return self.current_actions[self.current_action_index]
end

function LightBattle:getActionBy(battler)
    for i,party in ipairs(self.party) do
        if party == battler then
            return self.character_actions[i]
        end
    end
end

function LightBattle:finishActionBy(battler)
    for _,action in ipairs(self.current_actions) do
        local ibattler = self.party[action.character_id]
        if ibattler == battler then
            self:finishAction(action)
        end
    end
end

function LightBattle:finishAllActions()
    for _,action in ipairs(self.current_actions) do
        self:finishAction(action)
    end
end

function LightBattle:allActionsDone()
    for _,action in ipairs(self.current_actions) do
        if not self.processed_action[action] then
            return false
        end
    end
    return true
end

function LightBattle:markAsFinished(action)
    if self:getState() ~= "BATTLETEXT" then
        self:finishAction(action)
    else
        self.on_finish_action = action
        self.should_finish_action = true
    end
end

function LightBattle:finishAction(action)
    action = action or self.current_actions[self.current_action_index]

    local battler = self.party[action.character_id]
    
    local function finish()
        self.processed_action[action] = true

        if self.processing_action == action then
            self.processing_action = nil
        end

        local all_processed = self:allActionsDone()

        if all_processed then
            for _,iaction in ipairs(Utils.copy(self.current_actions)) do
                local ibattler = self.party[iaction.character_id]

                Utils.removeFromTable(self.current_actions, iaction)
                self:tryProcessNextAction()

                if iaction.action == "DEFEND" then
                    ibattler.defending = false
                end

                Kristal.callEvent(MG_EVENT.onLightBattleActionEnd, iaction, iaction.action, ibattler, iaction.target)
            end
        else
            -- Process actions if we can
            self:tryProcessNextAction()
        end
    end
    
    if battler.delay_turn_end then
        Game.battle.timer:after(1, function() finish() end)
    else
        finish()
    end
end

function LightBattle:onStateChange(old,new)
    if self.encounter.beforeStateChange then
        local result = self.encounter:beforeStateChange(old,new)
        if result or self.state ~= new then
            return
        end
    end

    if new == "ACTIONSELECT" then
        self.arena.layer = LIGHT_BATTLE_LAYERS["ui"] - 1

        if not self.soul then
            self:spawnSoul()
        end

        self:toggleSoul(true)
        self.soul.can_move = false

        if self.current_selecting < 1 or self.current_selecting > #self.party then
            self:nextTurn()
            if self.state ~= "ACTIONSELECT" then
                return
            end
        end
        
        self.fader:fadeIn(function()
            self.soul.layer = LIGHT_BATTLE_LAYERS["soul"]
        end, {speed=5/30})

        self.battle_ui.encounter_text.text.line_offset = 5
        self.battle_ui:clearEncounterText()
        self.battle_ui.encounter_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. "[noskip][wait:1][noskip:false]" ..self.battle_ui.current_encounter_text)

        local party = self.party[self.current_selecting]
        party.chara:onLightActionSelect(party, false)
        self.encounter:onCharacterTurn(party, false)
        
        if not self.started then
            self.started = true

            if self.encounter.music then
                self.music:play(self.encounter.music)
            end
            
            for _,action_box in ipairs(Game.battle.battle_ui.action_boxes) do
                if action_box.battler == party then
                    action_box:update()
                    break
                end
            end
        end

    elseif new == "BUTNOBODYCAME" then
        self.current_selecting = 0
        if not self.soul then
            self:spawnSoul()
        end

        self.soul.can_move = false
        
        self.fader:fadeIn(nil, {speed=5/30})

        self.battle_ui.encounter_text.text.line_offset = 5
        self.battle_ui:clearEncounterText()
        self.battle_ui.encounter_text:setText("[noskip][wait:1][noskip:false]"..self.battle_ui.current_encounter_text)

        if not self.started then
            self.started = true

            if self.encounter.music then
                self.music:play(self.encounter.music)
            end
        end

    elseif new == "ACTIONS" then
        self.battle_ui:clearEncounterText()
        if self.state_reason ~= "DONTPROCESS" then
            self:tryProcessNextAction()
        end
    elseif new == "MENUSELECT" then
        self.battle_ui:clearEncounterText()

        if self.menuselect_cursor_memory[self.state_reason] and Utils.containsValue(self:menuSelectMemory(), self.state_reason) then
            self.current_menu_x = self.menuselect_cursor_memory[self.state_reason].x
            self.current_menu_y = self.menuselect_cursor_memory[self.state_reason].y
        else
            self.current_menu_x = 1
            self.current_menu_y = 1
        end

        if not self:isValidMenuLocation() then
            self.current_menu_x = 1
            self.current_menu_y = 1
        end
    elseif new == "ENEMYSELECT" then
        self.battle_ui:clearEncounterText()

        if self.enemyselect_cursor_memory[self.state_reason] then
            self.current_menu_x = 1
            self.current_menu_y = self.enemyselect_cursor_memory[self.state_reason] or 1
        else
            self.current_menu_x = 1
            self.current_menu_y = 1
        end

        if not (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable) and #self.enemies_index > 0 then
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y + 1
                if self.current_menu_y > #self.enemies_index then
                    self.current_menu_y = 1
                end
            until (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable)
        end

    elseif new == "PARTYSELECT" then
        self.battle_ui:clearEncounterText()

        if self.partyselect_cursor_memory[self.state_reason] then
            self.current_menu_x = 1
            self.current_menu_y = self.partyselect_cursor_memory[self.state_reason]
        else
            self.current_menu_x = 1
            self.current_menu_y = 1
        end

    elseif new == "ATTACKING" then
        self.battle_ui:clearEncounterText()

        local enemies_left = self:getActiveEnemies()

        if #enemies_left > 0 then
            for i,battler in ipairs(self.party) do
                local action = self.character_actions[i]
                if action and action.action == "ATTACK" then
                    self:beginAction(action)
                    table.insert(self.attackers, battler)
                    table.insert(self.normal_attackers, battler)
                elseif action and action.action == "AUTOATTACK" then
                    table.insert(self.attackers, battler)
                    table.insert(self.auto_attackers, battler)
                end
            end
        end

        self.auto_attack_timer = 0

        if #self.attackers == 0 then
            self.attack_done = true
            self:setState("ACTIONSDONE")
        else
            self.attack_done = false
        end

    elseif new == "ENEMYDIALOGUE" then
        self.current_selecting = 0
        self.battle_ui:clearEncounterText()
        self.textbox_timer = 3 * 30
        self.use_textbox_timer = true
        local active_enemies = self:getActiveEnemies()
        
        local function update_enemies()
            for _,enemy in ipairs(active_enemies) do
                enemy.current_target = enemy:getTarget()
            end
            local cutscene_args = {self.encounter:getDialogueCutscene()}
            if self.debug_wave then
                self:setState("DIALOGUEEND")
            elseif #cutscene_args > 0 then
                self:startCutscene(unpack(cutscene_args)):after(function()
                    self:setState("DIALOGUEEND")
                end)
            else
                local any_dialogue = false
                for _,enemy in ipairs(active_enemies) do
                    local dialogue = enemy:getEnemyDialogue()
                    if dialogue then
                        any_dialogue = true
                        local bubble = enemy:spawnSpeechBubble(dialogue, {no_sound_overlap = true})
                        if Kristal.getLibConfig("magical-glass", "undertale_text_skipping") then
                            bubble:setSkippable(false)
                        end
                        table.insert(self.enemy_dialogue, bubble)
                    end
                end
                if not any_dialogue then
                    self:setState("DIALOGUEEND")
                end
            end
        end
        if #active_enemies == 0 and not self.encounter.event then
            self:setState("VICTORY")
        elseif Mod.libs["classic_turn_based_rpg"] and self.encounter:getEnemyAutoAttack() and not self.encounter.event and not self.debug_wave then
            update_enemies()
        else
            if self.state_reason then
                self:setWaves(self.state_reason)
                local enemy_found = false
                for i,enemy in ipairs(self.enemies) do
                    if Utils.containsValue(enemy.waves, self.state_reason[1]) then
                        enemy.selected_wave = self.state_reason[1]
                        enemy_found = true
                    end
                end
                if not enemy_found then
                    self.enemies[Utils.random(1, #self.enemies, 1)].selected_wave = self.state_reason[1]
                end
            else
                self:setWaves(self.encounter:getNextWaves())
            end

            local soul_x, soul_y, soul_offset_x, soul_offset_y
            local arena_x, arena_y, arena_h, arena_w
            local has_arena = false
            local has_soul = false
            local fullscreen = false
            for _,wave in ipairs(self.waves) do
                soul_x = wave.soul_start_x or soul_x
                soul_y = wave.soul_start_y or soul_y
                soul_offset_x = wave.soul_offset_x or soul_offset_x
                soul_offset_y = wave.soul_offset_y or soul_offset_y
                arena_x = wave.arena_x or arena_x
                arena_y = wave.arena_y or arena_y
                arena_w = wave.arena_width and math.max(wave.arena_width, arena_w or 0) or arena_w
                arena_h = wave.arena_height and math.max(wave.arena_height, arena_h or 0) or arena_h
                if wave.has_arena then
                    has_arena = true
                end
                if wave.has_soul then
                    has_soul = true
                end
                if wave.fullscreen then
                    fullscreen = true
                end
            end
    
            arena_w, arena_h = arena_w or 160, arena_h or 130
            arena_x, arena_y = arena_x or self.arena.home_x, arena_y or self.arena.home_y

            if fullscreen and #self.waves > 0 then
                if self.encounter.event then
                    self.arena:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
                    self.arena:setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
                    self.arena:update()
                else
                    self.arena:changeShape({SCREEN_WIDTH-10, self.arena.height})
                end
            elseif has_arena then
                if self.encounter.event then
                    self.arena:setPosition(arena_x, arena_y)
                    self.arena:setSize(arena_w, arena_h)
                    self.arena:update()
                else
                    self.arena:changeShape({arena_w, self.arena.height})
                end
            elseif #self.waves > 0 then
                self.arena:disable()
            end

            local center_x, center_y = self.arena:getCenter()
    
            self:toggleSoul(has_soul)
            soul_x = soul_x or (soul_offset_x and center_x + soul_offset_x)
            soul_y = soul_y or (soul_offset_y and center_y + soul_offset_y)
            self.soul:setPosition(soul_x or center_x, soul_y or center_y)
            self.soul.can_move = self.encounter.event

            update_enemies()
        end
    elseif new == "DIALOGUEEND" then
        self.battle_ui:clearEncounterText()

        for i,battler in ipairs(self.party) do
            local action = self.character_actions[i]
            if action and action.action == "DEFEND" then
                self:beginAction(action)
                self:processAction(action)
            end
        end

        self.encounter:onDialogueEnd()
    elseif new == "DEFENDING" then
        self.arena.layer = LIGHT_BATTLE_LAYERS["arena"]

        self.wave_length = 0
        self.wave_timer = 0

        for _,wave in ipairs(self.waves) do
            wave.encounter = self.encounter

            self.wave_length = math.max(self.wave_length, wave.time)

            wave:onStart()

            wave.active = true
        end

        self.soul:onWaveStart()
    elseif new == "VICTORY" then
        self:toggleSoul(false)
        self.music:stop()
        self.current_selecting = 0
        self.forced_victory = true

        self:resetParty()
        
        local win_text = ""
        
        local no_skip = ""
        if Kristal.getLibConfig("magical-glass", "undertale_text_skipping") then
            no_skip = "[noskip]"
        end
        
        if Game:isLight() then

            self.money = self.encounter:getVictoryMoney(self.money) or self.money

            if self.tension then
                self.money = self.money + math.floor(Game:getTension() / 5)
            end

            for _,battler in ipairs(self.party) do
                for _,equipment in ipairs(battler.chara:getEquipment()) do
                    self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
                end
            end

            self.money = math.floor(self.money)

            self.money = self.encounter:getVictoryMoney(self.money) or self.money
            self.xp = self.encounter:getVictoryXP(self.xp) or self.xp

            win_text = no_skip.."* YOU WON!\n* You earned " .. self.xp .. " EXP and " .. self.money .. " " .. Game:getConfig("lightCurrency"):lower() .. "."

            Game.lw_money = Game.lw_money + self.money

            if (Game.lw_money < 0) then
                Game.lw_money = 0
            end

            for _,member in ipairs(self.party) do
                local lv = member.chara:getLightLV()
                member.chara:addLightEXP(self.xp)

                if lv ~= member.chara:getLightLV() then
                    win_text = no_skip.."* YOU WON!\n* You earned " .. self.xp .. " EXP and " .. self.money .. " " .. Game:getConfig("lightCurrency"):lower() .. ".\n* Your "..Kristal.getLibConfig("magical-glass", "light_level_name").." increased."
                    Assets.stopAndPlaySound("levelup")
                end
            end

            win_text = self.encounter:getVictoryText(win_text, self.money, self.xp) or win_text
        else
            if self.tension then
                self.money = self.money + (math.floor(((Game:getTension() * 2.5) / 10)) * Game.chapter)
            end

            for _,battler in ipairs(self.party) do
                for _,equipment in ipairs(battler.chara:getEquipment()) do
                    self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
                end
            end

            self.money = math.floor(self.money)

            self.money = self.encounter:getVictoryMoney(self.money) or self.money
            self.xp = self.encounter:getVictoryXP(self.xp) or self.xp
            -- if (in_dojo) then
            --     self.money = 0
            -- end

            Game.money = Game.money + self.money
            Game.xp = Game.xp + self.xp

            if (Game.money < 0) then
                Game.money = 0
            end

            win_text = no_skip.."* YOU WON!\n* You earned " .. self.xp .. " EXP and " .. self.money .. " " .. Game:getConfig("darkCurrencyShort") .. "."
            -- if (in_dojo) then
            --     win_text == "* You won the battle!"
            -- end
            if self.used_violence and Game:getConfig("growStronger") then
                local stronger = "You"
                
                local party_to_lvl_up = {}
                for _,battler in ipairs(self.party) do
                    table.insert(party_to_lvl_up, battler.chara)
                    if Game:getConfig("growStrongerChara") and battler.chara.id == Game:getConfig("growStrongerChara") then
                        stronger = battler.chara:getName()
                    end
                    for _,id in pairs(battler.chara:getStrongerAbsent()) do
                        table.insert(party_to_lvl_up, Game:getPartyMember(id))
                    end
                end
                
                for _,party in ipairs(Utils.removeDuplicates(party_to_lvl_up)) do
                    Game.level_up_count = Game.level_up_count + 1
                    party:onLevelUp(Game.level_up_count)
                end

                if self.xp == 0 then
                    win_text = no_skip.."* YOU WON!\n* You earned " .. self.money .. " " .. Game:getConfig("darkCurrencyShort") .. ".\n* "..stronger.." became stronger."
                else
                    win_text = no_skip.."* YOU WON!\n* You earned " .. self.xp .. " EXP and " .. self.money .. " " .. Game:getConfig("darkCurrencyShort") .. ".\n* "..stronger.." became stronger."
                end

                Assets.playSound("dtrans_lw", 0.7, 2)
                --scr_levelup()
            end

            win_text = self.encounter:getVictoryText(win_text, self.money, self.xp) or win_text
        end
        
        if self.encounter.no_end_message then
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
        else
            self:battleText(win_text, function()
                self:setState("TRANSITIONOUT", "POSTFADE")
                self.encounter:onBattleEnd()
                return true
            end)
        end

    elseif new == "TRANSITIONOUT" then
        self.ended = true
        self.current_selecting = 0
        if self.encounter_context and self.encounter_context:includes(ChaserEnemy) then
            for _,enemy in ipairs(self.encounter_context:getGroupedEnemies(true)) do
                enemy:onEncounterTransitionOut(enemy == self.encounter_context, self.encounter)
            end
        end

        local enemies = {}
        for k,v in pairs(self.enemy_world_characters) do
            table.insert(enemies, v)
        end
        self.encounter:onReturnToWorld(enemies)

        if self.state_reason == "POSTFADE" then
            self:returnToWorld()
            Game.fader:fadeIn(nil, {alpha = 1, speed = 12/30, color = {0, 0, 0}})
        else
            Game.fader:transition(function() self:returnToWorld() end, nil, {speed = (self.encounter.fast_transition and 5 or 12)/30})
        end
    elseif new == "DEFENDINGBEGIN" then
        self.battle_ui:clearEncounterText()
    elseif new == "FLEEING" then
        self.current_selecting = 0
        
        self:resetParty()
        self.encounter:onFlee()
    elseif new == "FLEEFAIL" then
        self:toggleSoul(false)
        self.current_selecting = 0
        self.encounter:onFleeFail()
        self:setState("ACTIONSDONE")
    elseif new == "DEFENDINGEND" then
        if self.encounter.event then
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
        else
            self:toggleSoul(false)
            self.arena:enable()
            self.arena.rotation = 0
            if self.arena.height >= self.arena.init_height then
                self.arena:changePosition({self.arena.home_x, self.arena.home_y}, true,
                function()
                    self.arena:changeShape({self.arena.width, self.arena.init_height},
                    function()
                        self.arena:changeShape({self.arena.init_width, self.arena.height})
                    end)
                end)
            else
                self.arena:changePosition({self.arena.home_x, self.arena.home_y}, true,
                function()
                    self.arena:changeShape({self.arena.init_width, self.arena.height},
                    function()
                        self.arena:changeShape({self.arena.width, self.arena.init_height})
                    end)
                end)
            end
        end
    end
    
    local normal_arena_state = {"DEFENDINGEND", "TRANSITIONOUT", "ACTIONSELECT", "VICTORY", "INTRO", "ACTIONS", "ENEMYSELECT", "PARTYSELECT", "MENUSELECT", "ATTACKING", "FLEEING", "FLEEFAIL", "BUTNOBODYCAME"}

    local should_end = not self.encounter.event
    if Utils.containsValue(normal_arena_state, new) then
        for _,wave in ipairs(self.waves) do
            if wave:beforeEnd() then
                should_end = false
            end
        end
        if should_end then
            for _,battler in ipairs(self.party) do
                battler.targeted = false
            end
        end
    end

    if old == "DEFENDING" and not Utils.containsValue({"ENEMYDIALOGUE", "DIALOGUEEND", "DEFENDINGBEGIN"}, new) and should_end then
        for _,wave in ipairs(self.waves) do
            if not wave:onEnd(false) then
                wave:clear()
                wave:remove()
            end
        end

        if self.state_reason == "WAVEENDED" then
            if self:hasCutscene() then
                self.cutscene:after(function()
                    self:setState("DEFENDINGEND", "TURNDONE")
                end)
            else
                self.timer:after(15/30, function()
                    self:setState("DEFENDINGEND", "TURNDONE")
                end)
            end
        end
    end

    self.encounter:onStateChange(old,new)
end

function LightBattle:nextTurn()
  
    self.turn_count = self.turn_count + 1
    
    self.debug_wave = false
    if self.turn_count > 1 then
        if self.encounter:onTurnEnd() then
            return
        end
        for _,battler in ipairs(self.party) do
            if battler.chara:onLightTurnEnd(battler) then
                return
            end
        end
        for _,enemy in ipairs(self:getActiveEnemies()) do
            if enemy:onTurnEnd() then
                return
            end
        end
    end

    for _,action in ipairs(self.current_actions) do
        if action.action == "DEFEND" then
            self:finishAction(action)
        end
    end

    for _,enemy in ipairs(self.enemies) do
        enemy.selected_wave = nil
        enemy.hit_count = 0
        enemy.active_msg = 0
        enemy.x_number_offset = 0
        enemy.post_health = nil
    end

    for _,battler in ipairs(self.party) do
        battler.hit_count = 0
        battler.delay_turn_end = false
        battler.manual_spare = false
        if (battler.chara:getHealth() <= 0) and battler.chara:canAutoHeal() and self.encounter:isAutoHealingEnabled(battler) then
            battler:heal(battler.chara:autoHealAmount())
        end
        battler.action = nil
    end

    self.attackers = {}
    self.normal_attackers = {}
    self.auto_attackers = {}

    if self.state ~= "BUTNOBODYCAME" then
        self.current_selecting = 1
    end

    while not (self.party[self.current_selecting]:isActive()) do
        self.current_selecting = self.current_selecting + 1
        if self.current_selecting > #self.party then
            print("WARNING: nobody up! this shouldn't happen...")
            self.current_selecting = 1
            break
        end
    end

    self.character_actions = {}
    self.current_actions = {}
    self.processed_action = {}

    if self.battle_ui then
        local found = false
        for _,action_box in ipairs(self.battle_ui.action_boxes) do
            for i,button in ipairs(action_box.buttons or {}) do
                if button.type == self.last_button_type then
                    action_box.selected_button = i
                    found = true
                    break
                end
            end
            if not found then
                local group
                for _,pair in ipairs(self:actionButtonPairs()) do
                    if Utils.containsValue(pair, self.last_button_type) then
                        group = pair
                        break
                    end
                end
                if group then
                    for i,button in ipairs(action_box.buttons or {}) do
                        if Utils.containsValue(group, button.type) then
                            action_box.selected_button = i
                            found = true
                            break
                        end
                    end
                end
            end
            if not found then
                action_box.selected_button = action_box.last_button or 1
            end
        end
        
        if not self.seen_encounter_text then
            self.seen_encounter_text = true
            self.battle_ui.current_encounter_text = self.encounter.text
        else
            self.battle_ui.current_encounter_text = self:getEncounterText()
        end
        self.battle_ui.encounter_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. self.battle_ui.current_encounter_text)
    end

    self.encounter:onTurnStart()
    for _,enemy in ipairs(self:getActiveEnemies()) do
        enemy:onTurnStart()
    end
    
    if self.battle_ui then
        for _,battler in ipairs(self.party) do
            battler.chara:onLightTurnStart(battler)
        end
    end

    if self.current_selecting ~= 0 and self.state ~= "ACTIONSELECT" then
        self:setState("ACTIONSELECT")
    end

    if self.encounter.getNextMenuWaves and #self.encounter:getNextMenuWaves() > 0 then
        self:setMenuWaves(self.encounter:getNextMenuWaves())

        for _,enemy in ipairs(self:getActiveEnemies()) do
            enemy.menu_wave_override = nil
        end
        self.menu_wave_length = 0
        self.menu_wave_timer = 0

        for _,wave in ipairs(self.menu_waves) do
            wave.encounter = self.encounter

            self.menu_wave_length = math.max(self.menu_wave_length, wave.time)

            wave:onStart()

            wave.active = true
        end

        self.soul:onMenuWaveStart()
    end

end

function LightBattle:canSelectMenuItem(menu_item)
    if menu_item.unusable then
        return false
    end
    if menu_item.tp and (menu_item.tp > Game:getTension()) then
        return false
    end
    if menu_item.party then
        for _,party_id in ipairs(menu_item.party) do
            local party_index = self:getPartyIndex(party_id)
            local battler = self.party[party_index]
            local action = self.character_actions[party_index]
            if (not battler) or (not battler:isActive()) or (action and action.cancellable == false) then
                -- They're either down, asleep, or don't exist. Either way, they're not here to do the action.
                return false
            end
        end
    end
    return true
end

function LightBattle:returnToWorld()
    if not Game:getConfig("keepTensionAfterBattle") then
        Game:setTension(0)
    end

    self.encounter:setFlag("done", true)

    local all_enemies = {}
    Utils.merge(all_enemies, self.defeated_enemies)
    Utils.merge(all_enemies, self.enemies)
    for _,enemy in ipairs(all_enemies) do
        local world_chara = self.enemy_world_characters[enemy]
        if world_chara then
            world_chara.visible = true
        end
        if not enemy.exit_on_defeat and world_chara and world_chara.parent then
            if world_chara.onReturnFromBattle then
                world_chara:onReturnFromBattle(self.encounter, enemy)
            end
        end
    end
    if self.encounter_context and self.encounter_context:includes(ChaserEnemy) then
        for _,enemy in ipairs(self.encounter_context:getGroupedEnemies(true)) do
            enemy:onEncounterEnd(enemy == self.encounter_context, self.encounter)
        end
    end

    self.music:stop()
    if self.resume_world_music then
        Game.world.music:resume()
    end
    self:remove()
    self.encounter.defeated_enemies = self.defeated_enemies
    Game.battle = nil
    Game.state = "OVERWORLD"

    MagicalGlassLib.current_battle_system = nil
end

function LightBattle:setActText(text, dont_finish)
    self:battleText(text, function()
        if not dont_finish then
            self:finishAction()
        end
        if self.should_finish_action then
            self:finishAction(self.on_finish_action)
            self.on_finish_action = nil
            self.should_finish_action = false
        end
        self:setState("ACTIONS", "BATTLETEXT")
        return true
    end)
end

function LightBattle:resetParty()
    for _,battler in ipairs(self.party) do
        battler:setSleeping(false)
        battler.defending = false
        battler.action = nil
        
        battler.chara:setHealth(battler.chara:getHealth() - battler.karma)
        battler.karma = 0

        battler.chara:resetBuffs()

        if battler.chara:getHealth() <= 0 then
            battler:revive()
            battler.chara:setHealth(battler.chara:autoHealAmount())
        end
    end
end

function LightBattle:shortActText(text)
    self:setState("SHORTACTTEXT")
    self.battle_ui:clearEncounterText()

    self.battle_ui.short_act_text_1:setText(text[1] and "[voice:battle][shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. text[1] or "")
    self.battle_ui.short_act_text_2:setText(text[2] and "[voice:battle][shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. text[2] or "")
    self.battle_ui.short_act_text_3:setText(text[3] and "[voice:battle][shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. text[3] or "")
end

function LightBattle:checkGameOver()
    for _,battler in ipairs(self.party) do
        if not battler.is_down then
            return
        end
    end
    self.music:stop()
    if self:getState() == "DEFENDING" then
        for _,wave in ipairs(self.waves) do
            wave:onEnd(true)
        end
    end
    self:shakeCamera(0)
    if self.encounter:onGameOver() then
        return
    end
    if self.encounter.invincible then
        MagicalGlassLib:gameNotOver(self:getSoulLocation())
    else
        Game:gameOver(self:getSoulLocation())
    end
end

function LightBattle:battleText(text,post_func)
    local target_state = self:getState()
    self.battle_ui.encounter_text.text.line_offset = 4 -- accuracy thing
    
    if type(text) == "table" then
        for key,line in ipairs(text) do
            text[key] = "[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. line
        end
    else
        text = "[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. text
    end

    self.battle_ui.encounter_text:setText(text, function()
        self.battle_ui:clearEncounterText()
        if type(post_func) == "string" then
            target_state = post_func
        elseif type(post_func) == "function" and post_func() then
            return
        end
        self:setState(target_state)
    end)

    self.battle_ui.encounter_text:setAdvance(true)
    self:setState("BATTLETEXT")
end

function LightBattle:infoText(text)
    self.battle_ui.encounter_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. text or "")
end

function LightBattle:setEncounterText(options, instant)
    self.battle_ui:clearEncounterText()

    actor = options.actor
    if isClass(actor) and actor:includes(PartyBattler) then
        actor = actor.chara.actor
    end

    if isClass(actor) and actor:includes(PartyMember) then
        actor = actor.actor
    end

    self.battle_ui.encounter_text:setActor(actor)
    self.battle_ui.encounter_text:setFace(options.portrait)

    local text = options.text or ""
    if instant then
        if type(text) == "table" then
            text = "[instant]" .. text[#text]
        else
            text = "[instant]" .. text
        end
    end

    self.battle_ui.encounter_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]"..text)
end

function LightBattle:hasCutscene()
    return self.cutscene and not self.cutscene.ended
end

function LightBattle:startCutscene(group, id, ...)
    if self.cutscene then
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
    self.cutscene = BattleCutscene(group, id, ...)
    return self.cutscene
end

function LightBattle:startActCutscene(group, id, dont_finish)
    local action = self:getCurrentAction()
    local cutscene
    if type(id) ~= "string" then
        dont_finish = id
        cutscene = self:startCutscene(group, self.party[action.character_id], action.target)
    else
        cutscene = self:startCutscene(group, id, self.party[action.character_id], action.target)
    end
    return cutscene:after(function()
        if not dont_finish then
            self:finishAction(action)
        end
        self:setState("ACTIONS", "CUTSCENE")
    end)
end

function LightBattle:sortChildren()
    -- Sort battlers by Y position
    table.stable_sort(self.children, function(a, b)
        return a.layer < b.layer or (a.layer == b.layer and (a:includes(Battler) and b:includes(Battler)) and a.y < b.y)
    end)
end

function LightBattle:customHealthDisplay(type, health) -- Won't do anything in multi-mode due to lack of space
    if type and type >= 2 then
        self.max_hp_display = health
    else
        self.hp_display = health
    end
end

function LightBattle:update()
    for _,enemy in ipairs(self.enemies_to_remove) do
        Utils.removeFromTable(self.enemies, enemy)
        local enemy_y = Utils.getKey(self.enemies_index, enemy)
        if enemy_y then
            self.enemies_index[enemy_y] = false
        end
    end
    self.enemies_to_remove = {}

    if self.cutscene then
        if not self.cutscene.ended then
            self.cutscene:update()
        else
            self.cutscene = nil
        end
    end
    if Game.battle == nil then return end -- cutscene ended the battle

    if self.state == "ATTACKING" then
        self:updateAttacking()
    elseif self.state == "ACTIONSDONE" then
        local any_hurt = false
        for _,enemy in ipairs(self.enemies) do
            if enemy.hurt_timer > 0 then
                any_hurt = true
                break
            end
        end
        if not any_hurt then
            self:resetAttackers()
            if not self.encounter:onActionsEnd() then
                self:setState("ENEMYDIALOGUE")
            end
        end
    elseif self.state == "ENEMYDIALOGUE" then
        self.textbox_timer = self.textbox_timer - DTMULT
        if (self.textbox_timer <= 0) and self.use_textbox_timer then
            self:advanceBoxes()
        else
            local all_done = true
            local boxes_done = true

            for _,textbox in ipairs(self.enemy_dialogue) do
                if textbox:isTyping() then
                    boxes_done = false
                end
            end

            for _,textbox in ipairs(self.enemy_dialogue) do
                if boxes_done then
                    textbox:setAdvance(true)
                end
            end

            for _,textbox in ipairs(self.enemy_dialogue) do
                if not textbox:isDone() then
                    all_done = false
                    break
                end
            end

            if all_done then
                self:setState("DIALOGUEEND")
            end
        end
    elseif self.state == "DEFENDINGBEGIN" then
        if self.arena:isNotTransitioning() then
            local soul_x, soul_y, soul_offset_x, soul_offset_y
            local arena_x, arena_y, arena_h, arena_w
            local has_arena = true
            local fullscreen = true
            for _,wave in ipairs(self.waves) do
                soul_x = wave.soul_start_x or soul_x
                soul_y = wave.soul_start_y or soul_y
                soul_offset_x = wave.soul_offset_x or soul_offset_x
                soul_offset_y = wave.soul_offset_y or soul_offset_y
                arena_x = wave.arena_x or arena_x
                arena_y = wave.arena_y or arena_y
                arena_h = wave.arena_height and math.max(wave.arena_height, arena_h or 0) or arena_h
                if not wave.has_arena then
                    has_arena = false
                end
                if not wave.fullscreen then
                    fullscreen = false
                end
            end

            arena_h, arena_w  = arena_h or 130, arena_w or 160
            
            local center_x, center_y = self.arena:getCenter()

            if fullscreen and #self.waves > 0 then
                if (self.arena.width ~= SCREEN_WIDTH or self.arena.height ~= SCREEN_HEIGHT) then
                    self.arena:changeShape({SCREEN_WIDTH, SCREEN_HEIGHT})
                end
                if not (self.arena.x == SCREEN_WIDTH/2 and self.arena.y == SCREEN_HEIGHT/2) then
                    self.arena:changePosition({SCREEN_WIDTH/2, SCREEN_HEIGHT/2})
                end
            elseif has_arena then
                if self.arena.height ~= arena_h then
                    self.arena:changeShape({self.arena.width, arena_h})
                end
                if not (self.arena.x == arena_x and self.arena.y == arena_y) then
                    self.arena:changePosition({arena_x, arena_y})
                end
            end
        end

        if self.arena:isNotTransitioning() then
            self:setState("DEFENDING")
            self.soul.can_move = true
        end
    elseif self.state == "DEFENDING" then
        local darken = false
        local alt_darken = false
        local time
        for _,wave in ipairs(self.waves) do
            if wave.darken then
                darken = true
                time = wave.time
                if wave.darken == "alt" then
                    alt_darken = true
                end
            end
        end
        
        if alt_darken then
            self.darkify_fader.layer = LIGHT_BATTLE_LAYERS["ui"] - 1.5
        else
            self.darkify_fader.layer = LIGHT_BATTLE_LAYERS["below_arena"]
        end

        if darken and self.wave_timer <= time - 9/30 then
            self.darkify_fader.alpha = Utils.approach(self.darkify_fader.alpha, 0.5, DTMULT * 0.05)
            if alt_darken then
                self.arena.alpha = Utils.approach(self.arena.alpha, 0.5, DTMULT * 0.05)
            end
        else
            self.darkify_fader.alpha = Utils.approach(self.darkify_fader.alpha, 0, DTMULT * 0.05)
            self.arena.alpha = Utils.approach(self.arena.alpha, 1, DTMULT * 0.05)
        end

        self:updateWaves()
    elseif self.state == "DEFENDINGEND" then
        for _,wave in ipairs(self.waves) do
            wave:onArenaExit()
        end
        self.waves = {}

        if #self.arena.target_position == 0 and #self.arena.target_shape == 0 and not self.forced_victory then
            self:setSubState("ARENARESET", "DEFENDINGEND")
            if self.state_reason == "TURNDONE" then
                self:setSubState("NONE")
                Input.clear("cancel", true)
                self:nextTurn()
            end
        end
    elseif self.state == "SHORTACTTEXT" then
        self:updateShortActText()
    end
    
    for _,battler in ipairs(self.party) do
        battler:update()
    end
    
    if self.state == "ACTIONSELECT" then
        local actbox = self.battle_ui.action_boxes[self.current_selecting]
        if actbox then
            actbox:snapSoulToButton()
        end
    end

    if self.state ~= "TRANSITIONOUT" then
        self.encounter:update()
    end

    if Utils.containsValue({"ACTIONSELECT", "MENUSELECT", "ENEMYSELECT", "PARTYSELECT", "FLEEING", "FLEEFAIL"}, self.state) then
        self:updateMenuWaves()
    end
    
    if Utils.containsValue({"DEFENDINGEND", "ACTIONSELECT", "ACTIONS", "VICTORY", "TRANSITIONOUT", "BATTLETEXT", "FLEEING", "FLEEFAIL", "BUTNOBODYCAME"}, self.state) then
        self.darkify_fader.alpha = Utils.approach(self.darkify_fader.alpha, 0, DTMULT * 0.05)
        self.arena.alpha = Utils.approach(self.arena.alpha, 1, DTMULT * 0.05)
    end
    
    self.update_child_list = true
    super.update(self)
end

function LightBattle:updateChildren()
    if self.update_child_list then
        self:updateChildList()
        self.update_child_list = false
    end
    for _,v in ipairs(self.draw_fx) do
        v:update()
    end
    for _,v in ipairs(self.children) do
        if v.active and v.parent == self and Game.battle == self then
            v:fullUpdate()
        end
    end
end

function LightBattle:shakeAttackSprite(sprite)
    sprite.timer = 0
    local function sprite_exist() return sprite.parent end
    self.timer:doWhile(sprite_exist, function()
        sprite.timer = sprite.timer + DTMULT
        if sprite.timer >= 1 then
            sprite:move(-2, -2)
            sprite:move(Utils.random(4), Utils.random(4))
            sprite.timer = 0
        end
    end)
end

function LightBattle:updateAttacking()
    if self.cancel_attack then
        self:finishAllActions()
        self:setState("ACTIONSDONE")
    end
    
    local function autoAttack(only_auto)
        if #self.auto_attackers > 0 then
            if self.auto_attack_timer < 8 then
                self.auto_attack_timer = self.auto_attack_timer + DTMULT

                if self.auto_attack_timer >= 8 or not only_auto and self:allActionsDone() then
                    self.auto_attacker_index = self.auto_attacker_index + 1
                    local next_attacker = self.auto_attackers[self.auto_attacker_index]

                    local next_action = self:getActionBy(next_attacker)
                    if next_action then
                        self:beginAction(next_action)
                        self:processAction(next_action)
                    end
                    if #self.auto_attackers == self.auto_attacker_index then
                        if only_auto then
                            local function all_actions_done() return self:allActionsDone() end
                            self.timer:afterCond(all_actions_done, function()
                                if self.forced_victory then return false end
                                self.battle_ui.attack_box.fading = true
                                self:setState("ACTIONSDONE")
                            end)
                        end
                    else
                        self.auto_attack_timer = 0
                    end
                end
            end
        end
    end

    if not self.attack_done then
        if not self.battle_ui.attacking then
            self.battle_ui:beginAttack()
        end
        
        local all_done = true
        
        if #self.attackers == #self.auto_attackers then
            autoAttack(true)
        end

        for _,attacker in ipairs(self.battle_ui.attack_box.lanes) do
            if not attacker.attacked then
                local box = self.battle_ui.attack_box
                if box:checkMiss(attacker) and #attacker.bolts > 1 then

                    all_done = false
                    box:miss(attacker)

                elseif box:checkMiss(attacker) then
                    local points = box:miss(attacker)

                    local action = self:getActionBy(attacker.battler)
                    if attacker.attack_type == "slice" then
                        action.force_miss = true
                        action.points = points or 0
                        action.stretch = 0
                    else
                        action.points = points
                    end

                    if self:processAction(action) then
                        self:finishAction(action)
                    end
                else
                    all_done = false
                end
            end
        end

        if #self.battle_ui.attack_box.lanes ~= 0 and all_done then
            self.attack_done = true
        end
    else
        autoAttack(false)
        if self:allActionsDone() then
            self:setState("ACTIONSDONE")
        end
    end
end

function LightBattle:draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    if self.encounter.background then
        self.encounter:drawBackground()
    end

    super.draw(self)

    self.encounter:draw()

    if DEBUG_RENDER then
        self:drawDebug()
    end
end

function LightBattle:getItemIndex()
    local page = math.ceil(self.current_menu_x / self.current_menu_columns) - 1
    return (self.current_menu_columns * (self.current_menu_y - 1) + (self.current_menu_x + (page * 2)))
end

function LightBattle:isValidMenuLocation()
    if self:getItemIndex() > #self.menu_items then
        return false
    end
    if self:isPagerMenu() then
        if (self.current_menu_y > self.current_menu_rows) or (self.current_menu_y < 1) then
            return false
        end
    else
        if (self.current_menu_x > Game.battle.current_menu_columns) or self.current_menu_x < 1 then
            return false
        end
    end
    return true
end

function LightBattle:advanceBoxes()
    local all_done = true
    local to_remove = {}

    for _,dialogue in ipairs(self.enemy_dialogue) do
        if dialogue:isTyping() then
            all_done = false
            break
        end
    end

    if all_done then
        self.textbox_timer = 3 * 30
        self.use_textbox_timer = true
        for _,dialogue in ipairs(self.enemy_dialogue) do
            dialogue:advance()
            if not dialogue:isDone() then
                all_done = false
            else
                table.insert(to_remove, dialogue)
            end
        end
    end

    for _,dialogue in ipairs(to_remove) do
        if #self.arena.target_shape == 0 then
            Utils.removeFromTable(self.enemy_dialogue, dialogue)
        end
    end

    if all_done then
        self:setState("DIALOGUEEND")
    end
end

function LightBattle:powerAct(spell, battler, user, target)

    local user_battler = self:getPartyBattler(user)
    local user_index = self:getPartyIndex(user)

    if user_battler == nil then
        Kristal.Console:error("Invalid power act user: " .. tostring(user))
        return
    end

    if type(spell) == "string" then
        spell = Registry.createSpell(spell)
    end

    local menu_item = {
        data = spell,
        tp = 0
    }

    if target == nil then
        if spell.target == "ally" then
            target = user_battler
        elseif spell.target == "party" then
            target = self.party
        elseif spell.target == "enemy" then
            target = self:getActiveEnemies()[1]
        elseif spell.target == "enemies" then
            target = self:getActiveEnemies()
        end
    end

    local name = user_battler.chara:getNameOrYou(true)
    self:setActText("* Your soul shined its power on\n" .. name .. ".", true)

    self.timer:after(7/30, function()
        Assets.playSound("boost")
        local bx, by = SCREEN_WIDTH / 2, SCREEN_HEIGHT - 15
        local soul = Sprite("effects/soulshine", bx, by)
        soul:play(1/30, false, function() soul:remove() end)
        soul:setOrigin(0.25, 0.25)
        soul:setScale(2, 2)
        self:addChild(soul)
    end)

    self.timer:after(24/30, function()
        self:pushAction("SPELL", target, menu_item, user_index)
        self:markAsFinished(nil, {user})
    end)
end

function LightBattle:pushForcedAction(battler, action, target, data, extra)
    data = data or {}

    data.cancellable = false

    self:pushAction(action, target, data, self:getPartyIndex(battler.chara.id), extra)
end

function LightBattle:pushAction(action_type, target, data, character_id, extra)
    character_id = character_id or self.current_selecting

    local battler = self.party[character_id]

    local current_state = self:getState()

    self:commitAction(battler, action_type, target, data, extra)

    if self.current_selecting == character_id then
        if current_state == self:getState() then
            self:nextParty()
        elseif self.cutscene then
            self.cutscene:after(function()
                self:nextParty()
            end)
        end
    end
end

function LightBattle:commitAction(battler, action_type, target, data, extra)
    data = data or {}
    extra = extra or {}

    local is_xact = action_type:upper() == "XACT"
    if is_xact then
        action_type = "ACT"
    end

    local tp_diff = 0
    if data.tp then
        tp_diff = Utils.clamp(-data.tp, -Game:getTension(), Game:getMaxTension() - Game:getTension())
    end

    local party_id = self:getPartyIndex(battler.chara.id)

    if not battler:isActive() then return end

    if data.party then
        for _,v in ipairs(data.party) do
            local index = self:getPartyIndex(v)

            if index ~= party_id then
                local action = self.character_actions[index]
                if action then
                    if action.cancellable == false then
                        return
                    end
                    if action.act_parent then
                        local parent_action = self.character_actions[action.act_parent]
                        if parent_action.cancellable == false then
                            return
                        end
                    end
                end
            end
        end
    end

    self:commitSingleAction(Utils.merge({
        ["character_id"] = party_id,
        ["action"] = action_type:upper(),
        ["party"] = data.party,
        ["name"] = data.name,
        ["target"] = target,
        ["data"] = data.data,
        ["tp"] = tp_diff,
        ["cancellable"] = data.cancellable,
    }, extra))

    if data.party then
        for _,v in ipairs(data.party) do
            local index = self:getPartyIndex(v)

            if index ~= party_id then
                local action = self.character_actions[index]
                if action then
                    if action.act_parent then
                        self:removeAction(action.act_parent)
                    else
                        self:removeAction(index)
                    end
                end

                self:commitSingleAction(Utils.merge({
                    ["character_id"] = index,
                    ["action"] = "SKIP",
                    ["reason"] = action_type:upper(),
                    ["name"] = data.name,
                    ["target"] = target,
                    ["data"] = data.data,
                    ["act_parent"] = party_id,
                    ["cancellable"] = data.cancellable,
                }, extra))
            end
        end
    end
end

function LightBattle:commitSingleAction(action)
    local battler = self.party[action.character_id]

    battler.action = action
    self.character_actions[action.character_id] = action

    if Kristal.callEvent(MG_EVENT.onLightBattleActionCommit, action, action.action, battler, action.target) then
        return
    end

    if action.action == "ITEM" and action.data then
        local result = action.data:onBattleSelect(battler, action.target)
        if result ~= false then
            local storage, index = Game.inventory:getItemIndex(action.data)

            action.item_storage = storage
            action.item_index = index
            if action.data:hasResultItem() then
                local result_item = action.data:createResultItem()
                Game.inventory:setItem(storage, index, result_item)
                action.result_item = result_item
            else
                Game.inventory:removeItem(action.data)
            end
            action.consumed = true
        else
            action.consumed = false
        end
    end

    local anim = action.action:lower()
    if action.action == "SPELL" and action.data then
        local result = action.data:onSelect(battler, action.target)
        if result ~= false then
            if action.tp then
                if action.tp > 0 then
                    Game:giveTension(action.tp)
                elseif action.tp < 0 then
                    Game:removeTension(-action.tp)
                end
            end
            action.icon = anim
        end
    else
        if action.tp then
            if action.tp > 0 then
                Game:giveTension(action.tp)
            elseif action.tp < 0 then
                Game:removeTension(-action.tp)
            end
        end

        if action.action == "SKIP" and action.reason then
            anim = action.reason:lower()
        end

        if (action.action == "ITEM" and action.data and (not action.data.instant)) or (action.action ~= "ITEM") then
            action.icon = anim
        end
    end
end

function LightBattle:removeAction(character_id)
    local action = self.character_actions[character_id]

    if action then
        self:removeSingleAction(action)

        if action.party then
            for _,v in ipairs(action.party) do
                if v ~= character_id then
                    local iaction = self.character_actions[self:getPartyIndex(v)]
                    if iaction then
                        self:removeSingleAction(iaction)
                    end
                end
            end
        end
    end
end

function LightBattle:removeSingleAction(action)
    local battler = self.party[action.character_id]

    if Kristal.callEvent(MG_EVENT.onLightBattleActionUndo, action, action.action, battler, action.target) then
        battler.action = nil
        self.character_actions[action.character_id] = nil
        return
    end

    if action.tp then
        if action.tp < 0 then
            Game:giveTension(-action.tp)
        elseif action.tp > 0 then
            Game:removeTension(action.tp)
        end
    end

    if action.action == "ITEM" and action.data and action.item_index then
        if action.consumed then
            if action.result_item then
                Game.inventory:setItem(action.item_storage, action.item_index, action.data)
            else
                Game.inventory:addItemTo(action.item_storage, action.item_index, action.data)
            end
        end
        action.data:onBattleDeselect(battler, action.target)
    elseif action.action == "SPELL" and action.data then
        action.data:onDeselect(battler, action.target)
    end

    battler.action = nil
    self.character_actions[action.character_id] = nil
end

function LightBattle:getPartyIndex(string_id)
    for index, battler in ipairs(self.party) do
        if battler.chara.id == string_id then
            return index
        end
    end
    return nil
end

function LightBattle:getPartyBattler(string_id)
    for _, battler in ipairs(self.party) do
        if battler.chara.id == string_id then
            return battler
        end
    end
    return nil
end

function LightBattle:getEnemyBattler(string_id)
    for _, enemy in ipairs(self.enemies) do
        if enemy.id == string_id then
            return enemy
        end
    end
end

function LightBattle:getEnemyFromCharacter(chara)
    for _, enemy in ipairs(self.enemies) do
        if self.enemy_world_characters[enemy] == chara then
            return enemy
        end
    end
    for _, enemy in ipairs(self.defeated_enemies) do
        if self.enemy_world_characters[enemy] == chara then
            return enemy
        end
    end
end

function LightBattle:hasAction(character_id)
    return self.character_actions[character_id] ~= nil
end

function LightBattle:getActiveEnemies()
    for _,enemy in pairs(self.enemies) do
        if enemy.done_state == "PRE-DEATH" and enemy.health > 0 then
            enemy.done_state = nil
        end
    end
    return Utils.filter(self.enemies, function(enemy) return not enemy.done_state end)
end

function LightBattle:getActiveParty()
    return Utils.filter(self.party, function(party) return not party.is_down end)
end

function LightBattle:resetEnemiesIndex(reset_xact)
    self.enemies_index = Utils.copy(self.enemies, true)
    if reset_xact ~= false then
        self.battle_ui:resetXACTPosition()
    end
end

function LightBattle:shakeCamera(x, y, friction)
    self.camera:shake(x, y, friction)
end

function LightBattle:randomTargetOld()
    local none_targetable = true
    for _,battler in ipairs(self.party) do
        if battler:canTarget() then
            none_targetable = false
            break
        end
    end

    if none_targetable then
        return "ALL"
    end

    local target = nil
    while not target do
        local party = Utils.pick(self.party)
        if party:canTarget() then
            target = party
        end
    end

    target.targeted = true
    return target
end

function LightBattle:randomTarget()
    local target = self:randomTargetOld()

    if (not Game:getConfig("targetSystem")) and (target ~= "ALL") then
        for _,battler in ipairs(self.party) do
            if battler:canTarget() then
                battler.targeted = true
            end
        end
        return "ANY"
    end

    return target
end

function LightBattle:targetAll()
    for _,battler in ipairs(self.party) do
        if battler:canTarget() then
            battler.targeted = true
        end
    end
    return "ALL"
end

function LightBattle:targetAny()
    for _,battler in ipairs(self.party) do
        if battler:canTarget() then
            battler.targeted = true
        end
    end
    return "ANY"
end

function LightBattle:target(target)
    -- only used in dt mode
    if type(target) == "number" then
        target = self.party[target]
    end

    if target and target:canTarget() then
        target.targeted = true
        return target
    end

    return self:targetAny()
end

function LightBattle:getPartyFromTarget(target)
    if type(target) == "number" then
        return {self.party[target]}
    elseif isClass(target) then
        return {target}
    elseif type(target) == "string" then
        if target == "ANY" then
            return {Utils.pick(self.party)}
        elseif target == "ALL" then
            return Utils.copy(self.party)
        else
            for _,battler in ipairs(self.party) do
                if battler.chara.id == string.lower(target) then
                    return {battler}
                end
            end
        end
    end
end

function LightBattle:hurt(amount, exact, target, swoon)
    -- If target is a numberic value, it will hurt the party battler with that index
    -- "ANY" will choose the target randomly
    -- "ALL" will hurt the entire party all at once
    target = target or "ANY"

    -- Alright, first let's try to adjust targets.

    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and target:includes(LightPartyBattler) then
        if (not target) or (target.chara:getHealth() <= 0) then -- Why doesn't this look at :canTarget()? Weird.
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        target = self:randomTargetOld()

        if isClass(target) and target:includes(LightPartyBattler) then
            -- Calculate the average HP of the party.
            -- This is "scr_party_hpaverage", which gets called multiple times in the original script.
            -- We'll only do it once here, just for the slight optimization. This won't affect accuracy.

            -- Speaking of accuracy, this function doesn't work at all!
            -- It contains a bug which causes it to always return 0, unless all party members are at full health.
            -- This is because of a random floor() call.
            -- I won't bother making the code accurate; all that matters is the output.

            local party_average_hp = 1

            for _,battler in ipairs(self.party) do
                if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                    party_average_hp = 0
                    break
                end
            end

            -- Retarget... twice.
            if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
                target = self:randomTargetOld()
            end
            if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
                target = self:randomTargetOld()
            end

            -- If we landed on Kris (or, well, the first party member), and their health is low, retarget (plot armor lol)
            if (target == self.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
                target = self:randomTargetOld()
            end

            target.targeted = true
        end
    end

    -- Now it's time to actually damage them!
    if isClass(target) and target:includes(LightPartyBattler) then
        target:hurt(amount, exact, nil, { swoon = self.encounter:canSwoon(target) and swoon })
        return {target}
    end

    if target == "ALL" then
        Assets.playSound("hurt")
        local alive_battlers = Utils.filter(self.party, function(battler) return not battler.is_down end)
        for _,battler in ipairs(alive_battlers) do
            battler:hurt(amount, exact, nil, { all = true, swoon = self.encounter:canSwoon(battler) and swoon })
        end
        -- Return the battlers who aren't down, aka the ones we hit.
        return alive_battlers
    end
end

function LightBattle:clearWaves()
    for _,wave in ipairs(self.waves) do
        if wave.auto_clear then
            wave:onEnd(false)
            wave:clear()
            wave:remove()
        end
    end
    self.waves = {}
end

function LightBattle:clearMenuWaves()
    for _,wave in ipairs(self.menu_waves) do
        if wave.auto_clear then
            wave:onEnd(false)
            wave:clear()
            wave:remove()
        end
    end
    self.menu_waves = {}
end

function LightBattle:setWaves(waves)
    self:clearWaves()
    self:clearMenuWaves()
    self.finished_waves = false
    local added_wave = {}
    for i,wave in ipairs(waves) do
        if type(wave) == "string" then
            wave = MagicalGlassLib:getLightWave(wave)
        end
        if not wave:includes(LightWave) then
            error("Attempted to use Wave in a LightBattle. Convert \""..waves[i].."\" to a LightWave")
        end
    end
    for i,wave in ipairs(waves) do
        local exists = (type(wave) == "string" and added_wave[wave]) or (isClass(wave) and added_wave[wave.id])
        if type(wave) == "string" then
            wave = MagicalGlassLib:createLightWave(wave)
        end
        if wave:getAllowDuplicates() or not exists then
            wave.encounter = self.encounter
            self:addChild(wave)
            table.insert(self.waves, wave)
            added_wave[wave.id] = true

            wave.active = false
        end
    end
    return self.waves
end

function LightBattle:setMenuWaves(waves)
    self:clearWaves()
    self:clearMenuWaves()
    self.finished_menu_waves = false
    local added_wave = {}
    for i,wave in ipairs(waves) do
        if type(wave) == "string" then
            wave = MagicalGlassLib:getLightWave(wave)
        end
        if not wave:includes(LightWave) then
            error("Attempted to use Wave in a LightBattle. Convert \""..waves[i].."\" to a LightWave")
        end
    end
    for i,wave in ipairs(waves) do
        local exists = (type(wave) == "string" and added_wave[wave]) or (isClass(wave) and added_wave[wave.id])
        if type(wave) == "string" then
            wave = MagicalGlassLib:createLightWave(wave)
        end
        if wave:getAllowDuplicates() or not exists then
            wave.encounter = self.encounter
            self:addChild(wave)
            table.insert(self.menu_waves, wave)
            added_wave[wave.id] = true

            wave.active = false
        end
    end
    return self.menu_waves
end

function LightBattle:startProcessing()
    self.has_acted = false
    if not self.encounter:onActionsStart() then
        self:setState("ACTIONS")
    end
end

function LightBattle:setSelectedParty(index)
    self.current_selecting = index or 0
end

function LightBattle:menuSelectMemory()
    local reason = {"MERCY"}
    for lib_id,_ in Kristal.iterLibraries() do
        reason = Kristal.libCall(lib_id, "getLightMenuSelectMemory", reason) or reason
    end
    reason = Kristal.modCall("getLightMenuSelectMemory", reason) or reason
    return reason
end

function LightBattle:actionButtonPairs()
    local pairs = {{"act", "magic"}, {"mercy", "spare", "defend"}}
    for lib_id,_ in Kristal.iterLibraries() do
        pairs = Kristal.libCall(lib_id, "getLightActionButtonPairs", pairs) or pairs
    end
    pairs = Kristal.modCall("getLightActionButtonPairs", pairs) or pairs
    return pairs
end

function LightBattle:nextParty()
    table.insert(self.selected_character_stack, self.current_selecting)
    table.insert(self.selected_action_stack, Utils.copy(self.character_actions))

    local all_done = true
    local last_selected = self.current_selecting
    
    self.current_selecting = (self.current_selecting % #self.party) + 1
    while self.current_selecting ~= last_selected do
        if not self:hasAction(self.current_selecting) and self.party[self.current_selecting]:isActive() then
            all_done = false
            break
        end
        self.current_selecting = (self.current_selecting % #self.party) + 1
    end
    
    local last_button_type = ""
    local found = false
    for _,action_box in ipairs(self.battle_ui.action_boxes) do
        if action_box.battler == self.party[last_selected] then
            for i,button in ipairs(action_box.buttons or {}) do
                if i == action_box.last_button then
                    last_button_type = button.type
                    break
                end
            end
            break
        end
    end
    for _,action_box in ipairs(self.battle_ui.action_boxes) do
        if action_box.battler == self.party[self.current_selecting] then
            for i,button in ipairs(action_box.buttons or {}) do
                if button.type == last_button_type then
                    action_box.selected_button = i
                    found = true
                    break
                end
            end
            if not found then
                local group
                for _,pair in ipairs(self:actionButtonPairs()) do
                    if Utils.containsValue(pair, last_button_type) then
                        group = pair
                        break
                    end
                end
                if group then
                    for i,button in ipairs(action_box.buttons or {}) do
                        if Utils.containsValue(group, button.type) then
                            action_box.selected_button = i
                            found = true
                            break
                        end
                    end
                end
            end
            if not found then
                action_box.selected_button = action_box.last_button or 1
            end
            break
        end
    end

    if all_done then
        self:toggleSoul(false)
        self.selected_character_stack = {}
        self.selected_action_stack = {}
        self.current_action_processing = 1
        self.current_selecting = 0
        self.last_button_type = last_button_type
        self:startProcessing()
    else
        if self:getState() ~= "ACTIONSELECT" then
            self:setState("ACTIONSELECT")
            self.battle_ui.encounter_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. self.battle_ui.current_encounter_text)
        else
            local party = self.party[self.current_selecting]
            party.chara:onLightActionSelect(party, false)
            self.encounter:onCharacterTurn(party, false)
        end
    end
end

function LightBattle:previousParty()
    if #self.selected_character_stack == 0 then
        return
    end

    self.current_selecting = self.selected_character_stack[#self.selected_character_stack] or 1
    local new_actions = self.selected_action_stack[#self.selected_action_stack-1] or {}

    for i,battler in ipairs(self.party) do
        local old_action = self.character_actions[i]
        local new_action = new_actions[i]
        if new_action ~= old_action then
            if old_action.cancellable == false then
                new_actions[i] = old_action
            else
                if old_action then
                    self:removeSingleAction(old_action)
                end
                if new_action then
                    self:commitSingleAction(new_action)
                end
            end
        end
    end

    self.selected_action_stack[#self.selected_action_stack-1] = new_actions

    table.remove(self.selected_character_stack, #self.selected_character_stack)
    table.remove(self.selected_action_stack, #self.selected_action_stack)

    local party = self.party[self.current_selecting]
    party.chara:onLightActionSelect(party, true)
    self.encounter:onCharacterTurn(party, true)
end

function LightBattle:checkSolidCollision(collider)
    if NOCLIP then return false end
    Object.startCache()
    if self.arena then
        if self.arena:collidesWith(collider) then
            Object.endCache()
            return true, self.arena
        end
    end
    for _,solid in ipairs(Game.stage:getObjects(Solid)) do
        if solid:collidesWith(collider) then
            Object.endCache()
            return true, solid
        end
    end
    Object.endCache()
    return false
end

function LightBattle:removeEnemy(enemy, defeated)
    table.insert(self.enemies_to_remove, enemy)
    if defeated then
        table.insert(self.defeated_enemies, enemy)
    end
end

function LightBattle:parseEnemyIdentifier(id)
    local args = Utils.split(id, ":")
    local enemies = Utils.filter(self.enemies, function(enemy) return enemy.id == args[1] end)
    return enemies[args[2] and tonumber(args[2]) or 1]
end

function LightBattle:clearMenuItems()
    self.menu_items = {}
end

function LightBattle:addMenuItem(tbl)
    tbl = {
        ["name"] = tbl.name or "",
        ["shortname"] = tbl.shortname or nil,
        ["seriousname"] = tbl.seriousname or nil,
        ["tp"] = tbl.tp or 0,
        ["unusable"] = tbl.unusable or false,
        ["description"] = tbl.description or "",
        ["party"] = tbl.party or {},
        ["color"] = tbl.color or {1, 1, 1, 1},
        ["data"] = tbl.data or nil,
        ["callback"] = tbl.callback or function() end,
        ["highlight"] = tbl.highlight or nil,
        ["icons"] = tbl.icons or nil,
        ["special"] = tbl.special or nil
    }
    table.insert(self.menu_items, tbl)
end

function LightBattle:onKeyPressed(key)
    if Kristal.Config["debug"] and Input.ctrl() then
        if key == "h" then
            Assets.playSound("power")
            for _,party in ipairs(self.party) do
                party:heal(math.huge)
            end
        end
        if key == "y" then
            Input.clear(nil, true)
            self.forced_victory = true
            if Utils.containsValue({"DEFENDING", "DEFENDINGBEGIN", "ENEMYDIALOGUE"}, self.state) then
                self.encounter:onWavesDone()
            end
            self:setState("VICTORY")
        end
        if key == "m" then
            if self.music then
                if self.music:isPlaying() then
                    self.music:pause()
                else
                    self.music:resume()
                end
            end
        end
        if self.state == "DEFENDING" and key == "f" then
            self.encounter:onWavesDone()
        end
        if self.soul and self.soul.visible and self.state == "DEFENDING" and key == "j" then
            self.soul:shatter(6)
            self:toggleSoul(false)
        end
        if key == "b" then
            self:hurt(math.huge, true, "ALL")
        end
        if key == "k" then
            Game:setTension(Game:getMaxTension() * 2, true)
        end
        if key == "n" then
            NOCLIP = not NOCLIP
        end
    end

    if self.state == "MENUSELECT" then
        local menu_width = self.current_menu_columns
        local menu_height = math.ceil(#self.menu_items / self.current_menu_columns)
        if Input.isConfirm(key) then

            local menu_item = self.menu_items[self:getItemIndex()]
            local can_select = self:canSelectMenuItem(menu_item)
            if self.encounter:onMenuSelect(self.state_reason, menu_item, can_select) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattleMenuSelect, self.state_reason, menu_item, can_select) then return end

            if not self:isPagerMenu() then
                self.menuselect_cursor_memory[self.state_reason] = {x = self.current_menu_x, y = self.current_menu_y}
            end

            if can_select then
                if menu_item.special ~= "flee" then
                    self.ui_select:stop()
                    self.ui_select:play()
                end
                menu_item["callback"](menu_item)
                return
            end
        elseif Input.isCancel(key) then
            if self.encounter:onMenuCancel(self.state_reason, menu_item) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattleMenuCancel, self.state_reason, menu_item, can_select) then return end
            Game:setTensionPreview(0)

            if not self:isPagerMenu() then
                self.menuselect_cursor_memory[self.state_reason] = {x = self.current_menu_x, y = self.current_menu_y}
            end

            if self.state_reason == "ACT" then
                self:setState("ENEMYSELECT", "ACT")
            elseif self.state_reason == "MERCY" then
                self:setState("ACTIONSELECT", "CANCEL")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            Input.clear(key, true)
            return
        elseif Input.is("left", key) then
            local page = math.ceil(self.current_menu_x / self.current_menu_columns) - 1
            local max_page = math.ceil(#self.menu_items / (self.current_menu_columns * self.current_menu_rows))
            local old_position = self.current_menu_x

            self.current_menu_x = self.current_menu_x - 1
            if self.current_menu_x < 1 then -- vomit
                self.current_menu_x = self.current_menu_columns * (max_page - self.current_menu_x)
                while not self:isValidMenuLocation() do
                    self.current_menu_x = self.current_menu_x - 1
                end
                if not self:isPagerMenu() and self.current_menu_x % 2 ~= 0 and menu_width > 1 and #self.menu_items > 1 then
                    self.current_menu_y = self.current_menu_y - 1
                    self.current_menu_x = self.current_menu_columns

                    if not self:isValidMenuLocation() then
                        self.current_menu_y = 1
                    end
                end
            end
            if self.current_menu_x ~= old_position then
                self.ui_move:stop()
                self.ui_move:play()
            end
        elseif Input.is("right", key) then
            local old_position = self.current_menu_x
            self.current_menu_x = self.current_menu_x + 1
            if not self:isPagerMenu() and not self:isValidMenuLocation() and menu_width > 1 and #self.menu_items > 1 then
                if self.current_menu_x % 2 == 0 then
                    self.current_menu_y = self.current_menu_y - 1
                    if not self:isValidMenuLocation() then
                        self.current_menu_y = 1
                        self.current_menu_x = 2
                        if not self:isValidMenuLocation() then
                            self.current_menu_x = 1
                        end
                    end
                end
                if not self:isValidMenuLocation() then
                    self.current_menu_x = 1
                end
            elseif not self:isValidMenuLocation() then
                self.current_menu_x = 1  
            end
            if self:isPagerMenu() or self.current_menu_x ~= old_position then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
        if Input.is("up", key) then
            local old_position = self.current_menu_y
            self.current_menu_y = self.current_menu_y - 1
            if (self.current_menu_y < 1) or (not self:isValidMenuLocation()) then
                if self:isPagerMenu() then
                    self.current_menu_y = self.current_menu_rows
                    if not self:isValidMenuLocation() then
                        self.current_menu_y = self.current_menu_rows - 1
                        if not self:isValidMenuLocation() then
                            self.current_menu_y = self.current_menu_rows - 2
                        end
                    end
                else
                    self.current_menu_y = menu_height
                    if not self:isValidMenuLocation() then
                        if #self.menu_items <= 6 then
                            self.current_menu_y = self.current_menu_y - 1
                        else
                            self.current_menu_x = self.current_menu_x - 1
                        end
                    end
                end
            end
            if self:isPagerMenu() or self.current_menu_y ~= old_position then
                self.ui_move:stop()
                self.ui_move:play()
            end
        elseif Input.is("down", key) then
            local old_position = self.current_menu_y
            if self:isPagerMenu() then 
                self.current_menu_y = self.current_menu_y + 1
                if (self.current_menu_y > self.current_menu_rows) or (not self:isValidMenuLocation()) then
                    self.current_menu_y = 1
                end
            else
                if self:getItemIndex() % 6 == 0 and #self.menu_items % 6 == 1 and self.current_menu_y == menu_height - 1 and menu_width == 2 then
                    self.current_menu_x = self.current_menu_x - 1
                end
                self.current_menu_y = self.current_menu_y + 1
                if self.current_menu_y > menu_height or not self:isValidMenuLocation() then
                    self.current_menu_y = 1
                end
            end
            if self:isPagerMenu() or self.current_menu_y ~= old_position then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
    elseif self.state == "BUTNOBODYCAME" then
        if Input.isConfirm(key) then
            self.music:stop()
            self.current_selecting = 0

            self:resetParty()

            self:setState("TRANSITIONOUT", "POSTFADE")
            self.encounter:onBattleEnd()
        end

    elseif self.state == "ENEMYSELECT" then
        if Input.isConfirm(key) then
            if self.encounter:onEnemySelect(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattleEnemySelect, self.state_reason, self.current_menu_y) then return end
            self.enemyselect_cursor_memory[self.state_reason] = self.current_menu_y

            self.ui_select:stop()
            self.ui_select:play()
            if #self.enemies_index == 0 then return end
            self.selected_enemy = self.current_menu_y
            if self.state_reason == "XACT" then
                local xaction = Utils.copy(self.selected_xaction)
                if xaction.default then
                    xaction.name = self.enemies_index[self.selected_enemy]:getXAction(self.party[self.current_selecting])
                end
                self:pushAction("XACT", self.enemies_index[self.selected_enemy], xaction)
            elseif self.state_reason == "SPARE" then
                self:pushAction("SPARE", self.enemies_index[self.selected_enemy])
            elseif self.state_reason == "ACT" and self.party[self.current_selecting].has_save and self.enemies_index[self.selected_enemy].save_no_acts then
                self:pushAction("SAVE", self.enemies_index[self.selected_enemy])
            elseif self.state_reason == "ACT" then
                self:clearMenuItems()
                self.current_menu_columns = 2
                self.current_menu_rows = 3
                local enemy = self.enemies_index[self.selected_enemy]
                for _,v in ipairs(enemy.acts) do
                    local insert = not v.hidden
                    if v.character and self.party[self.current_selecting].chara.id ~= v.character then
                        insert = false
                    end
                    if v.party and (#v.party > 0) then
                        for _,party_id in ipairs(v.party) do
                            if not self:getPartyIndex(party_id) then
                                insert = false
                                break
                            end
                        end
                    end
                    if insert then
                        self:addMenuItem({
                            ["name"] = v.name,
                            ["tp"] = v.tp or 0,
                            ["description"] = v.description,
                            ["party"] = v.party,
                            ["color"] = v.color or {1, 1, 1, 1},
                            ["highlight"] = v.highlight or enemy,
                            ["icons"] = v.icons,
                            ["callback"] = function(menu_item)
                                self:pushAction("ACT", enemy, menu_item)
                            end
                        })
                    end
                end
                self:setState("MENUSELECT", "ACT")
            elseif self.state_reason == "ATTACK" then
                self:pushAction("ATTACK", self.enemies_index[self.selected_enemy])
            elseif self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.enemies_index[self.selected_enemy], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.enemies_index[self.selected_enemy], self.selected_item)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            if self.encounter:onEnemyCancel(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattleEnemyCancel, self.state_reason, self.current_menu_y) then return end
            self.enemyselect_cursor_memory[self.state_reason] = self.current_menu_y

            if self.state_reason == "SPELL" or self.state_reason == "XACT" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            Input.clear(key, true)
            return
        end
        if Input.is("up", key) then
            if #self.enemies_index == 0 then return end
            local old_location = self.current_menu_y
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y - 1
                if self.current_menu_y < 1 then
                    self.current_menu_y = #self.enemies_index
                end
            until (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        elseif Input.is("down", key) then
            if #self.enemies_index == 0 then return end
            local old_location = self.current_menu_y
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y + 1
                if self.current_menu_y > #self.enemies_index then
                    self.current_menu_y = 1
                end
            until (self.enemies_index[self.current_menu_y] and self.enemies_index[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
    elseif self.state == "PARTYSELECT" then
        if Input.isConfirm(key) then
            if self.encounter:onPartySelect(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattlePartySelect, self.state_reason, self.current_menu_y) then return end
            self.partyselect_cursor_memory[self.state_reason] = self.current_menu_y

            self.ui_select:stop()
            self.ui_select:play()
            if self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.party[self.current_menu_y], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.party[self.current_menu_y], self.selected_item)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            if self.encounter:onPartyCancel(self.state_reason, self.current_menu_y) then return end
            if Kristal.callEvent(MG_EVENT.onLightBattlePartyCancel, self.state_reason, self.current_menu_y) then return end
            self.partyselect_cursor_memory[self.state_reason] = self.current_menu_y
            
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            Input.clear(key, true)
            return
        end
        if Input.is("up", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = #self.party
            end
        elseif Input.is("down", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y + 1
            if self.current_menu_y > #self.party then
                self.current_menu_y = 1
            end
        end
    elseif self.state == "BATTLETEXT" then
        -- Nothing here
    elseif self.state == "SHORTACTTEXT" then
        -- Nothing here
    elseif self.state == "ENEMYDIALOGUE" then
        -- Nothing here
    elseif self.state == "ACTIONSELECT" then
        self:handleActionSelectInput(key)
    elseif self.state == "ATTACKING" then
        self:handleAttackingInput(key)
    end
end

function LightBattle:hasReducedTension()
    return self.encounter:hasReducedTension()
end

function LightBattle:getDefendTension(battler)
    return self.encounter:getDefendTension(battler)
end

function LightBattle:handleActionSelectInput(key)
    if not self.encounter.event then
        local actbox = self.battle_ui.action_boxes[self.current_selecting]

        if Input.isConfirm(key) then
            actbox:select()
            self.ui_select:stop()
            self.ui_select:play()
            return
        elseif Input.isCancel(key) then
            local old_selecting = self.current_selecting

            self:previousParty()

            if self.current_selecting ~= old_selecting then
                self.ui_move:stop()
                self.ui_move:play()
                self.battle_ui.action_boxes[self.current_selecting]:unselect()
            end
            return
        elseif Input.is("left", key) and #self.battle_ui.action_boxes[self.current_selecting].buttons > 1 then
            actbox.selected_button = actbox.selected_button - 1
            self.ui_move:stop()
            self.ui_move:play()
            if actbox then
                actbox:snapSoulToButton()
            end
        elseif Input.is("right", key) and #self.battle_ui.action_boxes[self.current_selecting].buttons > 1 then
            actbox.selected_button = actbox.selected_button + 1
            self.ui_move:stop()
            self.ui_move:play()
            if actbox then
                actbox:snapSoulToButton()
            end
        end
    end
end

function LightBattle:handleAttackingInput(key)
    if Input.isConfirm(key) then
        if not self.attack_done and not self.cancel_attack and self.battle_ui.attack_box then
            local closest
            local closest_attacks = {}
            local close

            for _,attack in ipairs(self.battle_ui.attack_box.lanes) do
                if not attack.attacked then
                    close = self.battle_ui.attack_box:getFirstBolt(attack)
                    if not closest then
                        closest = close
                        table.insert(closest_attacks, attack)
                    elseif close == closest then
                        table.insert(closest_attacks, attack)
                    elseif close < closest then
                        closest = close
                        closest_attacks = {attack}
                    end
                end
            end

            if closest and (closest <= 280 or not Game.battle.multi_mode) then
                for _,attack in ipairs(closest_attacks) do
                    local points, stretch = self.battle_ui.attack_box:hit(attack)

                    local action = self:getActionBy(attack.battler)
                    action.points = points
                    action.stretch = stretch

                    if self:processAction(action) then
                        self:finishAction(action)
                    end
                end
            end
        end
    end
end

function LightBattle:updateWaves()
    self.wave_timer = self.wave_timer + DT

    local all_done = true
    for _,wave in ipairs(self.waves) do
        if not wave.finished then
            if wave.time >= 0 and self.wave_timer >= wave.time then
                wave.finished = true
            else
                all_done = false
            end
        end
        if not wave:canEnd() then
            all_done = false
        end
    end

    if all_done and not self.finished_waves then
        self.finished_waves = true
        self.encounter:onWavesDone()
    end
end

function LightBattle:updateMenuWaves()
    self.menu_wave_timer = self.menu_wave_timer + DT

    local all_done = true
    for _,wave in ipairs(self.menu_waves) do
        if not wave.finished then
            if wave.time >= 0 and self.menu_wave_timer >= wave.time then
                wave.finished = true
            else
                all_done = false
            end
        end
        if not wave:canEnd() then
            all_done = false
        end
    end

    if all_done and not self.finished_menu_waves then
        self.finished_menu_waves = true
        self.encounter:onMenuWavesDone()
    end
end


function LightBattle:updateShortActText()
    if Input.pressed("confirm") or Kristal.getLibConfig("magical-glass", "undertale_text_skipping") ~= false and Input.down("menu") then
        if (not self.battle_ui.short_act_text_1:isTyping()) and
           (not self.battle_ui.short_act_text_2:isTyping()) and
           (not self.battle_ui.short_act_text_3:isTyping()) then
            self.battle_ui.short_act_text_1:setText("")
            self.battle_ui.short_act_text_2:setText("")
            self.battle_ui.short_act_text_3:setText("")
            for _,iaction in ipairs(self.short_actions) do
                self:finishAction(iaction)
            end
            self.short_actions = {}
            self:setState("ACTIONS", "SHORTACTTEXT")
        end
    end
end

function LightBattle:debugPrintOutline(string, x, y, color)
    color = color or {love.graphics.getColor()}
    Draw.setColor(0, 0, 0, 1)
    love.graphics.print(string, x - 1, y)
    love.graphics.print(string, x + 1, y)
    love.graphics.print(string, x, y - 1)
    love.graphics.print(string, x, y + 1)

    Draw.setColor(color)
    love.graphics.print(string, x, y)
end

function LightBattle:drawDebug()
    local font = Assets.getFont("main", 16)
    love.graphics.setFont(font)

    Draw.setColor(1, 1, 1, 1)
    self:debugPrintOutline("State: "    .. self.state   , 4, 0)
    self:debugPrintOutline("Substate: " .. self.substate, 4, 0 + 16)
end

function LightBattle:canDeepCopy() -- what
    return false
end

return LightBattle