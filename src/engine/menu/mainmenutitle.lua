---@class MainMenuTitle : StateClass
---
---@field menu MainMenu
---
---@field logo love.Image
---@field has_target_saves boolean
---
---@field options table
---@field selected_option number
---
---@overload fun(menu:MainMenu) : MainMenuTitle
local MainMenuTitle, super = Class(StateClass)

function MainMenuTitle:makeTitleLetter(image, x, y)
    x = x or 0
    y = y or 0

    if not self.letters then self.letters = {} end
    local letters = self.letters
    local offset = 0.4
    local letter = {
        image = Assets.getTexture(image),
        x = x,
        y = y,
        startX = x,
        startY = y,
        speed = 1,
        amplitude = 20,
        time = 0 + (offset * #letters),
    }

    table.insert(letters, letter)
end

function MainMenuTitle:init(menu)
    self.menu = menu

    -- self.logo = Assets.getTexture("kristal/title_logo_shadow")
    local skin = ""
    local letters
    local spacing = 50
    local date = os.date("*t")
    if date.month == 4 and date.day == 1 then
        self.logo = Assets.getTexture("kristal/title_logo_sun")
    else
        self.star = Assets.getTexture("kristal/title/big_star")
        local scale = 1
        local opacity = 0.4
        self.backstar = {
            image = Assets.getTexture("kristal/title/big_star"),
            startScaleX = scale,
            startScaleY = scale,
            scaleX = scale,
            scaleY = scale,
            speed = 1,
            amplitude = 0.3,
            time = 0,
            startOpacity = opacity,
            opacity = opacity,
        }
        self.tagline = Assets.getTexture("kristal/title/tagline")
        letters = "dark place"
    end

    if letters then
        for i = 1,string.len(letters) do
            local l = string.sub(letters, i, i)
            -- print(i)
            self:makeTitleLetter("kristal/title_logo_shadow/" .. skin .. l, 76 + (spacing * (i - 1)), 60)
        end
    end

    self.selected_option = 1
end

function MainMenuTitle:update()
    -- Do something!
    local star = self.star
    if star then
        local backstar = self.backstar
        if backstar then
            local time = backstar.time + DT * backstar.speed
            local change = math.sin(time) * backstar.amplitude
            local changeOpacity = change
            local limit = 0.05
            if change < limit then
                change = limit
            end
            backstar.scaleX = backstar.startScaleX + change
            backstar.scaleY = backstar.startScaleY + change
            backstar.opacity = backstar.startOpacity + changeOpacity
            backstar.time = time
        end
    end

    for _, letter in ipairs(self.letters) do
        local time = letter.time + DT * letter.speed
        letter.y = letter.startY + math.sin(time) * letter.amplitude
        letter.time = time
        -- print(letter.y)
        -- print(letter.time)
    end
end

function MainMenuTitle:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuTitle:onEnter(old_state)
    self.has_target_saves = TARGET_MOD and Kristal.hasAnySaves(TARGET_MOD) or false

    if TARGET_MOD then
        self.options = {
            {"play",    self.has_target_saves and "Load game" or "Start game"},
            {"dlc",     "Manage DLCs"},
            {"options", "Options"},
            {"credits", "Credits"},
            {"quit",    "Quit"},
        }
    else
        self.options = {
            {"play",      "Play a mod"},
            {"dlc",       "Manage DLCs"},
            {"options",   "Options"},
            {"credits",   "Credits"},
            {"wiki",      "Open wiki"},
            {"quit",      "Quit"},
        }
    end

    if not TARGET_MOD then
        self.menu.selected_mod = nil
        self.menu.selected_mod_button = nil
    end

    self.menu.heart_target_x = 196
    self.menu.heart_target_y = 238 + 32 * (self.selected_option - 1)
end

function MainMenuTitle:onKeyPressed(key, is_repeat)
    if Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")

        local option = self.options[self.selected_option][1]

        if option == "play" then
            if not TARGET_MOD then
                self.menu:setState("MODSELECT")
				if MainMenu.mod_list:getSelectedMod() then
                    if MainMenu.mod_list:getSelectedMod().soulColor then
                        MainMenu.heart.color = MainMenu.mod_list:getSelectedMod().soulColor
                    end
                    if MainMenu.mod_list:getSelectedMod().soulFacing then
                        MainMenu.heart:setSprite("player/"..MainMenu.mod_list:getSelectedMod().soulFacing.."/heart_menu")
                    end
				end 
            elseif self.menu.selected_mod["useSaves"] or self.menu.selected_mod["useSaves"] == nil and (not self.menu.selected_mod["encounter"] or self.has_target_saves) then
                self.menu:setState("FILESELECT")
            else
                if not Kristal.loadMod(TARGET_MOD, 1) then
                    error("Failed to load mod: " .. TARGET_MOD)
                end
            end

        elseif option == "dlc" then
            self.menu:setState("DLC")
            --love.system.openURL("file://"..love.filesystem.getSource().."/mods")
        elseif option == "modfolder" then
            -- FIXME: the game might freeze when using love.system.openURL to open a file directory
            if (love.system.getOS() == "Windows") then
                os.execute('start /B \"\" \"'..love.filesystem.getSaveDirectory()..'/mods\"')
            else
                love.system.openURL("file://"..love.filesystem.getSaveDirectory().."/mods")
            end

        elseif option == "options" then
            self.menu:setState("OPTIONS")

        elseif option == "credits" then
            self.menu:setState("CREDITS")

        elseif option == "wiki" then
            love.system.openURL("https://kristal.cc/wiki")

        elseif option == "quit" then
            love.event.quit()
        end

        return true
    end

    local old = self.selected_option
    if Input.is("up"   , key)                              then self.selected_option = self.selected_option - 1 end
    if Input.is("down" , key)                              then self.selected_option = self.selected_option + 1 end
    if Input.is("left" , key) and not Input.usingGamepad() then self.selected_option = self.selected_option - 1 end
    if Input.is("right", key) and not Input.usingGamepad() then self.selected_option = self.selected_option + 1 end
    if self.selected_option > #self.options then self.selected_option = is_repeat and #self.options or 1 end
    if self.selected_option < 1             then self.selected_option = is_repeat and 1 or #self.options end

    if old ~= self.selected_option then
        Assets.stopAndPlaySound("ui_move")
    end

    self.menu.heart_target_x = 196
    self.menu.heart_target_y = 238 + (self.selected_option - 1) * 32
end

function MainMenuTitle:draw()
    local logo_img = self.menu.selected_mod and self.menu.selected_mod.logo or self.logo

    if logo_img then
        Draw.draw(logo_img, SCREEN_WIDTH/2 - logo_img:getWidth()/2, 105 - logo_img:getHeight()/2)
    end
    --Draw.draw(self.selected_mod and self.selected_mod.logo or self.logo, 160, 70)


    local star = self.star
    if star then
        local starX, starY = SCREEN_WIDTH/2 - star:getWidth()/2, 105 - star:getHeight()/2
        local backstar = self.backstar
        if backstar then
            local image = backstar.image
            love.graphics.push()

            love.graphics.setColor(1,1,1,backstar.opacity)
            Draw.draw(backstar.image, starX + image:getWidth()/2, starY + image:getHeight()/2, 0, backstar.scaleX, backstar.scaleY, image:getWidth()/2, image:getHeight()/2)
            love.graphics.setColor(1,1,1,1)

            love.graphics.pop()
        end
        Draw.draw(star, starX, starY)
    end

    for i, option in ipairs(self.options) do
        local date = os.date("*t")
        if date.month == 4 and date.day == 1 then
            Draw.setColor(0, 0, 0, 1)
            Draw.printLight(option[2], 215, 219 + 32 * (i - 1))
        else
            Draw.printShadow(option[2], 215, 219 + 32 * (i - 1))
        end
    end

    local tagline = self.tagline
    if tagline then
        Draw.draw(tagline, 206, 150)
    end

    local letters = self.letters
    if letters then
        for _, letter in ipairs(letters) do
            if letter.image then
                Draw.draw(letter.image, letter.x, letter.y)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Class Methods
-------------------------------------------------------------------------------

function MainMenuTitle:selectOption(id)
    for i, options in ipairs(self.options) do
        if options[1] == id then
            self.selected_option = i

            self.menu.heart_target_x = 196
            self.menu.heart_target_y = 238 + (self.selected_option - 1) * 32

            return true
        end
    end

    return false
end

return MainMenuTitle
