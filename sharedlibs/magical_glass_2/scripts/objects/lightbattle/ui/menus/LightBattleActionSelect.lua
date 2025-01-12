local LightBattleActionSelect, super = Class(Object, "LightBattleActionSelect")

function LightBattleActionSelect:init(x, y, cursor_memory)
    super.init(self, x, y)

    self.menu_active = false

    self.battler = nil

    self.buttons = {}
    self.current_button = nil

    self.cursor_memory = cursor_memory
    self.memory_button = nil
end

function LightBattleActionSelect:onActivated()
    self.menu_active = true
end

function LightBattleActionSelect:onDeactivated()
    self.menu_active = false
end

function LightBattleActionSelect:hasButtons()
    return self.buttons and #self.buttons > 1
end

function LightBattleActionSelect:getCurrentButton()
    return self.buttons[self.current_button]
end

function LightBattleActionSelect:setup(member)
    for _,button in ipairs(self.buttons) do
        button:remove()
    end

    self.battler = member
    self.buttons = {}

    local button_types = {"fight", "act", "spell", "item", "mercy"}

    if not self.battler.chara:hasAct() then Utils.removeFromTable(button_types, "act") end
    if not self.battler.chara:hasSpells() then Utils.removeFromTable(button_types, "spell") end

    button_types = Kristal.callEvent("getLightActionButtons", self.battler, button_types) or button_types

    -- holy fuck this is terrible
    local start_x = (213 / 2) - ((#button_types - 1) * 35 / 2) - 1

    for i, ibutton in ipairs(button_types) do
        if type(ibutton) == "string" then
            local x

            if #button_types <= 4 then
                x = math.floor(67 + ((i - 1) * 156))
                if i == 2 then
                    x = x - 3
                elseif i == 3 then
                    x = x + 1
                end
            else
                x = math.floor(67 + ((i - 1) * 117))
            end
            
            local button = LightActionButton(x, 0, ibutton, self.battler)
            if ibutton == "item" and #Game.inventory:getStorage(Game.battle.item_inventory) == 0 then
                button.selectable = false
            end
            table.insert(self.buttons, button)
            self:addChild(button)
        elseif type(ibutton) == "boolean" and ibutton == false then
            -- nothing, used to create an empty space
        else
            ibutton:setPosition(math.floor(66 + ((i - 1) * 156)) + 0.5, 0)
            ibutton.battler = self.battler
            table.insert(self.buttons, ibutton)
            self:addChild(ibutton)
        end
    end

    if self.cursor_memory then
        if not self.buttons[self.current_button] then
            self.current_button = 1
        end
    else
        self.current_button = 1
    end
end

function LightBattleActionSelect:update()
    if self.menu_active and self:hasButtons() then
        for i, button in ipairs(self.buttons) do
            button.hovered = (self.current_button == i)
        end
    end

    if self.menu_active then
        self:snapSoulToButton()
    end

    super.update(self)
end

function LightBattleActionSelect:onKeyPressed(key)
    if self.menu_active and self:hasButtons() then
        if Input.isConfirm(key) then
            self:select(self:getCurrentButton())
        elseif Input.isCancel(key) then
            self:cancel()
        elseif Input.is("left", key) then
            Game.battle:playMoveSound()
            self.current_button = self.current_button - 1
        elseif Input.is("right", key) then
            Game.battle:playMoveSound()
            self.current_button = self.current_button + 1
        end

        if self.current_button < 1 then
            self.current_button = #self.buttons
        end

        if self.current_button > #self.buttons then
            self.current_button = 1
        end
    end
end

function LightBattleActionSelect:unselect()
    self.current_button = 0
    for _,button in ipairs(self.buttons) do
        button.hovered = false
    end
end

function LightBattleActionSelect:select(button)
    Game.battle:playSelectSound()
    
    button:select()
end

function LightBattleActionSelect:cancel()
    Game.battle:previousParty()
end

function LightBattleActionSelect:snapSoulToButton()
    if Game.battle.soul and self.buttons then
        local x, y = self:getCurrentButton():getRelativePosFor(Game.battle)
        Game.battle.soul:setPosition(x - 38, y + 9)
    end
end

return LightBattleActionSelect