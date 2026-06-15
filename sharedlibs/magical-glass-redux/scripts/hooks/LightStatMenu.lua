local LightStatMenu, super = HookSystem.hookScript(LightStatMenu)

function LightStatMenu:init()
    super.init(self)

    self.state = "STATS"
    self.party_selecting = 1
    self.spell_selecting = 1
    self.option_selecting = 1
    self.heart_sprite = Assets.getTexture("player/heart_menu")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")
    self.font_small = Assets.getFont("small")
    self.scroll_y = 1

    self.party_select_bg = UIBox(-37, 242 + 56, 372, 52)
    self.party_select_bg.visible = false
    self.party_select_bg.layer = -1
    self.party_selecting_spell = 1
    self:addChild(self.party_select_bg)
end

function LightStatMenu:update()
    self.undertale_stat_display = Kristal.getLibConfig("magical-glass", "undertale_menu_display")

    local show_magic = Kristal.getLibConfig("magical-glass", "show_magic")
    if show_magic == nil then
        show_magic = false
        for _, party in pairs(Game.party) do
            if party:hasSpells() then
                show_magic = true
                break
            end
        end
    end
    self.show_magic = show_magic

    local old_selecting_party        = self.party_selecting
    local old_selecting_spell        = self.spell_selecting
    local old_selecting_option       = self.option_selecting
    local old_selecting_party_spell  = self.party_selecting_spell

    if not OVERLAY_OPEN or TextInput.active then
        if self.state == "PARTYSELECT" then
            if Input.pressed("right") then
                if Mod.libs["moreparty"] then
                    local selected_party, success = Mod.libs["moreparty"]:partySelectHorizontal(self.party_selecting_spell, true, true)
                    if success then
                        self.party_selecting_spell = selected_party
                    else
                        self.party_selecting_spell = self.party_selecting_spell + 1
                    end
                else
                    self.party_selecting_spell = self.party_selecting_spell + 1
                end
            end

            if Input.pressed("left") then
                if Mod.libs["moreparty"] then
                    local selected_party, success = Mod.libs["moreparty"]:partySelectHorizontal(self.party_selecting_spell, false, true)
                    if success then
                        self.party_selecting_spell = selected_party
                    else
                        self.party_selecting_spell = self.party_selecting_spell - 1
                    end
                else
                    self.party_selecting_spell = self.party_selecting_spell - 1
                end
            end

            if Mod.libs["moreparty"] then
                if Input.pressed("up") then
                    self.party_selecting_spell = Mod.libs["moreparty"]:partySelectVectical(self.party_selecting_spell, true)
                end

                if Input.pressed("down") then
                    self.party_selecting_spell = Mod.libs["moreparty"]:partySelectVectical(self.party_selecting_spell, false)
                end
            end
        elseif self.state == "USINGSPELL" then
            if Input.pressed("right") then
                self.option_selecting = self.option_selecting + 1
            end

            if Input.pressed("left") then
                self.option_selecting = self.option_selecting - 1
            end
        elseif self.state ~= "SELECTINGSPELL" then
            if Input.pressed("right") then
                self.party_selecting = self.party_selecting + 1
            end

            if Input.pressed("left") then
                self.party_selecting = self.party_selecting - 1
            end
        else
            if Input.pressed("down") then
                self.spell_selecting = self.spell_selecting + 1
            end

            if Input.pressed("up") then
                self.spell_selecting = self.spell_selecting - 1
            end
        end
    end

    self.party_selecting = MathUtils.clamp(self.party_selecting, 1, #Game.party)
    self.spell_selecting = MathUtils.clamp(self.spell_selecting, 1, #self:getSpells())
    self.option_selecting = MathUtils.clamp(self.option_selecting, 1, 2)
    self.party_selecting_spell = MathUtils.clamp(self.party_selecting_spell, 1, #Game.party)

    if self.party_selecting ~= old_selecting_party or self.spell_selecting ~= old_selecting_spell or self.option_selecting ~= old_selecting_option or old_selecting_party_spell ~= self.party_selecting_spell then
        self.ui_move:stop()
        self.ui_move:play()
    end

    if self.spell_selecting ~= old_selecting_spell then
        local spell_limit = self:getSpellLimit()
        local min_scroll = math.max(1, self.spell_selecting - (spell_limit - 1))
        local max_scroll = math.min(math.max(1, #self:getSpells() - (spell_limit - 1)), self.spell_selecting)
        self.scroll_y = MathUtils.clamp(self.scroll_y, min_scroll, max_scroll)
    end

    local spell = self:getSpells()[self.spell_selecting]
    if Input.pressed("confirm") and (not OVERLAY_OPEN or TextInput.active) then
        if self.state == "STATS" and self.show_magic then
            self.ui_select:stop()
            self.ui_select:play()

            if #Game.party > 1 then
                self.state = "SPELLS"
            elseif #self:getSpells() > 0 then
                self.scroll_y = 1
                self.spell_selecting = 1
                self.state = "SELECTINGSPELL"
            end
        elseif self.state == "SPELLS" then
            self.ui_select:stop()
            self.ui_select:play()

            self.scroll_y = 1
            self.spell_selecting = 1
            if #self:getSpells() > 0 then
                self.state = "SELECTINGSPELL"
            end
        elseif self.state == "SELECTINGSPELL" then
            if Game:getConfig("overworldSpells") then
                self.ui_select:stop()
                self.ui_select:play()

                self.option_selecting = 1
                self.state = "USINGSPELL"
            else
                spell:onCheck()
            end
        elseif self.state == "USINGSPELL" then
            if self.option_selecting == 1 and self:canCast(spell) then
                if spell.target == "ally" and #Game.party > 1 then
                    self.ui_select:stop()
                    self.ui_select:play()

                    self.party_select_bg.visible = true
                    self.party_selecting_spell = 1
                    self.state = "PARTYSELECT"
                else
                    Game:removeTension(spell:getTPCost())
                    spell:onLightWorldStart(Game.party[self.party_selecting], spell.target == "ally" and Game.party[1] or spell.target == "party" and Game.party or nil)
                end
            elseif self.option_selecting == 2 then
                spell:onCheck()
            end
        elseif self.state == "PARTYSELECT" then
            Game:removeTension(spell:getTPCost())
            spell:onLightWorldStart(Game.party[self.party_selecting], Game.party[self.party_selecting_spell])
        end
    end

    if Input.pressed("cancel") and (not OVERLAY_OPEN or TextInput.active) then
        self.ui_move:stop()
        self.ui_move:play()
        if self.state == "PARTYSELECT" then
            self.party_select_bg.visible = false
            self.state = "USINGSPELL"
        elseif self.state == "USINGSPELL" then
            self.state = "SELECTINGSPELL"
        elseif self.state == "SELECTINGSPELL" then
            self.scroll_y = 1
            if #Game.party > 1 then
                self.state = "SPELLS"
            else
                self.state = "STATS"
            end
        elseif self.state == "SPELLS" then
            self.state = "STATS"
        elseif self.state == "STATS" then
            Game.world.menu:closeBox()
        end

        return
    end

    Object.update(self)
end

function LightStatMenu:getSpells()
    local spells = {}
    local party = Game.party[self.party_selecting]
    if party:hasAct() then
        table.insert(spells, Registry.createSpell("_act"))
    end
    for _, spell in ipairs(party:getSpells()) do
        table.insert(spells, spell)
    end

    return spells
end

function LightStatMenu:getSpellLimit()
    return 6
end

function LightStatMenu:canCast(spell)
    if not Game:getConfig("overworldSpells") then return false end
    if Game:getTension() < spell:getTPCost(Game.party[self.party_selecting]) then return false end

    return (spell:hasWorldUsage(Game.party[self.party_selecting]))
end

function LightStatMenu:draw()
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    local party = Game.party[self.party_selecting]

    if self.state == "PARTYSELECT" then
        local function party_box_area()
            local party_box = self.party_select_bg
            love.graphics.rectangle("fill", party_box.x - 24, party_box.y - 24, party_box.width + 48, party_box.height + 48)
        end
        love.graphics.stencil(party_box_area, "replace", 1)
        love.graphics.setStencilTest("equal", 0)
    end

    love.graphics.print("\"" .. party:getName() .. "\"", 4, 8)
    if party:getLightStatText() then
        if party:getLightPortrait() then
            Draw.printAlign(party:getLightStatText(), 222, 116, {align = "center", line_offset = -10})
        else
            love.graphics.print(party:getLightStatText(), 172, 8)
        end
    end

    local ox, oy = party.actor:getPortraitOffset()
    if party:getLightPortrait() then
        Draw.draw(Assets.getTexture(party:getLightPortrait()), 179 + ox, 7 + oy, 0, 2, 2)
    end

    if #Game.party > 1 then
        if self.state == "STATS" or self.state == "SPELLS" then
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, 54, 46, 0, 2, 2)
        end

        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("<                >", 4, 38)
    end

    Draw.setColor(PALETTE["world_text"])

    love.graphics.print(Kristal.getLibConfig("magical-glass", "light_level_name_short") .. "  " .. party:getLightLV(), 4, 68)
    love.graphics.print("HP  " .. party:getHealth() .. " / " .. party:getStat("health"), 4, 100)

    if self.state == "STATS" then
        local exp_needed = party:getLightEXPNeeded()
        if TableUtils.every({party:getLightLV(), exp_needed, party:getLightEXP()}, function(v) return type(v) == "number" end) then
            exp_needed = math.max(0, party:getLightEXPNeeded(party:getLightLV() + 1) - party:getLightEXP())
        end

        local at = party:getBaseStats()["attack"]
        local df = party:getBaseStats()["defense"]
        local mg = party:getBaseStats()["magic"]

        if self.undertale_stat_display then
            at = at - 10
            df = df - 10
        end

        local offset = 0
        if self.show_magic then
            offset = 16
            love.graphics.print("MG  ", 4, 228 - offset)
            love.graphics.print(mg .. " (" .. party:getEquipmentBonus("magic") .. ")", 44, 228 - offset) -- alinging the numbers with the rest of the stats
        end
        love.graphics.print("AT  " .. at .. " (" .. party:getEquipmentBonus("attack") .. ")", 4, 164 - offset)
        love.graphics.print("DF  " .. df .. " (" .. party:getEquipmentBonus("defense") .. ")", 4, 196 - offset)
        love.graphics.print("EXP: " .. party:getLightEXP(), 172, 164)
        love.graphics.print("NEXT: " .. exp_needed, 172, 196)

        local weapon_name = "None"
        local armor_name = "None"

        if party:getWeapon() then
            weapon_name = party:getWeapon():getEquipDisplayName()
        end

        if party:getArmor(1) then
            armor_name = party:getArmor(1):getEquipDisplayName()
        end

        love.graphics.print("WEAPON: " .. weapon_name, 4, 256)
        love.graphics.print("ARMOR: " .. armor_name, 4, 288)

        love.graphics.print(Game:getConfig("lightCurrency"):upper() .. ": " .. Game.lw_money, 4, 328)
        if Mod.libs["magical-glass"].kills > 20 then
            love.graphics.print("KILLS: " .. Mod.libs["magical-glass"].kills, 172, 328)
        end

        if self.show_magic then
            love.graphics.setFont(self.font_small)
            if Input.usingGamepad() then
                Draw.printAlign("PRESS    TO VIEW SPELLS", 150, 368, "center")
                Draw.draw(Input.getTexture("confirm"), 100, 366)
            else
                Draw.printAlign("PRESS " .. Input.getText("confirm") .. " TO VIEW SPELLS", 150, 368, "center")
            end
        end
    else
        local spells = self:getSpells()
        local spell_limit = self:getSpellLimit()

        love.graphics.setFont(self.font_small)
        Draw.setColor(PALETTE["world_gray"])
        love.graphics.print(Kristal.getLibConfig("magical-glass", "light_battle_tp_name"), 21, 138)

        love.graphics.setFont(self.font)
        Draw.setColor(PALETTE["world_text"])
        for i = self.scroll_y, math.min(#spells, self.scroll_y + (spell_limit - 1)) do
            local spell = spells[i]
            local offset = i - self.scroll_y

            love.graphics.print(tostring(spell:getTPCost(party)) .. "%", 20, 148 + offset * 32)
            love.graphics.print(spell:getName(), 90, 148 + offset * 32)
        end

        Draw.setColor(Game:getSoulColor())
        if self.state == "SELECTINGSPELL" then
            Draw.draw(self.heart_sprite, -4, 156 + 32 * (self.spell_selecting - self.scroll_y), 0, 2, 2)
        elseif self.state == "USINGSPELL" then
            if self.option_selecting == 1 then
                Draw.draw(self.heart_sprite, -4 + 32, 348, 0, 2, 2)
            elseif self.option_selecting == 2 then
                Draw.draw(self.heart_sprite, 206 - 32, 348, 0, 2, 2)
            end
        end

        -- Draw scroll arrows if needed
        if #spells > spell_limit then
            Draw.setColor(1, 1, 1)

            -- Move the arrows up and down only if we're in the spell selection state
            local sine_off = 0
            if self.state == "SELECTINGSPELL" then
                sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
            end

            if self.scroll_y > 1 then
                -- up arrow
                Draw.draw(self.arrow_sprite, 294 - 4, (148 + 25 - 3) - sine_off, 0, 1, -1)
            end
            if self.scroll_y + spell_limit <= #spells then
                -- down arrow
                Draw.draw(self.arrow_sprite, 294 - 4, (148 + (32 * spell_limit) - 19) + sine_off)
            end
        end

        -- Draw scrollbar if needed (unless the spell limit is 2, in which case the scrollbar is too small)
        if self.state == "SELECTINGSPELL" and spell_limit > 2 and #spells > spell_limit then
            local scrollbar_height = (spell_limit - 2) * 32 + 7
            Draw.setColor(0.25, 0.25, 0.25)
            love.graphics.rectangle("fill", 294, 148 + 30, 6, scrollbar_height)
            local percent = (self.scroll_y - 1) / (#spells - spell_limit)
            Draw.setColor(1, 1, 1)
            love.graphics.rectangle("fill", 294, 148 + 30 + math.floor(percent * (scrollbar_height - 6)), 6, 6)
        end

        if self.state == "PARTYSELECT" then
            love.graphics.setStencilTest()
            Draw.setColor(PALETTE["world_text"])

            local z = Mod.libs["moreparty"] and Mod.libs["moreparty"]:getPartyPerRowAmount()

            Draw.printAlign("Cast " .. spells[self.spell_selecting]:getName() .. " on", 150, 231 + (#Game.party > z and 18 or 56), "center")

            for i, party_mem in ipairs(Game.party) do
                if i <= z then
                    love.graphics.print(party_mem:getShortName(), 63 - (math.min(#Game.party, z) - 2) * 70 + (i - 1) * 122, 269 + (#Game.party > z and 18 or 56))
                else
                    love.graphics.print(party_mem:getShortName(), 63 - (math.min(#Game.party - z, z) - 2) * 70 + (i - 1 - z) * 122, 269 + 38 + (#Game.party > z and 18 or 56))
                end
            end

            Draw.setColor(Game:getSoulColor())
            for i, party_mem in ipairs(Game.party) do
                if i == self.party_selecting_spell then
                    if i <= z then
                        Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party, z) - 2) * 70 + (i - 1) * 122, 277 + (#Game.party > z and 18 or 56), 0, 2, 2)
                    else
                        Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party - z, z) - 2) * 70 + (i - 1 - z) * 122, 277 + 38 + (#Game.party > z and 18 or 56), 0, 2, 2)
                    end
                end
            end
        elseif Game:getConfig("overworldSpells") then
            Draw.setColor(PALETTE["world_text"])
            if self.state ~= "SPELLS" and not self:canCast(spells[self.spell_selecting]) then
                Draw.setColor(PALETTE["world_gray"])
            end
            love.graphics.print("USE", 20 + 32, 340)
            Draw.setColor(PALETTE["world_text"])
            love.graphics.print("INFO", 230 - 32, 340)
        end
    end
end

return LightStatMenu