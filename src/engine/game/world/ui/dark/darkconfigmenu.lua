---@class DarkConfigMenu : Object
---@overload fun(...) : DarkConfigMenu
local DarkConfigMenu, super = Class(Object)

function DarkConfigMenu:init()
    super.init(self, 82, 112, 477, 277)

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Assets.getTexture("player/heart")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")
    self.flat_arrow_sprite = Assets.getTexture("ui/flat_arrow_right")

    self.tp_sprite = Assets.getTexture("ui/menu/caption_tp")

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    -- MAIN, VOLUME, CONTROLS, BORDER
    self.state = "MAIN"

    self.currently_selected = 0
    self.noise_timer = 0

    self.reset_flash_timer = 0
    self.rebinding = false

    self.current_config_page = 1
    self.max_config_pages = 2

    self.border_types = {
        {"off",     "OFF",     nil},
        {"dynamic", "Dynamic", nil},
        {"simple",  "Simple",  "simple"},
        {"none",    "None",    nil}
    }
    self.keybinds = {}
    
    self:registerKeybind()

    self.control_page = 1
    self.max_control_page = math.ceil(#self.keybinds/7)
end

function DarkConfigMenu:registerKeybind()
    local alr_used = {}

    for _, keybind in ipairs(Input.order) do
        if not (Utils.containsValue(Game:getConfig("bannedKeys"), keybind) or Utils.containsValue(alr_used, keybind)) then
            table.insert(self.keybinds, {keybind = keybind, name = (Input.getBindName(keybind) or keybind:gsub("_", " ")):upper()})
            table.insert(alr_used, keybind)
        end
    end

    if not Game:getConfig("onlyMyDLCBind") then
        for mod_id, keys in pairs(Input.mod_keybinds) do
            local mod = Kristal.Mods.getMod(mod_id)
            if mod["hideKeybinds"] then
                goto continue
            end

            for _, keybind in ipairs(keys) do
                if not (Utils.containsValue(Game:getConfig("bannedKeys"), keybind) or Utils.containsValue(alr_used, keybind)) then
                    table.insert(self.keybinds, {keybind = keybind, name = (Input.getBindName(keybind) or keybind:gsub("_", " ")):upper()})
                    table.insert(alr_used, keybind)
                end
            end

            ::continue::
        end
    else
        local mod_id , keys = Mod.info.id, Input.mod_keybinds[Mod.info.id]
        local mod = Kristal.Mods.getMod(mod_id)
        if mod["hideKeybinds"] then
            goto continue
        end

        for _, keybind in ipairs(keys) do
            if not (Utils.containsValue(Game:getConfig("bannedKeys"), keybind) or Utils.containsValue(alr_used, keybind)) then
                table.insert(self.keybinds, {keybind = keybind, name = (Input.getBindName(keybind) or keybind:gsub("_", " ")):upper()})
                table.insert(alr_used, keybind)
            end
        end
        ::continue::
    end
end

function DarkConfigMenu:onKeyPressed(key)
    if self.state == "CONTROLS" then
        if self.rebinding then
            local gamepad = Utils.startsWith(key, "gamepad:")
            local key_rebind = self.keybinds[self.currently_selected + ((self.control_page - 1) * 7)]["keybind"]

            local worked = key ~= "escape" and
                Input.setBind(key_rebind, 1, key, gamepad)

            self.rebinding = false

            if worked then
                self.ui_select:stop()
                self.ui_select:play()

                if Game:getConfig("saveAfterModification") then Input.saveBinds() end
            else
                self.ui_cant_select:stop()
                self.ui_cant_select:play()
            end

            return
        end
        if Input.pressed("confirm") then
            if self.currently_selected < 8 then
                self.ui_select:stop()
                self.ui_select:play()
                self.rebinding = true
                return
            end

            if self.currently_selected == 8 then
                Assets.playSound("levelup")

                if Kristal.isConsole() then
                    Input.resetBinds(true)  -- Console, no keyboard, only reset gamepad binds
                elseif Input.hasGamepad() then
                    Input.resetBinds()      -- PC, keyboard and gamepad, reset all binds
                else
                    Input.resetBinds(false) -- PC, no gamepad, only reset keyboard binds
                end
                Input.saveBinds()
                self.reset_flash_timer = 10
            end

            if self.currently_selected == 9 then
                self.reset_flash_timer = 0
                self.state = "MAIN"
                self.currently_selected = 2
                self.ui_select:stop()
                self.ui_select:play()
                Input.clear("confirm", true)
            end
            return
        end

        local old_selected = self.currently_selected
        if Input.pressed("up") then
            self.currently_selected = self.currently_selected - 1
            if (self.currently_selected > 1 and self.currently_selected <= 7) and not self.keybinds[self.currently_selected + 8*(self.control_page - 1)] then
                self.currently_selected = #self.keybinds - 7*(self.control_page - 1)
            end
        end
        if Input.pressed("down") then
            self.currently_selected = self.currently_selected + 1
            if self.currently_selected < 8 and not self.keybinds[self.currently_selected + 7*(self.control_page - 1)] then
                self.currently_selected = 8
            end
        end

        self.currently_selected = Utils.clamp(self.currently_selected, 1, 9)

        if old_selected ~= self.currently_selected then
            self.ui_move:stop()
            self.ui_move:play()
        end

        local old_page = self.control_page
        if Input.pressed("left") then
            self.control_page = self.control_page - 1
        end
        if Input.pressed("right") then
            self.control_page = self.control_page + 1
        end

        self.control_page = Utils.clamp(self.control_page, 1, self.max_control_page)

        if old_page ~= self.control_page then
            self.ui_move:stop()
            self.ui_move:play()

            if not self.keybinds[self.currently_selected + 7*(self.control_page - 1)] and self.currently_selected <= 7 then
                if self.currently_selected <= (#self.keybinds - 7*self.control_page)/2 + 7 then
                    self.currently_selected = #self.keybinds - 7*(self.control_page - 1)
                else
                    self.currently_selected = 8
                end
            end
        end
    end
end

function DarkConfigMenu:update()
    if self.state == "MAIN" then
        if Input.pressed("confirm") then
            self.ui_select:stop()
            self.ui_select:play()
			
            if self.current_config_page == 1 then
                if self.currently_selected == 1 then
                    self.state = "VOLUME"
                    self.noise_timer = 0
                elseif self.currently_selected == 2 then
                    self.state = "CONTROLS"
                    self.currently_selected = 1
                elseif self.currently_selected == 3 then
                    Kristal.Config["simplifyVFX"] = not Kristal.Config["simplifyVFX"]
                elseif self.currently_selected == 4 then
                    Kristal.Config["fullscreen"] = not Kristal.Config["fullscreen"]
                    love.window.setFullscreen(Kristal.Config["fullscreen"])
                elseif self.currently_selected == 5 then
                    Kristal.Config["autoRun"] = not Kristal.Config["autoRun"]
                elseif self.currently_selected == 6 then
                    Game:returnToMenu()
                elseif self.currently_selected == 7 then
                    Game.world.menu:closeBox()
                end
            elseif self.current_config_page == 2 then
                if self.currently_selected == 1 then
                    self.state = "BORDER"
                elseif self.currently_selected == 2 then
                    Kristal.Config["runAnimations"] = not Kristal.Config["runAnimations"] or false
                elseif self.currently_selected == 3 then
                    Game.world.menu:closeBox()
                end
            end

            return
        end

        if Input.pressed("cancel") then
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()
            Game.world.menu:closeBox()
            return
        end

        if Input.pressed("up") then
            self.currently_selected = self.currently_selected - 1
            self.ui_move:stop()
            self.ui_move:play()
        end
        if Input.pressed("down") then
            self.currently_selected = self.currently_selected + 1
            self.ui_move:stop()
            self.ui_move:play()
        end

        if self.current_config_page == 1 then
            self.currently_selected = Utils.clamp(self.currently_selected, 1, 7)
        elseif self.current_config_page == 2 then
            self.currently_selected = Utils.clamp(self.currently_selected, 1, 3)
        end
		
        local old_page = self.current_config_page
        if Input.pressed("left") then
            self.current_config_page = self.current_config_page - 1
        end
        if Input.pressed("right") then
            self.current_config_page = self.current_config_page + 1
        end

        self.current_config_page = Utils.clamp(self.current_config_page, 1, self.max_config_pages)

        if old_page ~= self.current_config_page then
            self.ui_move:stop()
            self.ui_move:play()
        end
    elseif self.state == "VOLUME" then
        if Input.pressed("cancel") or Input.pressed("confirm") then
            Kristal.setVolume(Utils.round(Kristal.getVolume() * 100) / 100)
            self.ui_select:stop()
            self.ui_select:play()
            self.state = "MAIN"
            return
        end

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
    elseif self.state == "CONTROLS" then
        if not self.rebinding then
            if Input.pressed("cancel") and Game:getConfig("cancelToExit") then
                self.reset_flash_timer = 0
                self.state = "MAIN"
                self.currently_selected = 2
                Input.clear("confirm", true)
            end
        else
            return
        end
    elseif self.state == "BORDER" then
        if Input.pressed("cancel") or Input.pressed("confirm") then
                self.state = "MAIN"
				self.currently_selected = 1
                self.ui_select:stop()
                self.ui_select:play()
        end
        local border_index = -1
        for current_index, border in ipairs(self.border_types) do
            if border[1] == Kristal.Config["borders"] then
                border_index = current_index
            end
        end
        if border_index == -1 then
            border_index = 1
        end
        local old_index = border_index
        if Input.pressed("left") then
            border_index = math.max(border_index - 1, 1)
        end
        if Input.pressed("right") then
            border_index = math.min(border_index + 1, #self.border_types)
        end
        if old_index ~= border_index then
            self.ui_move:stop()
            self.ui_move:play()
            Kristal.Config["borders"] = self.border_types[border_index][1]
            if self.border_types[border_index][1] == "off" then
                Kristal.resetWindow()
            elseif self.border_types[old_index][1] == "off" then
                Kristal.resetWindow()
            end
        end
    end

    self.reset_flash_timer = math.max(self.reset_flash_timer - DTMULT, 0)

    super.update(self)
end

function DarkConfigMenu:draw()
    if Game.state == "EXIT" then
        super.draw(self)
        return
    end
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    if self.state ~= "CONTROLS" then
        love.graphics.print("CONFIG", 188, -12)
		
        local page_offset = ((self.max_config_pages >= 10 and self.current_config_page >= 10) and 14) or ((self.max_config_pages >= 10 and self.current_config_page < 10) and 6) or 0
        if self.max_config_pages > 1 then
            love.graphics.print(self.current_config_page.."/"..self.max_config_pages, 418 - page_offset, -4 + (28 * 9) + 4)
        end
		
    --  Code for the arrow sprite
        local sine_off = math.sin((Kristal.getTime()*30)/16) * 3

        if Game:getConfig("showArrow") and self.max_config_pages > 1 then
            if self.current_config_page ~= 1 then
                Draw.draw(self.flat_arrow_sprite, 410 - page_offset + sine_off, 264, 0, -1, 1)
            end
            if self.current_config_page ~= self.max_config_pages then
                Draw.draw(self.flat_arrow_sprite, 466 + page_offset - sine_off, 264)
            end
        end

        if self.current_config_page == 1 then
            if self.state == "VOLUME" then
                Draw.setColor(PALETTE["world_text_selected"])
            end
            love.graphics.print("Master Volume", 88, 38 + (0 * 32))
            Draw.setColor(PALETTE["world_text"])
            love.graphics.print("Controls", 88, 38 + (1 * 32))
            love.graphics.print("Simplify VFX", 88, 38 + (2 * 32))
            love.graphics.print("Fullscreen", 88, 38 + (3 * 32))
            love.graphics.print("Auto-Run", 88, 38 + (4 * 32))
            love.graphics.print("Return to Title", 88, 38 + (5 * 32))
            love.graphics.print("Back", 88, 38 + (6 * 32))

            if self.state == "VOLUME" then
                Draw.setColor(PALETTE["world_text_selected"])
            end
            love.graphics.print(Utils.round(Kristal.getVolume() * 100) .. "%", 348, 38 + (0 * 32))
            Draw.setColor(PALETTE["world_text"])
            love.graphics.print(Kristal.Config["simplifyVFX"] and "ON" or "OFF", 348, 38 + (2 * 32))
            love.graphics.print(Kristal.Config["fullscreen"] and "ON" or "OFF", 348, 38 + (3 * 32))
            love.graphics.print(Kristal.Config["autoRun"] and "ON" or "OFF", 348, 38 + (4 * 32))
		elseif self.current_config_page == 2 then
            if self.state == "BORDER" then
                Draw.setColor(PALETTE["world_text_selected"])
            end
            love.graphics.print("Border", 88, 38 + (0 * 32))
            Draw.setColor(PALETTE["world_text"])

            love.graphics.print("Run Animations", 88, 38 + (1 * 32))
            love.graphics.print(Kristal.Config["runAnimations"] and "ON" or "OFF", 348, 38 + (1 * 32))

            love.graphics.print("Back", 88, 38 + (2 * 32))
			
            if self.state == "BORDER" then
                love.graphics.setColor(PALETTE["world_text_selected"])
            end
            love.graphics.print(Kristal.getBorderName(), 348, 38 + (0 * 32))
            Draw.setColor(PALETTE["world_text"])
		end

        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 63, 48 + ((self.currently_selected - 1) * 32))
    else
        -- NOTE: This is forced to true if using a PlayStation in DELTARUNE... Kristal doesn't have a PlayStation port though.
        local dualshock = Input.getControllerType() == "ps4"

        love.graphics.print("Function", 23, -12)
        -- Console accuracy for the Heck of it
        if not Kristal.isConsole() then
            love.graphics.print("Key", 243, -12)
        end
        if Input.hasGamepad() then
            love.graphics.print(Kristal.isConsole() and "Button" or "Gamepad", 353, -12)
        end

        Draw.pushScissor()
        Draw.scissor(15, 30, 440, 200)
        for index, key_info in ipairs(self.keybinds) do
            if not (index < ((self.control_page - 1) * 7) - 1 or index > (self.control_page * 7)) then
                Draw.setColor(PALETTE["world_text"])
                local offset = ((self.control_page - 1) * 7)
                if self.currently_selected == index - offset then
                    if self.rebinding then
                        Draw.setColor(PALETTE["world_text_rebind"])
                    else
                        Draw.setColor(PALETTE["world_text_hover"])
                    end
                end

                if dualshock then
                    love.graphics.print(key_info.keybind:gsub("_", " "):upper(), 23, -4 + (29 * (index - offset)))
                else
                    love.graphics.print(key_info.keybind:gsub("_", " "):upper(), 23, -4 + (28 * (index - offset)) + 4)
                end
                
                if not Kristal.isConsole() then
                    local alias = Input.getBoundKeys(key_info.keybind, false)[1]
                    if type(alias) == "table" then
                        local title_cased = {}
                        for _, word in ipairs(alias) do
                            table.insert(title_cased, Utils.titleCase(word))
                        end
                        love.graphics.print(table.concat(title_cased, "+"), 243, 0 + (28 * (index - offset)))
                    elseif alias ~= nil then
                        love.graphics.print(Utils.titleCase(alias), 243, 0 + (28 * (index - offset)))
                    end
                end

                Draw.setColor(1, 1, 1)

                if Input.hasGamepad() then
                    local alias = Input.getBoundKeys(key_info.keybind, true)[1]
                    if alias then
                        local btn_tex = Input.getButtonTexture(alias)
                        if dualshock then
                            Draw.draw(btn_tex, 353 + 42, -2 + (29 * (index - offset)), 0, 2, 2, btn_tex:getWidth() / 2, 0)
                        else
                            Draw.draw(btn_tex, 353 + 42 + 16 - 6, -2 + (28 * (index - offset)) + 11 - 6 + 1, 0, 2, 2,
                                    btn_tex:getWidth() / 2, 0)
                        end
                    end
                end
            end
        end
        Draw.popScissor()

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == 8 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if (self.reset_flash_timer > 0) then
            Draw.setColor(Utils.mergeColor(PALETTE["world_text_hover"], PALETTE["world_text_selected"],
                                        ((self.reset_flash_timer / 10) - 0.1)))
        end

        if dualshock then
            love.graphics.print("Reset to default", 23, -4 + (29 * 8))
        else
            love.graphics.print("Reset to default", 23, -4 + (28 * 8) + 4)
        end

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == 9 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if dualshock then
            love.graphics.print("Finish", 23, -4 + (29 * 9))
        else
            love.graphics.print("Finish", 23, -4 + (28 * 9) + 4)
        end

        Draw.setColor(Game:getSoulColor())

        if dualshock then
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1) * 29))
        else
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1) * 28) + 2)
        end


        Draw.setColor(COLORS.white)
        local page_offset = ((self.max_control_page >= 10 and self.control_page >= 10) and 14) or ((self.max_control_page >= 10 and self.control_page < 10) and 6) or 0
        if self.max_control_page > 1 then
            love.graphics.print(self.control_page.."/"..self.max_control_page, 418 - page_offset, -4 + (28 * 9) + 4)
        end

        local sine_off = math.sin((Kristal.getTime()*30)/16) * 3

        if Game:getConfig("showArrow") and self.max_control_page > 1 then
            if self.control_page ~= 1 then
                Draw.draw(self.flat_arrow_sprite, 410 - page_offset + sine_off, 264, 0, -1, 1)
            end
            if self.control_page ~= self.max_control_page then
                Draw.draw(self.flat_arrow_sprite, 466 + page_offset - sine_off, 264)
            end
        end
    end

    Draw.setColor(1, 1, 1, 1)

    super.draw(self)
end

return DarkConfigMenu
