local LightAdvancedSaveMenu, super = Class(Object, "LightAdvancedSaveMenu")

function LightAdvancedSaveMenu:init(marker)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self:setParallax(0)

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_select = Assets.newSound("ui_select")

    self.heart_sprite = Assets.getTexture("player/heart_menu")
    self.divider_sprite = Assets.getTexture("ui/box/light/top")

    self.main_box = UIBox(140 - 8, 130 + 12, 359 + 17, 109 + 17, "light")
    self.main_box.layer = -1
    self:addChild(self.main_box)

    self.save_box = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.save_box:setColor(0, 0, 0, 0.8)
    self.save_box.layer = -1
    self.save_box.visible = false
    self:addChild(self.save_box)

    self.save_header = UIBox(92, 44, 457, 42)
    self.save_box:addChild(self.save_header)

    self.save_list = UIBox(92, 156, 457, 258)
    self.save_box:addChild(self.save_list)

    self.overwrite_box = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.overwrite_box:setColor(0, 0, 0, 0.8)
    self.overwrite_box.layer = 1
    self.overwrite_box.visible = false
    self:addChild(self.overwrite_box)

    self.overwrite_box:addChild(UIBox(42, 132, 557, 217))

    self.marker = marker

    -- MAIN, SAVE, SAVED, OVERWRITE
    self.state = "MAIN"

    self.selected_x = 1
    self.selected_y = 1

    self.selected_file = 1

    self.saved_file = nil

    self.saves = {}
    for i = 1, 4 do
        self.saves[i] = Kristal.getSaveFile(i)
    end
end

function LightAdvancedSaveMenu:updateSaveBoxSize()
    if self.state == "SAVED" then
        self.save_list.height = 210
    else
        self.save_list.height = 258
    end
end

function LightAdvancedSaveMenu:update()
    if self.state == "MAIN" then
        if Input.pressed("cancel") then
            self:remove()
            Game.world:closeMenu()
        end
        if Input.pressed("left") or Input.pressed("right") then
            self.selected_x = self.selected_x == 1 and 2 or 1
            Assets.playSound("ui_move")
        end
        if Input.pressed("confirm") then
            if self.selected_x == 1 and self.selected_y == 1 then
                self.state = "SAVE"

                self.ui_select:stop()
                self.ui_select:play()

                self.selected_file = Game.save_id
                self.saved_file = nil

                self.main_box.visible = false
                self.save_box.visible = true
                self:updateSaveBoxSize()
            elseif self.selected_x == 2 and self.selected_y == 1 then
                self:remove()
                Game.world:closeMenu()
            end
        end
    elseif self.state == "SAVE" then
        if Input.pressed("cancel") then
            self.state = "MAIN"

            self.ui_select:stop()
            self.ui_select:play()
            
            self.selected_x = 1
            self.selected_y = 1

            self.main_box.visible = true
            self.save_box.visible = false
        end
        local last_selected = self.selected_y
        if Input.pressed("up") then
            self.selected_y = self.selected_y - 1
            if self.selected_file ~= 2 and last_selected ~= 3 then
                self.selected_file = self.selected_file - 2
            end
        end
        if Input.pressed("down") then
            self.selected_y = self.selected_y + 1
            if self.selected_file ~= 3 and last_selected ~= 3 then
                self.selected_file = self.selected_file + 2
            end
        end
        if Input.pressed("left") then
            self.selected_x = self.selected_x - 1
            if self.selected_file ~= 3 then
                self.selected_file = self.selected_file - 1
            end
        end
        if Input.pressed("right") then
            self.selected_x = self.selected_x + 1
            if self.selected_file ~= 2 then
                self.selected_file = self.selected_file + 1
            end
        end
        self.selected_file = Utils.clamp(self.selected_file, 1, 4)
        self.selected_x = Utils.clamp(self.selected_x, 1, 2)
        self.selected_y = Utils.clamp(self.selected_y, 1, 3)

        if Input.pressed("confirm") then
            self.ui_select:stop()
            self.ui_select:play()

            if self.selected_y == 3 then
                self.state = "MAIN"

                self.selected_x = 1
                self.selected_y = 1

                self.main_box.visible = true
                self.save_box.visible = false
            elseif self.selected_file ~= Game.save_id and self.saves[self.selected_file] then
                self.state = "OVERWRITE"

                self.overwrite_box.visible = true
            else
                self.state = "SAVED"

                self.saved_file = self.selected_file
                Kristal.saveGame(self.saved_file, Game:save(self.marker))
                self.saves[self.saved_file] = Kristal.getSaveFile(self.saved_file)

                Assets.playSound("save")
                self:updateSaveBoxSize()
            end
        end
    elseif self.state == "SAVED" then
        if Input.pressed("cancel") or Input.pressed("confirm") then
            self:remove()
            Game.world:closeMenu()
        end
    elseif self.state == "OVERWRITE" then
        if Input.pressed("cancel") then
            self.state = "SAVE"

            self.selected_x = 1
            self.overwrite_box.visible = false
        end
        if Input.pressed("left") or Input.pressed("right") then
            self.selected_x = self.selected_x == 1 and 2 or 1
        end
        if Input.pressed("confirm") then
            if self.selected_x == 1 then
                self.state = "SAVED"

                self.saved_file = self.selected_file
                Kristal.saveGame(self.saved_file, Game:save(self.marker))
                self.saves[self.saved_file] = Kristal.getSaveFile(self.saved_file)

                Assets.playSound("save")

                self.selected_x = 1
                self.overwrite_box.visible = false
                self:updateSaveBoxSize()
            else
                self.state = "SAVE"

                self.selected_x = 1
                self.overwrite_box.visible = false
            end
        end
    end

    super.update(self)
end

function LightAdvancedSaveMenu:draw()
    love.graphics.setFont(self.font)
    if self.state == "MAIN" then
        local data      = Game:getSavePreview()   or {}
        data["level"] = Game.party[1]:getLightLV() or 1
    
        love.graphics.print(data.name,             self.main_box.x + 8,        self.main_box.y - 10 + 8)
    
        love.graphics.print("LV "..data.level, self.main_box.x + 210 - 42, self.main_box.y - 10 + 8)
    
        local minutes = math.floor(data.playtime / 60)
        local seconds = math.floor(data.playtime % 60)
        local time_text = string.format("%d:%02d", minutes, seconds)
        love.graphics.printf(time_text, self.main_box.x - 280 + 148, self.main_box.y - 10 + 8, 500, "right")
    
        love.graphics.print(data.room_name, self.main_box.x + 8, self.main_box.y + 38)
    
        if self.state == "MAIN" then
            love.graphics.print("Save",   self.main_box.x + 30  + 8, self.main_box.y + 98)
            love.graphics.print("Return", self.main_box.x + 210 + 8, self.main_box.y + 98)
    
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, self.main_box.x + 10 + (self.selected_x - 1) * 180, self.main_box.y + 96 + 8, 0, 2, 2)
        elseif self.state == "SAVED" then
            love.graphics.print("File saved.", self.main_box.x + 30 + 8, self.main_box.y + 98)
        end
    elseif self.state == "SAVE" or self.state == "OVERWRITE" then
        self:drawSaveFile(0, Game:getSavePreview(), 74, 26, false, true)

        self:drawSaveFile(1, self.saves[1], 64 + 2, 138 - 4, self.selected_file == 1)

        self:drawSaveFile(2, self.saves[2], 312 + 2, 138 - 4, self.selected_file == 2)

        self:drawSaveFile(3, self.saves[3], 64 + 2, 264, self.selected_file == 3)

        self:drawSaveFile(4, self.saves[4], 312 + 2, 264, self.selected_file == 4)

        Draw.setColor(PALETTE["world_text"])
        Draw.rectangle("fill", SCREEN_WIDTH/2 - 3, self.save_list.height/2 + 7, 6, 252)
        Draw.rectangle("fill", self.save_list.x - 20, SCREEN_HEIGHT/2 + 22 - 4, 497, 6)
        Draw.rectangle("fill", self.save_list.x - 20, 388 - 4, 497, 6)

        if self.selected_y == 3 then
            Draw.setColor(Game:getSoulColor())
            if self.selected_x == 1 then
                Draw.draw(self.heart_sprite, 236, 403, 0, 2)
            else
                Draw.draw(self.heart_sprite, 383, 403, 0, 2)
            end

            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Return", 278, 394)
    elseif self.state == "SAVED" then
        self:drawSaveFile(self.saved_file, self.saves[self.saved_file], 74, 26, false, true)

        self:drawSaveFile(1, self.saves[1], 64 + 2, 138 - 4, self.selected_file == 1)

        self:drawSaveFile(2, self.saves[2], 312 + 2, 138 - 4, self.selected_file == 2)

        self:drawSaveFile(3, self.saves[3], 64 + 2, 264, self.selected_file == 3)

        self:drawSaveFile(4, self.saves[4], 312 + 2, 264, self.selected_file == 4)

        Draw.setColor(PALETTE["world_text"])
        Draw.rectangle("fill", SCREEN_WIDTH/2 - 3, self.save_list.height/2 + 31, 6, 252)
        Draw.rectangle("fill", self.save_list.x - 20, SCREEN_HEIGHT/2 + 22 - 4, 497, 6)
    end

    super.draw(self)

    if self.state == "OVERWRITE" then
        Draw.setColor(PALETTE["world_text"])
        local overwrite_text = "Overwrite Slot "..self.selected_file.."?"
        love.graphics.print(overwrite_text, SCREEN_WIDTH/2 - self.font:getWidth(overwrite_text)/2, 123)

        local function drawOverwriteSave(data, x, y)
            local w = 478

            local level = 0

            if data.party_data and data.party_data[Kristal.getSaveFile(index).party[1]].lw_lv then
                level = data.party_data[Kristal.getSaveFile(index).party[1]].lw_lv
            else
                level = Game.party[1]:getLightLV()
            end

            -- Header
            love.graphics.print(data.name, x + (w/2) - self.font:getWidth(data.name)/2, y)
            love.graphics.print("LV "..level, x, y)

            local minutes = math.floor(data.playtime / 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d", minutes, seconds)
            love.graphics.print(time_text, x + w - self.font:getWidth(time_text), y)

            -- Room name
            love.graphics.print(data.room_name, x + (w/2) - self.font:getWidth(data.room_name)/2, y+30)
        end

        Draw.setColor(PALETTE["world_text"])
        drawOverwriteSave(self.saves[self.selected_file], 80, 165)
        Draw.setColor(PALETTE["world_text_selected"])
        drawOverwriteSave(Game:getSavePreview(), 80, 235)

        if self.selected_x == 1 then
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, 142, 332, 0, 2)

            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Save", 170, 324)

        if self.selected_x == 2 then
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, 322, 332, 0, 2)

            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Return", 350, 324)
    end
end

function LightAdvancedSaveMenu:drawSaveFile(index, data, x, y, selected, header)
    if self.saved_file then
        if self.saved_file == index and self.selected_y ~= 3 then
            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_save_other"])
        end
    else
        if selected and self.selected_y ~= 3 then
            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
    end
    if self.saved_file == index and not header then
        love.graphics.print("File Saved", x + 67, y + 44)
    elseif not data then
        love.graphics.print("New File", x + 79, y + 44)
        if selected and self.selected_y ~= 3 then
            Draw.setColor(Game:getSoulColor())
            if self.selected_x == 1 then
                Draw.draw(self.heart_sprite, x + 50, y + 53, 0, 2)
            else
                Draw.draw(self.heart_sprite, x + 196, y + 54, 0, 2)
            end
        end
    else
        if not header then
            local level = data.party_data[Kristal.getSaveFile(index).party[1]].lw_lv
            love.graphics.print("LV "..level, x + 28, y + 6)
    
            love.graphics.print(data.name, x + (262 / 2) - self.font:getWidth(data.name) / 2, y + 44)
    
            local minutes = math.floor(data.playtime / 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d", minutes, seconds)
            love.graphics.print(time_text, x + 234 - self.font:getWidth(time_text), y + 6)
    
            local room_x = Utils.clamp((260 / 2) - self.font:getWidth(data.room_name)/2, 12, math.huge)
            local room_sx = self.font:getWidth(data.room_name) <= 237 and 1 or 237/self.font:getWidth(data.room_name)
            love.graphics.print(data.room_name, x + room_x, y + 82, 0, room_sx, 1)
    
            if selected and not header and self.selected_y ~= 3 then
                Draw.setColor(Game:getSoulColor())
                Draw.draw(self.heart_sprite, x + 122, y + 15, 0, 2)
            end
        else
            love.graphics.print("LV "..Game.party[1]:getLightLV(), x + 26, y + 6)

            love.graphics.print(data.name, x + (493 / 2) - self.font:getWidth(data.name) / 2, y + 6)
    
            local minutes = math.floor(data.playtime / 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d", minutes, seconds)
            love.graphics.print(time_text, x + 467 - self.font:getWidth(time_text), y + 6)
    
            love.graphics.print(data.room_name, x + (493 / 2) - self.font:getWidth(data.room_name) / 2, y + 38)
    
            if selected and not header and self.selected_y ~= 3 then
                Draw.setColor(Game:getSoulColor())
                Draw.draw(self.heart_sprite, x + 18, y + 14, 0, 2)
            end
        end
    end
    Draw.setColor(1, 1, 1)
end

return LightAdvancedSaveMenu