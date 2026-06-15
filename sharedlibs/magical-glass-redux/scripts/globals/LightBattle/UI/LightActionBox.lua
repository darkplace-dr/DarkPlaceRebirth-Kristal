local LightActionBox, super = Class(Object)

function LightActionBox:init(x, y, index, battler)
    super.init(self, x, y)

    self.index = index
    self.battler = battler

    self.selected_button = 1
    self.last_button = 1

    if not Game.battle.encounter.event then
        self:createButtons()
    end
end

function LightActionBox:getSelectableButtons()
    local buttons = {}
    for i, button in ipairs(self.buttons) do
        if not button.disabled then
            table.insert(buttons, button)
        end
    end
    return buttons
end

function LightActionBox:getButtons(battler) end

function LightActionBox:createButtons()
    for _, button in ipairs(self.buttons or {}) do
        button:remove()
    end

    self.buttons = {}

    local btn_types = {"fight", "act", "magic", "item", "mercy"} -- There's also "defend" and "spare" as a seperated buttons instead of being part of "mercy"

    if not self.battler.chara:hasAct() then TableUtils.removeValue(btn_types, "act") end
    if not self.battler.chara:hasSpells() then TableUtils.removeValue(btn_types, "magic") end

    for lib_id,_ in Kristal.iterLibraries() do
        btn_types = Kristal.libCall(lib_id, "getLightActionButtons", self.battler, btn_types) or btn_types
    end
    btn_types = Kristal.modCall("getLightActionButtons", self.battler, btn_types) or btn_types
    
    if #btn_types == 1 then
        btn_types = {false, false, btn_types[1], false, false}
    elseif #btn_types == 2 then
        btn_types = {false, btn_types[1], false, btn_types[2], false}
    elseif #btn_types == 3 then
        btn_types = {btn_types[1], false, btn_types[2], false, btn_types[3]}
    end
    
    local function x_position(index)
        local x = 0
        if #btn_types == 4 then
            x = math.floor(67 + ((index - 1) * 156))
            if index == 2 then
                x = x - 3
            elseif index == 3 then
                x = x + 1
            end
        else
            x = math.floor(67 + ((index - 1) * 117) - (#btn_types - 5) * 117 / 2)
        end
        return x
    end

    for i, btn in ipairs(btn_types) do
        if type(btn) == "string" then
            local button = LightActionButton(btn, self.battler, x_position(i), 175)
            button.actbox = self
            table.insert(self.buttons, button)
            self:addChild(button)
        elseif type(btn) ~= "boolean" then -- nothing if a boolean value, used to create an empty space
            btn:setPosition(x_position(i), 175)
            btn.battler = self.battler
            btn.actbox = self
            table.insert(self.buttons, btn)
            self:addChild(btn)
        end
    end

    self.selected_button = MathUtils.clamp(self.selected_button, 1, #self:getSelectableButtons())
end

function LightActionBox:snapSoulToButton()
    if self:getSelectableButtons() then
        if self.selected_button < 1 then
            self.selected_button = #self:getSelectableButtons()
        end

        if self.selected_button > #self:getSelectableButtons() then
            self.selected_button = 1
        end

        Game.battle.soul.x = self:getSelectableButtons()[self.selected_button].x - 19
        Game.battle.soul.y = self:getSelectableButtons()[self.selected_button].y + 279
    end
end

function LightActionBox:update()
    if self.buttons then
        for i, button in ipairs(self.buttons) do
            if (Game.battle.current_selecting == 0 and self.index == 1) or (Game.battle.current_selecting == self.index) then
                button.visible = true
            else
                button.visible = false
            end
            if (Game.battle.current_selecting == self.index) then
                button.selectable = true
                button.hovered = (self.selected_button == i)
            else
                button.selectable = false
                button.hovered = false
            end
        end
    end

    super.update(self)
end

function LightActionBox:select()
    local buttons = self:getSelectableButtons()
    self.last_button = self.selected_button
    buttons[self.selected_button]:select()
end

function LightActionBox:unselect()
    local buttons = self:getSelectableButtons()
    self.last_button = self.selected_button
    buttons[self.selected_button]:unselect()
end

function LightActionBox:draw()
    super.draw(self)
end

return LightActionBox