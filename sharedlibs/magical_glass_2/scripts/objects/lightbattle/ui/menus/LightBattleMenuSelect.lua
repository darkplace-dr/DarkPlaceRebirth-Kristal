local LightBattleMenuSelect, super = Class(Object, "LightBattleMenuSelect")

function LightBattleMenuSelect:init(x, y, cursor_memory)
    super.init(self, x, y)

    self.menu_active = false
    self.visible = false

    self.menu_items = {}

    self.text = {}
    self:createText()

    self.current_x = nil
    self.current_y = nil

    self.current_columns = nil
    self.current_rows = nil
    self.current_h_separation = nil

    -- VERTICAL, HORIZONTAL
    self.scroll_direction = nil

    self.cursor_memory = cursor_memory
    self.memory_x = nil
    self.memory_y = nil

    self.shorten_names = nil

    self.page = nil
    self.show_page = nil

    self.always_play_move_sound = nil

    self.cancel_callback = nil

    self.page_text = Text("", 288, 64, {font = "main_mono"})
    self.page_text.visible = false
    self:addChild(self.page_text)

    self.arrow_sprite = Assets.getTexture("ui/lightbattle/item_arrow")
end

function LightBattleMenuSelect:onActivated()
    self.menu_active = true
    self.visible = true

    self:refresh()
end

function LightBattleMenuSelect:onDeactivated()
    self.menu_active = false
    self.visible = false
end

function LightBattleMenuSelect:hasItems()
    return #self.menu_items > 0
end

function LightBattleMenuSelect:getCurrentIndex()
    -- i hate this, do it better
    local page = math.ceil(self.current_x / self.current_columns) - 1
    return (self.current_columns * (self.current_y - 1) + ((self.current_x - 1) + (page * 2)))
end

function LightBattleMenuSelect:getCurrentItem()
    return self.menu_items[self:getCurrentIndex() + 1]
end

function LightBattleMenuSelect:getMaxPages()
    return math.ceil(#self.menu_items / (self.current_columns * self.current_rows))
end

function LightBattleMenuSelect:isCurrentLocationValid()
    if self:getCurrentIndex() + 1 > #self.menu_items or self:getCurrentIndex() < 0 then
        return false
    end

    if not self:getCurrentItem() then
        return false
    end

    if self.scroll_direction == "HORIZONTAL" then
        if self.current_y > self.current_rows or self.current_y < 1 then
            return false
        end

        if self.current_x > self.current_columns * self:getMaxPages() or self.current_x < 1 then
            return false
        end
    elseif self.scroll_direction == "VERTICAL" then
        if (self.current_x > self.current_columns) or self.current_x < 1 then
            return false
        end

        if self.current_y > self.current_rows * self:getMaxPages() or self.current_y < 1 then
            return false
        end
    end
    return true
end

function LightBattleMenuSelect:getCurrentText()
    local index = ((self:getCurrentIndex()) % (self.current_columns * self.current_rows)) + 1
    return self.text[index]
end

function LightBattleMenuSelect:canSelectItem(item)
    if item.unusable then
        return false
    end
    if item.tp and (item.tp > Game:getTension()) then
        return false
    end
    if item.party then
        for _,party_id in ipairs(item.party) do
            local party_index = Game.battle:getPartyIndex(party_id)
            local battler = Game.battle.party[party_index]
            local action = Game.battle.queued_actions[party_index]
            if (not battler) or (not battler:isActive()) or (action and action.cancellable == false) then
                -- They're either down, asleep, or don't exist. Either way, they're not here to do the action.
                return false
            end
        end
    end
    return true
end

function LightBattleMenuSelect:createText(item)
    for i = 1, 6 do
        local text = LightBattleMenuSelectItem()
        table.insert(self.text, text)
        self:addChild(text)
    end
end

function LightBattleMenuSelect:alignText()
    if self.current_columns == 1 then
        for i, text in ipairs(self.text) do
            text.x = 0
            text.y = (i - 1) * 32
        end
    else
        local y_left = 0
        local y_right = 0    

        for i, text in ipairs(self.text) do
            if i % 2 == 1 then
                text.x = 0
                text.y = y_right
    
                y_right = y_right + 32
            else
                text.x = self.current_h_separation
                text.y = y_left
    
                y_left = y_left + 32
            end
        end
    end
end

function LightBattleMenuSelect:addMenuItem(item)
    item = {
        ["name"] = (item.getName and item:getName()) or item.name or "",
        ["short_name"] = (item.getShortName and item:getShortName()) or item.short_name or nil,
        ["serious_name"] = (item.getSeriousName and item:getSeriousName()) or item.serious_name or nil,
        ["tp"] = item.tp or 0,
        ["unusable"] = item.unusable or false,
        ["description"] = item.description or "",
        ["color"] = item.color or nil,
        ["party"] = item.party or {},
        ["icons"] = item.icons or {},
        ["data"] = item.data or nil,
        ["callback"] = item.callback or function() end,
    }
    table.insert(self.menu_items, item)
end

function LightBattleMenuSelect:setCancelCallback(callback)
    self.cancel_callback = callback
end

function LightBattleMenuSelect:setup(items, columns, rows, options)
    if type(columns) == "table" then options = columns end
    options = options or {}

    self:clear()

    self.visible = true

    self.current_columns = columns or 2
    self.current_rows = rows or 3
    self.current_h_separation = options["h_separation"] or 256

    if options["cancel_callback"] then
        self:setCancelCallback(options["cancel_callback"])
    end

    self.scroll_direction = options["scroll_direction"] or "VERTICAL"

    self.shorten_names = options["shorten_names"] or false

    self.page_text.visible = options["show_page"] or false

    self.always_play_move_sound = options["always_play_move_sound"] or false

    self:alignText()

    for _,item in ipairs(items) do
        self:addMenuItem(item)
    end

    if not options["no_cursor_memory"] and (self.cursor_memory and self.memory_x and self.memory_y) then
        self.current_x = self.memory_x
        self.current_y = self.memory_y

        self.memory_x = nil
        self.memory_y = nil

        if not self:isCurrentLocationValid() then
            self.current_x = 1
            self.current_y = 1
        end
    else
        self.current_x = 1
        self.current_y = 1
    end

    self:refresh()
end

function LightBattleMenuSelect:refresh()
    self:refreshPage()
    self:refreshText()
end

function LightBattleMenuSelect:refreshText()
    local item_count = (self.current_columns * self.current_rows)
    for i, text in ipairs(self.text) do
        if i <= item_count then
            text.visible = true

            local item_index = i + self.page * item_count
            local item = self.menu_items[item_index]

            if item then
                if self.shorten_names then
                    if Game.battle.encounter.serious then
                        text:setName(item.serious_name or item.name)
                    else
                        text:setName(item.short_name or item.name)
                    end
                else
                    text:setName(item.name)
                end

                if not self:canSelectItem(item) then
                    text:setNameColor(Utils.unpackColor(COLORS.gray))
                elseif item.color then
                    text:setNameColor(Utils.unpackColor(item.color))
                else
                    if #item.party == 1 then
                        text:setNameColor(Game:getPartyMember(item.party[1]):getLightXActColor())
                    end
                end

                text:setParty(item.party)
                text:setIcons(item.icons)
            else
                text:clear()
            end
        else
            text.visible = false
            text:clear()
        end
    end
end

function LightBattleMenuSelect:refreshPage()
    if self.scroll_direction == "HORIZONTAL" then
        self.page = math.ceil(self.current_x / self.current_columns) - 1
    elseif self.scroll_direction == "VERTICAL" then
        self.page = math.ceil(self.current_y / self.current_rows) - 1
    end

    if MagicalGlass.light_battle_text_shake then
        self.page_text:setText("[ut_shake]PAGE " .. self.page + 1)
    else
        self.page_text:setText("PAGE " .. self.page + 1)
    end
end

function LightBattleMenuSelect:onKeyPressed(key)
    if self.menu_active and self:hasItems() then
        if Input.isConfirm(key) then
            self:select(self:getCurrentItem(), self:canSelectItem(self:getCurrentItem()))
        elseif Input.isCancel(key) then
            self:cancel()
        elseif Input.is("up", key) then
            self:moveCursor(0, -1)
        elseif Input.is("down", key) then
            self:moveCursor(0, 1)
        elseif Input.is("left", key) then
            self:moveCursor(-1, 0)
        elseif Input.is("right", key) then
            self:moveCursor(1, 0)
        end
    end
end

function LightBattleMenuSelect:select(item, can_select)
    if can_select then
        Game.battle:playSelectSound()
    end

    if item.callback then
        item.callback(item.data, item, can_select)
    end
end

function LightBattleMenuSelect:cancel()
    if self.cursor_memory then
        self.memory_x = self.current_x
        self.memory_y = self.current_y
    end

    if self.cancel_callback then
        self.cancel_callback()
    end

    self:clear()
end

function LightBattleMenuSelect:moveCursor(x, y)
    if #self.menu_items <= 1 then return end

    local memory_x = self.current_x
    local memory_y = self.current_y

    if x ~= 0 and self.current_columns > 1 then
        self.current_x = self.current_x + x

        if not self:isCurrentLocationValid() then
            if self.current_x > self.current_columns then
                self.current_x = 1
            elseif self.current_x < 1 then
                if self.scroll_direction == "HORIZONTAL" then
                    self.current_x = (self.current_columns * self:getMaxPages()) + 1

                    local give_up = 0
                    repeat
                        give_up = give_up + 1
                        if give_up >= 100 then
                            print("[MG WARNING] Couldn't find a valid menu item")
                            self.current_x = 1
                            break
                        end
    
                        self.current_x = self.current_x - 1
                    until(self:isCurrentLocationValid())
                elseif self.scroll_direction == "VERTICAL" then
                    self.current_x = self.current_columns

                    if not self:isCurrentLocationValid() then
                        self.current_y = self.current_y - 1
                    end
                end
            else
                if self.scroll_direction == "HORIZONTAL" then
                    self.current_x = memory_x
                    Game.battle:playMoveSound()
                elseif self.scroll_direction == "VERTICAL" then
                    self.current_x = self.current_columns
                    if not self:isCurrentLocationValid() then
                        self.current_y = self.current_y - 1
                    end
                end
            end 
        end 
    end
    
    if y ~= 0 and self.current_rows > 1 then
        self.current_y = self.current_y + y

        if self.scroll_direction == "HORIZONTAL" then
            Game.battle:playMoveSound()
        end

        if not self:isCurrentLocationValid() then
            if self.current_y > self.current_rows then
                self.current_y = 1
            elseif self.current_y < 1 then
                if self.scroll_direction == "HORIZONTAL" then
                    self.current_y = self.current_rows + 1
                elseif self.scroll_direction == "VERTICAL" then
                    self.current_y = (self.current_rows * self:getMaxPages()) + 1
                end

                local give_up = 0
                repeat
                    give_up = give_up + 1
                    if give_up >= 100 then
                        print("[MG WARNING] Couldn't find a valid menu item")
                        self.current_y = 1
                        break
                    end

                    self.current_y = self.current_y - 1
                until(self:isCurrentLocationValid())
            else
                self.current_y = 1
            end
        end
    end

    if (self.current_x ~= memory_x) or (self.current_y ~= memory_y) then
        Game.battle:playMoveSound()
    end

    self:refresh()
end

function LightBattleMenuSelect:update()
    if self.menu_active then
        self:snapSoulToItem()
    end

    super.update(self)
end

function LightBattleMenuSelect:snapSoulToItem()
    if Game.battle.soul and self:hasItems() then
        if self:getCurrentText() then
            local x, y = self:getCurrentText():getRelativePosFor(Game.battle)
            Game.battle.soul:setPosition(x - 27, y + 16)
        else
            Game.battle.soul:setPosition(0, 0)
        end
    end
end

function LightBattleMenuSelect:drawArrows()
    Draw.setColor(COLORS.WHITE)
    if self:getMaxPages() > 1 then
        local x, y = 477, 10
        local y_offset = Utils.round((math.min((Kristal.getTime() % 1), 0.5) * 6))

        if self.page > 0 then
            Draw.draw(self.arrow_sprite, x - 4.5, -y_offset - 3)
        end

        if self.page < math.ceil((#self.menu_items + 1) / (self.current_columns * self.current_rows)) - 1 then
            Draw.draw(self.arrow_sprite, x - 4.5, 97 + y_offset, 0, 1, -1)
        end
    end
end

function LightBattleMenuSelect:draw()
    if self.scroll_direction == "VERTICAL" then
        self:drawArrows()
    end

    if DEBUG_RENDER then
        love.graphics.print("x: " .. self.current_x, 0, -64)
        love.graphics.print("y: " .. self.current_y, 128, -64)
        love.graphics.print("col: " .. self.current_columns, 0, -128)
        love.graphics.print("row: " .. self.current_rows, 128, -128)
    end

    super.draw(self)
end

function LightBattleMenuSelect:clear()
    self.visible = false
    self.cancel_callback = nil

    self.menu_items = {}

    self.current_x = nil
    self.current_y = nil

    self.current_columns = nil
    self.current_rows = nil
    self.current_h_separation = nil

    self.shorten_names = nil

    for _,text in ipairs(self.text) do
        text:clear()
    end
end

return LightBattleMenuSelect