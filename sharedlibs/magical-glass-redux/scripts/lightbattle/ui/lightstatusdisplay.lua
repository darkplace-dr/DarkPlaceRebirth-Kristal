local LightStatusDisplay, super = Class(Object, "LightStatusDisplay")

function LightStatusDisplay:init(x, y, event)
    super.init(self, x, y, SCREEN_WIDTH + 1, 43)
    
    self.event = event
end

function LightStatusDisplay:getHPGaugeLengthCap()
    return Kristal.getLibConfig("magical-glass", "hp_gauge_length_cap")
end

function LightStatusDisplay:draw()
    if self.event and Game.battle.party[1] then
        self:drawStatusStripEvent()
    else
        self:drawStatusStrip()
    end
end

function LightStatusDisplay:drawStatusStripEvent()
    local x, y = 200, 10
    
    local karma_mode = Game.battle.encounter.karma_mode
    local karma_mode_offset = karma_mode and 20 or 0
    
    local level = Game:isLight() and Game.battle.party[1].chara:getLightLV() or Game.battle.party[1].chara:getLevel()
    local level_name = Game:isLight() and Kristal.getLibConfig("magical-glass", "light_level_name_short") or Kristal.getLibConfig("magical-glass", "light_level_name_dark")

    local font = Assets.getFont("namelv", 24)
    love.graphics.setFont(font)
    love.graphics.setColor(MG_PALETTE["player_text"])
    local lenght = font:getWidth(level_name) - 30
    if font:getWidth(level) > 30 then
        lenght = lenght + font:getWidth(level) - 30
    end
    love.graphics.print(level_name.." "..level, x - karma_mode_offset - lenght, y)

    love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 74 - karma_mode_offset, y + 5)

    local max = Game.battle.party[1].chara:getStat("health")
    local current = Game.battle.party[1].chara:getHealth()
    local karma = Game.battle.party[1].karma
    
    local limit = self:getHPGaugeLengthCap()
    if limit == true then
        limit = 99
    end
    local size = max
    if limit and size > limit then
        size = limit
        limit = true
    end
    
    if karma_mode then
        love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 110 + size * 1.2 + 1 + 9 - karma_mode_offset, y + 5)
    end

    love.graphics.setColor(Game:isLight() and (karma_mode and MG_PALETTE["player_karma_health_bg"] or MG_PALETTE["player_health_bg"]) or MG_PALETTE["player_health_bg_dark"])
    love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, size * 1.2 + 1, 21)
    if current > 0 then
        love.graphics.setColor(Game:isLight() and MG_PALETTE["player_karma_health"] or MG_PALETTE["player_karma_health_dark"])
        love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1), 21)
        love.graphics.setColor(Game:isLight() and MG_PALETTE["player_health"] or {Game.battle.party[1].chara:getColor()})
        love.graphics.rectangle("fill", x + 110 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1) - (karma_mode and 1 or 0), 21)
    end

    if max < 10 and max >= 0 then
        max = "0" .. tostring(max)
    end

    if current < 10 and current >= 0 then
        current = "0" .. tostring(current)
    end

    local color = MG_PALETTE["player_text"]
    if not Game.battle.party[1].is_down then
        if Game.battle.party[1].sleeping then
            color = MG_PALETTE["player_sleeping_text"]
        elseif Game.battle:getActionBy(Game.battle.party[1]) and Game.battle:getActionBy(Game.battle.party[1]).action == "DEFEND" then
            color = MG_PALETTE["player_defending_text"]
        elseif karma > 0 then
            color = MG_PALETTE["player_karma_text"]
        end
    end
    
    if Game.battle.hp_display then current = Game.battle.hp_display end
    if Game.battle.max_hp_display then max = Game.battle.max_hp_display end
    
    love.graphics.setColor(color)
    love.graphics.print(current .. " / " .. max, x + 115 + size * 1.2 + 1 + 14 + (karma_mode and Assets.getTexture("ui/lightbattle/kr"):getWidth() + 12 or 0) - karma_mode_offset, y)
end

function LightStatusDisplay:drawStatusStrip()
    for index,battler in ipairs(Game.battle.party) do
        if not Game.battle.multi_mode then
            local x, y = 30, 10
            
            local karma_mode = Game.battle.encounter.karma_mode
            local karma_mode_offset = karma_mode and 20 or 0
            
            local name = battler.chara:getName()
            local level = Game:isLight() and battler.chara:getLightLV() or battler.chara:getLevel()
            
            local current = battler.chara:getHealth()
            local max = battler.chara:getStat("health")
            local karma = battler.karma

            love.graphics.setFont(Assets.getFont("namelv", 24))
            love.graphics.setColor(MG_PALETTE["player_text"])
            love.graphics.print(name .. "   "..(Game:isLight() and Kristal.getLibConfig("magical-glass", "light_level_name_short") or Kristal.getLibConfig("magical-glass", "light_level_name_dark")).." " .. level, x, y)
            
            love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 214 - karma_mode_offset, y + 5)
            
            local limit = self:getHPGaugeLengthCap()
            if limit == true then
                limit = 99
            end
            local size = max
            if limit and size > limit then
                size = limit
                limit = true
            end
            
            if karma_mode then
                love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 245 + size * 1.2 + 1 + 9 - karma_mode_offset, y + 5)
            end

            love.graphics.setColor(Game:isLight() and (karma_mode and MG_PALETTE["player_karma_health_bg"] or MG_PALETTE["player_health_bg"]) or MG_PALETTE["player_health_bg_dark"])
            love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, size * 1.2 + 1, 21)
            if current > 0 then
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_karma_health"] or MG_PALETTE["player_karma_health_dark"])
                love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1), 21)
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_health"] or {battler.chara:getColor()})
                love.graphics.rectangle("fill", x + 245 - karma_mode_offset, y, (limit == true and math.ceil((Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) / max) * size) * 1.2 + 1 or Utils.clamp(current - karma, 0, max + (karma_mode and 5 or 10)) * 1.2 + 1) - (karma_mode and 1 or 0), 21)
            end

            if max < 10 and max >= 0 then
                max = "0" .. tostring(max)
            end

            if current < 10 and current >= 0 then
                current = "0" .. tostring(current)
            end

            local color = MG_PALETTE["player_text"]
            if not battler.is_down then
                if battler.sleeping then
                    color = MG_PALETTE["player_sleeping_text"]
                elseif Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "DEFEND" then
                    color = MG_PALETTE["player_defending_text"]
                elseif karma > 0 then
                    color = MG_PALETTE["player_karma_text"]
                end
            end
            
            if Game.battle.hp_display then current = Game.battle.hp_display end
            if Game.battle.max_hp_display then max = Game.battle.max_hp_display end
            
            love.graphics.setColor(color)
            love.graphics.print(current .. " / " .. max, x + 245 + size * 1.2 + 1 + 14 + (karma_mode and Assets.getTexture("ui/lightbattle/kr"):getWidth() + 12 or 0) - karma_mode_offset, y)
        else
            local x, y = 22 + (3 - #Game.battle.party - (#Game.battle.party == 2 and 0.4 or 0)) * 102 + (index - 1) * 102 * 2 * (#Game.battle.party == 2 and (1 + 0.4) or 1), 10
            if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                x, y = 41 + (3 - #Game.battle.party - (#Game.battle.party == 2 and 0 or 0)) * 102 + (index - 1) * 95 * 2 * (#Game.battle.party == 2 and (1) or 1), 10
            end
            
            local name = battler.chara:getShortName()
            local level = Game:isLight() and battler.chara:getLightLV() or battler.chara:getLevel()
            
            local current = battler.chara:getHealth()
            local max = battler.chara:getStat("health")
            local karma = battler.karma
            
            if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                if Game.battle.current_selecting == index then
                love.graphics.setFont(Assets.getFont("namelv", 16))
                love.graphics.setColor(MG_PALETTE["player_text"])
                love.graphics.print(name, x+9, y+2)
                else
                love.graphics.setFont(Assets.getFont("namelv", 16))
                love.graphics.setColor(MG_PALETTE["player_text"])
                love.graphics.print(name, x+9, y-4)
                end
            else
                love.graphics.draw(Assets.getTexture("ui/lightbattle/hp"), x + 66, y + 15)
                love.graphics.setFont(Assets.getFont("namelv", 24))
                love.graphics.setColor(MG_PALETTE["player_text"])
                love.graphics.print(name, x, y - 7)
                love.graphics.setFont(Assets.getFont("namelv", 16))
                love.graphics.print((Game:isLight() and Kristal.getLibConfig("magical-glass", "light_level_name_short") or Kristal.getLibConfig("magical-glass", "light_level_name_dark")).." " .. level, x, y + 13)
            end
            
            local small = false
            for _,party in ipairs(Game.battle.party) do
                if party.chara:getStat("health") >= 100 then
                    small = true
                end
            end
            
            local karma_mode = Game.battle.encounter.karma_mode
            if karma_mode then
                love.graphics.draw(Assets.getTexture("ui/lightbattle/kr"), x + 95 + (small and 20 or 32) * 1.2 + 1, y + 15)
            end

            if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
            if current > 0 then
                if Game.battle.current_selecting == index then
                love.graphics.setColor(Game:isLight() and (MG_PALETTE["player_health_bg"]) or MG_PALETTE["player_health_bg_dark"])
                love.graphics.rectangle("fill", x + 72, y+5, (small and 20 or 28) * 1.2 + 1, 9)
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_health"] or {battler.chara:getColor()})
                love.graphics.rectangle("fill", x + 72, y+5, math.ceil((Utils.clamp(current, 0, max) / max) * (small and 20 or 28)) * 1.2 + 1, 9)
                else
                love.graphics.setColor(Game:isLight() and (MG_PALETTE["player_health_bg"]) or MG_PALETTE["player_health_bg_dark"])
                love.graphics.rectangle("fill", x + 72, y-1, (small and 20 or 28) * 1.2 + 1, 9)
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_health"] or {battler.chara:getColor()})
                love.graphics.rectangle("fill", x + 72, y-1, math.ceil((Utils.clamp(current, 0, max) / max) * (small and 20 or 28)) * 1.2 + 1, 9)
                end
            end
        else
            love.graphics.setColor(Game:isLight() and (karma_mode and MG_PALETTE["player_karma_health_bg"] or MG_PALETTE["player_health_bg"]) or MG_PALETTE["player_health_bg_dark"])
            love.graphics.rectangle("fill", x + 92, y, (small and 20 or 32) * 1.2 + 1, 21)
            if current > 0 then
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_karma_health"] or MG_PALETTE["player_karma_health_dark"])
                love.graphics.rectangle("fill", x + 92, y, math.ceil((Utils.clamp(current, 0, max) / max) * (small and 20 or 32)) * 1.2 + 1, 21)
                love.graphics.setColor(Game:isLight() and MG_PALETTE["player_health"] or {battler.chara:getColor()})
                love.graphics.rectangle("fill", x + 92, y, math.ceil((Utils.clamp(current - karma, 0, max) / max) * (small and 20 or 32)) * 1.2 + 1 - (karma_mode and 1 or 0), 21)
            end
        end
            
            love.graphics.setFont(Assets.getFont("namelv", 16))
            if max < 10 and max >= 0 then
                max = "0" .. tostring(max)
            end

            if current < 10 and current >= 0 then
                current = "0" .. tostring(current)
            end
            
            local color = MG_PALETTE["player_text"]
            if battler.is_down then
                color = MG_PALETTE["player_down_text"]
            elseif battler.sleeping then
                color = MG_PALETTE["player_sleeping_text"]
            elseif Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "DEFEND" then
                color = MG_PALETTE["player_defending_text"]
            elseif Game.battle:getActionBy(battler) and Utils.containsValue({"ACTIONSELECT", "MENUSELECT", "ENEMYSELECT", "PARTYSELECT"}, Game.battle:getState()) and Game.battle:getActionBy(battler).action ~= "AUTOATTACK" then
                color = MG_PALETTE["player_action_text"]
            elseif karma > 0 then
                color = MG_PALETTE["player_karma_text"]
            end
            love.graphics.setColor(color)
            if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                if Game.battle.current_selecting == index then
                    Draw.printAlign(current .. "/" .. max, x + 170, y + 3, "right")
                else
                    Draw.printAlign(current .. "/" .. max, x + 170, y - 3, "right")
                end
            else
                Draw.printAlign(current .. "/" .. max, x + 197, y + 3 - (karma_mode and 2 or 0), "right")
            end
            
            if Game.battle.current_selecting == index or DEBUG_RENDER and Input.alt() then
                love.graphics.setColor(battler.chara:getColor())
                if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                    if Game.battle.current_selecting == index then
                        love.graphics.setLineWidth(6)
                        love.graphics.rectangle("line", x, y - 12, 177, 35)
                    end
                else
                    love.graphics.setLineWidth(2)
                    love.graphics.rectangle("line", x - 3, y - 7, 201, 35)
                end
            else
                if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
                love.graphics.setColor(battler.chara:getColor())
                love.graphics.setLineWidth(6)
                love.graphics.rectangle("line", x, y - 18, 177, 35)
                end
            end
            
            if battler:isTargeted() and Game:getConfig("targetSystem") and Game.battle.state == "ENEMYDIALOGUE" then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setLineWidth(2)
                local function target_text_area()
                    love.graphics.rectangle("fill", x + 1, y - 9, 25, 4)
                end
                love.graphics.stencil(target_text_area, "replace", 1)
                love.graphics.setStencilTest("equal", 0)
                if math.floor(Kristal.getTime() * 3) % 2 == 0 then
                    love.graphics.rectangle("line", x - 3, y - 7, 201, 35)
                else
                    love.graphics.rectangle("line", x - 2, y - 6, 199, 33)
                end
                love.graphics.setStencilTest()
                love.graphics.draw(Assets.getTexture("ui/lightbattle/chartarget"), x + 2, y - 9)
            end
        end
    end
end

return LightStatusDisplay