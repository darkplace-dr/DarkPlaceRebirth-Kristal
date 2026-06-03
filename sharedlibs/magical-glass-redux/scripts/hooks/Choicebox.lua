local Choicebox, super = HookSystem.hookScript(Choicebox)

function Choicebox:clearChoices()
    super.clearChoices(self)

    if Game.battle and Game.battle.light then
        for i = 1, 2 do
            Game.battle.battle_ui.choice_option[i]:setText("")
        end
        self.current_choice = 1
        Input.clear("confirm")
    end
end

function Choicebox:update()
    if Game.battle and Game.battle.light then
        local old_choice = self.current_choice
        if Input.pressed("left") or Input.pressed("right") then
            if self.current_choice == 1 then
                self.current_choice = 2
            else
                self.current_choice = 1
            end
        end

        if self.current_choice > #self.choices then
            self.current_choice = old_choice
        end

        if self.ui_sound ~= false and self.current_choice ~= old_choice then
            Game.battle.ui_move:stop()
            Game.battle.ui_move:play()
        end

        if Input.pressed("confirm") then
            if self.current_choice ~= 0 then
                self.selected_choice = self.current_choice

                self.done = true
                Game.battle:toggleSoul(false)

                if not self.battle_box then
                    self:remove()
                    if Game.world:hasCutscene() then
                        Game.world.cutscene.choice = self.selected_choice
                        Game.world.cutscene:tryResume()
                    end
                else
                    self:clearChoices()
                    self.active = false
                    self.visible = false
                    Game.battle.battle_ui.encounter_text.active = true
                    Game.battle.battle_ui.encounter_text.visible = true
                    if Game.battle:hasCutscene() then
                        Game.battle.cutscene.choice = self.selected_choice
                        Game.battle.cutscene:tryResume()
                    end
                end
            end
        end

        Object.update(self)
    else
        super.update(self)
    end
end

function Choicebox:draw()
    if Game.battle and Game.battle.light then
        Object.draw(self)

        love.graphics.setFont(self.font)
        if self.choices[1] then
            Game.battle.battle_ui.choice_option[1]:setPosition(48, 30 - (select(2, string.gsub(self.choices[1], "\n", "")) >= 2 and self.font:getHeight() or 0))
            Game.battle.battle_ui.choice_option[1]:setText("[shake:" .. Mod.libs["magical-glass"].light_battle_shake_text .. "]" .. self.choices[1])
        end
        if self.choices[2] then
            Game.battle.battle_ui.choice_option[2]:setPosition(304, 30 - (select(2, string.gsub(self.choices[2], "\n", "")) >= 2 and self.font:getHeight() or 0))
            Game.battle.battle_ui.choice_option[2]:setText("[shake:" .. Mod.libs["magical-glass"].light_battle_shake_text .. "]" .. self.choices[2])
        end

        local soul_positions = {
            --[[ Left:   ]] {80, 318},
            --[[ Right:  ]] {340, 318},
        }

        local arena_ox, arena_oy = Game.battle.arena:getOffset()
        
        local heart_x = arena_ox + soul_positions[self.current_choice][1]
        local heart_y = arena_oy + soul_positions[self.current_choice][2]

        Game.battle:toggleSoul(true)
        Game.battle.soul:setPosition(heart_x, heart_y)
    else
        super.draw(self)
    end
end

return Choicebox