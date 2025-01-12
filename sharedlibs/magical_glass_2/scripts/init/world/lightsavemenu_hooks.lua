Utils.hook(LightSaveMenu, "update", function(orig, self)
    if self.state == "MAIN" then
        if ((Input.pressed("confirm") and self.selected_x == 1) or (Input.pressed("left") or Input.pressed("right"))) then
            Assets.playSound("ui_move")
        end
    end
    orig(self)
end)

Utils.hook(LightSaveMenu, "draw", function(orig, self)
    love.graphics.setFont(self.font)

    if self.state == "SAVED" then
        Draw.setColor(PALETTE["world_text_selected"])
    else
        Draw.setColor(PALETTE["world_text"])
    end

    local data      = self.saved_file            or {}
    local name      = data.name                  or "EMPTY"
    local level     = Game.party[1]:getLightLV() or 1
    local playtime  = data.playtime              or 0
    local room_name = data.room_name             or "--"

    love.graphics.print(name,             self.box.x + 8,        self.box.y - 10 + 8)

    if self.saved_file or self.state == "SAVED" then
        love.graphics.print("LV "..level, self.box.x + 210 - 42, self.box.y - 10 + 8)
    else
        love.graphics.print("LV 0",       self.box.x + 210 - 42, self.box.y - 10 + 8)
    end

    local minutes = math.floor(playtime / 60)
    local seconds = math.floor(playtime % 60)
    local time_text = string.format("%d:%02d", minutes, seconds)
    love.graphics.printf(time_text, self.box.x - 280 + 148, self.box.y - 10 + 8, 500, "right")

    love.graphics.print(room_name, self.box.x + 8, self.box.y + 38)

    if self.state == "MAIN" then
        love.graphics.print("Save",   self.box.x + 30  + 8, self.box.y + 98)
        love.graphics.print("Return", self.box.x + 210 + 8, self.box.y + 98)

        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, self.box.x + 10 + (self.selected_x - 1) * 180, self.box.y + 96 + 8, 0, 2, 2)
    elseif self.state == "SAVED" then
        love.graphics.print("File saved.", self.box.x + 30 + 8, self.box.y + 98)
    end

    Draw.setColor(1, 1, 1)

    LightSaveMenu.__super.draw(self)
end)