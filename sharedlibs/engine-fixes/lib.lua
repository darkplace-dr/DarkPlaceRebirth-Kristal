local lib = {}

function lib:save(data)
    data.calls = Game.world.calls
end

function lib:load(data, new_file)
    Game.world.calls = {}
    if data.calls then
        Game.world.calls = data.calls
    end
end

function lib:init()
    Utils.hook(EnemyBattler, "init", function(orig, self, actor, use_overlay)
        orig(self, actor, use_overlay)
        
        self.show_hp = true
    end)
    
    Utils.hook(EnemyBattler, "setTired", function(orig, self, bool)
        local old_tired = self.tired
        self.tired = bool
        if self.tired then
            self.comment = "(Tired)"
            if not old_tired and Game:getConfig("tiredMessages") and self.health > 0 then
                -- Check for self.parent so setting Tired state in init doesn't crash
                if self.parent then
                    self:statusMessage("msg", "tired")
                    Assets.playSound("spellcast", 0.5, 0.9)
                end
            end
        else
            self.comment = ""
            if old_tired and Game:getConfig("awakeMessages") and self.health > 0 then
                if self.parent then self:statusMessage("msg", "awake") end
            end
        end
    end)
    
    Utils.hook(EnemyBattler, "getHPVisibility", function(orig, self) return self.show_hp end)
    
    Utils.hook(EnemyBattler, "defeat", function(orig, self, reason, violent)
        orig(self, reason, violent)
        
        if not violent then
            Game.battle.xp = Game.battle.xp - self.experience
        end
    end)
    
    Utils.hook(PartyBattler, "hurt", function(orig, self, amount, exact, color, options)
        options = options or {}
        
        Game.battle:shakeCamera(4)

        local swoon = options["swoon"]

        if not options["all"] then
            Assets.playSound("hurt")
            if not exact then
                amount = self:calculateDamage(amount)
                if self.defending then
                    amount = math.ceil((2 * amount) / 3)
                end
                -- we don't have elements right now
                local element = 0
                amount = math.ceil((amount * self:getElementReduction(element)))
            end

            self:removeHealth(amount, swoon)
        else
            -- We're targeting everyone.
            if not exact then
                amount = self:calculateDamage(amount)
                -- we don't have elements right now
                local element = 0
                amount = math.ceil((amount * self:getElementReduction(element)))

                if self.defending then
                    amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
                end
            end

            self:removeHealthBroken(amount, swoon) -- Use a separate function for cleanliness
        end

        if (self.chara:getHealth() <= 0) then
            self:statusMessage("msg", swoon and "swoon" or "down", color, true)
        else
            self:statusMessage("damage", amount, color, true)
        end

        self.hurt_timer = 0

        if (not self.defending) and (not self.is_down) then
            self.sleeping = false
            self.hurting = true
            self:toggleOverlay(true)
            self.overlay_sprite:setAnimation("battle/hurt", function()
                if self.hurting then
                    self.hurting = false
                    self:toggleOverlay(false)
                end
            end)
            if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
                Game.battle.timer:after(0.5, function()
                    if self.hurting then
                        self.hurting = false
                        self:toggleOverlay(false)
                    end
                end)
            end
        end
    end)
    
    Utils.hook(World, "hurtParty", function(orig, self, battler, amount)
        Assets.playSound("hurt")

        self:shakeCamera()
        self:showHealthBars()

        if type(battler) == "number" then
            amount = battler
            battler = nil
        end

        local any_killed = false
        local any_alive = false
        for _,party in ipairs(Game.party) do
            if not battler or battler == party.id or battler == party then
                local current_health = party:getHealth()
                party:setHealth(party:getHealth() - amount)
                if party:getHealth() <= 0 then
                    party:setHealth(1)
                    any_killed = true
                else
                    any_alive = true
                end

                local dealt_amount = current_health - party:getHealth()

                if dealt_amount > 0 then
                    self:getPartyCharacterInParty(party):statusMessage("damage", dealt_amount)
                end
            elseif party:getHealth() > amount then
                any_alive = true
            end
        end

        if self.player then
            self.player.hurt_timer = 7
        end

        if any_killed and not any_alive then
            for _,party in ipairs(Game.party) do
                if party:getHealth() > 0 then
                    party:setHealth(0)
                end
            end
            self:shakeCamera(0)
            if not self.map:onGameOver() then
                Game:gameOver(self.soul:getScreenPos())
            end
            return true
        elseif battler then
            return any_killed
        end

        return false
    end)
    
    -- Replaces a phone call in the Light World CELL menu with another
    Utils.hook(World, "replaceCall", function(orig, self, replace_name, name, scene)
        for i,call in ipairs(self.calls) do
            if call[1] == replace_name then
                self.calls[i] = {name, scene}
                break
            end
        end
    end)
    
    -- Removes a phone call in the Light World CELL menu
    Utils.hook(World, "removeCall", function(orig, self, name)
        for i,call in ipairs(self.calls) do
            if call[1] == name then
                table.remove(self.calls, i)
                break
            end
        end
    end)
    
    -- Removes all the phone calls in the Light World CELL menu
    Utils.hook(World, "clearCalls", function(orig, self)
        self.calls = {}
    end)
    
    Utils.hook(Game, "gameOver", function(orig, self, x, y, redraw)
        if redraw or (redraw == nil and Game:isLight()) then
            love.draw() -- Redraw the frame so the screenshot will use an updated draw data
        end
        orig(self, x, y, redraw)
    end)
    
    Utils.hook(PartyMember, "init", function(orig, self)
        -- Message will show even if the member is the soul character
        self.force_gameover_message = false
        
        -- The number of times that this party member got stronger (saved to the save file)
        self.level_up_count = 0
        
        -- Battle soul position offset (optional)
        self.soul_offset = nil
        
        orig(self)
    end)
    
    Utils.hook(PartyMember, "getForceGameOverMessage", function(orig, self)
        return self.force_gameover_message
    end)
    
    Utils.hook(PartyMember, "getSoulOffset", function(orig, self)
        return unpack(self.soul_offset or {0, 0})
    end)
    
    Utils.hook(Encounter, "getSoulSpawnLocation", function(orig, self)
        local main_chara = Game:getSoulPartyMember()

        if main_chara and main_chara:getSoulPriority() >= 0 then
            local battler = Game.battle.party[Game.battle:getPartyIndex(main_chara.id)]

            if battler then
                local offset_x, offset_y = main_chara:getSoulOffset()
                return battler:localToScreenPos(battler.sprite.width/2 - 4.5 + offset_x, battler.sprite.height/2 + offset_y)
            end
        end
        return -9, -9
    end)
    
    Utils.hook(PartyMember, "onSave", function(orig, self, data)
        orig(self, data)
        data["level_up_count"] = self.level_up_count
    end)
    
    Utils.hook(PartyMember, "onLoad", function(orig, self, data)
        orig(self, data)
        self.level_up_count = data.level_up_count or self.level_up_count
    end)
    
    Utils.hook(ActionBoxDisplay, "draw", function(orig, self) -- Fixes an issue with HP higher than normal + MGR Karma
        if #Game.battle.party <= 3 then
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

            Draw.setColor(MagicalGlassLib and Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() and (Game.battle.encounter.karma_mode and MG_PALETTE["player_karma_health_bg"] or MG_PALETTE["player_health_bg"]) or PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, 76, 9)

            local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * 76
            local karma_health
            if MagicalGlassLib then
                karma_health = ((self.actbox.battler.chara:getHealth() - self.actbox.battler.karma) / self.actbox.battler.chara:getStat("health")) * 76
            end

            if health > 0 then
                if MagicalGlassLib then
                    if Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() then
                        Draw.setColor(MG_PALETTE["player_karma_health"])
                    else
                        Draw.setColor(MG_PALETTE["player_karma_health_dark"])
                    end
                    love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.min(math.ceil(health), 76), 9)
                end
                if MagicalGlassLib and Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() then
                    Draw.setColor(MG_PALETTE["player_health"])
                else
                    Draw.setColor(self.actbox.battler.chara:getColor())
                end
                love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.min(math.ceil(MagicalGlassLib and (Game.battle.encounter.karma_mode and karma_health > 1 and (karma_health - 1) or karma_health) or health), 76), 9)
            end


            local color = PALETTE["action_health_text"]
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif MagicalGlassLib and self.actbox.battler.karma > 0 then
                color = MG_PALETTE["player_karma_text"]
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
        else
            orig(self)
        end
    end)
    
    Utils.hook(OverworldActionBox, "draw", function(orig, self) -- Fixes an issue with HP higher than normal
        if #Game.party > 3 then orig(self) return end
        
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
            love.graphics.rectangle("fill", 128, 24, math.min(math.ceil(health), 76), 9)
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
            local spacing = 5 - Utils.len(name)

            local off = 0
            for i = 1, Utils.len(name) do
                local letter = Utils.sub(name, i, i)
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
    end)
    
    Utils.hook(DebugSystem, "returnMenu", function(orig, self)
        orig(self)
        if not (#self.menu_history == 0) then
            self.menu_target_y = 0
        end
    end)
    
    Utils.hook(DebugSystem, "enterMenu", function(orig, self, menu, soul, skip_history)
        orig(self, menu, soul, skip_history)
        self.menu_target_y = 0
    end)
end

return lib