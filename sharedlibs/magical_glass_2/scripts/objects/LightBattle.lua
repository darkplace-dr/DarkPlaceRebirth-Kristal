local LightBattle, super = Class(Object, "LightBattle")

-- welp

function LightBattle:init()
    super.init(self)

    self.allow_party = MagicalGlass.party_members
    self.encounter_group = nil

    self.state = "NONE"
    self.state_reason = nil
    self.state_extra = {}

    self.substate = "NONE"
    self.substate_reason = nil
    self.substate_extra = {}

    -- States that instantly end normal waves if they're active.
    -- Equivalent of remove_arena from Battle:update
    self.wave_end_states = {
        "DEFENDINGEND", "TRANSITIONOUT", "ACTIONSELECT",
        "VICTORY", "INTRO", "ACTIONS",
        "ENEMYSELECT", "XACTENEMYSELECT", "PARTYSELECT",
        "MENUSELECT", "ATTACKING", "TURNDONE"
    }

    self.item_inventory = "items"

    self.party = {}
    self:createPartyBattlers()

    self.enemies = {}
    self.enemy_index = {}
    self.enemy_dialogue = {}
    self.defeated_enemies = {}

    self.enemies_to_remove = {}
    self.enemy_world_characters = {}

    self.money = 0
    self.exp = 0

    self.tension = nil
    self.can_defend = nil
    self.can_flee = nil

    self.turn_count = 0

    -- maybe put these in encounter?
    self.x_actions = {}

    self.encounter_context = nil
    self.used_violence = false

    self.current_selecting_index = 0

    self.queued_actions = {}

    self.selected_member_stack = {}
    self.selected_action_stack = {}

    self.current_actions = {}
    self.short_actions = {}
    self.current_action_index = 1
    self.processed_action = {}
    self.processing_action = false

    self.selected_x_action = nil

    self.should_finish_action = false
    self.on_finish_action = nil

    self.attackers = {}
    self.normal_attackers = {}
    self.auto_attackers = {}

    self.attack_done = false
    self.cancel_attack = false

    self.waves = {}
    self.finished_waves = false
    self.menu_waves = {}
    self.finished_menu_waves = false

    self.ui_move_sound = Assets.newSound("ui_move")
    self.ui_select_sound = Assets.newSound("ui_select")
    self.vaporized_sound = Assets.newSound("vaporized")

    self.arena = nil
    self.soul = nil
    
    self.battle_ui = nil

    self.camera = Camera(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.cutscene = nil

    self.music = Music()
    self.resume_world_music = false

    self.mask = ArenaMask()
    self:addChild(self.mask)

    self.timer = Timer()
    self:addChild(self.timer)

    self.fader = Fader()
    self.fader.layer = BATTLE_LAYERS["top"]
    self.fader.alpha = 1
    self:addChild(self.fader)

    self.darkify_fader = Fader()
    self.darkify_fader.layer = BATTLE_LAYERS["below_arena"]
    self:addChild(self.darkify_fader)

    self.enemy_dialogue_timer = nil
    self.use_dialogue_timer = true

    self.begin_arena_height = nil

    self.soul_appear_timer = nil
end

function LightBattle:playSelectSound()
    self.ui_select_sound:play()
end

function LightBattle:playMoveSound()
    self.ui_move_sound:play()
end

function LightBattle:playVaporizedSound()
    self.vaporized_sound:stop()
    self.vaporized_sound:play()
end

function LightBattle:createPartyBattlers()
    if not self.allow_party then
        local battler = LightPartyBattler(Game.party[1])
        self:addChild(battler)
        table.insert(self.party, battler)
    else
        for i = 1, math.min(4, #Game.party) do
            local battler = LightPartyBattler(Game.party[i])
            self:addChild(battler)
            table.insert(self.party, battler)
        end
    end
end

function LightBattle:getActiveParty()
    return Utils.filter(self.party, function(party) return not party.is_down end)
end

function LightBattle:getCurrentlySelectingMember()
    return self.party[self.current_selecting_index]
end

function LightBattle:getMemberAtIndex(index)
    return self.party[index]
end

function LightBattle:getPartyIndex(battler)
    if type(battler) == "string" then
        if self:getPartyBattler(battler) then
            battler = self:getPartyBattler(battler)
        else
            return nil
        end
    end

    for index, ibattler in ipairs(self.party) do
        if ibattler.chara.id == battler.chara.id then
            return index
        end
    end
    return nil
end

function LightBattle:getPartyBattler(battler_id)
    for _,battler in ipairs(self.party) do
        if battler.chara.id == battler_id then
            return battler
        end
    end
    return nil
end

function LightBattle:getEnemyBattler(battler_id)
    for _,enemy in ipairs(self.enemies) do
        if enemy.id == battler_id then
            return enemy
        end
    end
end

function LightBattle:getEnemyFromCharacter(chara)
    for _,enemy in ipairs(self.enemies) do
        if self.enemy_world_characters[enemy] == chara then
            return enemy
        end
    end
    for _,enemy in ipairs(self.defeated_enemies) do
        if self.enemy_world_characters[enemy] == chara then
            return enemy
        end
    end
end

function LightBattle:getBattlerID(battler)
    if isClass(battler) and battler:includes(LightPartyBattler) then
        return battler.chara.id
    elseif isClass(battler) and (battler:includes(PartyMember) or battler:includes(LightEnemyBattler)) then
        return battler.id
    end
end

function LightBattle:setSelectedParty(index)
    self.current_selecting = index or 0
end

function LightBattle:resetParty()
    for _,battler in ipairs(self.party) do
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

function LightBattle:getActiveEnemies()
    return Utils.filter(self.enemies, function(enemy) return not enemy.done_state end)
end

function LightBattle:getEncounterText()
    return self.encounter:getEncounterText()
end

function LightBattle:parseEnemyIdentifier(id)
    local args = Utils.split(id, ":")
    local enemies = Utils.filter(self.enemies, function(enemy) return enemy.id == args[1] end)
    return enemies[args[2] and tonumber(args[2]) or 1]
end

function LightBattle:postInit(state, encounter)
    self.state = state

    if type(encounter) == "string" then
        self.encounter = MagicalGlass:createLightEncounter(encounter)
    else
        self.encounter = encounter
    end

    if self.encounter:includes(Encounter) then
        error("Attempted to use Encounter in a LightBattle. Convert the encounter file to LightEncounter.")
    end

    if Game.world.music:isPlaying() and self.encounter.music then
        self.resume_world_music = true
        Game.world.music:pause()
    end

    if self.encounter.queued_enemy_spawns then
        for _,enemy in ipairs(self.encounter.queued_enemy_spawns) do
            table.insert(self.enemies, enemy)
            table.insert(self.enemy_index, enemy)
            self:addChild(enemy)
        end
    end

    self:toggleTension(self.encounter.allow_tension)
    self.can_defend = self.encounter.allow_defend
    self.can_flee = self.encounter.allow_flee

    self.arena = LightArena(SCREEN_WIDTH/2 - 1, 385)
    self.arena.layer = BATTLE_LAYERS["ui"]
    self:addChild(self.arena)

    self.battle_ui = LightBattleUI()
    self.battle_ui.layer = BATTLE_LAYERS["ui"]
    if self.encounter.story then
        self.battle_ui:setupStory()
    else
        self.battle_ui:setup()
    end
    self:addChild(self.battle_ui)

    if Game.encounter_enemies then
        for _,from in ipairs(Game.encounter_enemies) do
            if not isClass(from) then
                local enemy = self:parseEnemyIdentifier(from[1])
                from[2].battler = enemy
                self.enemy_world_characters[enemy] = from[2]
            else
                for _,enemy in ipairs(self.enemies) do
                    if enemy.actor and from.actor and enemy.actor.name == from.actor.name then
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

    if state == "TRANSITION" then
        self.encounter:onTransition()
    else
        self.fader:fadeIn({speed = 5/30})
    end

    if not self.encounter:onBattleInit() then
        self:setState(state)
    end
end

function LightBattle:getSoulPosition()
    if self.soul then
        return self.soul:getPosition()
    end
end

function LightBattle:spawnSoul(x, y)
    local color = {self.encounter:getSoulColor()}
    if not self.soul then
        self.soul = self.encounter:createSoul(x, y, color, {sprite = "player/heart_light"})
        self.soul:toggleGrazing(self.tension)
        self.soul.alpha = 1
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

function LightBattle:toggleSoul(active, can_move)
    if not self.soul then
        self:spawnSoul(self.arena:getCenter())
    end
    self.soul:toggle(active)

    if can_move ~= nil then
        self.soul.can_move = can_move
    else
        self.soul.can_move = active
    end
end

function LightBattle:toggleTension(active)
    if active == nil then
        self.tension = not self.tension
    else
        self.tension = active
    end

    if self.soul then
        self.soul:toggleGrazing(active)
    end
end

function LightBattle:setEncounterText(text)
    self.battle_ui:setEncounterText(text)
end

function LightBattle:clearEncounterText()
    self.battle_ui:clearEncounterText()
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

    local name = user_battler.chara:getName()
    if name == "Ralsei" then
        -- deltarune inconsistency lol
        name = "RALSEI"
    end
    self:setActText("* Your soul shined its power on\n" .. name .. "!", true)

    self.timer:after(7/30, function()
        Assets.playSound("boost")
    end)

    self.timer:after(24/30, function()
        self:pushAction("SPELL", target, menu_item, user_index)
        self:markActionAsFinished(nil, {user})
    end)
end

function LightBattle:nextTurn()
    self.turn_count = self.turn_count + 1

    if self.turn_count > 1 then
        if self.encounter:onTurnEnd() then
            return
        end

        for _,enemy in ipairs(self:getActiveEnemies()) do
            if enemy:onTurnEnd() then
                return
            end
        end
    end

    for _,battler in ipairs(self.party) do
        battler.chara:getWeapon():onLightBattleNextTurn(battler, self.turn_count)
        battler.chara:getArmor(1):onLightBattleNextTurn(battler, self.turn_count)

        if (battler.chara:getHealth() <= 0) and battler.chara:canAutoHeal() then
            battler:heal(battler.chara:autoHealAmount())
        end
    end

    for _,action in ipairs(self.current_actions) do
        if action.action == "DEFEND" then
            self:finishAction(action)
        end
    end

    self.queued_actions = {}
    self.current_actions = {}
    self.processed_action = {}

    self.attackers = {}
    self.normal_attackers = {}
    self.auto_attackers = {}

    if self.battle_ui then
        if not self.seen_encounter_text then
            self.seen_encounter_text = true
            self.battle_ui.current_encounter_text = self.encounter.text
        else
            self.battle_ui.current_encounter_text = self:getEncounterText()
        end
        self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
    end

    self.current_selecting_index = 1
    while not (self:getCurrentlySelectingMember():isActive()) do
        self.current_selecting_index = self.current_selecting_index + 1
        if self.current_selecting_index > #self.party then
            print("WARNING: nobody up! this shouldn't happen...")
            self.current_selecting_index = 1
            break
        end
    end

    if self.state ~= "ACTIONSELECT" then
        self:setState("ACTIONSELECT")
    end
end

function LightBattle:previousParty()
    if #self.selected_member_stack == 0 then
        return
    end

    self.battle_ui:clearStack()

    self.current_selecting_index = self.selected_member_stack[#self.selected_member_stack] or 1
    local new_actions = self.selected_action_stack[#self.selected_action_stack - 1] or {}

    for i, battler in ipairs(self.party) do
        local old_action = self.queued_actions[i]
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

    self.selected_action_stack[#self.selected_action_stack - 1] = new_actions

    table.remove(self.selected_member_stack, #self.selected_member_stack)
    table.remove(self.selected_action_stack, #self.selected_action_stack)

    local party = self:getCurrentlySelectingMember()
    party.chara:onActionSelect(party, true)
    self.encounter:onCharacterTurn(party, true)

    self.battle_ui:setupActionSelect(party)
end

function LightBattle:nextParty()
    self.battle_ui:clearStack()

    table.insert(self.selected_member_stack, self.current_selecting_index)
    table.insert(self.selected_action_stack, Utils.copy(self.queued_actions))

    local all_done = true
    local last_selected = self.current_selecting_index
    self.current_selecting_index = (self.current_selecting_index % #self.party) + 1
    while self.current_selecting_index ~= last_selected do
        if not self:hasAction(self.current_selecting_index) and self:getCurrentlySelectingMember():isActive() then
            all_done = false
            break
        end
        self.current_selecting_index = (self.current_selecting_index % #self.party) + 1
    end

    if all_done then
        self.selected_member_stack = {}
        self.selected_action_stack = {}
        self.current_action_processing = 1
        self.current_selecting_index = 0

        self.battle_ui:setupActionSelect(self:getActiveParty()[1])

        self:startProcessingActions()
    else
        if self:getState() ~= "ACTIONSELECT" then
            self:setState("ACTIONSELECT")
            self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
        else
            local party = self:getCurrentlySelectingMember()
            party.chara:onActionSelect(party, false)
            self.encounter:onCharacterTurn(party, false)
        end
    end
end

function LightBattle:getState()
    return self.state
end

function LightBattle:setState(state, reason, extra)
    local old = self.state
    self.state = state
    self.state_reason = reason
    self.state_extra = extra or {}
    self:onStateChange(old, self.state)
end

function LightBattle:onStateChange(old, new)
    local event_result = Kristal.callEvent(MagicalGlass.EVENT.beforeLightBattleStateChange, old, new, self.state_reason, self.state_extra)
    local enc_result = self.encounter:beforeStateChange(old, new, self.state_reason, self.state_extra)
    if event_result or enc_result or self.state ~= new then
        Kristal.callEvent(MagicalGlass.EVENT.onLightBattleStateChange, old, new, self.state_reason, self.state_extra)
        self.encounter:onStateChange(old, new, self.state_reason, self.state_extra)
        return
    end

    if new == "INTRO" then
        if self.encounter.story then
            self:setState("STORY")
        else
            self:nextTurn()
        end
        self.encounter:onBattleStart()
        if self.encounter.music then
            self.music:play(self.encounter.music)
        end
    elseif new == "STORY" then
        self:spawnSoul(self.encounter:getSoulTarget())
        self.soul.can_move = true
        if self.encounter:getStoryCutscene() then
            self:startCutscene(self.encounter:getStoryCutscene()):after(function()
                self:setState("TRANSITIONOUT")
            end)
        end
    elseif new == "ACTIONSELECT" then
        Input.clear("cancel", true)

        if self.current_selecting_index < 1 or self.current_selecting_index > #self.party then
            self:nextTurn()
            if self.state ~= "ACTIONSELECT" then
                return
            end
        end
        
        self.arena.layer = BATTLE_LAYERS["ui"]

        self:toggleSoul(true, false)

        if self.state_reason ~= "CANCEL" then
            local party = self:getCurrentlySelectingMember()
            party.chara:onActionSelect(party, false)
            self.encounter:onCharacterTurn(party, false)

            self.battle_ui:setupActionSelect(party)
        end

        self.battle_ui:clearEncounterText()
        self.battle_ui.encounter_text.text.line_offset = 5
        self:setEncounterText(self.battle_ui.current_encounter_text)
    elseif new == "ENEMYSELECT" then
        self:clearEncounterText()

        if self.state_reason == "ATTACK" then
            self.battle_ui:setupAttackEnemySelect(self.enemy_index)
        elseif self.state_reason == "ACT" then
            self.battle_ui:setupACTEnemySelect(self.enemy_index)
        elseif self.state_reason == "SPELL" then
            self.battle_ui:setupSpellEnemySelect(self.enemy_index, self.state_extra["spell"])
        elseif self.state_reason == "XACT" then
            self.battle_ui:setupXActionEnemySelect(self.enemy_index, self.state_extra["x_act"])
        end
    elseif new == "PARTYSELECT" then
        self:clearEncounterText()

        if self.state_reason == "SPELL" then
            if not self.allow_party or #self.party == 1 then
                self:pushAction("SPELL", self.party[1], self.state_extra["spell"])
            else
                self.battle_ui:setupSpellPartySelect(self.party, self.state_extra["spell"])
            end            
        elseif self.state_reason == "ITEM" then
            if not self.allow_party or #self.party == 1 then
                self:pushAction("ITEM", self.party[1], self.state_extra["item"])
            else
                self.battle_ui:setupItemPartySelect(self.party, self.state_extra["item"])
            end
        end
    elseif new == "MENUSELECT" then
        self:clearEncounterText()

        if self.state_reason == "ACT" then
            if self.state_extra.acts then
                self.battle_ui:setupACTSelect(self.state_extra["enemy"], self.state_extra["acts"])
            end
        elseif self.state_reason == "SPELL" then
            self.battle_ui:setupSpellSelect(self.state_extra["user"])
        elseif self.state_reason == "ITEM" then
            if not MagicalGlass.list_item_menu then
                self.battle_ui:setupItemSelect(Game.inventory:getStorage(self.item_inventory))
            else
                self.battle_ui:setupListItemSelect(Game.inventory:getStorage(self.item_inventory))
            end
        elseif self.state_reason == "MERCY" then
            self.battle_ui:setupMercySelect()
        end
    elseif new == "ACTIONS" then
        self:clearEncounterText()
        self:toggleSoul(false)
        self.battle_ui:clearStack()
        self.battle_ui.action_select:unselect()

        if self.state_reason ~= "DONTPROCESS" then
            self:tryProcessNextAction()
        end
    elseif new == "ATTACKING" then
        self:clearEncounterText()
        self:toggleSoul(false)

        local enemies_left = self:getActiveEnemies()

        if #enemies_left > 0 then
            for i, battler in ipairs(self.party) do
                local action = self.queued_actions[i]
                if action and action.action == "ATTACK" then
                    self:beginAction(action)
                    table.insert(self.attackers, battler)
                    table.insert(self.normal_attackers, battler)
--[[                 elseif action and action.action == "AUTOATTACK" then
                    table.insert(self.attackers, battler)
                    table.insert(self.auto_attackers, battler) ]]
                end
            end
        end

        self.auto_attack_timer = 0

        if #self.attackers == 0 then
            self.attack_done = true
            self:setState("ACTIONSDONE")
        else
            self.attack_done = false
            if self.allow_party then
                self.battle_ui:beginAttackMulti()
            else
                self.battle_ui:beginAttackSingle()
            end
        end
    elseif new == "ENEMYDIALOGUE" then
        self:clearEncounterText()
        self:toggleSoul(false)
        self.battle_ui:clearStack()
        self.battle_ui.action_select:unselect()

        self.current_selecting = 0
        self.enemy_dialogue_timer = 3 * 30
        self.use_dialogue_timer = true

        local active_enemies = self:getActiveEnemies()
        if #active_enemies == 0 then
            self:setState("VICTORY")
            return
        end

        for _,enemy in ipairs(active_enemies) do
            enemy.current_target = enemy:getTarget()
        end

        self:setupWaves()

        local cutscenes = {self.encounter:getDialogueCutscene()}
        if #cutscenes > 0 then
            self:startCutscene(unpack(cutscenes)):after(function()
                self:setState("DIALOGUEEND")
            end)
        else
            local playing_dialogue = false
            for _,enemy in ipairs(active_enemies) do
                local dialogue = enemy:getEnemyDialogue()
                if dialogue then
                    playing_dialogue = true
                    local bubble = enemy:spawnSpeechBubble(dialogue)
                    bubble:setSkippable(false)
                    table.insert(self.enemy_dialogue, bubble)
                end
                if not playing_dialogue then
                    self:setState("DIALOGUEEND")
                end
            end
        end
    elseif new == "DIALOGUEEND" then
        if not self.soul.visible then
            self:toggleSoul(true, true)
        end

        self:clearEncounterText()
        self.battle_ui:clearStack()
        self.battle_ui.action_select:unselect()

        -- make defending take effect
        for i, battler in ipairs(self.party) do
            local action = self.queued_actions[i]
            if action and action.action == "DEFEND" then
                self:beginAction(action)
                self:processAction(action)
            end
        end

        if not self.encounter:onDialogueEnd() then
            self:setState("DEFENDINGBEGIN")
        end
    elseif new == "DEFENDINGBEGIN" then
        local dont_change = false
        for _,wave in ipairs(self.waves) do
            if wave.arena_shape then
                dont_change = true
                break
            end
        end
        
        if not dont_change then
            self.arena:setTargetSize(nil, self.begin_arena_height)
            self.begin_arena_height = nil
        else
            self.begin_arena_height = nil
        end

        self.soul.can_move = true

        self:setState("DEFENDING")
    elseif new == "DEFENDING" then
        self.wave_length = 0
        self.wave_timer = 0

        for _,wave in ipairs(self.waves) do
            wave.encounter = self.encounter

            self.wave_length = math.max(self.wave_length, wave.time)

            wave:onStart()
            wave.active = true
        end

        self.soul:onWaveStart()
    elseif new == "DEFENDINGEND" then
        self:resetArena()
    elseif new == "TURNDONE" then
        for _,wave in ipairs(self.waves) do
            wave:onArenaExit()
        end
        self.waves = {}

        Input.clear("cancel", true)
        self:nextTurn()
    elseif new == "FLEESTART" then
        self:clearEncounterText()
        self:toggleSoul(true, false)
        self.battle_ui:clearStack()
        self.battle_ui.action_select:unselect()
    
        self.current_selecting = 0

        for _,party in ipairs(self.party) do
            self:removeQueuedAction(self:getPartyIndex(party))
        end

        if MagicalGlass.always_flee or self.encounter:attemptFlee(self.turn_count) then
            self.ui_select_sound:stop()
            self:setState("FLEEING")
        else
            self:setState("ACTIONSDONE")
        end
    elseif new == "FLEEING" then
        self:handleFlee()
    elseif new == "VICTORY" then
        self:handleVictory()
    elseif new == "TRANSITIONOUT" then
        self.ended = true
        self.current_selecting = 0
        if self.encounter_context and self.encounter_context:includes(ChaserEnemy) then
            for _,enemy in ipairs(self.encounter_context:getGroupedEnemies(true)) do
                enemy:onEncounterTransitionOut(enemy == self.encounter_context, self.encounter)
            end
        end

        -- toby
        if self:getSubState() == "VICTORY" then
            self:returnToWorld()
            Game.fader:fadeIn(nil, {alpha = 1, speed = 7/30})
        else
            Game.fader:transition(function() self:returnToWorld() end, nil, {speed = 10/30})
        end
    end

    local should_end_waves = true
    if Utils.containsValue(self.wave_end_states, new) then
        for _,wave in ipairs(self.waves) do
            if wave:beforeEnd() then
                should_end_waves = false
            end
        end
        if should_end_waves then
            for _,battler in ipairs(self.party) do
                battler.targeted = false
            end
        end
    end

    if old == "DEFENDING" and new ~= "ENEMYDIALOGUE" and should_end_waves then
        self:clearWaves()
        
        if self:hasCutscene() then
            self.cutscene:after(function()
                self:setState("TURNDONE", "WAVEENDED")
            end)
        else
            self.timer:after(15/30, function()
                self:setState("TURNDONE", "WAVEENDED")
            end)
        end
    end

    Kristal.callEvent(MagicalGlass.EVENT.onLightBattleStateChange, old, new, self.state_reason, self.state_extra)
    self.encounter:onStateChange(old, new, self.state_reason, self.state_extra)
end

function LightBattle:getSubState()
    return self.substate
end

function LightBattle:setSubState(state, reason, extra)
    local old = self.substate
    self.substate = state
    self.substate_reason = reason
    self.substate_extra = extra or {}
    self:onSubStateChange(old, self.substate)
end

function LightBattle:onSubStateChange(old, new)
    local event_result = Kristal.callEvent(MagicalGlass.EVENT.beforeLightBattleSubStateChange, old, new, self.state_reason, self.state_extra)
    local enc_result = self.encounter:beforeSubStateChange(old, new, self.state_reason, self.state_extra)
    if event_result or enc_result or self.substate ~= new then
        Kristal.callEvent(MagicalGlass.EVENT.onLightBattleSubStateChange, old, new, self.state_reason, self.state_extra)
        self.encounter:onSubStateChange(old, new, self.state_reason, self.state_extra)
        return
    end

    -- Do shit here

    Kristal.callEvent(MagicalGlass.EVENT.onLightBattleSubStateChange, old, new, self.state_reason, self.state_extra)
    self.encounter:onSubStateChange(old, new, self.state_reason, self.state_extra)
end

function LightBattle:setupWaves()
    if self.state_reason then -- self.state_reason is used to force a wave in this context
        self:setWaves(self.state_reason)
        local enemy_found = false
        for i, enemy in ipairs(self.enemies) do
            if Utils.containsValue(enemy.waves, self.state_reason[1]) then
                enemy.selected_wave = self.state_reason[1]
                enemy_found = true
            end
        end
        if not enemy_found then
            self.enemies[love.math.random(1, #self.enemies)].selected_wave = self.state_reason[1]
        end
    else
        self:setWaves(self.encounter:getNextWaves())
    end

    local has_arena = true 
    local dont_change_shape = false

    local has_soul = false  

    local instant_transition = false

    local soul_x, soul_y
    local soul_offset_x, soul_offset_y

    local arena_x, arena_y
    local arena_offset_x, arena_offset_y
    local arena_w, arena_h
    local arena_shape

    local center_x, center_y

    for _,wave in ipairs(self.waves) do
        if not wave.has_arena then
            has_arena = false
        end

        if wave.dont_change_shape then
            dont_change_shape = true
        end

        if wave.has_soul then
            has_soul = true
        end

        if wave.instant_transition_in then
            instant_transition = true
        end

        soul_x = wave.soul_start_x or soul_x
        soul_y = wave.soul_start_y or soul_y

        soul_offset_x = wave.soul_offset_x or soul_offset_x
        soul_offset_y = wave.soul_offset_y or soul_offset_y

        arena_x = wave.arena_x or arena_x
        arena_y = wave.arena_y or arena_y

        arena_offset_x = wave.arena_offset_x or arena_offset_x
        arena_offset_y = wave.arena_offset_y or arena_offset_y

        if wave.arena_shape then
            arena_shape = wave.arena_shape
        else
            arena_w = wave.arena_width and math.max(wave.arena_width, arena_w or 0) or arena_w
            arena_h = wave.arena_height and math.max(wave.arena_height, arena_h or 0) or arena_h
        end

        wave:beforeStart()
    end

    if has_arena then
        if not dont_change_shape then
            if not arena_shape then
                arena_x, arena_y = (arena_x or self.arena.x) + (arena_offset_x or 0), (arena_y or self.arena.y) + (arena_offset_y or 0)
                arena_w, arena_h = arena_w or 160, arena_h or 130

                self.arena:setPosition(arena_x, arena_y)

                if self.encounter.story or instant_transition then
                    self.arena:setSize(arena_w, arena_h)
                else
                    self.arena:setTargetSize(arena_w)
                    self.begin_arena_height = arena_h
                end
            else
                self.arena:setShape(arena_shape)
            end
        end
        center_x, center_y = self.arena:getCenter()
    else
        self.arena:disable()
        center_x, center_y = self.arena:getCenter()
    end

    if has_soul then
        soul_x = soul_x or (soul_offset_x and center_x + soul_offset_x)
        soul_y = soul_y or (soul_offset_y and center_y + soul_offset_y)
        self.soul:setPosition(soul_x or center_x, soul_y or center_y)
        self.soul.can_move = false

        self.soul_appear_timer = 2
    end
end

function LightBattle:setWaves(waves)
    self:clearWaves()
    self:clearMenuWaves()
    self.finished_waves = false
    local added_wave = {}
    for _,wave in ipairs(waves) do
        local exists = (type(wave) == "string" and added_wave[wave]) or (isClass(wave) and added_wave[wave.id])
        if type(wave) == "string" then
            wave = MagicalGlass:createLightWave(wave)
        end
        if wave.allow_duplicates or not exists then
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
    for _,wave in ipairs(waves) do
        local exists = (type(wave) == "string" and added_wave[wave]) or (isClass(wave) and added_wave[wave.id])
        if type(wave) == "string" then
            wave = MagicalGlass:createLightWave(wave)
        end
        if wave.allow_duplicates or not exists then
            wave.encounter = self.encounter
            self:addChild(wave)
            table.insert(self.menu_waves, wave)
            added_wave[wave.id] = true

            wave.active = false
        end
    end
    return self.menu_waves
end

function LightBattle:resetArena()
    local dont_change_shape
    local instant_transition

    for _,wave in ipairs(self.waves) do
        if wave.dont_change_shape then
            dont_change_shape = true
        end
        if wave.instant_transition_out then
            instant_transition = true
        end
    end

    if not dont_change_shape then
        if instant_transition then
            if self.arena.x ~= self.arena.init_x then self.arena.x = self.arena.init_x end
            if self.arena.y ~= self.arena.init_y then self.arena.y = self.arena.init_y end

            self.arena:setSize(self.arena.init_width, self.arena.init_height)
        else
            if self.arena.height >= self.arena.init_height then
                self.arena:resetPosition(function()
                    self.arena:setTargetSize(nil, self.arena.init_height, function()
                        self.arena:setTargetSize(self.arena.init_width)
                    end)
                end)
            else
                self.arena:resetPosition(function()
                    self.arena:setTargetSize(self.arena.init_width, nil, function()
                        self.arena:setTargetSize(nil, self.arena.init_height)
                    end)
                end)
            end
        end
    end

    self.arena:enable()
end

function LightBattle:handleFlee()
    self:resetParty()

    if self.encounter:onFlee() then return end
    
    Assets.playSound("escaped")

    local flee_text
    if not self.used_violence then
        flee_text = self.encounter:getFleeMessage()
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
        self.exp = self.encounter:getVictoryEXP(self.exp) or self.exp

        if Game:isLight() then
            Game.lw_money = Game.lw_money + self.money
    
            if (Game.lw_money < 0) then
                Game.lw_money = 0
            end

            local leveled_up = false
            for _,battler in ipairs(self.party) do
                local result = battler.chara:gainLightEXP(self.exp)
                if result then
                    leveled_up = true
                end
            end

            if leveled_up then Assets.playSound("levelup") end
    
            flee_text = self.encounter:getRewardFleeMessage(self.exp, self.money)
        else
            Game.money = Game.money + self.money
            Game.xp = Game.xp + self.exp
    
            if (Game.money < 0) then
                Game.money = 0
            end

            flee_text = self.encounter:getRewardFleeMessage(self.exp, self.money)

            if Game:getConfig("growStronger") then
                local stronger = "You"
    
                for _,battler in ipairs(self.party) do
                    Game.level_up_count = Game.level_up_count + 1
                    battler.chara:onLevelUp(Game.level_up_count)
    
                    if battler.chara.id == Game:getConfig("growStrongerChara") then
                        stronger = battler.chara:getName()
                    end
                end
        
                Assets.playSound("dtrans_lw", 0.7, 2)
            end
        end
    end
    
    self.battle_ui:setFleeText(flee_text)

    self.soul.collidable = false
    self.soul.y = self.soul.y + 4
    self.soul.sprite:setAnimation({"player/heartgtfo", 1/15, true})
    self.soul.physics.speed_x = -3

    Game.battle.timer:after(1, function()
        self:setState("TRANSITIONOUT")
        self.encounter:onBattleEnd(true)
    end)
end

function LightBattle:handleVictory()
    self:setSubState("VICTORY")

    self:clearEncounterText()

    self.battle_ui:clearStack()
    self.battle_ui.action_select:unselect()

    self.music:stop()
    self.current_selecting = 0

    self:resetParty()

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
    self.exp = self.encounter:getVictoryEXP(self.exp) or self.exp

    local win_text
    if Game:isLight() then
        Game.lw_money = Game.lw_money + self.money

        if (Game.lw_money < 0) then
            Game.lw_money = 0
        end

        local leveled_up = false
        for _,battler in ipairs(self.party) do
            local result = battler.chara:gainLightEXP(self.exp)
            if result then
                leveled_up = true
            end
        end

        win_text = "* YOU WON!\n* You earned " .. self.exp .. " EXP and " .. self.money .. " " .. Game:getConfig("lightCurrency"):lower() .. "."

        if leveled_up then
            Assets.playSound("levelup")
            win_text = win_text .. "\n* Your LOVE increased."
        end
    else
        Game.money = Game.money + self.money
        Game.xp = Game.xp + self.exp

        if (Game.money < 0) then
            Game.money = 0
        end

        win_text = "* You won!\n* Got " .. self.exp .. " EXP and " .. self.money .. " "..Game:getConfig("darkCurrencyShort").."."

        if self.used_violence and Game:getConfig("growStronger") then
            local stronger = "You"

            for _,battler in ipairs(self.party) do
                Game.level_up_count = Game.level_up_count + 1
                battler.chara:onLevelUp(Game.level_up_count)

                if battler.chara.id == Game:getConfig("growStrongerChara") then
                    stronger = battler.chara:getName()
                end
            end

            win_text = "* You won!\n* Got " .. self.money .. " "..Game:getConfig("darkCurrencyShort")..".\n* "..stronger.." became stronger."

            Assets.playSound("dtrans_lw", 0.7, 2)
        end
    end

    win_text = self.encounter:getVictoryText(win_text, self.money, self.exp) or win_text

    if self.encounter.no_end_message then
        self:setState("TRANSITIONOUT")
        self.encounter:onBattleEnd()
    else
        self:battleText(win_text, function()
            self:setState("TRANSITIONOUT")
            self.encounter:onBattleEnd()
            return true
        end)
    end
end

function LightBattle:battleText(text, after, toggle_soul)
    local target_state = self:getState()
    self.battle_ui.encounter_text.text.line_offset = 4 -- toby jesus christ

    self.battle_ui:setEncounterText(text, function()
        self:clearEncounterText()
        if type(after) == "string" then
            target_state = after
        elseif type(after) == "function" and after() then
            return
        end
        self:setState(target_state)
    end)

    if self.soul and (toggle_soul == nil or toggle_soul) then
        self:toggleSoul(false)
    end

    self.battle_ui.encounter_text:setAdvance(true)
    self:setState("BATTLETEXT")
end

function LightBattle:hasAction(battler)
    if type(battler) ~= "string" and type(battler) ~= "number" then
        battler = self:getPartyIndex(battler)
    end

    return self.queued_actions[battler] ~= nil
end

function LightBattle:getActionBy(battler, ignore_current)
    for i, party in ipairs(self.party) do
        if party == battler then
            local action = self.queued_actions[i]
            if action then
                return action
            end
            break
        end
    end

    if ignore_current then
        return nil
    end

    for _,action in ipairs(self.current_actions) do
        local ibattler = self.party[action.party_index]
        if ibattler == battler then
            return action
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

    local party_index = self:getPartyIndex(battler)

    -- Don't commit this action if the battler isn't active
    if not battler:isActive() then return end

    -- Make sure this action doesn't cancel any uncancellable actions
    if data.party then
        for _,battler in ipairs(data.party) do
            local index = self:getPartyIndex(battler)

            if index ~= party_index then
                local action = self.queued_actions[index]
                if action then
                    if action.cancellable == false then
                        return
                    end
                    if action.act_parent then
                        local parent_action = self.queued_actions[action.act_parent]
                        if parent_action.cancellable == false then
                            return
                        end
                    end
                end
            end
        end
    end

    self:commitSingleAction(Utils.merge({
        ["party_index"] = party_index,
        ["action"] = action_type:upper(),
        ["party"] = data.party,
        ["name"] = data.name,
        ["target"] = target,
        ["data"] = data.data,
        ["tp"] = tp_diff,
        ["cancellable"] = data.cancellable,
    }, extra))

    -- Queue the SKIP action for members involved with this action
    if data.party then
        for _,battler in ipairs(data.party) do
            local index = self:getPartyIndex(battler)

            if index ~= party_index then
                local action = self.queued_actions[index]
                if action then
                    if action.act_parent then
                        self:removeQueuedAction(action.act_parent)
                    else
                        self:removeQueuedAction(index)
                    end
                end

                self:commitSingleAction(Utils.merge({
                    ["party_index"] = index,
                    ["action"] = "SKIP",
                    ["reason"] = action_type:upper(),
                    ["name"] = data.name,
                    ["target"] = target,
                    ["data"] = data.data,
                    ["act_parent"] = party_index,
                    ["cancellable"] = data.cancellable,
                }, extra))
            end
        end
    end
end

function LightBattle:pushAction(action_type, target, data, party_index, extra)
    party_index = party_index or self.current_selecting_index

    local battler = self:getMemberAtIndex(party_index)

    local current_state = self:getState()

    self:commitAction(battler, action_type, target, data, extra)

    if self.current_selecting_index == party_index then
        if current_state == self:getState() then
            self:nextParty()
        elseif self.cutscene then
            self.cutscene:after(function()
                self:nextParty()
            end)
        end
    end
end

function LightBattle:pushForcedAction(battler, action, target, data, extra)
    data = data or {}

    data.cancellable = false

    self:pushAction(action, target, data, self:getPartyIndex(battler), extra)
end

function LightBattle:commitSingleAction(action)
    local battler = self:getMemberAtIndex(action.party_index)

    battler.action = action
    self.queued_actions[action.party_index] = action

    if Kristal.callEvent(MagicalGlass.EVENT.onLightBattleActionCommit, action, action.action, battler, action.target) then
        return
    end

    -- Remove the selected item so other members can't use it
    if action.action == "ITEM" and action.data then
        local result = action.data:onLightBattleSelect(battler, action.target)
        if result ~= false then
            local storage, index = Game.inventory:getItemIndex(action.data)
            action.item_storage = storage
            action.item_index = index
            if action.data:hasResultItem() then
                local result_item = action.data:createResultItem()
                Game.inventory:setItem(storage, index, result_item)
                action.result_item = result_item
            else
                local item = action.data
                if item:includes(LightEquipItem) and item.battle_swap_equip then
                    if not self.allow_party then
                        -- replace weapons and armors instantly in solo mode
                        local replaced
                        if item.type == "weapon" then
                            if battler.chara:getWeapon() then
                                replaced = battler.chara:getWeapon()
                                replaced:onUnequip(chara, item)
                                Game.inventory:setItem(storage, index, battler.chara:getWeapon())
                            end
                            battler.chara:setWeapon(item)
                        elseif item.type == "armor" then
                            if battler.chara:getArmor(1) then
                                replaced = battler.chara:getArmor(1)
                                replaced:onUnequip(chara, item)
                                Game.inventory:setItem(storage, index, battler.chara:getArmor(1))
                            end
                            battler.chara:setArmor(1, item)
                        end
                        item:onEquip(battler.chara, replaced)
                    else
                        -- otherwise, store the item in the action to be swapped later
                        if item.type == "weapon" then
                            if battler.chara:getWeapon() then
                                action.replaced_item = battler.chara:getWeapon()
                            end
                        elseif item.type == "armor" then
                            if battler.chara:getArmor(1) then
                                action.replaced_item = battler.chara:getArmor(1)
                            end
                        end
                        Game.inventory:removeItem(item)
                    end
                else
                    Game.inventory:removeItem(item)
                end
            end
            action.consumed = true
        else
            action.consumed = false
        end
    end

    if action.action == "SPELL" and action.data then
        local result = action.data:onLightBattleSelect(battler, action.target)
        if result ~= false then
            if action.tp then
                if action.tp > 0 then
                    Game:giveTension(action.tp)
                elseif action.tp < 0 then
                    Game:removeTension(-action.tp)
                end
            end

        end
    else
        if action.tp then
            if action.tp > 0 then
                Game:giveTension(action.tp)
            elseif action.tp < 0 then
                Game:removeTension(-action.tp)
            end
        end
    end
end

function LightBattle:removeQueuedAction(party_index)
    local action = self.queued_actions[party_index]

    if action then
        self:removeSingleAction(action)

        if action.party then
            for _,battler in ipairs(action.party) do
                if v ~= party_index then
                    local iaction = self.queued_actions[self:getPartyIndex(battler)]
                    if iaction then
                        self:removeSingleAction(iaction)
                    end
                end
            end
        end
    end
end

function LightBattle:removeSingleAction(action)
    local battler = self:getMemberAtIndex(action.party_index)

    if Kristal.callEvent(MagicalGlass.EVENT.onLightBattleActionUndo, action, action.action, battler, action.target) then
        battler.action = nil
        self.queued_actions[action.party_index] = nil
        return
    end

    if action.tp then
        if action.tp < 0 then
            Game:giveTension(-action.tp)
        elseif action.tp > 0 then
            Game:removeTension(action.tp)
        end
    end

    -- Give items removed by commitSingleAction back
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
        action.data:onLightBattleDeselect(battler, action.target)
    end

    battler.action = nil
    self.queued_actions[action.party_index] = nil
end

function LightBattle:markActionAsFinished(action)
    if self:getState() ~= "BATTLETEXT" then
        self:finishAction(action)
    else
        self.on_finish_action = action
        self.should_finish_action = true
    end
end

function LightBattle:finishAction(action)
    action = action or self.current_actions[self.current_action_index]

    local battler = self:getMemberAtIndex(action.party_index)

    self.processed_action[action] = true

    if self.processing_action == action then
        self.processing_action = nil
    end

    if action.action == "ATTACK" then
        if action.missed and not action.no_miss then
            action.target:hurt(0, battler, nil, false)
        elseif action.final_damage then
            local sound = action.target:getDamageSound() or "damage"
            if sound then
                Assets.stopAndPlaySound(sound)
            end
            action.target:hurt(action.final_damage, battler)
        end
    end

    local all_done = self:allActionsDone()

    if all_done then
        for _,iaction in ipairs(Utils.copy(self.current_actions)) do
            local ibattler = self:getMemberAtIndex(iaction.party_index)

            local party_num = 1
            local callback = function()
                party_num = party_num - 1
                if party_num == 0 then
                    Utils.removeFromTable(self.current_actions, iaction)
                    self:tryProcessNextAction()
                end
            end

            if iaction.party then
                for _,party in ipairs(iaction.party) do
                    local jbattler = self.party[self:getPartyIndex(party)]

                    if jbattler ~= ibattler then
                        party_num = party_num + 1

                        callback()
                    end
                end
            end

            callback()

            if iaction.action == "DEFEND" then
                ibattler.defending = false
            end

            Kristal.callEvent(MagicalGlass.EVENT.onLightBattleActionEnd, iaction, iaction.action, ibattler, iaction.target, dont_end)
        end
    else
        -- Process actions if we can
        self:tryProcessNextAction()
    end
end

function LightBattle:finishActionBy(battler)
    for _,action in ipairs(self.current_actions) do
        local ibattler = self:getMemberAtIndex(action.party_index)
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

function LightBattle:startProcessingActions()
    self.has_acted = false
    if not self.encounter:onActionsStart() then
        self:setState("ACTIONS")
    end
end

function LightBattle:processQueuedActions()
    if self.state ~= "ACTIONS" then
        self:setState("ACTIONS", "DONTPROCESS")
    end

    self.current_action_index = 1

    local order = {{"ACT", "SPELL", "ITEM"}, "SPARE"}
    order = Kristal.callEvent(MagicalGlass.EVENT.getLightBattleActionOrder, order, self.encounter) or order

    -- SKIP actions go last
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
            local action = self.queued_actions[i]
            if action and action.action == group then
                found = true
                self:beginAction(action)
            end
        end
        for _,action in ipairs(self.current_actions) do
            self.queued_actions[action.party_index] = nil
        end
        return found
    else
        for i,battler in ipairs(self.party) do
            local action = self.queued_actions[i]
            if action and Utils.containsValue(group, action.action) then
                self.queued_actions[i] = nil
                self:beginAction(action)
                return true
            end
        end
    end
end

function LightBattle:tryProcessNextAction()
    if self.state == "ACTIONS" and not self.processing_action then
        if #self.current_actions == 0 then
            self:processQueuedActions()
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

function LightBattle:getCurrentAction()
    return self.current_actions[self.current_action_index]
end

function LightBattle:beginAction(action)
    local battler = self:getMemberAtIndex(action.party_index)
    local target = action.target

    -- Add the action to the actions table, for group processing
    table.insert(self.current_actions, action)

    -- Set the state
    if self.state == "ACTIONS" then
        self:setSubState(action.action)
    end

    -- Call mod callbacks for adding new beginAction behaviour
    if Kristal.callEvent(MagicalGlass.EVENT.onLightBattleActionBegin, action, action.action, battler, enemy) then
        return
    end

    if action.action == "ACT" then
        target:onActStart(battler, action.name)
    end
end

function LightBattle:processAction(action)
    local battler = self:getMemberAtIndex(action.party_index)
    local party_member = battler.chara
    local target = action.target

    self.current_processing_action = action

    if self:enemyExists(target) and target.done_state then
        target = self:retargetEnemy()
        action.target = target
        if not self:enemyExists(target) then
            return true
        end
    end

    local result = Kristal.callEvent(MagicalGlass.EVENT.onLightBattleAction, action, action.action, battler, target)
    if result ~= nil then
        return result
    end

    if action.action == "SKIP" then
        return true
    elseif action.action == "SPARE" then
        return self:processSpareAction(action, battler, target)
    elseif action.action == "ACT" then
        return self:processACTAction(action, battler, target)
    elseif action.action == "SPELL" then
        return self:processSpellAction(action, battler, target)
    elseif action.action == "ITEM" then
        return self:processItemAction(action, battler, target)
    elseif action.action == "ATTACK" or action.action == "AUTOATTACK" then
        return self:processAttackAction(action, battler, target)
    elseif action.action == "DEFEND" then
        return self:processDefendAction(action, battler, target)
    else
        -- we don't know how to handle this...
        Kristal.Console:warn("Unhandled battle action: " .. tostring(action.action))
        return true
    end
end

function LightBattle:processSpareAction(action, battler, target)
    for _,enemy in ipairs(self:getActiveEnemies()) do
        enemy:onMercy(battler)
    end

    self:finishAction(action)
    return false
end

function LightBattle:processACTAction(action, battler, target)
    local short = false
    self.short_actions = {}
    for _,iaction in ipairs(self.current_actions) do
        if iaction.action == "ACT" then
            local ibattler = self:getMemberAtIndex(action.party_index)
            local itarget = iaction.target

            if itarget then
                local act = itarget and itarget:getAct(iaction.name)

                if (act and act.short) or (itarget:getXAction(ibattler) == iaction.name and itarget:isXActionShort(ibattler)) then
                    table.insert(self.short_actions, iaction)
                    if ibattler == battler then
                        short = true
                    end
                end
            end
        end
    end

    if short and #self.short_actions > 1 then
        local short_text = {}
        for _,iaction in ipairs(self.short_actions) do
            local ibattler = self:getMemberAtIndex(action.party_index)
            local itarget = iaction.target

            local act_text = itarget:onShortAct(ibattler, iaction.name)
            if act_text then
                table.insert(short_text, act_text)
            end
        end

        self:shortActText(short_text)
    else
        local text = target:onAct(battler, action.name)
        if text then
            self:setActText(text)
        end
    end

    return false
end

function LightBattle:processSpellAction(action, battler, target)
    self:clearEncounterText()

    -- The spell itself handles the animation and finishing
    action.data:onLightBattleStart(battler, target)

    return false
end

function LightBattle:processItemAction(action, battler, target)
    local item = action.data
    if item.instant then
        self:finishAction(action)
    else
        local result = item:onLightBattleUse(battler, action.target)
        if result or result == nil then
            if item:includes(LightEquipItem) and action.replaced_item then
                if item.type == "weapon" then
                    if battler.chara:getWeapon() then
                        action.replaced_item:onUnequip(chara, item)
                        Game.inventory:addItem(action.replaced_item)
                    end
                    battler.chara:setWeapon(item)
                elseif item.type == "armor" then
                    if battler.chara:getArmor(1) then
                        action.replaced_item:onUnequip(chara, item)
                        Game.inventory:addItem(action.replaced_item)
                    end
                    battler.chara:setArmor(1, item)
                end
                item:onEquip(battler.chara, action.replaced_item)
            end
            self:finishAction(action)
        end
    end
    return false
end

function LightBattle:processAttackAction(action, battler, target)
    -- kinda redundant but ok
    if self:enemyExists(action.target) and action.target.done_state then
        target = self:retargetEnemy()
        action.target = target
        if not self:enemyExists(target) then
            self.battle_ui.attack_target.cancelled = true
            self:finishAction(action)
            return
        end
    end

    if self:enemyExists(target) then
        local attack = action.group       
        local weapon = attack.weapon
        
        if not action.missed and action.points ~= 0 then
            local damage, crit = target:getAttackDamage(battler, attack, action.damage or 0)
            damage = math.max(0, damage)

            Game:giveTension(Utils.round(target:getAttackTension(action.points or 100)))

            local result, final_damage, ignore_damage = weapon:onLightBattleAttack(battler, target, damage, action.stretch, attack, crit)

            if not ignore_damage then
                if final_damage then
                    action.final_damage = math.max(0, final_damage)
                else
                    action.final_damage = damage
                end
            end

            if result or result == nil then
                self:finishAction(action)
            end
        else
            local result, no_miss = weapon:onLightBattleMiss(battler, target)
            action.no_miss = no_miss
            if result or result == nil then
                self:finishAction(action)
            end
        end
    end

    return false
end

function LightBattle:processDefendAction(action, battler, target)
    -- lmao
    battler.defending = true
    return false
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

function LightBattle:shortActText(text)
    self:setState("SHORTACTTEXT")
    self:clearEncounterText()

    self.battle_ui.short_act_text_1:setText(text[1] or "")
    self.battle_ui.short_act_text_2:setText(text[2] or "")
    self.battle_ui.short_act_text_3:setText(text[3] or "")
end

function LightBattle:hasCutscene()
    return self.cutscene and not self.cutscene.ended
end

function LightBattle:startCutscene(group, id, ...)
    if not self.encounter.story then
        self:toggleSoul(false)
        self.battle_ui:clearStack()
        self.battle_ui.action_select:unselect()
    end

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
    self.cutscene = LightBattleCutscene(group, id, ...)
    return self.cutscene
end

function LightBattle:startActCutscene(group, id, dont_finish)
    local action = self:getCurrentAction()
    local cutscene
    if type(id) ~= "string" then
        dont_finish = id
        cutscene = self:startCutscene(group, self:getMemberAtIndex(action.party_index), action.target)
    else
        cutscene = self:startCutscene(group, id, self:getMemberAtIndex(action.party_index), action.target)
    end
    return cutscene:after(function()
        if not dont_finish then
            self:finishAction(action)
        end
        self:setState("ACTIONS", "CUTSCENE")
    end)
end

function LightBattle:advanceDialogue()
    local all_done = true
    local to_remove = {}

    for _,bubble in ipairs(self.enemy_dialogue) do
        if bubble:isTyping() then
            all_done = false
            break
        end
    end

    if all_done then
        self.enemy_dialogue_timer = 3 * 30
        for _,bubble in ipairs(self.enemy_dialogue) do
            bubble:advance()
            if not bubble:isDone() then
                all_done = false
            else
                table.insert(to_remove, bubble)
            end
        end
    end

--[[     for _,bubble in ipairs(to_remove) do
        if #self.arena.target_shape == 0 then
            Utils.removeFromTable(self.enemy_dialogue, bubble)
        end
    end ]]

    if all_done then
        self:setState("DIALOGUEEND")
    end
end

function LightBattle:enemyExists(enemy)
    return enemy ~= nil and type(enemy) ~= "boolean"
end

function LightBattle:retargetEnemy()
    for _,other in ipairs(self.enemies) do
        if not other.done_state then
            return other
        end
    end
    return true
end

function LightBattle:clearWaves()
    for _,wave in ipairs(self.waves) do
        if wave.clear_on_end then
            wave:onEnd(false)
            wave:clear()
            wave:remove()
        end
    end
    self.waves = {}
end

function LightBattle:clearMenuWaves()
    for _,wave in ipairs(self.menu_waves) do
        if wave.clear_on_end then
            wave:onEnd(false)
            wave:clear()
            wave:remove()
        end
    end
    self.menu_waves = {}
end

function LightBattle:removeEnemy(enemy, defeated)
    table.insert(self.enemies_to_remove, enemy)
    if defeated then
        table.insert(self.defeated_enemies, enemy)
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

function LightBattle:hurt(amount, exact, target)
    -- for now this is unchanged from kristal's hurt function
    target = target or "ANY"

    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and (target:includes(PartyBattler) or target:includes(LightPartyBattler)) then
        if (not target) or (target.chara:getHealth() <= 0) then
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        target = self:randomTargetOld()

        local party_average_hp = 1

        for _,battler in ipairs(self.party) do
            if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                party_average_hp = 0
                break
            end
        end

        -- make an attack roll with disadvantage
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = self:randomTargetOld()
        end
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = self:randomTargetOld()
        end

        -- again
        if (target == self.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
            target = self:randomTargetOld()
        end
        
        target.targeted = true
    end

    if isClass(target) and target:includes(LightPartyBattler) then
        target:hurt(amount, exact)
        return {target}
    end

    if target == "ALL" then
        Assets.playSound("hurt")
        for _,battler in ipairs(self.party) do
            if not battler.is_down then
                battler:hurt(amount, exact, nil, {all = true})
            end
        end

        return Utils.filter(self.party, function(item) return not item.is_down end)
    end
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

    if self.encounter:onGameOver() then return end

    if self.soul.visible then
        Game:gameOver(self:getSoulLocation())
    else
        Game:gameOver(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    end
end

function LightBattle:returnToWorld()
    if not MagicalGlass:getConfig("keepTensionAfterLightBattles") then
        Game:setTension(0)
    end

    if self.encounter.id ~= "_nobody" then
        self.encounter:setFlag("done", true)
    end

    local enemies = {}
    for k,v in pairs(self.enemy_world_characters) do
        table.insert(enemies, v)
    end
    self.encounter:onReturnToWorld(enemies)

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
end

function LightBattle:onKeyPressed(key)
    if Kristal.Config["debug"] then
        if Input.ctrl() then
            -- Full heal
            if key == "h" then
                Assets.playSound("power")
                for _,party in ipairs(self.party) do
                    party:heal(math.huge)
                end
            end
            -- Force Victory
            if key == "y" then
                Input.clear(nil, true)
                --self.forced_victory = true
                if self.state == "DEFENDING" then
                    if not self.encounter:onWavesDone() then
                        self:toggleSoul(false)
                        self:setState("DEFENDINGEND", "WAVEENDED")
                    end
                end
                self:setState("VICTORY")
            end
            -- Mute Music
            -- todo: make this persist between reloads
            if key == "m" then
                if self.music then
                    if self.music:isPlaying() then
                        self.music:pause()
                    else
                        self.music:resume()
                    end
                end
            end
            -- Insta-end the DEFENDING phase
            if key == "f" and self.state == "DEFENDING" then
                if not self.encounter:onWavesDone() then
                    self:toggleSoul(false)
                    self:setState("DEFENDINGEND", "WAVEENDED")
                end
            end
            -- "You dare bring light into my lair? You must die!" -Ganon 1993
            if key == "j" and Input.shift() then
                if self.soul then
                    Game:gameOver(self:getSoulPosition())
                else
                    Game:gameOver()
                end
            end
            -- Gain a lot of TP, enough for a Snowgrave
            if key == "k" then
                Game:setTension(Game:getMaxTension() * 2, true)
            end
            -- SOUL noclip (or phasing, if you're toby)
            if key == "n" then
                NOCLIP = not NOCLIP
            end
        end

        -- 999 HP (carryover from UT's debug mode)
        if key == "delete" then
            for _,party in ipairs(self.party) do
                party.chara:setHealth(999)
            end
        end
    end

    self.battle_ui:onKeyPressed(key)
end

function LightBattle:update()
    for _,enemy in ipairs(self.enemies_to_remove) do
        Utils.removeFromTable(self.enemies, enemy)
        self.enemy_index[Utils.getKey(self.enemy_index, enemy)] = false
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

    local state = self:getState()

    if state == "ATTACKING" then
        if self.battle_ui.attack_target then
            if self:allActionsDone() then
                self:setState("ACTIONSDONE")
            end
        else
            self:setState("ACTIONSDONE")
        end
    elseif state == "ACTIONSDONE" then
        local any_hurt = false
        for _,enemy in ipairs(self.enemies) do
            if enemy.hurt_timer > 0 then
                any_hurt = true
                break
            end
        end
        if not any_hurt then
            self.attackers = {}
            self.normal_attackers = {}
            self.auto_attackers = {}
            if self.battle_ui.attacking then
                self.battle_ui:endAttack()
            end
            if not self.encounter:onActionsEnd() then
                self:setState("ENEMYDIALOGUE")
            end
        end
    elseif state == "ENEMYDIALOGUE" then
        if self.soul_appear_timer then
            if self.soul_appear_timer ~= 0 then
                self.soul_appear_timer = Utils.approach(self.soul_appear_timer, 0, DTMULT)
            else
                self:toggleSoul(true, false)
                for _,wave in ipairs(self.waves) do
                    if wave:onArenaEnter() then
                        wave.active = true
                        self.soul.can_move = true
                    end
                end
                self.soul_appear_timer = nil
            end
        end

        self.enemy_dialogue_timer = self.enemy_dialogue_timer - DTMULT
        if (self.enemy_dialogue_timer <= 0) and self.use_dialogue_timer then
            self:advanceDialogue()
        else
            local all_done = true
            local dialogue_done = true

            for _,bubble in ipairs(self.enemy_dialogue) do
                if bubble:isTyping() then
                    dialogue_done = false
                end
            end

            for _,bubble in ipairs(self.enemy_dialogue) do
                if dialogue_done then
                    bubble:setAdvance(true)
                end
            end

            for _,bubble in ipairs(self.enemy_dialogue) do
                if not bubble:isDone() then
                    all_done = false
                    break
                end
            end

            if all_done then
                self:setState("DIALOGUEEND")
            end
        end
    elseif state == "DEFENDING" then
        local darken = false
        local time = 0

        for _,wave in ipairs(self.waves) do
            if wave.darken then
                darken = true
                if wave.time > time then
                    time = wave.time
                end
            end
        end

        if darken and self.wave_timer <= (time - 9/30) then
            self.darkify_fader.alpha = Utils.approach(self.darkify_fader.alpha, 0.5, DTMULT * 0.05)
        else
            self.darkify_fader.alpha = Utils.approach(self.darkify_fader.alpha, 0, DTMULT * 0.05)
        end

        self:updateWaves()
    end

    self.update_child_list = true

    super.update(self)
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
        if not self.encounter:onWavesDone() then
            self:toggleSoul(false)
            self:setState("DEFENDINGEND", "WAVEENDED")
        end
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

function LightBattle:isHighlighted()
    return false
end

function LightBattle:isWorldHidden()
    return true
end

function LightBattle:draw()
    self.encounter:preDraw()

    if self.encounter:getBackgroundImage() then
        self.encounter:drawBackground()
    end

    super.draw(self)

    self.encounter:postDraw()

    if DEBUG_RENDER then
        self:drawDebug()
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
    self:debugPrintOutline("State:          " .. self:getState()   , 4, 0)
    self:debugPrintOutline("Substate:   " .. self:getSubState(), 4, 0 + 16)

    local menu = self.battle_ui:getCurrentMenu()
    if menu then
        self:debugPrintOutline("Menu:            " .. Utils.getClassName(menu), 4, 32)
    end
end

return LightBattle