Utils.hook(LightMenu, "onKeyPressed", function(orig, self, key)
    if (Input.isMenu(key) or Input.isCancel(key)) and self.state == "MAIN" then
        Game.world:closeMenu()
        return
    end

    if self.state == "MAIN" then
        local old = self.current_selecting
        if Input.is("up", key)   then self.current_selecting = self.current_selecting - 1 end
        if Input.is("down", key) then self.current_selecting = self.current_selecting + 1 end
        local menu_items = 4
        if MagicalGlass:getConfig("lightMenuHideCell") and not Game:getFlag("has_cell_phone") then
            menu_items = 3
        end
        self.current_selecting = Utils.clamp(self.current_selecting, 1, menu_items)
        if old ~= self.current_selecting then
            self.ui_move:stop()
            self.ui_move:play()
        end
        if Input.isConfirm(key) then
            self:onButtonSelect(self.current_selecting)
        end
    end
end)

Utils.hook(LightMenu, "draw", function(orig, self)
    LightMenu.__super.draw(self)
    
    love.graphics.setFont(self.font)
    if (Game.inventory:getItemCount("items", false) > 0) or (Game.inventory:getItemCount("key_items", false) > 0) then
        Draw.setColor(PALETTE["world_text"])
    else
        Draw.setColor(PALETTE["world_gray"])
    end
    love.graphics.print("ITEM", 84, 188 + (36 * 0))
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print("STAT", 84, 188 + (36 * 1))

    if not MagicalGlass:getConfig("lightMenuHideCell") then
        if Game:getFlag("has_cell_phone") and #Game.world.calls > 0  then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        love.graphics.print("CELL", 84, 188 + (36 * 2))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("TALK", 84, 188 + (36 * 3))
    else
        if Game:getFlag("has_cell_phone") then
            if #Game.world.calls > 0 then
                Draw.setColor(PALETTE["world_text"])
            else
                Draw.setColor(PALETTE["world_gray"])
            end
            love.graphics.print("CELL", 84, 188 + (36 * 2))
            Draw.setColor(PALETTE["world_text"])
            love.graphics.print("TALK", 84, 188 + (36 * 3))
        else
            Draw.setColor(PALETTE["world_text"])
            love.graphics.print("TALK", 84, 188 + (36 * 2))
        end
    end
    
    if self.state == "MAIN" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 56, 160 + (36 * self.current_selecting), 0, 2, 2)
    end
    
    local offset = 0
    if self.top then
        offset = 270
    end

    local chara = Game.party[1]

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    if MagicalGlass:getConfig("lightMenuCapitalizedName") then
        love.graphics.print(chara:getName():upper(), 46, 60 + offset)
    else
        love.graphics.print(chara:getName(), 46, 60 + offset)
    end

    love.graphics.setFont(self.font_small)
    love.graphics.print("LV  "..chara:getLightLV(), 46, 100 + offset)
    love.graphics.print("HP  "..chara:getHealth() ..  "/" .. chara:getStat("health"), 46, 118 + offset)
    if MagicalGlass:getConfig("lightMenuCurrencyAlignFix") then
        love.graphics.print(Game:getConfig("lightCurrencyShort"), 46, 136 + offset)
        love.graphics.print(Game.lw_money, 82, 136 + offset)
    else
        love.graphics.print(Utils.padString(Game:getConfig("lightCurrencyShort"), 4) .. Game.lw_money, 46, 136 + offset)
    end
end)