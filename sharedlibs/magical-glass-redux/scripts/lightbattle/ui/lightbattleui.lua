local LightBattleUI, super = Class(Object)

function LightBattleUI:init()
    super.init(self, 0, 270)

    self.layer = LIGHT_BATTLE_LAYERS["ui"]

    self.current_encounter_text = Game.battle.encounter.text

    self.arena = Game.battle.arena
    
    self.enemy_counter = {}

    self.style = Kristal.getLibConfig("magical-glass", "gauge_style")
    self.draw_mercy = Kristal.getLibConfig("magical-glass", "mercy_bar")
    self.draw_percents = Kristal.getLibConfig("magical-glass", "enemy_bar_percentages")

    self.encounter_text = Textbox(14, 17, SCREEN_WIDTH - 90, SCREEN_HEIGHT - 53, "main_mono", nil, true)
    self.encounter_text.text.default_sound = "battle"
    self.encounter_text.text.hold_skip = false
    self.encounter_text.text.line_offset = 5
    self.encounter_text:setText("")
    self.encounter_text.debug_rect = {-30, -12, SCREEN_WIDTH - 45, 121}
    Game.battle.arena:addChild(self.encounter_text)

    self.choice_box = Choicebox(14, 17, 529, 103, true)
    self.choice_box.active = false
    self.choice_box.visible = false
    Game.battle.arena:addChild(self.choice_box)
    
    self.choice_option = {}
    for i = 1, 2 do
        self.choice_option[i] = Text("", 62, 15 + 32 * (i-1), nil, nil, {["font"] = "main_mono"})
        self.choice_option[i].line_offset = 4
        self.choice_box:addChild(self.choice_option[i])
    end

    self.short_act_text_1 = DialogueText("", 14, 15, SCREEN_WIDTH - 90, SCREEN_HEIGHT - 53, {wrap = false, line_offset = 0, font = "main_mono"})
    self.short_act_text_2 = DialogueText("", 14, 15 + 32, SCREEN_WIDTH - 90, SCREEN_HEIGHT - 53, {wrap = false, line_offset = 0, font = "main_mono"})
    self.short_act_text_3 = DialogueText("", 14, 15 + 32 + 32, SCREEN_WIDTH - 90, SCREEN_HEIGHT - 53, {wrap = false, line_offset = 0, font = "main_mono"})
    Game.battle.arena:addChild(self.short_act_text_1)
    Game.battle.arena:addChild(self.short_act_text_2)
    Game.battle.arena:addChild(self.short_act_text_3)

    -- active: 237
    -- inactive: 280
    self.help_window = HelpWindow(SCREEN_WIDTH/2, 280) -- height is 99px in dt
    self.help_window.layer = self.arena.layer - 0.5
    Game.battle:addChild(self.help_window)

    self.attack_box = nil
    self.action_boxes = {}
    
    self.attacking = false

    for i,battler in ipairs(Game.battle.party) do
        self.action_box_ut = LightActionBox(20, 0, i, battler)
        self.action_box_ut.layer = LIGHT_BATTLE_LAYERS["ui"] - 1
        self.action_box_ut:move(self:getRelativePos())
        Game.battle:addChild(self.action_box_ut)
        table.insert(self.action_boxes, self.action_box_ut)
        battler.chara:onActionBox(self.action_box_ut, false)
    end

    self.shown = true 
    
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")

    self.sparestar = Assets.getTexture("ui/battle/sparestar")
    self.tiredmark = Assets.getTexture("ui/battle/tiredmark")
    
    self.menu_text = {}
    for i = 1, 6 do
        self.menu_text[i] = Text("", 62, 15 + 32 * (i-1), nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.menu_text[i])
    end
    
    self.page_text = Text("", 350, 15 + 64, nil, nil, {["font"] = "main_mono"})
    Game.battle.arena:addChild(self.page_text)
    
    self.enemies_text = {}
    for i = 1, 3 do
        self.enemies_text[i] = DynamicGradientText("", 62, 15 + 32 * (i-1), nil, nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.enemies_text[i])
    end
    
    self.enemies_special_text = {}
    for i = 1, 3 do
        self.enemies_special_text[i] = DynamicGradientText("", 90, 15 + 32 * (i-1), nil, nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.enemies_special_text[i])
    end
    
    self.comment_text = {}
    for i = 1, 3 do
        self.comment_text[i] = Text("", 62, 15 + 32 * (i-1), nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.comment_text[i])
    end
    
    self.xact_text = {}
    for i = 1, 3 do
        self.xact_text[i] = Text("", 122, 15 + 32 * (i-1), nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.xact_text[i])
    end
    
    self.party_text = {}
    for i = 1, 3 do
        self.party_text[i] = Text("", 62, 15 + 32 * (i-1), nil, nil, {["font"] = "main_mono"})
        Game.battle.arena:addChild(self.party_text[i])
    end
    
    self.flee_text = Text("", 62, 15, nil, nil, {["font"] = "main_mono"})
    if not Game:isLight() then
        self.flee_text.style = "dark"
    end
    self.flee_text.line_offset = 4
    Game.battle.arena:addChild(self.flee_text)
    
    self.status_display = LightStatusDisplay(0, 390, Game.battle.encounter.event and not Game.battle.multi_mode)
    self.status_display.layer = LIGHT_BATTLE_LAYERS["ui"] - 2
    Game.battle:addChild(self.status_display)
    
    self:resetXACTPosition()
end

function LightBattleUI:resetXACTPosition()
    self.xact_x_pos = 122
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

function LightBattleUI:beginAttack()
    Game.battle.current_selecting = 0

    self.attack_box = LightAttackBox(self.arena.width / 2, self.arena.height / 2)
    self.arena:addChild(self.attack_box)

    self.attacking = true
end

function LightBattleUI:endAttack()
    self.attack_box.fading = true

    for _,lane in ipairs(self.attack_box.lanes) do
        for _,bolt in ipairs(lane.bolts) do
            bolt:remove()
        end
    end

    self.attacking = false
end

function LightBattleUI:drawState()
    local state = Game.battle.state
    
    for _,text in ipairs(self.menu_text) do
        text:setText("")
    end
    self.page_text:setText("")
    for _,text in ipairs(self.enemies_text) do
        text:setText("")
    end
    for _,text in ipairs(self.enemies_special_text) do
        if state ~= "ENEMYSELECT" then
            text:setText("")
            text.enemy = nil
            text.enemy_name = nil
        end
    end
    for _,text in ipairs(self.comment_text) do
        text:setText("")
    end
    for _,text in ipairs(self.xact_text) do
        text:setText("")
    end
    for _,text in ipairs(self.party_text) do
        text:setText("")
    end
    self.flee_text:setText("")
    
    if state == "MENUSELECT" then
    
        local page = Game.battle:isPagerMenu() and math.ceil(Game.battle.current_menu_x / Game.battle.current_menu_columns) - 1 or math.ceil(Game.battle.current_menu_y / Game.battle.current_menu_rows) - 1
        local max_page = math.ceil(#Game.battle.menu_items / (Game.battle.current_menu_columns * Game.battle.current_menu_rows)) - 1

        local x = 0
        local y = 0

        local menu_offsets = { -- {soul, text}
            ["ACT"] = {12, 16},
            ["ITEM"] = {0, 0},
            ["SPELL"] = {12, 16},
            ["MERCY"] = {0, 0},
        }

        for lib_id,_ in Kristal.iterLibraries() do
            menu_offsets = Kristal.libCall(lib_id, "getLightBattleMenuOffsets", menu_offsets) or menu_offsets
        end
        menu_offsets = Kristal.modCall("getLightBattleMenuOffsets", menu_offsets) or menu_offsets

        local extra_offset
        for name, offset in pairs(menu_offsets) do
            if name == Game.battle.state_reason then
                extra_offset = offset
            end
        end

        if Game.battle:isPagerMenu() then
            Game.battle.soul:setPosition(72 + ((Game.battle.current_menu_x - 1 - (page * 2)) * (248 + extra_offset[1])), 255 + ((Game.battle.current_menu_y) * 31.5))
        else
            Game.battle.soul:setPosition(72 + ((Game.battle.current_menu_x - 1) * (248 + extra_offset[1])), 255 + ((Game.battle.current_menu_y - (page * Game.battle.current_menu_rows)) * 31.5))
        end

        local font = Assets.getFont("main_mono")
        love.graphics.setFont(font, 32)

        local col = Game.battle.current_menu_columns
        local row = Game.battle.current_menu_rows
        local draw_amount = col * row

        local page_offset = page * draw_amount
        
        for i = page_offset + 1, math.min(page_offset + draw_amount, #Game.battle.menu_items) do
            local item = Game.battle.menu_items[i]

            Draw.setColor(1, 1, 1, 1)
            
            local text_offset = 0
            local able = Game.battle:canSelectMenuItem(item)
            
            -- Head counter
            local heads = 0
            if item.party then
                for index, party_id in ipairs(item.party) do
                    local chara = Game:getPartyMember(party_id)
                    if Game.battle:getPartyIndex(party_id) ~= Game.battle.current_selecting then
                        heads = heads + 1
                    end
                end
                if not able then
                    Draw.setColor(COLORS.gray)
                end

                if heads <= 1 then
                    for index, party_id in ipairs(item.party) do
                        local chara = Game:getPartyMember(party_id)

                        if Game.battle:getPartyIndex(party_id) ~= Game.battle.current_selecting then
                            local ox, oy = chara:getHeadIconOffset()
                            Draw.draw(Assets.getTexture(chara:getHeadIcons() .. "/head"), text_offset + 92 + (x * (240 + extra_offset[2])) + ox, 5 + (y * 32) + oy)
                            text_offset = text_offset + 37
                        end
                    end
                else
                    for index, party_id in ipairs(item.party) do
                        local chara = Game:getPartyMember(party_id)
                        -- Draw head only if it isn't the currently selected character
                        if Game.battle:getPartyIndex(party_id) ~= Game.battle.current_selecting then
                            local ox, oy = chara:getHeadIconOffset()
                            local party = 0
                            if heads > 2 then
                                party = heads - 2
                            end
                            Draw.draw(Assets.getTexture(chara:getHeadIcons() .. "/head"), text_offset + 92 + (x * (240 + extra_offset[2])) + ox, 5 + (y * 32) + oy + (party ~= 0 and (0 + party * 1.9) or 0), 0, 1 / (1 + party * 0.35))
                            text_offset = text_offset + (30 / (1 + party * 0.5))
                        end
                    end
                end
            end

            local icons_at_beginning = nil
            if item.icons then
                if not able then
                    Draw.setColor(COLORS.gray)
                end

                icons_at_beginning = false
                for _, icon in ipairs(item.icons) do
                    if type(icon) == "string" then
                        icon = {icon, false, 0, 0, nil}
                    end
                    if not icon[2] then
                        local texture = Assets.getTexture(icon[1])
                        Draw.draw(texture, text_offset + 95 + (x * (240 + extra_offset[2])) + (icon[3] or 0), (y * 32) + (icon[4] or 0))
                        text_offset = text_offset + (icon[5] or texture:getWidth())
                    else
                        icons_at_beginning = true
                    end
                end
            end
            
            local menu_text = self.menu_text[i - page_offset]

            if able then
                menu_text:setColor(item.color or {1, 1, 1, 1})
            else
                menu_text:setColor(COLORS.gray)
            end

            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy:canSpare() and item.special == "spare" then
                    menu_text:setColor(MagicalGlassLib.spare_color)
                end
            end

            local name = item.name
            if item.seriousname and MagicalGlassLib.serious_mode then
                name = item.seriousname
            elseif item.shortname then
                name = item.shortname
            end

            if heads > 0 or icons_at_beginning == false then
                menu_text:setPosition(text_offset + 57 + (x * (240 + extra_offset[2])), 15 + (y * 32))
                menu_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. name)
                text_offset = text_offset + font:getWidth(name)
            else
                menu_text:setPosition(text_offset + 62 + (x * (240 + extra_offset[2])), 15 + (y * 32))
                menu_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. "* " .. name)
                text_offset = text_offset + font:getWidth("* " .. name) + 5
            end

            if item.icons then
                if able then
                    Draw.setColor(1, 1, 1)
                else
                    Draw.setColor(COLORS.gray)
                end

                for _, icon in ipairs(item.icons) do
                    if type(icon) == "string" then
                        icon = {icon, false, 0, 0, nil}
                    end
                    if icon[2] then
                        local texture = Assets.getTexture(icon[1])
                        Draw.draw(texture, text_offset + 95 + (x * (240 + extra_offset[2])) + (icon[3] or 0), (y * 32) + (icon[4] or 0))
                        text_offset = text_offset + (icon[5] or texture:getWidth())
                    end
                end
            end

            if Game.battle.current_menu_columns == 1 then
                if x == 0 then
                    y = y + 1
                end
            else
                if x == 0 then
                    x = 1
                else
                    x = 0
                    y = y + 1
                end
            end

        end

        local tp_offset = 0
        local current_item = Game.battle.menu_items[Game.battle:getItemIndex()] or Game.battle.menu_items[1] -- crash prevention in case of an invalid option
        if current_item.description then
            self.help_window:setDescription(current_item.description)
        end

        if current_item.tp and current_item.tp ~= 0 then
            self.help_window:setTension(current_item.tp)
            Game:setTensionPreview(current_item.tp)
        else
            self.help_window:setTension(0)
            Game:setTensionPreview(0)
        end

        Draw.setColor(1, 1, 1, 1)

        if Game.battle:isPagerMenu() then
            self.page_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. "PAGE " .. page + 1)
        else
            if page < max_page then
                Draw.draw(self.arrow_sprite, 45, 90 + (math.sin(Kristal.getTime()*6) * 2))
            end
            if page > 0 then
                Draw.draw(self.arrow_sprite, 45, 10 - (math.sin(Kristal.getTime()*6) * 2), 0, 1, -1)
            end
        end

    elseif state == "ENEMYSELECT" then

        local enemies = Game.battle.enemies_index
        local reason = Game.battle.state_reason

        local page = math.ceil(Game.battle.current_menu_y / 3) - 1
        local max_page = math.ceil(#enemies / 3) - 1
        local page_offset = page * 3

        Game.battle.soul:setPosition(72, 255 + ((Game.battle.current_menu_y - (page * 3)) * 31.5))
        local font_main = Assets.getFont("main")
        local font_mono = Assets.getFont("main_mono")
        local font_status = Assets.getFont("battlehud")

        Draw.setColor(1, 1, 1, 1)

        if self.draw_mercy then
            if self.style == "deltarune" then
                love.graphics.setFont(font_main)
                if Game.battle.state_reason ~= "XACT" then
                    love.graphics.print("HP", 400, -10, 0, 1, 0.5)
                end
                love.graphics.print("MERCY", 500, -10, 0, 1, 0.5)
            elseif self.style == "deltatraveler" then
                love.graphics.setFont(font_main)
                if Game.battle.state_reason ~= "XACT" then
                    love.graphics.print("HP", 412, -15, 0, 1, 0.75)
                end
                love.graphics.print("MERCY", 502, -15, 0, 1, 0.75)
            end
        end
        
        local letters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
        
        for _,enemy in pairs(enemies) do
            if enemy then
                if self.enemy_counter[enemy.id] == nil then
                    self.enemy_counter[enemy.id] = 0
                end
                if not enemy.index then
                    self.enemy_counter[enemy.id] = self.enemy_counter[enemy.id] + 1
                    if self.enemy_counter[enemy.id] <= math.pow(#letters, 2) + #letters then
                        if self.enemy_counter[enemy.id] > #letters then
                            enemy.index = letters[math.floor((self.enemy_counter[enemy.id] - 1) / #letters)] .. letters[self.enemy_counter[enemy.id] - #letters * math.floor((self.enemy_counter[enemy.id] - 1) / #letters)]
                        else
                            enemy.index = letters[self.enemy_counter[enemy.id]]
                        end
                    else
                        enemy.index = ""
                    end
                end
            end
        end
        
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            local enemy_name = "* " .. enemy.name .. (self.enemy_counter[enemy.id] > 1 and enemy.index ~= "" and " " .. enemy.index or "")
            if self.xact_x_pos < font_mono:getWidth(enemy_name) + 122 then
                self.xact_x_pos = font_mono:getWidth(enemy_name) + 122
            end
        end
        for _,text in ipairs(self.xact_text) do
            text.x = self.xact_x_pos
            if not self.draw_mercy or self.xact_x_pos <= 314 then
                text:setScale(1, 1)
                text.visible = true
            elseif self.xact_x_pos <= 378 then
                text:setScale(0.5, 1)
                text.visible = true
            else
                text:setScale(1, 1)
                text.visible = false
            end
        end
        
        local remainder = #enemies % 3
        if remainder == 0 then
            remainder = #enemies
        else
            remainder = #enemies + (3 - remainder)
        end
        for index = page_offset + 1, math.min(page_offset + 3, remainder) do
        
            love.graphics.setFont(font_mono)
            
            local enemy = enemies[index]
            local y_offset = (index - page_offset - 1) * 32

            if enemy then
                local name_colors = enemy:getNameColors()
                if type(name_colors) ~= "table" then
                    name_colors = {name_colors}
                end

                local name = "* " .. enemy.name
                if self.enemy_counter[enemy.id] > 1 and enemy.index ~= "" then
                    name = name .. " " .. enemy.index
                end

                local enemy_text = self.enemies_text[index - page_offset]
                local enemy_special_text = self.enemies_special_text[index - page_offset]
                local xact_text = self.xact_text[index - page_offset]
                local comment_text = self.comment_text[index - page_offset]

                if #name_colors <= 1 then
                    enemy_text:setColor(name_colors[1] or enemy.selectable and {1, 1, 1} or {0.5, 0.5, 0.5})
                    enemy_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. (enemy.rainbow_name and "*" or name))
                else
                    enemy_text:setColor(1, 1, 1)
                    enemy_text:setGradientColors(name_colors)
                    enemy_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. (enemy.rainbow_name and "*" or name))
                end
                
                if enemy.rainbow_name then
                    enemy_special_text:setColor(1, 1, 1)
                    local colors = {}
                    for i = 1, 4 do
                        table.insert(colors, {Utils.hslToRgb((Kristal.getTime() / 1 + (i-1) * 0.25) % 1, 1, 0.73)})
                    end
                    enemy_special_text:setGradientColors(colors)
                    if enemy_special_text.enemy ~= enemy or enemy_special_text.enemy_name ~= enemy.name .. (enemy.index ~= "" and " " .. enemy.index or "") then
                        enemy_special_text.enemy = enemy
                        enemy_special_text.enemy_name = enemy.name .. (enemy.index ~= "" and " " .. enemy.index or "")
                        enemy_special_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."][wave:7,15,11]" .. Utils.sub(name, 3))
                        enemy_special_text.text_width = enemy_special_text.text_width + 24
                        enemy_special_text.text_height = enemy_special_text.text_height + 10
                    end
                else
                    enemy_special_text:setText("")
                    enemy_special_text.enemy = nil
                    enemy_special_text.enemy_name = nil
                end
                
                Draw.setColor(1, 1, 1)

                if self.style ~= "undertale" then
                    local spare_icon = false
                    local tired_icon = false

                    if enemy.tired and enemy:canSpare() then
                        Draw.draw(self.sparestar, 98 + font_mono:getWidth(name) + 20, 8 + y_offset)
                        spare_icon = true
                        
                        Draw.draw(self.tiredmark, 98 + font_mono:getWidth(name) + 40, 8 + y_offset)
                        tired_icon = true
                    elseif enemy.tired then
                        Draw.draw(self.tiredmark, 98 + font_mono:getWidth(name) + 40, 8 + y_offset)
                        tired_icon = true
                    elseif enemy.mercy >= 100 then
                        Draw.draw(self.sparestar, 98 + font_mono:getWidth(name) + 20, 8 + y_offset)
                        spare_icon = true
                    end

                    for i = 1, #enemy.icons do
                        if enemy.icons[i] then
                            if (spare_icon and (i == 1)) or (tired_icon and (i == 2)) then
                                -- Skip the custom icons if we're already drawing spare/tired ones
                            else
                                Draw.setColor(1, 1, 1, 1)
                                Draw.draw(enemy.icons[i], 98 + font_mono:getWidth(name) + (i * 20), 8 + y_offset)
                            end
                        end
                    end
                end
                
                if Game.battle.state_reason == "XACT" then
                    xact_text:setColor(Game.battle.party[Game.battle.current_selecting].chara:getLightXActColor())
                    if Game.battle.selected_xaction.id == 0 then
                        xact_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. enemy:getXAction(Game.battle.party[Game.battle.current_selecting]))
                    else
                        xact_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. Game.battle.selected_xaction.name)
                    end
                elseif self.style ~= "undertale" then
                    comment_text.x = 74 + font_mono:getWidth(name)
                    comment_text:setColor(128/255, 128/255, 128/255, 1)
                    if font_mono:getWidth(name) + (font_mono:getWidth(enemy.comment) / 2) < 264 then
                        comment_text:setScale(1, 1)
                    else
                        comment_text:setScale(0.5, 1)
                    end
                    comment_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. enemy.comment)
                end

                local hp_percent = enemy.health / enemy.max_health

                if self.style == "undertale" then
                    local name_length = 0
                    for _,enemy in ipairs(enemies) do
                        if enemy and string.len(enemy.name) + (enemy.rainbow_name and 2 or 0) > name_length then
                            name_length = string.len(enemy.name) + (enemy.rainbow_name and 2 or 0)
                        end
                    end
                    local hp_x = 190 + (name_length * 16)
                    if Game.battle.state_reason ~= "ACT" and Game.battle.state_reason ~= "SPARE" and Game.battle.state_reason ~= "XACT" then
                        if enemy.show_hp_bar and enemy.selectable then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["action_health_bg"])
                            else
                                Draw.setColor(PALETTE["action_health_bg"])
                            end
                            love.graphics.rectangle("fill", hp_x, 10 + y_offset, 101, 17)

                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["action_health"])
                            else
                                Draw.setColor(PALETTE["action_health"])
                            end
                            love.graphics.rectangle("fill", hp_x, 10 + y_offset, math.max(0,math.ceil(hp_percent),math.floor(hp_percent * 101)), 17)
                            if self.draw_percents then
                                love.graphics.setFont(font_status)
                                local shadow_offset = 1

                                Draw.setColor(COLORS.black)
                                Draw.printAlign(enemy:getHealthDisplay(), (hp_x + 51) + shadow_offset, (9 + y_offset) + shadow_offset, "center")
                                
                                if Game:isLight() then
                                    Draw.setColor(MG_PALETTE["action_health_text"])
                                else
                                    Draw.setColor(PALETTE["action_health_text"])
                                end
                                Draw.printAlign(enemy:getHealthDisplay(), hp_x + 51, 9 + y_offset, "center")
                            end
                        end
                    else
                        local mercy_x = Game.battle.state_reason == "XACT" and 480 or hp_x
                        if enemy.show_mercy_bar and self.draw_mercy then
                            if enemy.selectable then
                                if Game:isLight() then
                                    Draw.setColor(MG_PALETTE["battle_mercy_bg"])
                                else
                                    Draw.setColor(PALETTE["battle_mercy_bg"])
                                end
                            else
                                Draw.setColor(127/255, 127/255, 127/255, 1)
                            end
                            
                            love.graphics.rectangle("fill", mercy_x, 10 + y_offset, 101, 17)
                            
                            if enemy.disable_mercy then
                                if Game:isLight() then
                                    Draw.setColor(MG_PALETTE["battle_mercy_text"])
                                else
                                    Draw.setColor(PALETTE["battle_mercy_text"])
                                end
                                love.graphics.setLineWidth(2)
                                love.graphics.line(mercy_x, 11 + y_offset, mercy_x + 101, 10 + y_offset + 17 - 1)
                                love.graphics.line(mercy_x, 10 + y_offset + 17 - 1, mercy_x + 101, 11 + y_offset)
                            else
                                Draw.setColor(COLORS.yellow)
                                love.graphics.rectangle("fill", mercy_x, 10 + y_offset, ((enemy.mercy / 100) * 101), 17)
                                if self.draw_percents and enemy.selectable then
                                    love.graphics.setFont(font_status)
                                    local shadow_offset = 1

                                    Draw.setColor(COLORS.black)
                                    Draw.printAlign(enemy:getMercyDisplay(), (hp_x + 51) + shadow_offset, (9 + y_offset) + shadow_offset, "center")

                                    if Game:isLight() then
                                        Draw.setColor(MG_PALETTE["battle_mercy_text"])
                                    else
                                        Draw.setColor(PALETTE["battle_mercy_text"])
                                    end
                                    Draw.printAlign(enemy:getMercyDisplay(), hp_x + 51, 9 + y_offset, "center")
                                end
                            end
                        end
                    end
                elseif self.style == "deltarune" then
                    local hp_x = self.draw_mercy and 400 or 500
                    if enemy.selectable and Game.battle.state_reason ~= "XACT" then
                        if Game:isLight() then
                            Draw.setColor(MG_PALETTE["action_health_bg"])
                        else
                            Draw.setColor(PALETTE["action_health_bg"])
                        end
                        love.graphics.rectangle("fill", hp_x, 10 + y_offset, 81, 16)
    
                        if Game:isLight() then
                            Draw.setColor(MG_PALETTE["action_health"])
                        else
                            Draw.setColor(PALETTE["action_health_bg"])
                        end
                        love.graphics.rectangle("fill", hp_x, 10 + y_offset, math.max(0,math.ceil(hp_percent),math.floor(hp_percent * 81)), 16)
                        
                        if self.draw_percents then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["action_health_text"])
                            else
                                Draw.setColor(PALETTE["action_health_text"])
                            end
                            love.graphics.print(enemy:getHealthDisplay(), hp_x + 4, 10 + y_offset, 0, 1, 0.5)
                        end
                    end
                    
                    if self.draw_mercy then
                        if enemy.selectable then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["battle_mercy_bg"])
                            else
                                Draw.setColor(PALETTE["battle_mercy_bg"])
                            end
                        else
                            Draw.setColor(127/255, 127/255, 127/255, 1)
                        end
                        
                        love.graphics.rectangle("fill", 500, 10 + y_offset, 81, 16)
                        
                        if enemy.disable_mercy then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["battle_mercy_text"])
                            else
                                Draw.setColor(PALETTE["battle_mercy_text"])
                            end
                            love.graphics.setLineWidth(2)
                            love.graphics.line(500, 11 + y_offset, 500 + 81, 10 + y_offset + 16 - 1)
                            love.graphics.line(500, 10 + y_offset + 16 - 1, 500 + 81, 11 + y_offset)
                        else
                            Draw.setColor(COLORS.yellow)
                            love.graphics.rectangle("fill", 500, 10 + y_offset, ((enemy.mercy / 100) * 81), 16)
                            
                            if self.draw_percents and enemy.selectable then
                                if Game:isLight() then
                                    Draw.setColor(MG_PALETTE["battle_mercy_text"])
                                else
                                    Draw.setColor(PALETTE["battle_mercy_text"])
                                end
                                love.graphics.print(enemy:getMercyDisplay(), 500 + 4, 10 + y_offset, 0, 1, 0.5)
                            end
                        end
                    end
                elseif self.style == "deltatraveler" then
                    local hp_x = self.draw_mercy and 400 or 500
                    if enemy.selectable and Game.battle.state_reason ~= "XACT" then
                        if Game:isLight() then
                            Draw.setColor(MG_PALETTE["action_health_bg"])
                        else
                            Draw.setColor(PALETTE["action_health_bg"])
                        end
                        love.graphics.rectangle("fill", hp_x + 12, 11 + y_offset, 75, 17)
    
                        if Game:isLight() then
                            Draw.setColor(MG_PALETTE["action_health"])
                        else
                            Draw.setColor(PALETTE["action_health"])
                        end
                        love.graphics.rectangle("fill", hp_x + 12, 11 + y_offset, math.max(0,math.ceil(hp_percent),math.floor(hp_percent * 75)), 17)

                        if self.draw_percents then
                            love.graphics.setFont(font_status)
                            local shadow_offset = 1

                            Draw.setColor(COLORS.black)
                            Draw.printAlign(enemy:getHealthDisplay(), (hp_x + 52) + shadow_offset, (10 + y_offset) + shadow_offset, "center")

                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["action_health_text"])
                            else
                                Draw.setColor(PALETTE["action_health_text"])
                            end
                            Draw.printAlign(enemy:getHealthDisplay(), hp_x + 52, 10 + y_offset, "center")
                        end
                    end

                    if self.draw_mercy then
                        love.graphics.setFont(font_status)
                        local shadow_offset = 1

                        if enemy.selectable then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["battle_mercy_bg"])
                            else
                                Draw.setColor(PALETTE["battle_mercy_bg"])
                            end
                        else
                            Draw.setColor(127/255, 127/255, 127/255, 1)
                        end

                        love.graphics.rectangle("fill", 502, 11 + y_offset, 75, 17)
        
                        if enemy.disable_mercy then
                            if Game:isLight() then
                                Draw.setColor(MG_PALETTE["battle_mercy_text"])
                            else
                                Draw.setColor(PALETTE["battle_mercy_text"])
                            end
                            love.graphics.setLineWidth(2)
                            love.graphics.line(502, 12 + y_offset, 502 + 75, 12 + y_offset + 16 - 1)
                            love.graphics.line(502, 12 + y_offset + 16 - 1, 502 + 75, 12 + y_offset)
                        else
                            Draw.setColor(COLORS.yellow)
                            love.graphics.rectangle("fill", 502, 11 + y_offset, ((enemy.mercy / 100) * 75), 17)
        
                            if self.draw_percents and enemy.selectable then
                                Draw.setColor(COLORS.black)
                                Draw.printAlign(enemy:getMercyDisplay(), 541 + shadow_offset, (10 + y_offset) + shadow_offset, "center")

                                if Game:isLight() then
                                    Draw.setColor(MG_PALETTE["battle_mercy_text"])
                                else
                                    Draw.setColor(PALETTE["battle_mercy_text"])
                                end
                                Draw.printAlign(enemy:getMercyDisplay(), 541, 10 + y_offset, "center")
                            end
                        end
                    end
                end
            else
                local enemy_special_text = self.enemies_special_text[index - page_offset]
                enemy_special_text:setText("")
                enemy_special_text.enemy = nil
                enemy_special_text.enemy_name = nil
            end
        end
        
        Draw.setColor(1, 1, 1, 1)
        local arrow_down = page_offset + 3
        while true do
            arrow_down = arrow_down + 1
            if arrow_down > #enemies then
                arrow_down = false
                break
            elseif enemies[arrow_down] then
                arrow_down = true
                break
            end
        end
        local arrow_up = page_offset + 1
        while true do
            arrow_up = arrow_up - 1
            if arrow_up < 1 then
                arrow_up = false
                break
            elseif enemies[arrow_up] then
                arrow_up = true
                break
            end
        end
        if arrow_down then
            Draw.draw(self.arrow_sprite, 45, 90 + (math.sin(Kristal.getTime()*6) * 2))
        end
        if arrow_up then
            Draw.draw(self.arrow_sprite, 45, 10 - (math.sin(Kristal.getTime()*6) * 2), 0, 1, -1)
        end
    elseif state == "PARTYSELECT" then
        local page = math.ceil(Game.battle.current_menu_y / 3) - 1
        local max_page = math.ceil(#Game.battle.party / 3) - 1
        local page_offset = page * 3

        Game.battle.soul:setPosition(72, 255 + ((Game.battle.current_menu_y - (page * 3)) * 31.5))

        local font = Assets.getFont("main_mono")
        love.graphics.setFont(font)
        
        local name_length = 0
        for _,party in ipairs(Game.battle.party) do
            if string.len(party.chara.name) > name_length then
                name_length = string.len(party.chara.name)
            end
        end
        local hp_x = 190 + (name_length * 16)

        for index = page_offset + 1, math.min(page_offset + 3, #Game.battle.party) do
            local party_text = self.party_text[index - page_offset]
            Draw.setColor(1, 1, 1, 1)
            party_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. "* " .. Game.battle.party[index].chara:getName())

            if self.style ~= "deltarune" then
                if Game:isLight() then
                    Draw.setColor(MG_PALETTE["action_health_bg"])
                else
                    Draw.setColor(PALETTE["action_health_bg"])
                end
                love.graphics.rectangle("fill", hp_x, 10 + ((index - page_offset - 1) * 32), 101, 17)

                local percentage = Game.battle.party[index].chara:getHealth() / Game.battle.party[index].chara:getStat("health")
                if Game:isLight() then
                    Draw.setColor(MG_PALETTE["action_health"])
                else
                    Draw.setColor(PALETTE["action_health"])
                end
                love.graphics.rectangle("fill", hp_x, 10 + ((index - page_offset - 1) * 32), math.max(0,math.ceil(percentage),math.floor(percentage * 101)), 17)
            else
                if Game:isLight() then
                    Draw.setColor(MG_PALETTE["action_health_bg"])
                else
                    Draw.setColor(PALETTE["action_health_bg"])
                end
                love.graphics.rectangle("fill", 420, 10 + ((index - page_offset - 1) * 32), 101, 17)

                local percentage = Game.battle.party[index].chara:getHealth() / Game.battle.party[index].chara:getStat("health")
                -- Chapter 3 introduces this lower limit, but all chapters in Kristal might as well have it
                -- Swooning is the only time you can ever see it this low
                percentage = math.max(-1, percentage)
                if Game:isLight() then
                    Draw.setColor(MG_PALETTE["action_health"])
                else
                    Draw.setColor(PALETTE["action_health"])
                end
                love.graphics.rectangle("fill", 420, 10 + ((index - page_offset - 1) * 32), math.ceil(percentage * 101), 17)
            end
        end
        
        Draw.setColor(1, 1, 1, 1)
        
        if page < max_page then
            Draw.draw(self.arrow_sprite, 45, 90 + (math.sin(Kristal.getTime()*6) * 2))
        end
        if page > 0 then
            Draw.draw(self.arrow_sprite, 45, 10 - (math.sin(Kristal.getTime()*6) * 2), 0, 1, -1)
        end
    elseif state == "FLEEING" or state == "TRANSITIONOUT" then
        local message = Game.battle.encounter.used_flee_message or ""
        self.flee_text:setText("[shake:"..MagicalGlassLib.light_battle_shake_text.."]" .. message)
    end
end

function LightBattleUI:update()
    local shapeshifting_arena = {"ENEMYDIALOGUE", "DIALOGUEEND", "DEFENDINGBEGIN", "DEFENDING", "DEFENDINGEND"}
    if math.ceil(self.help_window.y) < 280 and not Utils.containsValue(shapeshifting_arena, Game.battle.state) then
        self.help_window:toggleVisibility(true)
    else
        self.help_window:toggleVisibility(false)
    end
    super.update(self)
end

function LightBattleUI:draw()
    self:drawState()
    super.draw(self)
end

return LightBattleUI