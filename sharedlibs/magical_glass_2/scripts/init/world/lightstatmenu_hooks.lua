Utils.hook(LightStatMenu, "init", function(orig, self)
    orig(self)
    self.party_selecting = 1

    self.undertale_stat_display = MagicalGlass:getConfig("lightStatMenuUndertaleStatDisplay")

    self.magic_display = MagicalGlass:getConfig("lightStatMenuMagicDisplay")
    self.party_magic_display = MagicalGlass:getConfig("lightStatMenuPartyWideMagicDisplay")
end)

Utils.hook(LightStatMenu, "update", function(orig, self)
    local old = self.party_selecting

    if Input.pressed("cancel") and (not OVERLAY_OPEN or TextInput.active) then
        self.ui_move:stop()
        self.ui_move:play()
        Game.world.menu:closeBox()
        return
    end

    if not OVERLAY_OPEN or TextInput.active then
        if Input.pressed("right") then
            self.party_selecting = self.party_selecting + 1
        elseif Input.pressed("left") then
            self.party_selecting = self.party_selecting - 1
        end
    end

    if self.party_selecting > #Game.party then
        self.party_selecting = 1
    end

    if self.party_selecting < 1 then
        self.party_selecting = #Game.party
    end

    if self.party_selecting ~= old then
        self.ui_move:stop()
        self.ui_move:play()
    end

    LightStatMenu.__super.update(self)
end)

Utils.hook(LightStatMenu, "draw", function(orig, self)
    love.graphics.setFont(self.font)

    local sx, sy = 172, 8
    if #Game.party > 1 then
        Draw.setColor(Game:getSoulColor())
        -- why is this in the base class
        Draw.draw(self.heart_sprite, sx + 50, sy + 8, 0, 2)
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("<                >", sx, sy)
    else
        Draw.setColor(PALETTE["world_text"])
    end
    
    local chara = Game.party[self.party_selecting]

    if MagicalGlass:getConfig("lightStatMenuCapitalizedName") then
        love.graphics.print("\"" .. chara:getName():upper() .. "\"", 4, 8)
    else
        love.graphics.print("\"" .. chara:getName() .. "\"", 4, 8)
    end
    love.graphics.print("LV  " .. chara:getLightLV(), 4, 68)
    love.graphics.print("HP  " .. chara:getHealth() .. " / " .. chara:getStat("health"), 4, 100)

    local at = chara:getBaseStats()["attack"]
    local df = chara:getBaseStats()["defense"]
    local mg = chara:getBaseStats()["magic"] or 0

    if self.undertale_stat_display then
        at = at - 10
        df = df - 10
    end

    local show_magic = self:shouldDrawMagic()

    local offset = 0
    if show_magic then
        offset = -16
    end

    love.graphics.print("AT  " .. at .. " (" .. chara:getEquipmentBonus("attack")  .. ")", 4, 164 + offset)
    love.graphics.print("DF  " .. df .. " (" .. chara:getEquipmentBonus("defense") .. ")", 4, 196 + offset)
    if show_magic then
        if MagicalGlass:getConfig("lightStatMenuMagicAlignFix") then
            love.graphics.print("MG", 4, 228 + offset)
            love.graphics.print(mg  .. " (" .. chara:getEquipmentBonus("magic") .. ")", 44, 228 + offset)
        else
            love.graphics.print("MG  " .. mg .. " (" .. chara:getEquipmentBonus("magic")   .. ")", 4, 228 + offset)
        end
    end

    local exp_needed = math.max(0, chara:getLightEXPNeeded(chara:getLightLV() + 1) - chara:getLightEXP())

    love.graphics.print("EXP: "  .. chara:getLightEXP(), 172, 164 + offset)
    love.graphics.print("NEXT: " .. exp_needed,          172, 196 + offset)

    local weapon_name = "None"
    local armor_name = "None"
    if chara:getWeapon() then
        weapon_name = chara:getWeapon():getEquipName() or chara:getWeapon():getName()
    end
    if chara:getArmor(1) then
        armor_name =  chara:getArmor(1):getEquipName() or chara:getArmor(1):getName()
    end

    love.graphics.print("WEAPON: " .. weapon_name, 4, 256)
    love.graphics.print("ARMOR: "  .. armor_name,  4, 288)

    love.graphics.print(Game:getConfig("lightCurrency"):upper() .. ": " .. Game.lw_money, 4, 328)
    if MagicalGlass.kills > 20 then
        love.graphics.print("KILLS: " .. MagicalGlass.kills, 172, 328)
    end

    LightStatMenu.__super.draw(self)
end)

Utils.hook(LightStatMenu, "shouldDrawMagic", function(orig, self)
    if self.magic_display == "always" then
        return true
    elseif self.magic_display == "has_spell" then
        if self.party_magic_display then
            for _,party in pairs(Game.party) do
                if #party:getSpells() > 0 then
                    return true
                end
            end
        else
            if chara:getSpells() > 0 then return true end
        end
    elseif self.magic_display == "has_magic" then
        if self.party_magic_display then
            for _,party in pairs(Game.party) do
                if (party:getBaseStats()["magic"] or 0) > 0 then
                    return true
                end
            end
        else
            if (chara:getBaseStats()["magic"] or 0) > 0 then return true end
        end
    end
    return false
end)