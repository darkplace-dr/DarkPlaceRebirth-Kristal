local LightBattleItemSelect, super = Class(Object, "LightBattleItemSelect")

-- Note: This class defines the layout of the JP-styled item menu.
--       the normal item menu is handled by LightBattleMenuSelect.

LightBattleItemSelect.SHOWN_ITEMS = 3

function LightBattleItemSelect:init(x, y)
    super.init(self, x, y)

    options = options or {}

    self.menu_active = false
    self.visible = false

    self.menu_items = {}
    self.max_items = nil

    self.text = {}
    self:createText()

    self.current_item = nil
    self.offset = nil

    self.always_show_scrollbar = nil

    self.cancel_callback = nil

    self.arrow_sprite = Assets.getTexture("ui/lightbattle/item_arrow")
end

function LightBattleItemSelect:onActivated()
    self.menu_active = true
    self.visible = true
end

function LightBattleItemSelect:onDeactivated()
    self.menu_active = false
    self.visible = false
end

function LightBattleItemSelect:hasItems()
    return #self.menu_items > 0
end

function LightBattleItemSelect:getCurrentItem()
    return self.menu_items[self.current_item]
end

function LightBattleItemSelect:getCurrentText()
    return self.text[self.current_item - (self.offset - 1)]
end

function LightBattleItemSelect:canSelectMenuItem(item)
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

function LightBattleItemSelect:createText()
    for i = 0, 2 do
        local text = LightBattleMenuSelectItem(0, i * 32)
        table.insert(self.text, text)
        self:addChild(text)
    end
end

function LightBattleItemSelect:setCancelCallback(callback)
    self.cancel_callback = callback
end

function LightBattleItemSelect:setup(inventory, options)
    self:clear()

    self.visible = true
    if inventory then
        self.max_items = options["max_items"] or inventory.max

        for _,item in ipairs(inventory) do
            self:addMenuItem(item)
        end 
    else
        self.max_items = options["max_items"]
    end

    self.always_show_scrollbar = options["always_show_scrollbar"]

    self.current_item = 1
    self.offset = 1

    self:refresh()
end

function LightBattleItemSelect:addMenuItem(item)
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

    self:refresh()
end

function LightBattleItemSelect:clear()
    self.visible = false

    self.cancel_callback = nil

    self.menu_items = {}
    self.max_items = nil

    for _,text in ipairs(self.text) do
        text:setText("")
    end
end

function LightBattleItemSelect:refresh()
    self:refreshOffset()
    self:refreshText()
end

function LightBattleItemSelect:refreshOffset()
    local min_scroll = math.max(1, self.current_item - (LightBattleItemSelect.SHOWN_ITEMS - 1))
    local max_scroll = math.min(math.max(1, #self.menu_items - (LightBattleItemSelect.SHOWN_ITEMS - 1)), self.current_item)
    self.offset = Utils.clamp(self.offset, min_scroll, max_scroll)
end

function LightBattleItemSelect:refreshText()
    for i, text in ipairs(self.text) do
        local item_index = ((i - 1) + self.offset)
        local item = self.menu_items[item_index]

        if item then
            text.visible = true
            text:setText("* " .. item.name)
            if not self:canSelectItem(item) then
                text:setColor(Utils.unpackColor(COLORS.gray))
            elseif item.color then
                text:setColor(Utils.unpackColor(item.color))
            end
            text:setParty(item.party)
            text:setIcons(item.icons)
        else
            text.visible = false
            text:clear()
        end
    end
end

function LightBattleItemSelect:onKeyPressed(key)
    if self.menu_active and self:hasItems() then
        if Input.isConfirm(key) then
            self:select(self:getCurrentItem(), self:canSelectMenuItem(self:getCurrentItem()))
        elseif Input.isCancel(key) then
            self:cancel()
        elseif Input.is("up", key) then
            if self.current_item - 1 > 0 then
                Game.battle:playMoveSound()
                self.current_item = self.current_item - 1

                self:refresh()
            end
        elseif Input.is("down", key) then
            if self.current_item + 1 <= #self.menu_items then
                Game.battle:playMoveSound()
                self.current_item = self.current_item + 1

                self:refresh()
            end
        end
    end
end

function LightBattleItemSelect:select(item, can_select)
    if can_select then
        Game.battle:playSelectSound()
    end

    if item.callback then
        item.callback(item.data, item, can_select)
    end
end

function LightBattleItemSelect:cancel()
    if self.cancel_callback then
        self.cancel_callback()
    end

    self:clear()
end

function LightBattleItemSelect:update()
    if self.menu_active then
        self:snapSoulToItem()
    end

    super.update(self)
end

function LightBattleItemSelect:snapSoulToItem()
    if Game.battle.soul and self:hasItems() then
        if self:getCurrentText() then
            local x, y = self:getCurrentText():getRelativePosFor(Game.battle)
            Game.battle.soul:setPosition(x - 27, y + 16)
        else
            Game.battle.soul:setPosition(0, 0)
        end
    end
end

function LightBattleItemSelect:draw()
    if #self.menu_items > 0 then
        Draw.setColor(COLORS.WHITE)

        if not self.always_show_scrollbar and (self.max_items and self.max_items <= 8) then
            self:drawDots()
        else
            self:drawScrollBar()
        end
    end

    super.draw(self)
end

function LightBattleItemSelect:drawDots()
    if #self.menu_items > 3 then
        local x = 472

        local y_limit_top = 12
        local y_limit_bottom = 70

        local y = math.floor(Utils.round(y_limit_top + (y_limit_bottom / 2)) - (5 * (2 + #self.menu_items)))
        local y_offset = Utils.round((math.min((Kristal.getTime() % 1), 0.5) * 6))

        if self.offset > 1 then
            Draw.draw(self.arrow_sprite, x, y - y_offset)
        end

        y = y + 10

        for i = 0, #self.menu_items - 1 do
            if i == self.current_item - 1 then
                Draw.rectangle("fill", x + 3, y, 10, 10)
            else
                Draw.rectangle("fill", (x + 3) + 3, y + 3, 4, 4)
            end

            y = y + 10
        end

        if self.offset <= #self.menu_items - LightBattleItemSelect.SHOWN_ITEMS then
            Draw.draw(self.arrow_sprite, x, (y + 10) + y_offset, 0, 1, -1)
        end
    end
end

function LightBattleItemSelect:drawScrollBar()
    if #self.menu_items > 3 then
        local x, y = 477, 10
        local height = 75

        local y_offset = Utils.round((math.min((Kristal.getTime() % 1), 0.5) * 6))

        if self.offset > 1 then
            Draw.draw(self.arrow_sprite, x - 4.5, -y_offset - 3)
        end

        if self.offset <= #self.menu_items - LightBattleItemSelect.SHOWN_ITEMS then
            Draw.draw(self.arrow_sprite, x - 4.5, 97 + y_offset, 0, 1, -1)
        end

        Draw.setColor(COLORS.dkgray)
        Draw.rectangle("fill", x, y, 6, height)
        local percent = (self.current_item - 1) / (#self.menu_items - 1)
        Draw.setColor(COLORS.white)
        Draw.rectangle("fill", x, y + math.floor(percent * (height - 8)), 6, 8)
    end
end

return LightBattleItemSelect