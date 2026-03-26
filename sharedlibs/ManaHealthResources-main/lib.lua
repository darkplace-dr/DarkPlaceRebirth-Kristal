Lib = {}

Registry.registerGlobal("ManaHealthResources", Lib)
ManaHealthResources = Lib

function Lib:init()

    --Default colors for UI purposes. Change values here.
    Lib.PALETTE = {
        mana_bar_bg = {0.4, 0.4, 0.4},
        mana_bar_fill = {30/255, 144/255, 1},
        mana_desc = {0, 191/255, 1},
        mana_text = {1, 1, 1},
        mana_text_low = {1, 1, 0},
        mana_text_empty = {0.6, 0.6, 0.6},
        mana_text_down = {0.25, 0.25, 0.25},
        mana_msg = {30/255, 144/255, 1},
        mana_sparkle = {0, 193/255, 242/255},
        health_cost_desc = {1, 0, 0},
    }
    for _, v in pairs(Lib.PALETTE) do
        setmetatable(v, { __call = function (c, a) return { c[1], c[2], c[3], a or 1 } end })
    end

    HookSystem.hook(World, "onKeyPressed", function (orig, self, key)
        orig(self, key)

        if Kristal.Config["debug"] and Input.ctrl() then
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["full_mana_all"] then
                for _,party in ipairs(Game.party) do
                    if party:usesMana() then
                        party:regenMana(math.huge)
                    end
                end
            end
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["zero_mana_all"] then
                Game.world:depleteManaParty(math.huge)
            end
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["zero_tension"] then
                Game:setTension(0, true)
            end
        end
    end)
    HookSystem.hook(Battle, "onKeyPressed", function (orig, self, key)
        orig(self, key)

        if Kristal.Config["debug"] and Input.ctrl() then
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["full_mana_all"] then
                for _,battler in ipairs(self.party) do
                    if battler.chara:usesMana() then
                        battler:regenMana(math.huge)
                    end
                end
            end
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["zero_mana_all"] then
                for _,battler in ipairs(self.party) do
                    if battler.chara:usesMana() then
                        Assets.stopAndPlaySound("pmd2_pp_down", 0.6)
                        battler.chara:setMana(0)
                    end
                end
            end
            if key == Kristal.getLibConfig("ManaHealthResources", "debug_keys")["zero_tension"] then
                Game:setTension(0, true)
            end
        end

    end)

    HookSystem.hook(PartyMember, "increaseStat", function(orig, self, stat, amount, max)
        orig(self, stat, amount, max)
        if stat == "mana" then
            local base_stats = self:getBaseStats()
            base_stats[stat] = (base_stats[stat] or 0) + amount
            self:setMana(math.min(self:getMana() + amount, base_stats[stat]))
        end
    end)
    HookSystem.hook(PartyMember, "onSave", function(orig, self, data)
        data.mana = self.mana
        data.lw_mana = self.lw_mana
        data.uses_mana = self.uses_mana
        data.default_spell_resource = self.default_spell_resource
        orig(self, data)
    end)
    HookSystem.hook(PartyMember, "onLoad", function(orig, self, data)
        self.mana = data.mana or self:getStat("mana", 0, false)
        self.lw_mana = data.lw_mana or self:getStat("mana", 0, true)
        self.uses_mana = data.uses_mana or self.uses_mana
        self.default_spell_resource = data.default_spell_resource or self.default_spell_resource
        orig(self, data)
    end)

    HookSystem.hook(OverworldActionBox, "init", function (orig, self, x, y, index, chara)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["OverworldActionBox"] then orig(self, x, y, index, chara) return end

        orig(self, x, y, index, chara)
        self.new_hp_sprite  = Sprite("ui/hp_new", 109, 24)
        self:addChild(self.new_hp_sprite)

        self.mp_sprite  = Sprite("ui/mp", 107, 26)
        self:addChild(self.mp_sprite)
        self.mp_sprite.visible = false

        self.hp_sprite.visible = false
    end)
    HookSystem.hook(OverworldActionBox, "draw", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["OverworldActionBox"] then orig(self) return end

        if self.chara:usesMana() then

            self.new_hp_sprite.x = 107
            self.new_hp_sprite.y = 10

            self.mp_sprite.visible = true

            -- Draw the line at the top
            if self.selected then
                Draw.setColor(self.chara:getColor())
            else
                Draw.setColor(PALETTE["action_strip"])
            end

            love.graphics.setLineWidth(2)
            love.graphics.line(0, 1, 213, 1)

            if Game:getConfig("oldUIPositions") then
                love.graphics.line(0, 2, 2, 2)
                love.graphics.line(211, 2, 213, 2)
            end

            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 125, 8, 81, 12)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 82

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 125, 8, math.ceil(health), 12)
            end

            ----------------- Mana Bar -----------------------------
            Draw.setColor(ManaHealthResources.PALETTE["mana_bar_bg"])
            love.graphics.rectangle("fill", 125, 24, 81, 12)

            local mana = (self.chara:getMana() / self.chara:getStat("mana")) * 82

            if mana > 0 then
                Draw.setColor(ManaHealthResources.PALETTE["mana_bar_fill"])
                love.graphics.rectangle("fill", 125, 24, math.ceil(mana), 12)
            end
            --------------------------------------------------------------

            local color = PALETTE["action_health_text"]
            local mana_color = ManaHealthResources.PALETTE["mana_text"]

            if mana <= 0 then
                mana_color = ManaHealthResources.PALETTE["mana_text_empty"]
            elseif (self.chara:getMana() <= (self.chara:getStat("mana") / 4)) then
                mana_color = ManaHealthResources.PALETTE["mana_text_low"]
            else
                mana_color = ManaHealthResources.PALETTE["mana_text"]
            end

            if health <= 0 then
                color = PALETTE["action_health_text_down"]
                mana_color = ManaHealthResources.PALETTE["mana_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            local mana_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8
            mana_offset = (#tostring(self.chara:getMana()) - 1) * 8

            local string_width_health = self.font:getWidth(tostring(self.chara:getStat("health")))
            local string_width_mana = self.font:getWidth(tostring(self.chara:getStat("mana")))

            love.graphics.setFont(self.font)

            --Draw the black translucent outlines
            local outline_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_WIDTH)

                ManaHealthResources:getOutlineDraft(self.chara:getHealth(), 182 - health_offset - string_width_health, 9)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_health, 9)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("health"), 207 - string_width_health, 9)

                ManaHealthResources:getOutlineDraft(self.chara:getMana(), 182 - mana_offset - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("mana"), 207 - string_width_mana, 25)

                Draw.setColor(COLORS["black"], 0.5)
            Draw.popCanvas()

            Draw.drawCanvas(outline_canvas)

            Draw.setColor(color)
            love.graphics.print(self.chara:getHealth(), 182 - health_offset - string_width_health, 9)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 192 - string_width_health, 9)
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 207 - string_width_health, 9)

            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getMana(), 182 - mana_offset - string_width_mana, 25)
            Draw.setColor(ManaHealthResources.PALETTE["mana_text"])
            love.graphics.print("/", 192 - string_width_mana, 25)
            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getStat("mana"), 207 - string_width_mana, 25)

            -- Draw name text if there's no sprite
            if not self.name_sprite then
                local font = Assets.getFont("name")
                love.graphics.setFont(font)
                Draw.setColor(1, 1, 1, 1)

                local name = self.chara:getName():upper()
                local spacing = 5 - name:len()

                local off = 0
                for i = 1, name:len() do
                    local letter = name:sub(i, i)
                    love.graphics.print(letter, 51 + off, 16 - 1)
                    off = off + font:getWidth(letter) + spacing
                end
            end

            local reaction_x = -1

            if self.x == 0 then -- lazy check for leftmost party member
                reaction_x = 3
            end

            love.graphics.setFont(self.main_font)
            Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
            love.graphics.print(self.reaction_text, reaction_x, 43, 0, 0.5, 0.5)

            Object.draw(self)
        else
            -- Draw the line at the top
            if self.selected then
                Draw.setColor(self.chara:getColor())
            else
                Draw.setColor(PALETTE["action_strip"])
            end

            love.graphics.setLineWidth(2)
            love.graphics.line(0, 1, 213, 1)

            if Game:getConfig("oldUIPositions") then
                love.graphics.line(0, 2, 2, 2)
                love.graphics.line(211, 2, 213, 2)
            end

            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 128, 24, 76, 9)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 76

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 128, 24, math.ceil(health), 9)
            end

            local color = PALETTE["action_health_text"]
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8

            Draw.setColor(color)
            love.graphics.setFont(self.font)
            love.graphics.print(self.chara:getHealth(), 152 - health_offset, 11)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 161, 11)
            local string_width = self.font:getWidth(tostring(self.chara:getStat("health")))
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 205 - string_width, 11)

            -- Draw name text if there's no sprite
            if not self.name_sprite then
                local font = Assets.getFont("name")
                love.graphics.setFont(font)
                Draw.setColor(1, 1, 1, 1)

                local name = self.chara:getName():upper()
                local spacing = 5 - name:len()

                local off = 0
                for i = 1, name:len() do
                    local letter = name:sub(i, i)
                    love.graphics.print(letter, 51 + off, 16 - 1)
                    off = off + font:getWidth(letter) + spacing
                end
            end

            local reaction_x = -1

            if self.x == 0 then -- lazy check for leftmost party member
                reaction_x = 3
            end

            love.graphics.setFont(self.main_font)
            Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
            love.graphics.print(self.reaction_text, reaction_x, 43, 0, 0.5, 0.5)

            Object.draw(self)
        end
    end)

    HookSystem.hook(ActionBox, "init", function (orig, self, x, y, index, battler)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["ActionBox"] then orig(self, x, y, index, battler) return end

        orig(self, x, y, index, battler)

        self.new_hp_sprite  = Sprite("ui/hp_new", 109, 5)
        self.box:addChild(self.new_hp_sprite)

        self.mp_sprite = Sprite("ui/mp", 107, 7)
        self.box:addChild(self.mp_sprite)
        self.mp_sprite.visible = false

        self.hp_sprite.visible = false
    end)
    HookSystem.hook(ActionBox, "update", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["ActionBox"] then orig(self) return end

        if self.battler.chara:usesMana() then
            self.selection_siner = self.selection_siner + 2 * DTMULT

            if Game.battle.current_selecting == self.index then
                if self.box.y > -32 then self.box.y = self.box.y - 2 * DTMULT end
                if self.box.y > -24 then self.box.y = self.box.y - 4 * DTMULT end
                if self.box.y > -16 then self.box.y = self.box.y - 6 * DTMULT end
                if self.box.y > -8  then self.box.y = self.box.y - 8 * DTMULT end
                -- originally '= -64' but that was an oversight by toby
                if self.box.y < -32 then self.box.y = -32 end
            elseif self.box.y < -14 then
                self.box.y = self.box.y + 15 * DTMULT
            else
                self.box.y = 0
            end

            self.head_sprite.y = 11 - self.data_offset + self.head_offset_y
            if self.name_sprite then
                self.name_sprite.y = 14 - self.data_offset
            end
            self.new_hp_sprite.x = 107
            self.new_hp_sprite.y = 8 - self.data_offset

            self.mp_sprite.visible = true
            self.mp_sprite.y = 24 - self.data_offset

            if not self.force_head_sprite then
                local current_head = self.battler.chara:getHeadIcons().."/"..self.battler:getHeadIcon()
                if not self.head_sprite:hasSprite(current_head) then
                    current_head = self.battler.chara:getHeadIcons().."/head"
                end

                if not self.head_sprite:isSprite(current_head) then
                    self.head_sprite:setSprite(current_head)
                end
            end

            for i,button in ipairs(self.buttons) do
                if (Game.battle.current_selecting == self.index) then
                    button.selectable = true
                    button.hovered = (self.selected_button == i)
                else
                    button.selectable = false
                    button.hovered = false
                end
            end
            Object.draw(self)
        else
            self.selection_siner = self.selection_siner + 2 * DTMULT

            self:animateBox()

            self.head_sprite.y = 11 - self.data_offset + self.head_offset_y
            if self.name_sprite then
                self.name_sprite.y = 14 - self.data_offset
            end
            self.new_hp_sprite.y = 22 - self.data_offset

            if not self.force_head_sprite then
                local current_head = self.battler.chara:getHeadIcons() .. "/" .. self.battler:getHeadIcon()
                if not self.head_sprite:hasSprite(current_head) then
                    current_head = self.battler.chara:getHeadIcons() .. "/head"
                end

                if not self.head_sprite:isSprite(current_head) then
                    self.head_sprite:setSprite(current_head)
                end
            end

            for i, button in ipairs(self:getSelectableButtons()) do
                if (Game.battle.current_selecting == self.index) then
                    button.selectable = true
                    button.hovered = (self.selected_button == i)
                else
                    button.selectable = false
                    button.hovered = false
                end
            end

            Object.draw(self)
        end

    end)
    HookSystem.hook(ActionBoxDisplay, "draw", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["ActionBox"] then orig(self) return end

        if self.actbox.battler.chara:usesMana() then
            if Game.battle.current_selecting == self.actbox.index then
                Draw.setColor(self.actbox.battler.chara:getColor())
            else
                Draw.setColor(PALETTE["action_strip"], 1)
            end

            love.graphics.setLineWidth(2)
            love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)

            love.graphics.setLineWidth(2)
            if Game.battle.current_selecting == self.actbox.index then
                love.graphics.line(1  , 2, 1,   36)
                love.graphics.line(212, 2, 212, 36)
            end

            Draw.setColor(PALETTE["action_fill"])
            love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)

            if self.actbox.battler.succumbed then
                love.graphics.setFont(self.font)
                Draw.setColor(1, 0, 0)
                love.graphics.print("SUCCUMBED", 129, 14 - self.actbox.data_offset)

                Object.draw(self)
                return
            end

            ------------Health Bar--------------
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 125, 6 - self.actbox.data_offset, 81, 12)

            local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * 82

            if health > 0 then
                Draw.setColor(self.actbox.battler.chara:getColor())
                love.graphics.rectangle("fill", 125, 6 - self.actbox.data_offset, math.ceil(health), 12)
            end
            -------------------------------------

            ----------------- Mana Bar -----------------------------
            Draw.setColor(ManaHealthResources.PALETTE["mana_bar_bg"])
            love.graphics.rectangle("fill", 125, 22 - self.actbox.data_offset, 81, 12)

            local mana = (self.actbox.battler.chara:getMana() / self.actbox.battler.chara:getStat("mana")) * 82

            if mana > 0 then
                Draw.setColor(ManaHealthResources.PALETTE["mana_bar_fill"])
                love.graphics.rectangle("fill", 125, 22 - self.actbox.data_offset, math.ceil(mana), 12)
            end
            ----------------------------------------------------------

            local color = PALETTE["action_health_text"]
            local mana_color = ManaHealthResources.PALETTE["mana_text"]

            if mana <= 0 then
                mana_color = ManaHealthResources.PALETTE["mana_text_empty"]
            elseif (self.actbox.battler.chara:getMana() <= (self.actbox.battler.chara:getStat("mana") / 4)) then
                mana_color = ManaHealthResources.PALETTE["mana_text_low"]
            else
                mana_color = ManaHealthResources.PALETTE["mana_text"]
            end

            if health <= 0 then
                color = PALETTE["action_health_text_down"]
                mana_color = ManaHealthResources.PALETTE["mana_text_down"]
            elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            local mana_offset = 0
            health_offset = (#tostring(self.actbox.battler.chara:getHealth()) - 1) * 8
            mana_offset = (#tostring(self.actbox.battler.chara:getMana()) - 1) * 8

            local string_width_health = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
            local string_width_mana = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("mana")))

            love.graphics.setFont(self.font)

            --Draw the black translucent outlines
            local outline_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_WIDTH)

                ManaHealthResources:getOutlineDraft(self.actbox.battler.chara:getHealth(), 183 - health_offset - string_width_health, 7 - self.actbox.data_offset)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_health, 7 - self.actbox.data_offset)
                ManaHealthResources:getOutlineDraft(self.actbox.battler.chara:getStat("health"), 207 - string_width_health, 7 - self.actbox.data_offset)

                ManaHealthResources:getOutlineDraft(self.actbox.battler.chara:getMana(), 183 - mana_offset - string_width_mana, 23 - self.actbox.data_offset)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_mana, 23 - self.actbox.data_offset)
                ManaHealthResources:getOutlineDraft(self.actbox.battler.chara:getStat("mana"), 207 - string_width_mana, 23 - self.actbox.data_offset)

                Draw.setColor(COLORS["black"], 0.5)
                Draw.popCanvas()

            Draw.drawCanvas(outline_canvas)

            Draw.setColor(color)
            love.graphics.print(self.actbox.battler.chara:getHealth(), 183 - health_offset - string_width_health, 7 - self.actbox.data_offset)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 192 - string_width_health, 7 - self.actbox.data_offset)
            Draw.setColor(color)
            love.graphics.print(self.actbox.battler.chara:getStat("health"), 207 - string_width_health, 7 - self.actbox.data_offset)


            Draw.setColor(mana_color)
            love.graphics.print(self.actbox.battler.chara:getMana(), 183 - mana_offset - string_width_mana, 23 - self.actbox.data_offset)
            Draw.setColor(ManaHealthResources.PALETTE["mana_text"])
            love.graphics.print("/", 192 - string_width_mana, 23 - self.actbox.data_offset)
            Draw.setColor(mana_color)
            love.graphics.print(self.actbox.battler.chara:getStat("mana"), 207 - string_width_mana, 23 - self.actbox.data_offset)

            --super.super.draw(self)
            Object.draw(self)
        else

            if Game.battle.current_selecting == self.actbox.index then
            Draw.setColor(self.actbox.battler.chara:getColor())
            else
                Draw.setColor(PALETTE["action_strip"], 1)
            end

            love.graphics.setLineWidth(2)
            love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)

            love.graphics.setLineWidth(2)
            if Game.battle.current_selecting == self.actbox.index then
                love.graphics.line(1  , 2, 1,   36)
                love.graphics.line(212, 2, 212, 36)
            end

            Draw.setColor(PALETTE["action_fill"])
            love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)

            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, 76, 9)

            if self.actbox.battler.succumbed then
                love.graphics.setFont(self.font)
                Draw.setColor(1, 0, 0)
                love.graphics.print("SUCCUMBED", 129, 9 - self.actbox.data_offset)

                Object.draw(self)
                return
            end

            local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * 76

            if health > 0 then
                Draw.setColor(self.actbox.battler.chara:getColor())
                love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.ceil(health), 9)
            end


            local color = PALETTE["action_health_text"]
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end


            local health_offset = 0
            health_offset = (#tostring(self.actbox.battler.chara:getHealth()) - 1) * 8

            Draw.setColor(color)
            love.graphics.setFont(self.font)
            love.graphics.print(self.actbox.battler.chara:getHealth(), 152 - health_offset, 9 - self.actbox.data_offset)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 161, 9 - self.actbox.data_offset)
            local string_width = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
            Draw.setColor(color)
            love.graphics.print(self.actbox.battler.chara:getStat("health"), 205 - string_width, 9 - self.actbox.data_offset)

            Object.draw(self)
        end
    end)

    HookSystem.hook(Savepoint, "init", function (orig, self, x, y, properties)
        orig(self, x, y, properties)

        --Whether this Savepoint regens mana the party when interacted with (Defaults to `true`)
        self.regen_mana = properties["regen_mana"] ~= false
    end)
    HookSystem.hook(Savepoint, "onTextEnd", function (orig, self)
        if self.regen_mana then
            for _,party in pairs(Game.party_data) do
                if party:usesMana() then
                    party:regenMana(math.huge, false)
                end
            end
        end
        orig(self)
    end)

    HookSystem.hook(DarkPowerMenu, "init", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["DarkPowerMenu"] then orig(self) return end

        orig(self)
        self.mp_sprite = Game:getConfig("oldUIPositions") and Assets.getTexture("ui/menu/caption_mp_old") or Assets.getTexture("ui/menu/caption_mp")
        self.hp_sprite = Game:getConfig("oldUIPositions") and Assets.getTexture("ui/menu/caption_mp_old") or Assets.getTexture("ui/menu/caption_hp")
    end)
    HookSystem.hook(DarkPowerMenu, "draw", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["DarkPowerMenu"] then orig(self) return end

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
        Draw.draw(self.caption_sprites["spells"], 298,  98, 0, 2, 2)

        self:drawChar()
        self:drawStats()
        self:drawSpells()

        Object.draw(self)
    end)
    HookSystem.hook(DarkPowerMenu, "drawSpells", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["DarkPowerMenu"] then orig(self) return end

        local spells = self:getSpells()

        local tp_x, tp_y
        local name_x, name_y
        local caption_x, caption_y

        if #spells <= 6 then
            tp_x, tp_y = 258, 118
            name_x, name_y = 328, 118
            caption_x, caption_y = 286, 118
        else
            tp_x, tp_y = 242, 118
            name_x, name_y = 302, 118
            caption_x, caption_y = 286, 118
        end

        Draw.setColor(1, 1, 1)
        local resource_caption = spells[self.selected_spell]:getResourceType(self.party:getSelected())
        if resource_caption == "tension" then
            Draw.draw(self.tp_sprite, tp_x, tp_y - 5)
        elseif resource_caption == "mana" then
            Draw.draw(self.mp_sprite, tp_x, tp_y - 5)
        elseif resource_caption == "health" then
            Draw.draw(self.hp_sprite, tp_x, tp_y - 5)
        end


        local spell_limit = self:getSpellLimit()

        --local resource = self.party:getSelected():getDefaultSpellResourceType()

        for i = self.scroll_y, math.min(#spells, self.scroll_y + (spell_limit - 1)) do
            local spell = spells[i]
            local offset = i - self.scroll_y
            local resource = spell:getResourceType(self.party:getSelected())

            if not self:canCast(spell) then
                Draw.setColor(0.5, 0.5, 0.5)
            else
                Draw.setColor(1, 1, 1)
            end

            --local caption_resource = spells[self.selected_spell]:getResourceType(self.party:getSelected())
            if resource == "tension" then
                --love.graphics.print("TP", caption_x, caption_y + (offset * 25))
                love.graphics.print(tostring(spell:getTPCost(self.party:getSelected())).."%", tp_x, tp_y + (offset * 25))
            elseif resource == "mana" then
                --love.graphics.print("MP", caption_x, caption_y + (offset * 25))
                love.graphics.print(tostring(spell:getMPCost(self.party:getSelected())), tp_x, tp_y + (offset * 25))
            elseif resource == "health" then
                --love.graphics.print("HP", caption_x, caption_y + (offset * 25))
                love.graphics.print(tostring(spell:getHPCost(self.party:getSelected())), tp_x, tp_y + (offset * 25))
            end
            --print(resource)
            --love.graphics.print(spell:getName(), name_x - 30, name_y + (offset * 25))
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
                Draw.draw(self.arrow_sprite, 469 + 5, (name_y + 25 - 3) - sine_off, 0, 1, -1)
            end
            if self.scroll_y + spell_limit <= #spells then
                -- down arrow
                Draw.draw(self.arrow_sprite, 469 + 5, (name_y + (25 * spell_limit) - 12) + sine_off)
            end
        end

        if self.state == "SPELLS" then
            local party = Game.battle.party[Game.battle.current_selecting].chara
            if party.soul_color then
                Draw.setColor(party.soul_color)
            else
                Draw.setColor(Game.battle.encounter:getSoulColor())
            end
            local heart_sprite = Assets.getTexture("player/"..party:getSoulFacing().."/heart")
            if party.heart_sprite then
                heart_sprite = Assets.getTexture(party.heart_sprite)
            end
            Draw.draw(heart_sprite, tp_x - 20, tp_y + 10 + ((self.selected_spell - self.scroll_y) * 25))

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
    end)
    HookSystem.hook(DarkPowerMenu, "canCast", function (orig, self, spell)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_darkpowermenu_spell_usability_changes") then orig(self, spell) return end

        if not Game:getConfig("overworldSpells") then return false end
        local resource = spell:getResourceType(self.party:getSelected())
        --print(resource)
        if resource == "tension" then
            if Game:getTension() < spell:getTPCost(self.party:getSelected()) then return false end
        elseif resource == "mana" then
            if self.party:getSelected():getMana() < spell:getMPCost(self.party:getSelected()) then return false end
            --print("huhh")
        elseif resource == "health" then
            if self.party:getSelected():getHealth() <= spell:getTPCost(self.party:getSelected()) then return false end
        end

        return (spell:hasWorldUsage(self.party:getSelected()))
    end)
    HookSystem.hook(DarkPowerMenu, "update", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_darkpowermenu_spell_usability_changes") then orig(self) return end
        if self.state == "PARTY" then
            if Input.pressed("cancel") then
                self.ui_cancel_small:stop()
                self.ui_cancel_small:play()
                Game.world.menu:closeBox()
                return
            elseif Input.pressed("confirm") then
                if #self:getSpells() > 0 then
                    self.state = "SPELLS"

                    self.party.focused = false

                    self.ui_select:stop()
                    self.ui_select:play()

                    self.selected_spell = 1
                    self.scroll_y = 1

                    self:updateDescription()
                else
                    self.ui_select:stop()
                    self.ui_select:play()
                end
            end
        elseif self.state == "SPELLS" then
            if Input.pressed("cancel") then
                self.state = "PARTY"

                self.ui_cancel_small:stop()
                self.ui_cancel_small:play()

                self.party.focused = true

                self.scroll_y = 1

                self:updateDescription()
                return
            end
            if Input.pressed("confirm") then
                local spell = self:getSpells()[self.selected_spell]
                if self:canCast(spell) then
                    self.state = "USE"
                    if spell:getTarget() == "ally" or spell:getTarget() == "party" then

                        local target_type = spell:getTarget() == "ally" and "SINGLE" or "ALL"

                        self:selectParty(target_type, spell)
                    else
                        Game.world:setWorldCaster(self.party:getSelected())
                        local caster = Game.world:getWorldCaster()
                        local resource = spell:getResourceType(caster)
                        if resource == "tension" then
                            Game:removeTension(spell:getTPCost())
                        elseif resource == "mana" then
                            caster:removeMana(spell:getMPCost(caster))
                        elseif resource == "health" then
                            caster:setHealth(caster:getHealth() - spell:getHPCost(caster))
                        end
                        spell:onWorldCast()
                        Game.world:setWorldCaster(nil)
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
        end
        Object.update(self)
    end)
    HookSystem.hook(DarkPowerMenu, "selectParty", function (orig, self, target_type, spell)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_darkpowermenu_spell_usability_changes") then orig(self, target_type, spell) return end

        Game.world.menu:partySelect(target_type, function(success, party)
            Game.world:setWorldCaster(self.party:getSelected())
            --local caster = Game.world:getWorldCaster()
            --local main_resource = self.party:getSelected():getMainSpellResourceType()
            local caster = Game.world:getWorldCaster()
            local resource = spell:getResourceType(caster)
            if success then
                if resource == "tension" then
                    Game:removeTension(spell:getTPCost())
                elseif resource == "mana" then
                    caster:removeMana(spell:getMPCost(caster))
                elseif resource == "health" then
                    caster:setHealth(caster:getHealth() - spell:getHPCost(caster))
                end
                spell:onWorldCast(party)
                if self:canCast(spell) then
                    self:selectParty(target_type, spell)
                else
                    self.state = "SPELLS"
                end
            else
                Game.world:setWorldCaster(nil)
                self.state = "SPELLS"
            end
        end)
    end)

    HookSystem.hook(BattleUI, "drawState", function (orig, self)
        if not Kristal.getLibConfig("ManaHealthResources", "use_propietary_ui")["BattleUI"] then orig(self) return end

        if Game.battle.state == "MENUSELECT" then
            local page = math.ceil(Game.battle.current_menu_y / 3) - 1
            local max_page = math.ceil(#Game.battle.menu_items / 6) - 1

            local x = 0
            local y = 0
            local party = Game.battle.party[Game.battle.current_selecting].chara
            if party.soul_color then
                Draw.setColor(party.soul_color)
            else
                Draw.setColor(Game.battle.encounter:getSoulColor())
            end
            local heart_sprite = Assets.getTexture("player/"..party:getSoulFacing().."/heart")
            if party.heart_sprite then
                heart_sprite = Assets.getTexture(party.heart_sprite)
            end
            Draw.draw(heart_sprite, 5 + ((Game.battle.current_menu_x - 1) * 230), 30 + ((Game.battle.current_menu_y - (page*3)) * 30))

            local font = Assets.getFont("main")
            love.graphics.setFont(font)

            local page_offset = page * 6
            for i = page_offset+1, math.min(page_offset+6, #Game.battle.menu_items) do
                local item = Game.battle.menu_items[i]

                Draw.setColor(1, 1, 1, 1)
                local text_offset = 0
                -- Are we able to select this?
                local able = Game.battle:canSelectMenuItem(item)
                if item.party then
                    if not able then
                        -- We're not able to select this, so make the heads gray.
                        Draw.setColor(COLORS.gray)
                    end

                    for index, party_id in ipairs(item.party) do
                        local chara = Game:getPartyMember(party_id)

                        -- Draw head only if it isn't the currently selected character
                        if Game.battle:getPartyIndex(party_id) ~= Game.battle.current_selecting then
                            local ox, oy = chara:getHeadIconOffset()
                            Draw.draw(Assets.getTexture(chara:getHeadIcons() .. "/head"), text_offset + 30 + (x * 230) + ox, 50 + (y * 30) + oy)
                            text_offset = text_offset + 30
                        end
                    end
                end

                if item.icons then
                    if not able then
                        -- We're not able to select this, so make the heads gray.
                        Draw.setColor(COLORS.gray)
                    end

                    for _, icon in ipairs(item.icons) do
                        if type(icon) == "string" then
                            icon = {icon, false, 0, 0, nil}
                        end
                        if not icon[2] then
                            local texture = Assets.getTexture(icon[1])
                            Draw.draw(texture, text_offset + 30 + (x * 230) + (icon[3] or 0), 50 + (y * 30) + (icon[4] or 0))
                            text_offset = text_offset + (icon[5] or texture:getWidth())
                        end
                    end
                end

                if able then
                    -- Using color like a function feels wrong... should this be called getColor?
                    Draw.setColor(item:color() or {1, 1, 1, 1})
                else
                    Draw.setColor(COLORS.gray)
                end
                love.graphics.print(item.name, text_offset + 30 + (x * 230), 50 + (y * 30))
                text_offset = text_offset + font:getWidth(item.name)

                if item.icons then
                    if able then
                        Draw.setColor(1, 1, 1)
                    end

                    for _, icon in ipairs(item.icons) do
                        if type(icon) == "string" then
                            icon = {icon, false, 0, 0, nil}
                        end
                        if icon[2] then
                            local texture = Assets.getTexture(icon[1])
                            Draw.draw(texture, text_offset + 30 + (x * 230) + (icon[3] or 0), 50 + (y * 30) + (icon[4] or 0))
                            text_offset = text_offset + (icon[5] or texture:getWidth())
                        end
                    end
                end

                if x == 0 then
                    x = 1
                else
                    x = 0
                    y = y + 1
                end
            end

            -- Print information about currently selected item
            local tp_offset, _ = 0, nil --initialize placeholdder variable so it doenst go in global scope
            local current_item = Game.battle.menu_items[Game.battle:getItemIndex()]
            if current_item.description then
                Draw.setColor(COLORS.gray)
                love.graphics.print(current_item.description, 260 + 240, 50)
                Draw.setColor(1, 1, 1, 1)
                _, tp_offset = current_item.description:gsub('\n', '\n')
                tp_offset = tp_offset + 1
            end
    -------------------------------------------------------------------------------------------------------------
            --local battler = Game.battle.party[Game.battle.current_selecting]
            --print(current_item.resource)

            if current_item.tp and current_item.tp ~= 0 and current_item.resource == ("tension") then
                Draw.setColor(PALETTE["tension_desc"])
                love.graphics.print(math.floor((current_item.tp / Game:getMaxTension()) * 100) .. "% "..Game:getConfig("tpName"), 260 + 240, 50 + (tp_offset * 32))
                Game:setTensionPreview(current_item.tp)
            else
                if current_item.mp and current_item.mp ~= 0 and current_item.resource == "mana" then
                    local text_offset = 0
                    Draw.setColor(ManaHealthResources.PALETTE["mana_desc"])
                    love.graphics.print(current_item.mp .. " MP", text_offset + 260 + 240, 50 + (tp_offset * 32))
                elseif current_item.hp and current_item.hp ~= 0 and current_item.resource == "health" then
                    Draw.setColor(ManaHealthResources.PALETTE["health_cost_desc"])
                    love.graphics.print(current_item.hp .. " HP", 260 + 240, 50 + (tp_offset * 32))
                end
                Game:setTensionPreview(0)
            end
    -------------------------------------------------------------------------------------------------------------
            Draw.setColor(1, 1, 1, 1)
            if page < max_page then
                Draw.draw(self.arrow_sprite, 470, 120 + (math.sin(Kristal.getTime()*6) * 2))
            end
            if page > 0 then
                Draw.draw(self.arrow_sprite, 470, 70 - (math.sin(Kristal.getTime()*6) * 2), 0, 1, -1)
            end

        else
            orig(self)
        end
    end)

    HookSystem.hook(Battle, "onVictory", function (orig, self)
        orig(self)
        for index, battler in ipairs(self.party) do
            if not Kristal.getLibConfig("ManaHealthResources", "keep_negative_mana") and battler.chara:getMana() < 0 then
                battler.chara:setMana(0)
            end
        end
    end)
end

function Lib:postInit(new_save)
    if new_save then
        for id,data in pairs(Game.party_data) do
            if not data.stats["mana"] then
                data.stats["mana"] = 0
            end
            if not data.lw_stats["mana"] then
                data.lw_stats["mana"] = 0
            end
        end
    end
end

--VERY ad-hoc function to make outlines on text. Use it within the creation of a canvas.
---@param text string|table     # A text string, or table of color-formatted text.
---@param x? number             # The position on the x-axis.
---@param y? number             # The position on the y-axis.
function Lib:getOutlineDraft(text, x, y)
    x, y = x or 0, y or 0


    love.graphics.print(text, x, y - 1)     --up            ↑
    love.graphics.print(text, x + 1, y - 1) --up right      ↗
    love.graphics.print(text, x + 1, y)     --right         →
    love.graphics.print(text, x + 1, y + 1) --down right    ↘
    love.graphics.print(text, x, y + 1)     --down          ↓
    love.graphics.print(text, x - 1, y + 1) --down left     ↙
    love.graphics.print(text, x - 1, y)     --left          ←
    love.graphics.print(text, x - 1, y - 1) --up left       ↖

end

return Lib