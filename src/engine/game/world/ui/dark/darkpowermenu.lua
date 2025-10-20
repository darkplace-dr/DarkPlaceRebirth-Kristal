---@class DarkPowerMenu : Object
---@overload fun(...) : DarkPowerMenu
local DarkPowerMenu, super = Class(Object)

function DarkPowerMenu:init()
    super.init(self, 82, 112, 477, 277)

    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Assets.getTexture("player/heart")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")

    self.tp_sprite = Game:getConfig("oldUIPositions") and Assets.getTexture("ui/menu/caption_tp_old") or Assets.getTexture("ui/menu/caption_tp")

    self.caption_sprites = {
          ["char"] = Assets.getTexture("ui/menu/caption_char"),
         ["stats"] = Assets.getTexture("ui/menu/caption_stats"),
        ["spells"] = Assets.getTexture("ui/menu/caption_spells"),
    }

    self.stat_icons = {
         ["attack"] = Assets.getTexture("ui/menu/icon/sword"),
        ["defense"] = Assets.getTexture("ui/menu/icon/armor"),
          ["magic"] = Assets.getTexture("ui/menu/icon/magic"),
   }

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    self.party = DarkMenuPartySelect(8, 48)
    self.party.focused = true
    self.party.highlight_party = false
    self:addChild(self.party)

    self.party.on_select = function(new, old)
        Game.party[old]:onPowerDeselect(self)
        Game.party[new]:onPowerSelect(self)
    end

    -- PARTY, SPELLS
    self.state = "PARTY"

    self.selected_spell = 1

    self.scroll_y = 1

    self.leveling_use_global_values = false

    self.data_shown = "spells"

    self.caption_sprites["experience"] = Assets.getTexture("ui/menu/caption_exp")
    self.caption_sprites["combos"] = Assets.getTexture("ui/menu/caption_combo")
    self.caption_sprites["arrow_l"] = Assets.getTexture("ui/flat_arrow_left_opaque")
    self.caption_sprites["arrow_r"] = Assets.getTexture("ui/flat_arrow_right_opaque")
end

function DarkPowerMenu:getSpellLimit()
    return 6
end

function DarkPowerMenu:getSpells()
    local spells = {}
    local party = self.party:getSelected()
    if party:hasAct() then
        table.insert(spells, Registry.createSpell("_act"))
    end
    for _,spell in ipairs(party:getSpells()) do
        table.insert(spells, spell)
    end
    return spells
end

function DarkPowerMenu:updateDescription()
    if self.state == "SPELLS" then
        local spell = self:getSpells()[self.selected_spell]
        Game.world.menu:setDescription(spell and spell:getDescription() or "", true)
    elseif self.state == "COMBOS" then
        local combo = self:getCombos()[self.selected_spell]
        Game.world.menu:setDescription(combo and combo:getDescription() or "", true)
    else
        Game.world.menu:setDescription("", false)
    end
end

function DarkPowerMenu:onRemove(parent)
    super.onRemove(self, parent)
    if Game.world.menu then
        Game.world.menu:updateSelectedBoxes()
    end
end

function DarkPowerMenu:update()
    if self.state == "PARTY" then
        if Input.pressed("confirm") then
            self.state = "CHOOSETAB"

            self.party.focused = false

            self.ui_select:stop()
            self.ui_select:play()
        elseif Input.pressed("cancel") then
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()
            Game.world.menu:closeBox()
            return
        else
            super.update(self)
        end
    elseif self.state == "CHOOSETAB" then
        if Input.pressed("cancel") then
            self.state = "PARTY"

            self.party.focused = true

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()
            return
        elseif Input.pressed("right") then
            self.ui_move:stop()
            self.ui_move:play()

            if self.data_shown == "spells" then self.data_shown = "experience"
            elseif self.data_shown == "experience" then self.data_shown = "combos"
            elseif self.data_shown == "combos" then self.data_shown = "spells" end
        elseif Input.pressed("left") then
            self.ui_move:stop()
            self.ui_move:play()

            if self.data_shown == "spells" then self.data_shown = "combos"
            elseif self.data_shown == "combos" then self.data_shown = "experience"
            elseif self.data_shown == "experience" then self.data_shown = "spells" end
        elseif Input.pressed("confirm") then
            if self.data_shown == "spells" then
                self.ui_select:stop()
                self.ui_select:play()
                if #self:getSpells() > 0 then
                    self.state = "SPELLS"

                    self.party.focused = false

                    self.selected_spell = 1
                    self.scroll_y = 1

                    self:updateDescription()
                end
			elseif self.data_shown == "combos" and #self.party:getSelected():getCombos() > 0 then
                self.ui_select:stop()
                self.ui_select:play()
                if #self:getSpells() > 0 then
                    self.state = "COMBOS"

                    self.party.focused = false

                    self.selected_spell = 1
                    self.scroll_y = 1

                    self:updateDescription()
                end
            end
        end
    elseif self.state == "SPELLS" then
        if Input.pressed("cancel") then
            self.state = "CHOOSETAB"

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self.scroll_y = 1

            self:updateDescription()
            return
        end
        if Input.pressed("confirm") then
            local spell = self:getSpells()[self.selected_spell]
            if self:canCast(spell) then
                self.state = "USE"
                if spell.target == "ally" or spell.target == "party" then

                    local target_type = spell.target == "ally" and "SINGLE" or "ALL"

                    self:selectParty(target_type, spell)
                else
                    Game:removeTension(spell:getTPCost())
                    spell:onWorldCast()
                    self.state = "SPELLS"
                end
            end
        end
        local spells = self:getSpells()
        local old_selected = self.selected_spell
        if Input.pressed("up", true) then
            self.selected_spell = self.selected_spell - 1
        end
        if Input.pressed("down", true) then
            self.selected_spell = self.selected_spell + 1
        end
        self.selected_spell = Utils.clamp(self.selected_spell, 1, #spells)
        if self.selected_spell ~= old_selected then
            local spell_limit = self:getSpellLimit()
            local min_scroll = math.max(1, self.selected_spell - (spell_limit - 1))
            local max_scroll = math.min(math.max(1, #spells - (spell_limit - 1)), self.selected_spell)
            self.scroll_y = Utils.clamp(self.scroll_y, min_scroll, max_scroll)

            self.ui_move:stop()
            self.ui_move:play()
            self:updateDescription()
        end
	elseif self.state == "COMBOS" then
        if Input.pressed("cancel") then
            self.state = "CHOOSETAB"

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self.scroll_y = 1

            self:updateDescription()
            return
        end
        local spells = self:getCombos()
        local old_selected = self.selected_spell
        if Input.pressed("up", true) then
            self.selected_spell = self.selected_spell - 1
        end
        if Input.pressed("down", true) then
            self.selected_spell = self.selected_spell + 1
        end
        self.selected_spell = Utils.clamp(self.selected_spell, 1, #spells)
        if self.selected_spell ~= old_selected then
            local spell_limit = self:getSpellLimit()
            local min_scroll = math.max(1, self.selected_spell - (spell_limit - 1))
            local max_scroll = math.min(math.max(1, #spells - (spell_limit - 1)), self.selected_spell)
            self.scroll_y = Utils.clamp(self.scroll_y, min_scroll, max_scroll)

            self.ui_move:stop()
            self.ui_move:play()
            self:updateDescription()
        end
    else
        super.update(self)
    end
end

function DarkPowerMenu:selectParty(target_type, spell)
    Game.world.menu:partySelect(target_type, function(success, party)
        if success then
            Game:removeTension(spell:getTPCost())
            spell:onWorldCast(party)
            if self:canCast(spell) then
                self:selectParty(target_type, spell)
            else
                self.state = "SPELLS"
            end
        else
            self.state = "SPELLS"
        end
    end)
end

function DarkPowerMenu:draw()
    love.graphics.setFont(self.font)

    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("fill", -24, 104, 525, 6)
    if Game:getConfig("oldUIPositions") then
        love.graphics.rectangle("fill", 212, 104, 6, 196)
    else
        love.graphics.rectangle("fill", 212, 104, 6, 200)
    end

    Draw.setColor(1, 1, 1, 1)
    Draw.draw(self.caption_sprites[  "char"],  42, -28, 0, 2, 2)
    Draw.draw(self.caption_sprites[ "stats"],  42,  98, 0, 2, 2)

    local x, y, offset
    if self.data_shown == "spells" then
        x = 298
        y = 98
        offset = 91+28
    elseif self.data_shown == "experience" then
        x = 265
        y = 218-14
        offset = 91+95
    else
        x = 298
        y = 98
        offset = 91+28
    end

    local arrow_weave = 0
    if self.state == "CHOOSETAB" then
        arrow_weave = Utils.round(math.sin(Kristal.getTime() * 5)) * 2
        Draw.setColor(1, 1, 0, 1)
    end
    Draw.draw(self.caption_sprites["arrow_l"], x-19-arrow_weave, 95, 0, 2, 2)
    Draw.draw(self.caption_sprites["arrow_r"], x+offset+arrow_weave, 95, 0, 2, 2)
    if self.state == "CHOOSETAB" then
        Draw.setColor(1, 1, 1, 1)
    end

    Draw.draw(self.caption_sprites[self.data_shown], x, 98, 0, 2, 2)

    self:drawChar()
    self:drawStats()
    if self.data_shown == "spells" then
        self:drawSpells()
    elseif self.data_shown == "experience" then
        self:drawExperience()
    else
        self:drawCombos()
    end

    super.draw(self)
end

function DarkPowerMenu:drawChar()
    local party = self.party:getSelected()
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print(party:getName(), 48, -7)
    love.graphics.print(party:getTitle(), 238, -7)
end

function DarkPowerMenu:drawStats()
    local party = self.party:getSelected()
    Draw.setColor(1, 1, 1, 1)
    Draw.draw(self.stat_icons[ "attack"], -8, 124, 0, 2, 2)
    Draw.draw(self.stat_icons["defense"], -8, 149, 0, 2, 2)
    Draw.draw(self.stat_icons[  "magic"], -8, 174, 0, 2, 2)
    love.graphics.print( "Attack:", 18, 118)
    love.graphics.print("Defense:", 18, 143)
    love.graphics.print(  "Magic:", 18, 168)
    local stats = party:getStats()
    love.graphics.print(stats[ "attack"], 148, 118)
    love.graphics.print(stats["defense"], 148, 143)
    love.graphics.print(stats[  "magic"], 148, 168)
    for i = 1, 3 do
        local x, y = 18, 168 + (i * 25)
        love.graphics.setFont(self.font)
        Draw.setColor(PALETTE["world_text"])
        love.graphics.push()
        if not party:drawPowerStat(i, x, y, self) then
            Draw.setColor(PALETTE["world_dark_gray"])
            love.graphics.print("???", x, y)
        end
        love.graphics.pop()
    end
end

function DarkPowerMenu:drawSpells()
    local spells = self:getSpells()

    local tp_x, tp_y
    local name_x, name_y

    if #spells <= 6 then
        tp_x, tp_y = 258, 118
        name_x, name_y = 328, 118
    else
        tp_x, tp_y = 242, 118
        name_x, name_y = 302, 118
    end

    Draw.setColor(1, 1, 1)
    Draw.draw(self.tp_sprite, tp_x, tp_y - 5)

    local spell_limit = self:getSpellLimit()

    for i = self.scroll_y, math.min(#spells, self.scroll_y + (spell_limit - 1)) do
        local spell = spells[i]
        local offset = i - self.scroll_y

        if not self:canCast(spell) then
            Draw.setColor(0.5, 0.5, 0.5)
        else
            Draw.setColor(1, 1, 1)
        end
        love.graphics.print(tostring(spell:getTPCost(self.party:getSelected())).."%", tp_x, tp_y + (offset * 25))
        love.graphics.print(spell:getName(), name_x, name_y + (offset * 25))
    end

    -- Draw scroll arrows if needed
    if #spells > spell_limit then
        Draw.setColor(1, 1, 1)

        -- Move the arrows up and down only if we're in the spell selection state
        local sine_off = 0
        if self.state == "SPELLS" then
            sine_off = math.sin((Kristal.getTime()*30)/12) * 3
        end

        if self.scroll_y > 1 then
            -- up arrow
            Draw.draw(self.arrow_sprite, 469, (name_y + 25 - 3) - sine_off, 0, 1, -1)
        end
        if self.scroll_y + spell_limit <= #spells then
            -- down arrow
            Draw.draw(self.arrow_sprite, 469, (name_y + (25 * spell_limit) - 12) + sine_off)
        end
    end

    if self.state == "SPELLS" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, tp_x - 20, tp_y + 10 + ((self.selected_spell - self.scroll_y) * 25))

        -- Draw scrollbar if needed (unless the spell limit is 2, in which case the scrollbar is too small)
        if spell_limit > 2 and #spells > spell_limit then
            local scrollbar_height = (spell_limit - 2) * 25
            Draw.setColor(0.25, 0.25, 0.25)
            love.graphics.rectangle("fill", 473, name_y + 30, 6, scrollbar_height)
            local percent = (self.scroll_y - 1) / (#spells - spell_limit)
            Draw.setColor(1, 1, 1)
            love.graphics.rectangle("fill", 473, name_y + 30 + math.floor(percent * (scrollbar_height-6)), 6, 6)
        end
    end
end

function DarkPowerMenu:getExp()
    return self.leveling_use_global_values
        and Game:getFlag("library_experience")
        or self.party:getSelected():getExp()
end

function DarkPowerMenu:getNextLv()
    return self.leveling_use_global_values
        and Kristal.callEvent("getGlobalNextLv")
        or self.party:getSelected():getNextLv()
end

function DarkPowerMenu:getLOVE()
    return self.leveling_use_global_values
        and Game:getFlag("library_love")
        or self.party:getSelected():getLOVE()
end

function DarkPowerMenu:drawExperience()
    Draw.setColor(1, 1, 1, 1)
    if self.party:getSelected().id == "pauling" then
        love.graphics.print("LEVEL:",   242-6,  122)
        love.graphics.print("KILLS:",   242-6,  156)
        -- love.graphics.print("HIRED:",   242-6,  190)                         -- Reserved for HIRED
        love.graphics.print("MILESTONE-BASED",   242-6,  258)

        love.graphics.print(               self:getLOVE(),  	242+76, 122)
        love.graphics.print(              self:getKills(),  	242+76, 156)
        -- love.graphics.print(          self:getNextLv(),  	242+76, 190)    -- Reserved for HIRED
    else
        love.graphics.print( "LOVE:",   242-6,  122)
        love.graphics.print(  "EXP:",   242-6,  156)
        love.graphics.print( "NEXT:",   242-6,  190)
        love.graphics.print("KILLS:",   242-6,  224)

        love.graphics.print(               self:getLOVE(),  	242+64, 122)
        love.graphics.print(                self:getExp(),  	242+49, 156)
        love.graphics.print(             self:getNextLv(),  	242+62, 190)
        love.graphics.print(              self:getKills(),  	242+76, 224)
    end
end

function DarkPowerMenu:getKills()
    local party = self.party:getSelected()
    return party.kills
end

function DarkPowerMenu:drawCombos()
    local combos = self:getCombos()

    local tp_x, tp_y
    local name_x, name_y

    if #combos <= 6 then
        tp_x, tp_y = 258, 118
        name_x, name_y = 328, 118
    else
        tp_x, tp_y = 242, 118
        name_x, name_y = 302, 118
    end

    Draw.setColor(1, 1, 1)
    Draw.draw(self.tp_sprite, tp_x, tp_y - 5)

    local spell_limit = self:getSpellLimit()

    for i = self.scroll_y, math.min(#combos, self.scroll_y + (spell_limit - 1)) do
        local spell = combos[i]
        local offset = i - self.scroll_y

        Draw.setColor(0.5, 0.5, 0.5)
        love.graphics.print(tostring(spell:getTPCost(self.party:getSelected())).."%", tp_x, tp_y + (offset * 25))
        love.graphics.print(spell:getName(), name_x, name_y + (offset * 25))
    end

    -- Draw scroll arrows if needed
    if #combos > spell_limit then
        Draw.setColor(1, 1, 1)

        -- Move the arrows up and down only if we're in the spell selection state
        local sine_off = 0
        if self.state == "COMBOS" then
            sine_off = math.sin((Kristal.getTime()*30)/12) * 3
        end

        if self.scroll_y > 1 then
            -- up arrow
            Draw.draw(self.arrow_sprite, 469, (name_y + 25 - 3) - sine_off, 0, 1, -1)
        end
        if self.scroll_y + spell_limit <= #combos then
            -- down arrow
            Draw.draw(self.arrow_sprite, 469, (name_y + (25 * spell_limit) - 12) + sine_off)
        end
    end

    if self.state == "COMBOS" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, tp_x - 20, tp_y + 10 + ((self.selected_spell - self.scroll_y) * 25))

        -- Draw scrollbar if needed (unless the spell limit is 2, in which case the scrollbar is too small)
        if spell_limit > 2 and #combos > spell_limit then
            local scrollbar_height = (spell_limit - 2) * 25
            Draw.setColor(0.25, 0.25, 0.25)
            love.graphics.rectangle("fill", 473, name_y + 30, 6, scrollbar_height)
            local percent = (self.scroll_y - 1) / (#combos - spell_limit)
            Draw.setColor(1, 1, 1)
            love.graphics.rectangle("fill", 473, name_y + 30 + math.floor(percent * (scrollbar_height-6)), 6, 6)
        end
    end
end

function DarkPowerMenu:canCast(spell)
    --if not Game:getFlag("tension_storage") then return false end
    if Game:getTension() <= spell:getTPCost(self.party:getSelected()) then return false end
    return spell:hasWorldUsage(self.party:getSelected())
end

function DarkPowerMenu:getCombos()
    local combos = {}
    local party = self.party:getSelected()
    for _,combo in ipairs(party:getCombos()) do
        table.insert(combos, combo)
    end
    return combos
end

return DarkPowerMenu
