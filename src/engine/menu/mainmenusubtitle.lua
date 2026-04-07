---@class MainMenuSubTitle : StateClass
---
---@field menu MainMenu
---
---@field logo love.Image
---@field has_target_saves boolean
---
---@field options table
---@field selected_option number
---
---@overload fun(menu:MainMenu) : MainMenuSubTitle
local MainMenuSubTitle, super = Class(StateClass)

function MainMenuSubTitle:init(menu)
    self.menu = menu

    -- self.logo = Assets.getTexture("kristal/title_logo_shadow")

    -- local date = os.date("*t")
    -- if date.month == 4 and date.day == 1 then
        -- self.logo = Assets.getTexture("kristal/title_logo_sun")
    -- end

    self.selected_option = 1
end

function MainMenuSubTitle:update()
    -- Do nothing?
end

function MainMenuSubTitle:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuSubTitle:onEnter(old_state)
    self.has_target_saves = TARGET_MOD and Kristal.hasAnySaves(TARGET_MOD) or false

    self.options = {
        { "play", "PLAY" },
        { "dlc", "DLC MANAGER" },
        { "options", "OPTIONS" },
        { "credits", "CREDITS" },
        { "achievements", "ACHIEVEMENTS" },
    }

    if not TARGET_MOD then
        self.menu.selected_mod = nil
        self.menu.selected_mod_button = nil
    else
        local mod = Kristal.Mods.getMod(TARGET_MOD)
        if mod and mod.soulColor then
            self.menu.heart:setColor(mod.soulColor)
        end
    end

    self.menu.heart_target_x = 420 - (64 * (self.selected_option-1))
    self.menu.heart_target_y = 114 + (64 * (self.selected_option-1))
    
    self.menu.kristal_stage_title.visible = true
end

function MainMenuSubTitle:onKeyPressed(key, is_repeat)
    if Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")

        local option = self.options[self.selected_option][1]

        if option == "play" then
            if not TARGET_MOD then
                self.menu:setState("MODSELECT")
            else
                local mod = Kristal.Mods.getMod(TARGET_MOD)

                if (mod["useSaves"] == true) or (mod["useSaves"] == nil and self.has_target_saves) then
                    self.menu:setState("FILESELECT")
                elseif (mod["useSaves"] == false) or (mod["useSaves"] == nil and not self.has_target_saves) then
                    if not Kristal.loadMod(TARGET_MOD, 1) then
                        error("Failed to load mod: " .. TARGET_MOD)
                    end
                end
            end

        elseif option == "dlc" then
            self.menu:setState("DLC")
            --love.system.openURL("file://"..love.filesystem.getSource().."/mods")
        elseif option == "modfolder" then
            -- FIXME: the game might freeze when using love.system.openURL to open a file directory
            if (love.system.getOS() == "Windows") then
                os.execute('start /B \"\" \"' .. love.filesystem.getSaveDirectory() .. '/mods\"')
            else
                love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/mods")
            end

        elseif option == "options" then
            self.menu:setState("OPTIONS")

        elseif option == "credits" then
            self.menu:setState("CREDITS")

        elseif option == "achievements" then
            self.menu:setState("ACHIEVEMENTS")
        end

        return true
    end

    local old = self.selected_option
    if Input.is("up", key) then self.selected_option = self.selected_option - 1 end
    if Input.is("down", key) then self.selected_option = self.selected_option + 1 end
    if Input.is("left", key) and not Input.usingGamepad() then self.selected_option = self.selected_option - 1 end
    if Input.is("right", key) and not Input.usingGamepad() then self.selected_option = self.selected_option + 1 end
    if self.selected_option > #self.options then self.selected_option = is_repeat and #self.options or 1 end
    if self.selected_option < 1 then self.selected_option = is_repeat and 1 or #self.options end

    if old ~= self.selected_option then
        Assets.stopAndPlaySound("ui_move")
    end

    self.menu.heart_target_x = 420 - (64 * (self.selected_option-1))
    self.menu.heart_target_y = 114 + (64 * (self.selected_option-1))
end

function MainMenuSubTitle:draw()
    -- for i, option in ipairs(self.options) do
        -- local date = os.date("*t")
        -- if date.month == 4 and date.day == 1 then
            -- Draw.setColor(0, 0, 0, 1)
            -- Draw.printLight(option[2], 215, 219 + 32 * (i - 1))
        -- else
            -- Draw.printShadow(option[2], 215, 219 + 32 * (i - 1))
        -- end
    -- end
    
    for i, option in ipairs(self.options) do
        local date = os.date("*t")
        if date.month == 4 and date.day == 1 then
            if i == self.selected_option then
                Draw.setColor(0, 0, 1, 1)
            else
                Draw.setColor(0, 0, 0, 1)
            end
            Draw.drawMenuRectangle(395 - (64 * (i-1)), 89 + (64 * (i-1)), 220, 50)
            Draw.printLight(option[2], 435 - (64 * (i-1)), 98 + (64 * (i-1)))
        else
            if i == self.selected_option then
                Draw.setColor(1, 1, 0, 1)
            else
                Draw.setColor(1, 1, 1, 1)
            end
            Draw.drawMenuRectangle(395 - (64 * (i-1)), 89 + (64 * (i-1)), 220, 50)
            Draw.printShadow(option[2], 435 - (64 * (i-1)), 98 + (64 * (i-1)))
        end
    end
end

-------------------------------------------------------------------------------
-- Class Methods
-------------------------------------------------------------------------------

function MainMenuSubTitle:selectOption(id)
    for i, options in ipairs(self.options) do
        if options[1] == id then
            self.selected_option = i

            self.menu.heart_target_x = 420 - (64 * (self.selected_option-1))
            self.menu.heart_target_y = 114 + (64 * (self.selected_option-1))

            return true
        end
    end

    return false
end

return MainMenuSubTitle
