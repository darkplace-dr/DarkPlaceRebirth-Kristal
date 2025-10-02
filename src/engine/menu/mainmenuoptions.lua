---@class (exact) MainMenuOptions : StateClass, StateManagedClass
---
---@field menu MainMenu
---
---@field state string
---@field state_manager StateManager
---
---@field options table<string, {id: string, name: string, options: {name: string, value: (fun(x:number, y:number):any)|nil, callback: fun()}[]}>
---@field pages string[]
---
---@field selected_option number
---@field selected_page number
---
---@field heart_x number
---@field scroll_target_y number
---@field scroll_y number
---@field page_scroll_direction string
---@field page_scroll_timer number
---
---@field noise_timer number
---@field retro boolean
---
---@overload fun(menu:MainMenu) : MainMenuOptions
local MainMenuOptions, super = Class(StateClass)

function MainMenuOptions:init(menu)
    self.retro = false
    local date = os.date("*t")
    if date.month == 3 and date.day == 10 then
        self.retro = true
    end

    self.menu = menu

    self.state_manager = StateManager("MENU", self, true)
    self.state_manager:addState("MENU", { enter = self.onEnterMenu, keypressed = self.onKeyPressedMenu })
    self.state_manager:addState("VOLUME",
                                {
                                    enter = self.onEnterSubOption,
                                    keypressed = self.onKeyPressedVolume,
                                    update = self.updateVolume
                                })
    self.state_manager:addState("BORDER", { enter = self.onEnterSubOption, keypressed = self.onKeyPressedBorder })
    self.state_manager:addState("FPS", { enter = self.onEnterSubOption, keypressed = self.onKeyPressedFPS })
    self.state_manager:addState("WINDOWSCALE", {
        enter = self.onEnterSubOption,
        keypressed = self
            .onKeyPressedWindowScale
    })

    self.options = {}
    self.pages = {}

    self:initializeOptions()

    self.selected_option = 1
    self.selected_page = 1

    self.heart_x = 0
    self.scroll_target_y = 0
    self.scroll_y = 0
    self.page_scroll_direction = "right"
    self.page_scroll_timer = 0

    self.noise_timer = 0
	
    self.clouds1_x = 0
    self.clouds2_x = 0
    self.scroll_speed = 2
    self.scroll_speed2 = 1
	
    self.dog_balloon_siner = 0
	
    self.clouds_1 = Assets.getTexture("kristal/options_clouds1")
    if self.retro then
        self.clouds_1 = Assets.getTexture("kristal/options_retro1")
    end
    self.clouds_2 = Assets.getTexture("kristal/options_clouds2")
    if self.retro then
        self.clouds_2 = Assets.getTexture("kristal/options_retro2")
    end
    self.moon = Assets.getTexture("kristal/options_moon")
    if self.retro then
        self.moon = Assets.getTexture("kristal/options_platform")
    end
    self.dog = Assets.getTexture("kristal/dog_balloon")
end

function MainMenuOptions:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuOptions:onEnter(old_state)
    if old_state == "plugins" then return end
    self.selected_option = 1
    self.selected_page = 1

    self.scroll_target_y = 0
    self.scroll_y = 0

    self:setState("MENU")
end

function MainMenuOptions:onLeave()
    Kristal.Loader.in_channel:push({config = Kristal.Config})
    self:setState("NONE")
end

function MainMenuOptions:onKeyPressed(key, is_repeat)
    self.state_manager:call("keypressed", key, is_repeat)
end

function MainMenuOptions:update()
    local page = self.pages[self.selected_page]
    local options = self.options[page].options
    local max_option = #options + 1
	
    self.clouds1_x = self.clouds1_x + self.scroll_speed * DTMULT
    self.clouds2_x = self.clouds2_x + self.scroll_speed2 * DTMULT
	
    self.dog_balloon_siner = self.dog_balloon_siner + DTMULT

    if self.selected_option < max_option then
        local y_off = (self.selected_option - 1) * 32

        if y_off + self.scroll_target_y < 0 then
            self.scroll_target_y = self.scroll_target_y + (0 - (y_off + self.scroll_target_y))
        end

        if y_off + self.scroll_target_y > (9 * 32) then
            self.scroll_target_y = self.scroll_target_y + ((9 * 32) - (y_off + self.scroll_target_y))
        end
    end

    if (math.abs((self.scroll_target_y - self.scroll_y)) <= 2) then
        self.scroll_y = self.scroll_target_y
    end
    self.scroll_y = self.scroll_y + ((self.scroll_target_y - self.scroll_y) / 2) * DTMULT

    if self.page_scroll_timer > 0 then
        self.page_scroll_timer = Utils.approach(self.page_scroll_timer, 0, DT)
    end

    if Kristal.noel == true then
        self:noel_char()
    end

    self.menu.heart_target_x, self.menu.heart_target_y = self:getHeartPos()

    self.state_manager:update()
end

function MainMenuOptions:draw()
    local offset = math.sin(self.dog_balloon_siner * 0.1) * 15

    if self.retro then
        Draw.setColor(0.36, 0.58, 0.99, 1)
    else
        Draw.setColor(COLORS.black)
    end
    Draw.rectangle("fill", 0, 0, 640, 480)

    Draw.setColor(COLORS.white)
    Draw.draw(self.moon, 484, 38, 0, 1, 1)
    if self.retro then
        Draw.drawWrapped(self.clouds_2, true, false, (self.clouds2_x - 640), 200, 0, 1, 1)
    else
        Draw.drawWrapped(self.clouds_2, true, false, (self.clouds2_x - 640), 270, 0, 1, 1)
    end
    if not self.retro then
        Draw.draw(self.dog, 536, 296 + offset, 0, 2, 2)
    end
    if self.retro then
        Draw.drawWrapped(self.clouds_1, true, false, (self.clouds1_x - 640), 260, 0, 1, 1)
    else
        Draw.drawWrapped(self.clouds_1, true, false, (self.clouds1_x - 640), 380, 0, 1, 1)
    end

    local menu_font = Assets.getFont("main")

    local page = self.pages[self.selected_page]
    local options = self.options[page].options

    local title = self.options[page].name
    local title_width = menu_font:getWidth(title)

    Draw.setColor(COLORS.silver)
    Draw.printShadow("( OPTIONS )", 0, 0, 2, "center", 640)

    Draw.setColor(1, 1, 1)
    Draw.printShadow(title, 0, 48, 2, "center", 640)

    if self.state == "MENU" and #self.pages > 1 then
        love.graphics.setColor(COLORS.white)

        local l_offset, r_offset = 0, 0

        if self.page_scroll_timer > 0 then
            if self.page_scroll_direction == "left" then
                l_offset = -4
            elseif self.page_scroll_direction == "right" then
                r_offset = 4
            end
        end

        if self.selected_page >= #self.pages then
            Draw.setColor(COLORS.silver, 0.5)
        else
            Draw.setColor(COLORS.white)
        end
        Draw.draw(Assets.getTexture("kristal/menu_arrow_right"), 320 + (title_width / 2) + 8 + r_offset, 52, 0, 2, 2)

        if self.selected_page == 1 then
            Draw.setColor(COLORS.silver, 0.5)
        else
            Draw.setColor(COLORS.white)
        end
        Draw.draw(Assets.getTexture("kristal/menu_arrow_left"), 320 - (title_width / 2) - 26 + l_offset, 52, 0, 2, 2)

        Draw.setColor(COLORS.white)
    end

    local menu_x = 62 - 14
    local menu_y = 110

    local width = 360
    local height = 32 * 10
    local total_height = 32 * #options

    Draw.pushScissor()
    Draw.scissor(menu_x, menu_y, width + 10, height + 10)

    menu_y = menu_y + self.scroll_y

    for i, option in ipairs(options) do
        local y = menu_y + 32 * (i - 1)

        Draw.printShadow(option.name, menu_x, y)

        local value_x = menu_x + (32 * 8)
        local value = option.value and option.value(value_x, y) or nil

        if value then
            Draw.printShadow(tostring(value), value_x, y)
        end
    end

    -- Draw the scrollbar background if the menu scrolls
    if total_height > height then
        Draw.setColor({ 0, 0, 0, 0.5 })
        love.graphics.rectangle("fill", menu_x + width, 0, 4, menu_y + height - self.scroll_y)

        local scrollbar_height = (height / total_height) * height
        local scrollbar_y = (-self.scroll_y / (total_height - height)) * (height - scrollbar_height)

        Draw.popScissor()
        Draw.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", menu_x + width, menu_y + scrollbar_y - self.scroll_y, 4, scrollbar_height)
    else
        Draw.popScissor()
    end

    Draw.printShadow("Back", menu_x, 440 - 8, 2, "left", 640)

    self.state_manager:draw()
end

-------------------------------------------------------------------------------
-- Substate Callbacks
-------------------------------------------------------------------------------

function MainMenuOptions:onEnterMenu()
    self.heart_x = 0
end

function MainMenuOptions:onEnterSubOption()
    self.heart_x = 256
end

function MainMenuOptions:onKeyPressedMenu(key, is_repeat)
    if Input.isCancel(key) then
        Assets.stopAndPlaySound("ui_move")

        Kristal.saveConfig()

        self:remove_noel_char()

        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("options")
        return
    end

    local move_noise = false

    local page_dir = "right"
    local old_page = self.selected_page
    if Input.is("left", key) then
        self.selected_page = self.selected_page - 1
        page_dir = "left"
    end
    if Input.is("right", key) then
        self.selected_page = self.selected_page + 1
        page_dir = "right"
    end
    self.selected_page = Utils.clamp(self.selected_page, 1, #self.pages)

    if self.selected_page ~= old_page then
        move_noise = true
        self.selected_option = 1
        self.scroll_target_y = 0
        self.scroll_y = 0
        self.page_scroll_direction = page_dir
        self.page_scroll_timer = 0.1
    end

    local page = self.pages[self.selected_page]
    local options = self.options[page].options
    local max_option = #options + 1

    local old_option = self.selected_option
    if Input.is("up", key) then self.selected_option = self.selected_option - 1 end
    if Input.is("down", key) then self.selected_option = self.selected_option + 1 end
    if self.selected_option > max_option then self.selected_option = is_repeat and max_option or 1 end
    if self.selected_option < 1 then self.selected_option = is_repeat and 1 or max_option end

    if old_option ~= self.selected_option then
        move_noise = true
    end

    if move_noise then
        Assets.stopAndPlaySound("ui_move")
    end

    if Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")

        if self.selected_option == max_option then
            -- "Back" button
            Kristal.saveConfig()

            self:remove_noel_char()

            self.menu:setState("TITLE")
            self.menu.title_screen:selectOption("options")
        else
            options[self.selected_option].callback()
        end
    end
end

function MainMenuOptions:onKeyPressedVolume(key, is_repeat)
    if Input.isCancel(key) or Input.isConfirm(key) then
        Kristal.setVolume(Utils.round(Kristal.getVolume() * 100) / 100)

        Assets.stopAndPlaySound("ui_select")
        self:setState("MENU")
    end
end

function MainMenuOptions:onKeyPressedBorder(key, is_repeat)
    if Input.isCancel(key) or Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")
        self:setState("MENU")
    end

    local types = Kristal.getBorderTypes()

    local border_index = -1
    for current_index, border in ipairs(types) do
        if border[1] == Kristal.Config["borders"] then
            border_index = current_index
        end
    end
    if border_index == -1 then
        border_index = 1
    end

    local old_index = border_index
    if Input.is("left", key) then
        border_index = math.max(border_index - 1, 1)
    end
    if Input.is("right", key) then
        border_index = math.min(border_index + 1, #types)
    end

    if old_index ~= border_index then
        Assets.stopAndPlaySound("ui_move")

        Kristal.Config["borders"] = types[border_index][1]

        if types[border_index][1] == "off" then
            Kristal.resetWindow()
        elseif types[old_index][1] == "off" then
            Kristal.resetWindow()
        end
    end
end

function MainMenuOptions:onKeyPressedFPS(key, is_repeat)
    if Input.isCancel(key) or Input.isConfirm(key) then
        FRAMERATE = Kristal.Config["fps"]

        Assets.stopAndPlaySound("ui_select")
        self:setState("MENU")
    end

    if Input.is("left", key) then
        Assets.stopAndPlaySound("ui_move")

        if FRAMERATE == 0 or FRAMERATE > 240 then
            FRAMERATE = 240
        elseif FRAMERATE > 144 then
            FRAMERATE = 144
        elseif FRAMERATE > 120 then
            FRAMERATE = 120
        elseif FRAMERATE > 60 then
            FRAMERATE = 60
        elseif FRAMERATE > 30 then
            FRAMERATE = 30
        else
            FRAMERATE = 0
        end

        Kristal.Config["fps"] = FRAMERATE
    elseif Input.is("right", key) then
        Assets.stopAndPlaySound("ui_move")

        if FRAMERATE < 30 then
            FRAMERATE = 30
        elseif FRAMERATE < 60 then
            FRAMERATE = 60
        elseif FRAMERATE < 120 then
            FRAMERATE = 120
        elseif FRAMERATE < 144 then
            FRAMERATE = 144
        elseif FRAMERATE < 240 then
            FRAMERATE = 240
        else
            FRAMERATE = 0
        end

        Kristal.Config["fps"] = FRAMERATE
    end
end

function MainMenuOptions:onKeyPressedWindowScale(key, is_repeat)
    if Input.isCancel(key) or Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")
        self:setState("MENU")
    end

    local scale = Kristal.Config["windowScale"]

    if Input.is("right", key) then
        if scale < 1 then
            scale = scale * 2
        else
            scale = scale + 1
        end
    elseif Input.is("left", key) then
        if scale > 0.125 then
            if scale <= 1 then
                scale = scale / 2
            else
                scale = scale - 1
            end
        else
            Kristal.Config["windowScale"] = 1
            Assets.stopAndPlaySound("ui_move")
            love.event.quit()
            return
        end
    end

    if Kristal.Config["windowScale"] ~= scale then
        Assets.stopAndPlaySound("ui_move")

        Kristal.Config["fullscreen"] = false
        Kristal.Config["windowScale"] = scale

        Kristal.resetWindow()
    end
end

function MainMenuOptions:updateVolume()
    self.noise_timer = self.noise_timer + DTMULT

    if Input.down("left") then
        Kristal.setVolume(Kristal.getVolume() - ((2 * DTMULT) / 100))
        if self.noise_timer >= 3 then
            self.noise_timer = self.noise_timer - 3
            Assets.stopAndPlaySound("noise")
        end
    end

    if Input.down("right") then
        Kristal.setVolume(Kristal.getVolume() + ((2 * DTMULT) / 100))
        if self.noise_timer >= 3 then
            self.noise_timer = self.noise_timer - 3
            Assets.stopAndPlaySound("noise")
        end
    end

    if (not Input.down("right")) and (not Input.down("left")) then
        self.noise_timer = 3
    end
end

-------------------------------------------------------------------------------
-- Class Methods
-------------------------------------------------------------------------------

function MainMenuOptions:setState(state, ...)
    self.state_manager:setState(state, ...)
end

function MainMenuOptions:getHeartPos()
    local page = self.pages[self.selected_page]
    local options = self.options[page].options
    local max_option = #options + 1

    local x, y = 152, 129

    if self.selected_option < max_option then
        x = 27
        y = 129 + (self.selected_option - 1) * 32 + self.scroll_target_y
    else
        -- "Back" button
        x = 27
        y = 512 - 64 + 3
    end

    return x + self.heart_x, y
end

--- Adds a page to the options menu.
---@param id   string # The id of the page, referred to when adding options.
---@param name string # The name of the page, displayed in the options menu.
function MainMenuOptions:registerOptionsPage(id, name)
    if Utils.containsValue(self.pages, id) then
        return
    end

    table.insert(self.pages, id)

    self.options[id] = {
        id = id,
        name = name,
        options = {}
    }
end

--- Adds an option to the menu's options list.
---@param page     string|string[]             # The page (or pages) the option should be added to. Must be registered with `registerOptionsPage` first.
---@param name     string                      # The name of the option, displayed in the options list.
---@param value?   fun(x:number, y:number):any # A function which is called to get the value displayed for the option.
---@param callback fun()                       # A function called when the user selects this option.
function MainMenuOptions:registerOption(page, name, value, callback)
    local pages = type(page) == "table" and page or { page }

    for _, page_id in ipairs(pages) do
        table.insert(self.options[page_id].options, {
            name = name,
            value = value,
            callback = callback
        })
    end
end

--- *(Called internally)*
--- Convenience method to add a menu option based on a config option which is toggled on and off.
---@param page   string|string[]         # The page (or pages) the option should be added to. Must be registered with `registerOptionsPage` first.
---@param name   string                  # The name of the option, displayed in the options list.
---@param config string                  # The config option to toggle.
---@param callback? fun(toggled:boolean) # Additional callback for when the option is toggled.
function MainMenuOptions:registerConfigOption(page, name, config, callback)
    self:registerOption(page, name, function ()
                            return Kristal.Config[config] and "ON" or "OFF"
                        end, function ()
                            Kristal.Config[config] = not Kristal.Config[config]
                            if callback then
                                callback(Kristal.Config[config])
                            end
                        end)
end

function MainMenuOptions:initializeOptions()
    self:registerOptionsPage("general", "GENERAL")
    self:registerOptionsPage("graphics", "GRAPHICS")
    self:registerOptionsPage("engine", "ENGINE")
    self:registerOptionsPage("gameplay", "GAMEPLAY")

    ---------------------
    -- General Options
    ---------------------

    self:registerOption("general", "Master Volume", function ()
                            return Utils.round(Kristal.getVolume() * 100) .. "%"
                        end, function ()
                            self:setState("VOLUME")
                        end)

    local function enterControls(type)
        self.menu:pushState("CONTROLS", type)
        self:remove_noel_char()
    end
    self:registerOption("general", "Keyboard Controls", nil, function () enterControls("keyboard") end)
    self:registerOption("general", "Gamepad Controls", nil, function () enterControls("gamepad") end)

    self:registerConfigOption("general", "Auto-Run", "autoRun")

    self:registerConfigOption("general", "Discord RPC", "discordRPC", function(toggled)
        if DISCORD_RPC_AVAILABLE then
            if toggled then
                DiscordRPC.initialize(DISCORD_RPC_ID, true)
                DiscordRPC.updatePresence(Kristal.getPresence())
            else
                DiscordRPC.shutdown()
            end
        end
    end)

    ---------------------
    -- Graphics Options
    ---------------------

    self:registerConfigOption({ "general", "graphics" }, "Fullscreen", "fullscreen", function (toggled)
        love.window.setFullscreen(toggled)
    end)

    self:registerOption({ "general", "graphics" }, "Window Scale", function ()
                            return tostring(Kristal.Config["windowScale"]) .. "x"
                        end, function ()
                            self:setState("WINDOWSCALE")
                        end)

    self:registerOption({ "general", "graphics" }, "Border", function ()
                            return Kristal.getBorderName()
                        end, function ()
                            self:setState("BORDER")
                        end)

    self:registerConfigOption({ "general", "graphics" }, "Simplify VFX", "simplifyVFX")
	
    self:registerConfigOption("general", "Auto-Reload DLC", "ardlc")

    self:registerOption("graphics", "Target FPS", function (x, y)
                            if Kristal.Config["fps"] > 0 then
                                return Kristal.Config["fps"]
                            else
                                Draw.setColor(0, 0, 0)
                                Draw.draw(Assets.getTexture("kristal/menu_infinity"), x + 2, y + 11, 0, 2, 2)
                                Draw.setColor(1, 1, 1)
                                Draw.draw(Assets.getTexture("kristal/menu_infinity"), x, y + 9, 0, 2, 2)
                            end
                        end, function ()
                            self:setState("FPS")
                        end)

    self:registerConfigOption("graphics", "VSync", "vSync", function (toggled)
        love.window.setVSync(toggled and 1 or 0)
    end)
    self:registerConfigOption("graphics", "Frame Skip", "frameSkip")
    self:registerConfigOption("graphics", "Broken Menu Boxes", "brokenMenuBoxes")

    ---------------------
    -- Engine Options
    ---------------------

    self:registerConfigOption("engine", "Skip Intro", "skipIntro")
    self:registerConfigOption("engine", "Display FPS", "showFPS")

    self:registerOption("engine", "Default Name", function ()
                            return Kristal.Config["defaultName"]
                        end, function ()
                            self.menu:pushState("DEFAULTNAME")
                            self:remove_noel_char()
                        end)
    self:registerConfigOption("engine", "Skip Name Entry", "skipNameEntry")

    self:registerConfigOption("engine", "Debug Hotkeys", "debug")
    self:registerConfigOption("engine", "Verbose Loader", "verboseLoader")
    self:registerConfigOption("engine", "Lazy Load Sprites", "lazySprites")
    self:registerConfigOption("engine", "Use System Mouse", "systemCursor", function () Kristal.updateCursor() end)
    self:registerConfigOption("engine", "Always Show Mouse", "alwaysShowCursor", function () Kristal.updateCursor() end)
    self:registerConfigOption("engine", "Instant Quit", "instantQuit")

    self:registerConfigOption("gameplay", "Prefer Goner Keybd.", "prefersGonerKeyboard")
    self:registerConfigOption("gameplay", "Enable Shatter", "enableShatter")
    self:registerOption("gameplay", "Plugins", function ()
        local active, total = 0, 0
        local enabled = Kristal.Config["plugins/enabled_plugins"] or {}
        for _, mod in ipairs(Kristal.Mods.getMods()) do
            if mod.plugin then total = total + 1 end
            if enabled[mod.id] then active = active + 1 end
        end
        return active.."/"..total
    end,
    function ()
        ---@diagnostic disable-next-line: undefined-field
        if Kristal.PluginLoader == nil then Assets.playSound("ui_cant_select"); return end
        self:remove_noel_char()
        self.menu:pushState("plugins")
    end)

    self:registerConfigOption("gameplay", "Descriptive Loading", "dLoad")
    self:registerConfigOption("gameplay", "Alt Attack Style", "altAttack")
    self:registerConfigOption("gameplay", "Run Animations", "runAnimations")

end

-------------------------------------------------------------------------------
-- Noel the Nobody
-- please ignore :)
-------------------------------------------------------------------------------

function MainMenuOptions:remove_noel_char()
    if self.noel then
        self.noel:remove()
        self.noel2:remove()
        self.container:remove()
        self.container = nil
        self.noel = nil
        self.noel2 = nil
    end
end

function MainMenuOptions:noel_char()
    if self.noel2 then
        --for the update function
        --dont forget this sad diamond man you dumbass
        local angle = Utils.angle(self.menu.heart.x, self.menu.heart.y, self.noel.x + 4, self.noel.y - 18)
        --print(angle)
        self.noel2.y = -angle*10 + self.noel.y
        self.noel2.x = self.noel.x 
    else

    self.container = self.menu.stage:addChild(Object())
    self.container:setLayer(50)
    --Might come back to this in the future since noel is tecnically a save file
    --self.noel = Sprite("face/noel/hey_jeku")
    if self.retro then
        self.noel = Sprite("party/noel/retro_1")
        self.noel.visible = true
        self.noel:setOrigin(0.5, 0.5)
        self.noel:setScale(-2, 2)
        self.noel.x, self.noel.y = 521, 156
        self.noel.layer = 50
        self.container:addChild(self.noel)
        self.noel:addFX(OutlineFX())
        self.noel:getFX(OutlineFX):setColor(1, 1, 1)
    
        self.noel2 = Sprite("party/noel/retro_2")
        self.noel2.visible = true
        self.noel2:setOrigin(0.5, 0.5)
        self.noel2:setScale(-2, 2)
        self.noel2.x, self.noel2.y = 50, 300
        self.noel2.layer = 50
        self.container:addChild(self.noel2)
    else
        self.noel = Sprite("party/noel/battle/temp_idle_1")
        self.noel.visible = true
        self.noel:setOrigin(0.5, 0.5)
        self.noel:setScale(-2, 2)
        self.noel.x, self.noel.y = 521, 153
        self.noel.layer = 50
        self.container:addChild(self.noel)
        self.noel:addFX(OutlineFX())
        self.noel:getFX(OutlineFX):setColor(1, 1, 1)
    
        self.noel2 = Sprite("party/noel/battle/temp_idle_2")
        self.noel2.visible = true
        self.noel2:setOrigin(0.5, 0.5)
        self.noel2:setScale(-2, 2)
        self.noel2.x, self.noel2.y = 50, 300
        self.noel2.layer = 50
        self.container:addChild(self.noel2)
    end

    end
end

return MainMenuOptions
