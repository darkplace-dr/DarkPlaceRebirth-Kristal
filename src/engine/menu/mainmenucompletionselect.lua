-- This is a giant, horrific hack to load saves

---@class MainMenuCompletionSelect : StateClass
---
---@field menu MainMenu
---
---@overload fun(menu:MainMenu) : MainMenuCompletionSelect
local MainMenuCompletionSelect, super = Class(StateClass)

function MainMenuCompletionSelect:init(menu)
    self.menu = menu
end

function MainMenuCompletionSelect:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function MainMenuCompletionSelect:mkIter(input)
    if type(input) == "table" or type(input) == "userdata" then
        assert(input.lines, "Invalid argument #1 (Expected file or function)")
        local file = input
        if not file:isOpen() then
            file:open("r")
        end
        input = file:lines()
    elseif type(input) == "string" then
        local lines = Utils.split(input, "\n", false)
        local index = 0
        input = function()
            index = index + 1
            return lines[index]
        end
    else
        assert(type(input) == "function", type(input))
    end
    return input
end

function MainMenuCompletionSelect:parseIni(input)
    input = self:mkIter(input)
    local data = {}
    local current_subkey
    for line in input do
        local key, value = Utils.unpack(Utils.splitFast(line, "="))
        if line[1] == "[" then
            current_subkey = {}
            data[line:sub(2, #line - 1)] = current_subkey
        elseif key and value then
            if value[1] == '"' then
                value = value:sub(2, #value - 1)
            end
            if tonumber(value) then value = tonumber(value) end
            ---@diagnostic disable-next-line: cast-local-type
            if tonumber(key) then key = tonumber(key) end
            current_subkey[key] = value
        end
    end
    return data
end

local function getSaveDirectory()
    local os_name = love.system.getOS()
    if os_name == "Windows" then
        return string.gsub(os.getenv("LOCALAPPDATA"), "\\", "/") .. "/Deltarune/"
    elseif os_name == "Linux" then
        return os.getenv("HOME") .. "/.local/share/Steam/steamapps/compatdata/1690940/pfx/drive_c/users/steamuser/AppData/Local/DELTARUNE/"
    elseif os_name == "OS X" then
        return os.getenv("HOME") .. "/Library/Application Support/com.tobyfox.deltarune/"
    end
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuCompletionSelect:onEnter(old_state)
    self.dr_ini = {}
    (function ()
        local path = getSaveDirectory()
        self.dr_ini = self:parseIni(NativeFS.newFile(path .. "dr.ini"))
    end)()
    if old_state == "FILENAME" then
        self.container.visible = true
        self.container.active = true
        return
    end

    self.mod = self.menu.selected_mod

    self.container = self.menu.stage:addChild(Object())
    self.container:setLayer(50)

    -- SELECT, COPY, ERASE, TRANSITIONING
    self.state = "SELECT"

    self.result_text = nil
    self.result_timer = 0

    self.focused_button = nil
    self.copied_button = nil
    self.erase_stage = 1

    self.selected_x = 1
    self.selected_y = 1

    self.files = {}
    for i = 1, 3 do
        local data = Kristal.loadData("file_" .. i, self.mod.id)
        local button = FileButton(self, i, self:getCompletionFile(i), 110, 110 + 90 * (i - 1), 422, 82)
        if i == 1 then
            button.selected = true
        end
        table.insert(self.files, button)
        self.container:addChild(button)
    end

    self.bottom_row_heart = { 80, 250, 440 }
end

function MainMenuCompletionSelect:getCompletionFile(slot)
    local dr_save = self.dr_ini["G_2_"..(2+slot)]
    if dr_save then
        return {name = dr_save.Name, room_name = "Living Room?", playtime = (dr_save.Time/30)}
    end
end

function MainMenuCompletionSelect:onLeave(new_state)
    if new_state == "FILENAME" then
        self.container.visible = false
        self.container.active = false
    else
        self.container:remove()
        self.container = nil
    end
end

function MainMenuCompletionSelect:onKeyPressed(key, is_repeat)
    if is_repeat or self.state == "TRANSITIONING" then
        return true
    end
    if self.focused_button then
        local button = self.focused_button
        if Input.is("cancel", key) then
            button:setColor(1, 1, 1)
            button:setChoices()
            if self.state == "COPY" then
                self.selected_y = self.copied_button.id
                self.copied_button:setColor(1, 1, 1)
                self.copied_button = nil
                self:updateSelected()
            elseif self.state == "ERASE" then
                self.erase_stage = 1
            end
            self.focused_button = nil
            Assets.stopAndPlaySound("ui_cancel")
            return true
        end
        if Input.is("left", key) and button.selected_choice == 2 then
            button.selected_choice = 1
            Assets.stopAndPlaySound("ui_move")
        end
        if Input.is("right", key) and button.selected_choice == 1 then
            button.selected_choice = 2
            Assets.stopAndPlaySound("ui_move")
        end
        if Input.is("confirm", key) then
            if self.state == "SELECT" then
                Assets.stopAndPlaySound("ui_select")
                if button.selected_choice == 1 then
                    local skip_naming = button.data ~= nil

                    if skip_naming then
                        self:setState("TRANSITIONING")
                        local save_name = nil
                        if not button.data and Kristal.Config["skipNameEntry"] and Kristal.Config["defaultName"] ~= "" then
                            save_name = string.sub(Kristal.Config["defaultName"], 1, self.mod["nameLimit"] or 12)
                        end
                        Kristal.loadMod(self.mod.id, -1, save_name)
                    else
                        self.menu:setState("FILENAME")

                        button:setChoices()
                        self.focused_button = nil
                        Assets.playSound("ui_cant_select")
                    end
                elseif button.selected_choice == 2 then
                    button:setChoices()
                    self.focused_button = nil
                end
            elseif self.state == "ERASE" then
                if button.selected_choice == 1 and self.erase_stage == 1 then
                    Assets.stopAndPlaySound("ui_select")
                    button:setColor(1, 0, 0)
                    button:setChoices({ "Yes!", "No!" }, "Really erase it?")
                    self.erase_stage = 2
                else
                    local result
                    if button.selected_choice == 1 and self.erase_stage == 2 then
                        Assets.stopAndPlaySound("ui_spooky_action")
                        Kristal.eraseData("file_" .. button.id, self.mod.id)
                        button:setData(nil)
                        result = "Erase complete."
                    else
                        Assets.stopAndPlaySound("ui_select")
                    end
                    button:setChoices()
                    button:setColor(1, 1, 1)
                    self.focused_button = nil
                    self.erase_stage = 1

                    self:setState("SELECT", result)
                    self.selected_x = 2
                    self.selected_y = 4
                    self:updateSelected()
                end
            elseif self.state == "COPY" then
                if button.selected_choice == 1 then
                    Assets.stopAndPlaySound("ui_spooky_action")
                    local data = Kristal.loadData("file_" .. self.copied_button.id, self.mod.id)
                    Kristal.saveData("file_" .. button.id, data, self.mod.id)
                    button:setData(data)
                    button:setChoices()
                    self:setState("SELECT", "Copy complete.")
                    self.copied_button:setColor(1, 1, 1)
                    self.copied_button = nil
                    self.focused_button = nil
                    self.selected_x = 1
                    self.selected_y = 4
                    self:updateSelected()
                elseif button.selected_choice == 2 then
                    Assets.stopAndPlaySound("ui_select")
                    button:setChoices()
                    self:setState("SELECT")
                    self.copied_button:setColor(1, 1, 1)
                    self.copied_button = nil
                    self.focused_button = nil
                    self.selected_x = 1
                    self.selected_y = 4
                    self:updateSelected()
                end
            end
        end
    elseif self.state == "SELECT" then
        if Input.is("cancel", key) then
            self.menu:setState("FILESELECT")
            Assets.stopAndPlaySound("ui_cancel")
            return true
        end
        if Input.is("confirm", key) then
            Assets.stopAndPlaySound("ui_select")
            if self.selected_y <= 3 then
                if self:getSelectedFile().data then
                    -- TODO: Handle this variable in modland
                    DELTARUNE_SAVE_ID = self.selected_y
                    Kristal.loadMod(self.mod.id, -1, save_name)
                else
                    Assets.playSound("ui_cant_select")
                end
            elseif self.selected_y == 4 then
                self.menu:setState("FILESELECT")
            end
            return true
        end
        local last_x, last_y = self.selected_x, self.selected_y
        if Input.is("up", key) then self.selected_y = self.selected_y - 1 end
        if Input.is("down", key) then self.selected_y = self.selected_y + 1 end
        if Input.is("left", key) then self.selected_x = self.selected_x - 1 end
        if Input.is("right", key) then self.selected_x = self.selected_x + 1 end
        self.selected_y = Utils.clamp(self.selected_y, 1, 4)
        if self.selected_y <= 3 then
            self.selected_x = 1
        else
            self.selected_x = 1
        end
        if last_x ~= self.selected_x or last_y ~= self.selected_y then
            Assets.stopAndPlaySound("ui_move")
            self:updateSelected()
        end
    elseif self.state == "COPY" then
        if Input.is("cancel", key) then
            Assets.stopAndPlaySound("ui_cancel")
            if self.copied_button then
                self.selected_y = self.copied_button.id
                self.copied_button:setColor(1, 1, 1)
                self.copied_button = nil
                self:updateSelected()
            else
                self:setState("SELECT")
                self.selected_x = 1
                self.selected_y = 4
                self:updateSelected()
            end
            return true
        end
        if Input.is("confirm", key) then
            if self.selected_y <= 3 then
                if not self.copied_button then
                    local button = self:getSelectedFile()
                    if button.data then
                        Assets.stopAndPlaySound("ui_select")
                        self.copied_button = self:getSelectedFile()
                        self.copied_button:setColor(1, 1, 0.5)
                        self.selected_y = 1
                        self:updateSelected()
                    else
                        Assets.stopAndPlaySound("ui_cancel")
                        self:setResultText("It can't be copied.")
                    end
                else
                    local selected = self:getSelectedFile()
                    if selected == self.copied_button then
                        Assets.stopAndPlaySound("ui_cancel")
                        self:setResultText("You can't copy there.")
                    elseif selected.data then
                        Assets.stopAndPlaySound("ui_select")
                        self.focused_button = selected
                        self.focused_button:setChoices({ "Yes", "No" }, "Copy over this file?")
                    else
                        Assets.stopAndPlaySound("ui_spooky_action")
                        local data = Kristal.loadData("file_" .. self.copied_button.id, self.mod.id)
                        Kristal.saveData("file_" .. selected.id, data, self.mod.id)
                        selected:setData(data)
                        self:setState("SELECT", "Copy complete.")
                        self.copied_button:setColor(1, 1, 1)
                        self.copied_button = nil
                        self.selected_x = 1
                        self.selected_y = 4
                        self:updateSelected()
                    end
                end
            elseif self.selected_y == 4 then
                Assets.stopAndPlaySound("ui_select")
                self:setState("SELECT")
                if self.copied_button then
                    self.copied_button:setColor(1, 1, 1)
                    self.copied_button = nil
                end
                self.selected_x = 1
                self.selected_y = 4
                self:updateSelected()
            end
            return true
        end
        local last_x, last_y = self.selected_x, self.selected_y
        if Input.is("up", key) then self.selected_y = self.selected_y - 1 end
        if Input.is("down", key) then self.selected_y = self.selected_y + 1 end
        self.selected_x = 1
        self.selected_y = Utils.clamp(self.selected_y, 1, 4)
        if last_x ~= self.selected_x or last_y ~= self.selected_y then
            Assets.stopAndPlaySound("ui_move")
            self:updateSelected()
        end
    elseif self.state == "ERASE" then
        if Input.is("cancel", key) then
            Assets.stopAndPlaySound("ui_cancel")
            self:setState("SELECT")
            self.selected_x = 2
            self.selected_y = 4
            self:updateSelected()
            return true
        end
        if Input.is("confirm", key) then
            if self.selected_y <= 3 then
                local button = self:getSelectedFile()
                if button.data then
                    self.focused_button = button
                    self.focused_button:setChoices({ "Yes", "No" }, "Erase this file?")
                    Assets.stopAndPlaySound("ui_select")
                else
                    self:setResultText("There's nothing to erase.")
                    Assets.stopAndPlaySound("ui_cancel")
                end
            elseif self.selected_y == 4 then
                Assets.stopAndPlaySound("ui_select")
                self:setState("SELECT")
                self.selected_x = 2
                self.selected_y = 4
                self:updateSelected()
            end
            return true
        end
        local last_x, last_y = self.selected_x, self.selected_y
        if Input.is("up", key) then self.selected_y = self.selected_y - 1 end
        if Input.is("down", key) then self.selected_y = self.selected_y + 1 end
        self.selected_x = 1
        self.selected_y = Utils.clamp(self.selected_y, 1, 4)
        if last_x ~= self.selected_x or last_y ~= self.selected_y then
            Assets.stopAndPlaySound("ui_move")
            self:updateSelected()
        end
    end

    return true
end

function MainMenuCompletionSelect:update()
    if self.result_timer > 0 then
        self.result_timer = Utils.approach(self.result_timer, 0, DT)
        if self.result_timer == 0 then
            self.result_text = nil
        end
    end

    self:updateSelected()

    self.menu.heart_target_x, self.menu.heart_target_y = self:getHeartPos()
end

function MainMenuCompletionSelect:draw()
    local mod_name = string.upper(self.mod.name or self.mod.id)
    Draw.printShadow(mod_name, 16, 8)

    Draw.printShadow(self:getTitle(), 80, 60)

    local function setColor(x, y)
        if self.selected_x == x and self.selected_y == y then
            Draw.setColor(1, 1, 1)
        else
            Draw.setColor(0.6, 0.6, 0.7)
        end
    end

    if self.state == "SELECT" or self.state == "TRANSITIONING" then
        setColor(1, 4)
        Draw.printShadow("Don't use DELTARUNE file", 108, 380)
    else
        setColor(1, 4)
        Draw.printShadow("Cancel", 110, 380)
    end

    Draw.setColor(1, 1, 1)
end

-------------------------------------------------------------------------------
-- Class Methods
-------------------------------------------------------------------------------

function MainMenuCompletionSelect:getTitle()
    if self.result_text then
        return self.result_text
    end
    return "Start Dark Place from a DELTARUNE file."
end

function MainMenuCompletionSelect:setState(state, result_text)
    self:setResultText(result_text)
    self.state = state
end

function MainMenuCompletionSelect:setResultText(text)
    self.result_text = text
    self.result_timer = 3
end

function MainMenuCompletionSelect:updateSelected()
    for i, file in ipairs(self.files) do
        if i == self.selected_y or (self.state == "COPY" and self.copied_button == file) then
            file.selected = true
        else
            file.selected = false
        end
    end
end

function MainMenuCompletionSelect:getSelectedFile()
    return self.files[self.selected_y]
end

function MainMenuCompletionSelect:getHeartPos()
    if self.selected_y <= 3 then
        local button = self:getSelectedFile()
        local hx, hy = button:getHeartPos()
        local x, y = button:getRelativePos(hx, hy)
        return x + 9, y + 9
    elseif self.selected_y == 4 then
        return self.bottom_row_heart[self.selected_x] + 9, 390 + 9
    end
end

return MainMenuCompletionSelect
