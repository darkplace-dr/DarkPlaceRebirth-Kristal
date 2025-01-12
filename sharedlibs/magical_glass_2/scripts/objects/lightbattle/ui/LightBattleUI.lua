local LightBattleUI, super = Class(Object, "LightBattleUI")

function LightBattleUI:init()
    super.init(self)

    self.current_encounter_text = Game.battle.encounter.text

    self.encounter_text = UnderTextbox(14, 17, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 53, "main_mono", nil, true)
    self.encounter_text.text.default_voice = "battle"
    self.encounter_text.text.line_offset = 5
    self.encounter_text:setText("")
    self.encounter_text.debug_rect = {-30, -12, SCREEN_WIDTH+1, 124}
    Game.battle.arena:addChild(self.encounter_text)

    self.flee_text = Text("", 63, 15, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 53, {font = "main_mono"})
    self.flee_text.line_offset = 4
    self.flee_text.debug_rect = {-30, -12, SCREEN_WIDTH+1, 124}
    self.flee_text.visible = false
    Game.battle.arena:addChild(self.flee_text)

    -- todo: choicebox that's more ut-like and uses Game.battle.soul
    self.choice_box = Choicebox(14, 12, 535, 107, true, {font = "main_mono"})
    self.choice_box.active = false
    self.choice_box.visible = false
    Game.battle.arena:addChild(self.choice_box)

    self.action_displays = {}

    self.attack_target = nil
    self.attacking = false

    self.menu_stack = {}

    self.action_select = nil
    self.menu_select = nil
    self.list_menu_select = nil
    self.enemy_select = nil
    self.party_select = nil
end

function LightBattleUI:setup()
    self:setupMenus()
    self:setupActionDisplays()
end

function LightBattleUI:setupStory()
    self:setupStoryActionDisplay()
end

function LightBattleUI:setupMenus()
    local action_select_x = Game.battle.arena.x - Game.battle.arena.width / 2
    self.action_select = LightBattleActionSelect(action_select_x - 16, Game.battle.arena.y + 60, true)
    Game.battle:addChild(self.action_select)

    self.menu_select = LightBattleMenuSelect(63, 15, true)
    Game.battle.arena:addChild(self.menu_select)

    self.list_menu_select = LightBattleItemSelect(63, 15)
    Game.battle.arena:addChild(self.list_menu_select)

    self.enemy_select = LightBattleEnemySelect(63, 15, true)
    Game.battle.arena:addChild(self.enemy_select)

    self.party_select = LightBattlePartySelect(63, 15, true)
    Game.battle.arena:addChild(self.party_select)
end

function LightBattleUI:setupActionDisplays()
    local status_x, status_y = (SCREEN_WIDTH / 2) - 290, SCREEN_HEIGHT - 80
    local status = LightStatusDisplay(status_x, status_y, Game.battle.party[1])
    self:addChild(status)
    table.insert(self.action_displays, status)
end

function LightBattleUI:setupStoryActionDisplay()
    local status_x, status_y = 200, SCREEN_HEIGHT - 80
    local status = LightStoryStatusDisplay(status_x, status_y, Game.battle.party[1])
    self:addChild(status)
    table.insert(self.action_displays, status)
end

function LightBattleUI:setFleeText(text)
    self.flee_text.visible = true
    self.flee_text:setText("[ut_shake]"..text)
end

function LightBattleUI:setEncounterText(text, after)
    self:clearEncounterText()
    self.encounter_text:setText(text, after)
    if MagicalGlass.light_battle_text_shake then
        self.encounter_text.text.state.ut_shake = 1
        self.encounter_text.text.draw_every_frame = true
    end
end

function LightBattleUI:clearEncounterText()
    self.encounter_text:setActor(nil)
    self.encounter_text:setFace(nil)
    self.encounter_text:setFont()
    self.encounter_text:setAlign("left")
    self.encounter_text:setSkippable(true)
    self.encounter_text:setAdvance(true)
    self.encounter_text:setAuto(false)
    self.encounter_text:setText("")
end

function LightBattleUI:beginAttackSingle()
    self.attacking = true
    
    local arena = Game.battle.arena
    self.attack_target = LightAttackTargetSingle(Game.battle.normal_attackers[1], arena:getRelativePos(arena.width / 2, arena.height / 2))
    self.attack_target.layer = BATTLE_LAYERS["ui"]
    Game.battle:addChild(self.attack_target)
end

function LightBattleUI:beginAttackMulti()
    self.attacking = true
    
    local arena = Game.battle.arena
    self.attack_target = LightAttackTargetMulti(Game.battle.normal_attackers, arena:getRelativePos(arena.width / 2, arena.height / 2))
    self.attack_target.layer = BATTLE_LAYERS["ui"]
    Game.battle:addChild(self.attack_target)
end

function LightBattleUI:endAttack()
    self.attack_target:endAttack(Game.battle:retargetEnemy())
    self.attacking = false
end

function LightBattleUI:pushStack(menu)
    for _,imenu in ipairs(self.menu_stack) do
        imenu:onDeactivated()
    end

    table.insert(self.menu_stack, menu)
    menu:onActivated()
end

function LightBattleUI:popStack()
    local menu = table.remove(self.menu_stack)
    menu:onDeactivated()

    self:getCurrentMenu():onActivated()
end

function LightBattleUI:clearStack()
    for _,imenu in ipairs(self.menu_stack) do
        imenu:onDeactivated()
    end

    self.menu_stack = {}
end

function LightBattleUI:getCurrentMenu()
    return self.menu_stack[#self.menu_stack]
end

function LightBattleUI:setupActionSelect(member, activate)
    if activate == nil then activate = true end

    self.action_select:setup(member)

    if activate then
        self:pushStack(self.action_select)
    end
end

function LightBattleUI:setupAttackEnemySelect(enemies)
    self.enemy_select:setup(enemies)
    self.enemy_select:setCallback(function(enemy, can_select)
        if can_select then
            Game.battle:pushAction("ATTACK", enemy)
        end
    end)
    self.enemy_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.enemy_select)
end

function LightBattleUI:setupACTEnemySelect(enemies)
    self.enemy_select:setup(enemies, {["hide_health"] = true})
    self.enemy_select:setCallback(function(enemy, can_select)
        if can_select then
            local acts = {}
            for _,act in ipairs(enemy.acts) do
                local insert = not act.hidden
                if act.character and Game.battle:getCurrentlySelectingMember().chara.id ~= v.character then
                    insert = false
                end
                if act.party and #act.party > 0 then
                    for _,party_id in ipairs(act.party) do
                        if not Game.battle:getPartyIndex(party_id) then
                            insert = false
                            break
                        end
                    end
                end
                if insert then
                    table.insert(acts, act)
                end
            end
            Game.battle:setState("MENUSELECT", "ACT", {["acts"] = acts, ["enemy"] = enemy})
        end
    end)
    self.enemy_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.enemy_select)
end

function LightBattleUI:setupACTSelect(enemy, acts)
    local menu_items = {}
    for _,iact in ipairs(acts) do
        local act = {
            ["name"] = iact.name,
            ["tp"] = iact.tp or 0,
            ["description"] = iact.description,
            ["unusable"] = iact.unusable or false,
            ["party"] = iact.party,
            ["color"] = iact.color,
            ["icons"] = iact.icons,
            ["callback"] = function(iact, menu_item, can_select)
                if can_select then
                    Game.battle:pushAction("ACT", enemy, menu_item)
                end
            end
        }
        table.insert(menu_items, act)
    end
    self.menu_select:setup(menu_items, 2, 3)
    self.menu_select:setCancelCallback(function()
        Game.battle:setState("ENEMYSELECT", "CANCEL")
    end)
    self:pushStack(self.menu_select)
end

function LightBattleUI:setupSpellSelect(member)
    local menu_items = {}

    if Game.battle.encounter.default_x_actions and member.chara:hasXAct() then
        local data = {
            ["name"] = Game.battle.enemies[1]:getXAction(member),
            ["target"] = "xact",
            ["id"] = 0,
            ["default"] = true,
            ["party"] = {},
            ["tp"] = 0
        }

        local x_act = {
            ["name"] = member.chara:getXActName() or "X-Action",
            ["tp"] = 0,
            ["color"] = {member.chara:getXActColor()},
            ["data"] = data,
            ["callback"] = function()
                Game.battle:setState("ENEMYSELECT", "XACT", {["x_act"] = data})
            end
        }
        table.insert(menu_items, x_act)
    end
    for id, action in ipairs(Game.battle.x_actions) do
        if action.party == member.chara.id then
            local data = {
                ["name"] = action.name,
                ["target"] = "xact",
                ["id"] = id,
                ["default"] = false,
                ["party"] = {},
                ["tp"] = action.tp or 0
            }

            local x_act = {
                ["name"] = action.name,
                ["tp"] = action.tp or 0,
                ["description"] = action.description,
                ["color"] = action.color or {1, 1, 1, 1},
                ["data"] = data,
                ["callback"] = function()
                    Game.battle:setState("ENEMYSELECT", "XACT", {["x_act"] = data})
                end
            }
        end
        table.insert(menu_items, x_act)
    end

    for _,ispell in ipairs(member.chara:getSpells()) do
        local color = ispell.color or {1, 1, 1, 1}
        if ispell:hasTag("spare_tired") then
            local has_tired = false
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                color = {0, 178/255, 1, 1}
            end
        end
        local spell = {
            ["name"] = ispell:getName(),
            ["tp"] = ispell:getTPCost(member.chara),
            ["unusable"] = not ispell:isUsable(member.chara),
            ["description"] = ispell:getBattleDescription(),
            ["party"] = ispell.party,
            ["color"] = color,
            ["data"] = ispell,
            ["callback"] = function(spell, menu_item, can_select)
                if can_select then
                    if not ispell.target or ispell.target == "none" then
                        Game.battle:pushAction("SPELL", nil, menu_item)
                    elseif ispell.target == "ally" then
                        Game.battle:setState("PARTYSELECT", "SPELL", {["spell"] = menu_item})
                    elseif ispell.target == "enemy" then
                        Game.battle:setState("ENEMYSELECT", "SPELL", {["spell"] = menu_item})
                    elseif ispell.target == "party" then
                        Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                    elseif ispell.target == "enemies" then
                        Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
                    end
                end
            end
        }
        table.insert(menu_items, spell)
    end

    self.menu_select:setup(menu_items, 2, 3)
    self.menu_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.menu_select)
end

function LightBattleUI:setupSpellEnemySelect(enemies, spell)
    self.enemy_select:setup(enemies)
    self.enemy_select:setCallback(function(enemy, can_select)
        if can_select then
            Game.battle:pushAction("SPELL", enemy, spell)
        end
    end)
    self.enemy_select:setCancelCallback(function()
        Game.battle:setState("MENUSELECT", "CANCEL")
    end)
    self:pushStack(self.enemy_select)
end

function LightBattleUI:setupXActionEnemySelect(enemies, x_act)
    self.enemy_select:setup(enemies, {["hide_health"] = true, ["show_x_acts"] = true})
    self.enemy_select:setCallback(function(enemy, can_select)
        if can_select then
            local x_action = Utils.copy(x_act)
            if x_action.default then
                x_action.name = enemy:getXAction(Game.battle:getCurrentlySelectingMember())
            end
            Game.battle:pushAction("XACT", enemy, x_action)
        end
    end)
    self.enemy_select:setCancelCallback(function()
        Game.battle:setState("MENUSELECT", "CANCEL")
    end)
    self:pushStack(self.enemy_select)
end

function LightBattleUI:setupSpellPartySelect(party, spell)
    self.party_select:setup(party)
    self.party_select:setCallback(function(member)
        Game.battle:pushAction("SPELL", member, spell)
    end)
    self.party_select:setCancelCallback(function()
        Game.battle:setState("MENUSELECT", "CANCEL")
    end)
    self:pushStack(self.party_select)
end

function LightBattleUI:setupItemSelect(inventory)
    local menu_items = {}
    for _,iitem in ipairs(inventory) do
        local item = {
            ["name"] = iitem:getName() or "",
            ["short_name"] = iitem:getShortName() or nil,
            ["serious_name"] = iitem:getSeriousName() or nil,
            ["unusable"] = iitem.usable_in ~= "all" and iitem.usable_in ~= "battle",
            ["description"] = iitem:getBattleDescription(),
            ["data"] = iitem,
            ["callback"] = function(item, menu_item, can_select)
                if can_select then
                    if not iitem.target or iitem.target == "none" then
                        Game.battle:pushAction("ITEM", nil, menu_item)
                    elseif iitem.target == "ally" then
                        Game.battle:setState("PARTYSELECT", "ITEM", {["item"] = menu_item})
                    elseif iitem.target == "enemy" then
                        Game.battle:setState("ENEMYSELECT", "ITEM", {["item"] = menu_item})
                    elseif iitem.target == "party" then
                        Game.battle:pushAction("ITEM", Game.battle.party, menu_item)
                    elseif iitem.target == "enemies" then
                        Game.battle:pushAction("ITEM", Game.battle:getActiveEnemies(), menu_item)
                    end
                end
            end
        }
        table.insert(menu_items, item)
    end
    self.menu_select:setup(menu_items, 2, 2, {h_separation = 240, no_cursor_memory = true, scroll_direction = "HORIZONTAL", show_page = true, shorten_names = true, always_play_move_sound = true})
    self.menu_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.menu_select)
end

function LightBattleUI:setupListItemSelect(inventory)
    local menu_items = {}
    for _,iitem in ipairs(inventory) do
        local item = {
            ["name"] = iitem:getName() or "",
            ["unusable"] = iitem.usable_in ~= "all" and iitem.usable_in ~= "battle",
            ["description"] = iitem:getBattleDescription(),
            ["data"] = iitem,
            ["callback"] = function(item, menu_item, can_select)
                if can_select then
                    if not iitem.target or iitem.target == "none" then
                        Game.battle:pushAction("ITEM", nil, menu_item)
                    elseif iitem.target == "ally" then
                        Game.battle:setState("PARTYSELECT", "ITEM", {["item"] = menu_item})
                    elseif iitem.target == "enemy" then
                        Game.battle:setState("ENEMYSELECT", "ITEM", {["item"] = menu_item})
                    elseif iitem.target == "party" then
                        Game.battle:pushAction("ITEM", Game.battle.party, menu_item)
                    elseif iitem.target == "enemies" then
                        Game.battle:pushAction("ITEM", Game.battle:getActiveEnemies(), menu_item)
                    end
                end
            end
        }
        table.insert(menu_items, item)
    end
    self.list_menu_select:setup(menu_items, {max_items = 8})
    self.list_menu_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.list_menu_select)
end

function LightBattleUI:setupItemPartySelect(party, item)
    self.party_select:setup(party)
    self.party_select:setCallback(function(member)
        Game.battle:pushAction("ITEM", member, item)
    end)
    self.party_select:setCancelCallback(function()
        Game.battle:setState("MENUSELECT", "CANCEL")
    end)
    self:pushStack(self.party_select)
end

function LightBattleUI:setupMercySelect()
    local highlight_spare = false
    for _,enemy in ipairs(Game.battle.enemies) do
        if enemy:canSpare() then
            highlight_spare = true
            break
        end
    end

    local spare_color = COLORS.yellow
    if MagicalGlass.pink_spare then spare_color = MagicalGlass.PALETTE["pink_spare"] end

    local menu_items = {}
    table.insert(menu_items, {
        ["name"] = "Spare",
        ["color"] = highlight_spare and spare_color,
        ["callback"] = function()
            Game.battle:pushAction("SPARE", Game.battle:getActiveEnemies())
        end
    })
    if Game.battle.can_defend then
        table.insert(menu_items, {
            ["name"] = "Defend",
            ["callback"] = function()
                Game.battle:pushAction("DEFEND", nil, {tp = -16})
            end
        }) 
    end
    if Game.battle.can_flee and Game.battle.current_selecting_index == 1 then
        table.insert(menu_items, {
            ["name"] = "Flee",
            ["callback"] = function()
                Game.battle:setState("FLEESTART")
            end
        })
    end

    self.menu_select:setup(menu_items, 1, 3)
    self.menu_select:setCancelCallback(function()
        Game.battle:setState("ACTIONSELECT", "CANCEL")
    end)
    self:pushStack(self.menu_select)
end

function LightBattleUI:onKeyPressed(key)
    if self.attacking and self.attack_target then
        self.attack_target:onKeyPressed(key)
    else
        if self:getCurrentMenu() then
            self:getCurrentMenu():onKeyPressed(key)
        end
    
        if #self.menu_stack > 1 then
            if Input.isCancel(key) then
                self:popStack()
            end
        end
    end
end

function LightBattleUI:draw()
    local event_result = Kristal.callEvent(MagicalGlass.EVENT.preLightBattleUIDraw, self)
    local enc_result = Game.battle.encounter:preUIDraw(self)
    if event_result or enc_result then return end

    super.draw(self)

    Game.battle.encounter:onUIDraw(self)
    Kristal.callEvent(MagicalGlass.EVENT.onLightBattleUIDraw, self)
end

return LightBattleUI