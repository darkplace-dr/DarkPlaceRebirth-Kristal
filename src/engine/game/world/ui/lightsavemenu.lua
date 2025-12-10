---@class LightSaveMenu : Object
---@overload fun(...) : LightSaveMenu
local LightSaveMenu, super = Class(Object)

function LightSaveMenu:init(marker)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self.parallax_x = 0
    self.parallax_y = 0

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_select = Assets.newSound("ui_select")

    self.heart_sprite = Assets.getTexture("player/heart")

    self.main_box = UIBox(124, 130, 391, 154)
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

    -- MAIN, SAVE, SAVED, OVERWRITE, QUIT, QUITTING
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

function LightSaveMenu:updateSaveBoxSize()
    if self.state == "SAVED" then
        self.save_list.height = 210
    else
        self.save_list.height = 258
    end
end

function LightSaveMenu:update()
    if OVERLAY_OPEN then return end
    if self.state == "MAIN" then
        if Input.pressed("cancel") then
            self:remove()
            Game.world:closeMenu()
        end
        if Input.pressed("left") or Input.pressed("right") then
            self.selected_x = (self.selected_x == 1 and self.selected_y == 1) and 2 or 1
        end
        if Input.pressed("up") or Input.pressed("down") then
            self.selected_y = self.selected_y == 1 and 2 or 1
            self.selected_x = 1 -- Only one option on this row
        end
        if Input.pressed("confirm") then
            if self.selected_x == 1 and self.selected_y == 1 then
                self.state = "SAVE"

                self.ui_select:stop()
                self.ui_select:play()

                self.selected_file = Game.save_id
                self.selected_x = self.selected_file%2 == 0 and 2 or 1
                self.selected_y = self.selected_file <= 2 and 1 or 2
                self.saved_file = nil

                self.main_box.visible = false
                self.save_box.visible = true
                self:updateSaveBoxSize()
            elseif self.selected_x == 2 and self.selected_y == 1 then
                self:remove()
                Game.world:closeMenu()
            elseif self.selected_x == 1 and self.selected_y == 2 then
                self.state = "QUIT"

                self.ui_select:stop()
                self.ui_select:play()
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
            print("pressed left")
            self.selected_x = self.selected_x - 1
            if self.selected_file ~= 3 then
                self.selected_file = self.selected_file - 1
            end
            print(self.selected_x, self.selected_file)
        end
        if Input.pressed("right") then
            print("pressed right")
            self.selected_x = self.selected_x + 1
            if self.selected_file ~= 2 then
                self.selected_file = self.selected_file + 1
            end
            print(self.selected_x, self.selected_file)
        end

        self.selected_file = MathUtils.clamp(self.selected_file, 1, 4)
        self.selected_x = MathUtils.clamp(self.selected_x, 1, 2)
        self.selected_y = MathUtils.clamp(self.selected_y, 1, 3)
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
                self.selected_x = 1

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

            self.selected_x = (self.selected_file%2 == 0 and 2) or 1
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

                self.selected_x = (self.selected_file%2 == 0 and 2) or 1
                self.overwrite_box.visible = false
                self:updateSaveBoxSize()
            else
                self.state = "SAVE"

                self.selected_x = (self.selected_file%2 == 0 and 2) or 1
                self.overwrite_box.visible = false
            end
        end
    elseif self.state == "QUIT" then
        if Input.pressed("left") or Input.pressed("right") then
            self.selected_x = self.selected_x == 1 and 2 or 1
        end
        if Input.pressed("cancel") then
            self.state = "MAIN"

            self.selected_x = 1
            self.selected_y = 2
        end
        if Input.pressed("confirm") then
            if self.selected_x == 1 then
                self.state = "QUITTING"

                self.ui_select:stop()
                self.ui_select:play()

                Game:returnToMenu()

            elseif self.selected_x == 2 then
                self.state = "MAIN"

                self.selected_x = 1
                self.selected_y = 2
            end
        end
    end

    super.update(self)
end

function LightSaveMenu:draw()

    local heart_positions_x = {142, 322}
    local heart_positions_y = {228, 270}

    love.graphics.setFont(self.font)
    if self.state == "MAIN" then
        local data = Game:getSavePreview()

        -- Header
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print(data.name, 120, 120)
        love.graphics.print("LV "..data.level, 352, 120)

        local hours = math.floor(data.playtime / 3600)
        local minutes = math.floor(data.playtime / 60 % 60)
        local seconds = math.floor(data.playtime % 60)
        local time_text = string.format("%d:%02d:%02d", hours, minutes, seconds)
        love.graphics.print(time_text, 522 - self.font:getWidth(time_text), 120)

        -- Room name
        love.graphics.print(data.room_name, 319.5 - self.font:getWidth(data.room_name)/2, 170)

        -- Buttons
        love.graphics.print("Save", 170, 220)
        love.graphics.print("Return", 350, 220)
        love.graphics.print("Return to Title", 170, 260)

        -- Heart
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, heart_positions_x[self.selected_x], heart_positions_y[self.selected_y])
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
                Draw.draw(self.heart_sprite, 239, 403)
            else
                Draw.draw(self.heart_sprite, 383, 403)
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
    elseif self.state == "QUIT" or self.state == "QUITTING" then

        -- Prompt
        love.graphics.print("Really return to title?", 170, 130)

        -- Buttons
        love.graphics.print("Yes", 170, 260)
        love.graphics.print("No", 350, 260)

        if self.state == "QUIT" then
            -- Heart
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, heart_positions_x[self.selected_x], heart_positions_y[2])
        end
    end

    super.draw(self)

    if self.state == "OVERWRITE" then
        Draw.setColor(PALETTE["world_text"])
        local overwrite_text = "Overwrite Slot "..self.selected_file.."?"
        love.graphics.print(overwrite_text, SCREEN_WIDTH/2 - self.font:getWidth(overwrite_text)/2, 123)

        local function drawOverwriteSave(data, x, y)
            local w = 478

            -- Header
            love.graphics.print(data.name, x + (w/2) - self.font:getWidth(data.name)/2, y)
            love.graphics.print("LV "..data.level, x, y)

            local hours = math.floor(data.playtime / 3600)
            local minutes = math.floor(data.playtime / 60 % 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d:%02d", hours, minutes, seconds)
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
            Draw.draw(self.heart_sprite, 142, 332)

            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Save", 170, 324)

        if self.selected_x == 2 then
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, 322, 332)

            Draw.setColor(PALETTE["world_text_selected"])
        else
            Draw.setColor(PALETTE["world_text"])
        end
        love.graphics.print("Return", 350, 324)
    end
end

function LightSaveMenu:drawSaveFile(index, data, x, y, selected, header)

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
                Draw.draw(self.heart_sprite, x + 50, y + 53)
            else
                Draw.draw(self.heart_sprite, x + 196, y + 54)
            end
        end
    else
        if not header then
            love.graphics.print("LV "..data.level, x + 14, y + 6)
    
            love.graphics.print(data.name, x + (262 / 2) - self.font:getWidth(data.name) / 2, y + 44)
    
            local hours = math.floor(data.playtime / 3600)
            local minutes = math.floor(data.playtime / 60 % 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d:%02d", hours, minutes, seconds)
            love.graphics.print(time_text, x + 248 - self.font:getWidth(time_text), y + 6)
    
            local room_x = Utils.clamp((260 / 2) - self.font:getWidth(data.room_name)/2, 12, math.huge)
            local room_sx = self.font:getWidth(data.room_name) <= 237 and 1 or 237/self.font:getWidth(data.room_name)
            love.graphics.print(data.room_name, x + room_x, y + 82, 0, room_sx, 1)
    
            if selected and not header and self.selected_y ~= 3 then
                Draw.setColor(Game:getSoulColor())
                Draw.draw(self.heart_sprite, x + 122, y + 15)
            end
        else
            love.graphics.print("LV "..data.level, x + 26, y + 6)

            love.graphics.print(data.name, x + (493 / 2) - self.font:getWidth(data.name) / 2, y + 6)
    
            local hours = math.floor(data.playtime / 3600)
            local minutes = math.floor(data.playtime / 60 % 60)
            local seconds = math.floor(data.playtime % 60)
            local time_text = string.format("%d:%02d:%02d", hours, minutes, seconds)
            love.graphics.print(time_text, x + 467 - self.font:getWidth(time_text), y + 6)
    
            love.graphics.print(data.room_name, x + (493 / 2) - self.font:getWidth(data.room_name) / 2, y + 38)
    
            if selected and not header and self.selected_y ~= 3 then
                Draw.setColor(Game:getSoulColor())
                Draw.draw(self.heart_sprite, x + 18, y + 14)
            end
        end
    end
    Draw.setColor(1, 1, 1)
end

return LightSaveMenu
