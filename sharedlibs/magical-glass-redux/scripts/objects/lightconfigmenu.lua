local LightConfigMenu, super = Class(DarkConfigMenu, "LightConfigMenu")

function LightConfigMenu:init()
    super.init(self)
    
    self:setParallax(0, 0)
    self.heart_sprite = Assets.getTexture("player/heart_menu")
end

function LightConfigMenu:update()
    if self.state == "MAIN" then
        if Input.pressed("confirm") and self.currently_selected == 7 then
            self.ui_select:stop()
            self.ui_select:play()
            
            Game.world:closeMenu()
            self:remove()
            return
        end
        if Input.pressed("cancel") then
            Game.world:closeMenu()
            self:remove()
            return
        end
    end

    super.update(self)
end

function LightConfigMenu:draw()
    if Game.state == "EXIT" then
        Object.draw(self)
        return
    end
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    if self.state ~= "CONTROLS" then
        love.graphics.print("SETTINGS", 188, -12)

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
        love.graphics.print("Exit", 88, 38 + (6 * 32))

        if self.state == "VOLUME" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        love.graphics.print(Utils.round(Kristal.getVolume() * 100) .. "%", 348, 38 + (0 * 32))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print(Kristal.Config["simplifyVFX"] and "ON" or "OFF", 348, 38 + (2 * 32))
        love.graphics.print(Kristal.Config["fullscreen"] and "ON" or "OFF", 348, 38 + (3 * 32))
        love.graphics.print(Kristal.Config["autoRun"] and "ON" or "OFF", 348, 38 + (4 * 32))

        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 64, 46 + ((self.currently_selected - 1) * 32), 0, 2, 2)
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

        for index, name in ipairs(Input.order) do
            if index > 7 then
                break
            end
            Draw.setColor(PALETTE["world_text"])
            if self.currently_selected == index then
                if self.rebinding then
                    Draw.setColor(PALETTE["world_text_selected"])
                end
            end

            if dualshock then
                love.graphics.print(name:gsub("_", " "):upper(), 23, -4 + (29 * index))
            else
                love.graphics.print(name:gsub("_", " "):upper(), 23, -4 + (28 * index) + 4)
            end

            local shown_bind = self:getBindNumberFromIndex(index)

            if not Kristal.isConsole() then
                local alias = Input.getBoundKeys(name, false)[1]
                if type(alias) == "table" then
                    local title_cased = {}
                    for _, word in ipairs(alias) do
                        table.insert(title_cased, Utils.titleCase(word))
                    end
                    love.graphics.print(table.concat(title_cased, "+"), 243, 0 + (28 * index))
                elseif alias ~= nil then
                    love.graphics.print(Utils.titleCase(alias), 243, 0 + (28 * index))
                end
            end

            Draw.setColor(1, 1, 1)

            if Input.hasGamepad() then
                local alias = Input.getBoundKeys(name, true)[1]
                if alias then
                    local btn_tex = Input.getButtonTexture(alias)
                    if dualshock then
                        Draw.draw(btn_tex, 353 + 42, -2 + (29 * index), 0, 2, 2, btn_tex:getWidth() / 2, 0)
                    else
                        Draw.draw(btn_tex, 353 + 42 + 16 - 6, -2 + (28 * index) + 11 - 6 + 1, 0, 2, 2,
                                  btn_tex:getWidth() / 2, 0)
                    end
                end
            end
        end

        Draw.setColor(PALETTE["world_text"])

        if (self.reset_flash_timer > 0) then
            Draw.setColor(Utils.mergeColor(PALETTE["world_text"], PALETTE["world_text_selected"],
                                           ((self.reset_flash_timer / 10) - 0.1)))
        end

        if dualshock then
            love.graphics.print("Reset to default", 23, -4 + (29 * 8))
        else
            love.graphics.print("Reset to default", 23, -4 + (28 * 8) + 4)
        end

        Draw.setColor(PALETTE["world_text"])

        if dualshock then
            love.graphics.print("Finish", 23, -4 + (29 * 9))
        else
            love.graphics.print("Finish", 23, -4 + (28 * 9) + 4)
        end

        Draw.setColor(Game:getSoulColor())

        if dualshock then
            Draw.draw(self.heart_sprite, -1, 34 + ((self.currently_selected - 1) * 29), 0, 2, 2)
        else
            Draw.draw(self.heart_sprite, -1, 34 + ((self.currently_selected - 1) * 28) + 2, 0, 2, 2)
        end
    end

    Draw.setColor(1, 1, 1, 1)

    Object.draw(self)
end

return LightConfigMenu
