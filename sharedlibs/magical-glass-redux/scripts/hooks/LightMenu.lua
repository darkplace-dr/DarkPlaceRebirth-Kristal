local LightMenu, super = HookSystem.hookScript(LightMenu)

function LightMenu:draw()
    Object.draw(self)

    if self.box and self.box.state == "PARTYSELECT" then
        local function party_box_area()
            local party_box = self.box.party_select_bg
            love.graphics.rectangle("fill", party_box.x + 188, party_box.y + 52, party_box.width + 48, party_box.height + 48)
        end
        love.graphics.stencil(party_box_area, "replace", 1)
        love.graphics.setStencilTest("equal", 0)
    end

    local offset = 0
    local offset2 = 0
    if self.top then
        offset = 270
        if Game:getFlag("has_cell_phone") then
			offset2 = -36
		end
    end

    local chara = Game.party[1]

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print(chara:getShortName(), 46, 60 + offset)

    love.graphics.setFont(self.font_small)
    love.graphics.print(Kristal.getLibConfig("magical-glass", "light_level_name_short") .. "  " .. chara:getLightLV(), 46, 100 + offset)
    love.graphics.print("HP  " .. chara:getHealth() .. "/" .. chara:getStat("health"), 46, 118 + offset)
    if Kristal.getLibConfig("magical-glass", "undertale_menu_display") then
        love.graphics.print(Game:getConfig("lightCurrencyShort"), 46, 136 + offset)
        love.graphics.print(Game.lw_money, 82, 136 + offset)
    else
        love.graphics.print(StringUtils.pad(Game:getConfig("lightCurrencyShort"), 4) .. Game.lw_money, 46, 136 + offset)
    end

    love.graphics.setFont(self.font)
    if Game.inventory:getItemCount(self.storage, false) <= 0 then
        Draw.setColor(PALETTE["world_gray"])
    else
        Draw.setColor(PALETTE["world_text"])
    end
    love.graphics.print("ITEM", 84, offset2 + 188 + (36 * 0))
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print("STAT", 84, offset2 + 188 + (36 * 1))
    if Game:getFlag("has_cell_phone", false) then
        if #Game.world.calls > 0 then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        love.graphics.print("CELL", 84, offset2 + 188 + (36 * 2))

        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("TALK", 84, offset2 + 188 + (36 * 3))
    else
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("TALK", 84, offset2 + 188 + (36 * 2))
    end

    if self.state == "MAIN" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 56, offset2 + 160 + (36 * self.current_selecting), 0, 2, 2)
    end

    love.graphics.setStencilTest()
end

return LightMenu