local ShuttahSnapAct, super = Class(Object)

function ShuttahSnapAct:init(enemy, time, miss_add, success_add, miniboss_encounter)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.draw_children_below = -1
    self.draw_children_above = -1
    self.alpha = 0

    self.enemy = enemy
    self.total_time = time * 30
    self.miss_add = miss_add
    self.success_add = success_add

    self.instruction_time = 0
    self.start_transition_time = 0
    self.elapsed_time = 0
    self.pause_time = 0
    self.end_transition_time = 0

    -- Possible states: "INSTRUCTION", "START", "ACTION", "PAUSE", "END"
    self.state = "START"

    self.clock_sprite = Sprite('ui/clock', 200, 295)
    self.clock_sprite:setOrigin(0.5, 0.5)
    self.clock_sprite:setScale(2, 2)
    self.clock_sprite.inherit_color = true
    self:addChild(self.clock_sprite)

    -- if self.enemy.last_challenge and self.enemy.last_challenge_fail then self.challenge = self.enemy.last_challenge
    -- else self.challenge = Utils.pick({'SMILE', 'LANCER', 'RALSEI'}) end
    self.challenge = Utils.pick({'SMILE', 'LANCER', 'RALSEI'})
    self.challenge_controller = nil

    self.fade_to_started = false
    self.pause_text_set = false
    self.pause_text_advanced = false
    self.last_success = false

    self.camera_frame = nil
    self.photo = nil
    self.text = nil

    self.party_original_x = {}
    self.enemy_original_x = {}

    if self.challenge == 'RALSEI' then
        self:setText("* Take a photo of Ralsei!")
    elseif self.challenge == 'LANCER' then
        self:setText("* Take a photo of Lancer's\ntongue!")
    elseif self.challenge == 'SMILE' then
        self:setText("* Take a photo of Shuttah's\nSmile!")
    end
end

function ShuttahSnapAct:handleChallengeInit()
    if self.challenge == 'RALSEI' then
        self.challenge_controller = RalseiChallengeController()
    elseif self.challenge == 'LANCER' then
        self.challenge_controller = LancerChallengeController()
    elseif self.challenge == 'SMILE' then
        self.challenge_controller = SmileChallengeController()
    end
    self.challenge_controller.layer = -2
    self:addChild(self.challenge_controller)
end

function ShuttahSnapAct:handleChallengeDone()
    if self.challenge_controller then
        self.challenge_controller:remove()
    end
end

function ShuttahSnapAct:resetBattlerPositions()
    for _, battler in ipairs(Game.battle.party) do
        battler.physics.move_target = nil
    end

    for _, battler in ipairs(Game.battle.enemies) do
        battler.physics.move_target = nil
    end
    
    for index, battler in ipairs(Game.battle.party) do
        battler.x = self.party_original_x[index]
    end

    for index, battler in ipairs(Game.battle.enemies) do
        battler.x = self.enemy_original_x[index]
    end
end

function ShuttahSnapAct:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function ShuttahSnapAct:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function ShuttahSnapAct:canAdvancePause()
    return self.pause_text_advanced and
           ((self.pause_time > 20 and Input.pressed("confirm")) or not self.photo)
end

function ShuttahSnapAct:canAdvanceEnd()
    return (self.photo and self.end_transition_time > 20) or
            not self.photo
end

function ShuttahSnapAct:update()
    if self.state == "INSTRUCTION" then
        self.instruction_time = self.instruction_time + DTMULT
    elseif self.state == "START" then
        self.start_transition_time = self.start_transition_time + DTMULT
    elseif self.state == "ACTION" then
        self.elapsed_time = self.elapsed_time + DTMULT
    elseif self.state == "PAUSE" then
        self.pause_time = self.pause_time + DTMULT
    elseif self.state == "END" then
        self.end_transition_time = self.end_transition_time + DTMULT
    end

    if self.start_transition_time > 2 and not self.fade_to_started then
        self.fade_to_started = true
        self:fadeTo(1, 10/30)
        self:handleChallengeInit()
    end

    if self.elapsed_time > 0 and not self.camera_frame then
        self:fadeTo(1, 10/30)
        local x, y = self.challenge_controller:getCameraSpawn()
        self.camera_frame = CameraFrame(x, y)
        self.camera_frame.layer = -2
        self:addChild(self.camera_frame)
        self.challenge_controller.camera_collider = self.camera_frame.collider
    end

    -- if self.state == "INSTRUCTION" and Input.pressed("confirm") and self.instruction_time > 1 then
    --     self.state = "START"
    --     if not Game.battle.battle_ui.encounter_text:isTyping() then
    --         self:setText("[instant]* Press directions to aim!\n* Press [bind:confirm] to take the photo!")
    --     end
    --     for _, battler in ipairs(Game.battle.party) do
    --         table.insert(self.party_original_x, battler.x)
    --         battler:slideToSpeed(battler.x - 320, battler.y, 10)
    --     end

    --     for _, battler in ipairs(Game.battle.enemies) do
    --         table.insert(self.enemy_original_x, battler.x)
    --         battler:slideToSpeed(battler.x + 320, battler.y, 10)
    --     end
    if self.state == "START" and self.start_transition_time > 12 then
        self.state = "ACTION"
        if not Game.battle.battle_ui.encounter_text:isTyping() then
            self:setText("[instant]* Press directions to aim!\n* Press [bind:confirm] to take the photo!")
        end
        for _, battler in ipairs(Game.battle.party) do
            table.insert(self.party_original_x, battler.x)
            battler:slideToSpeed(battler.x - 320, battler.y, 24)
        end

        for _, battler in ipairs(Game.battle.enemies) do
            table.insert(self.enemy_original_x, battler.x)
            battler:slideToSpeed(battler.x + 320, battler.y, 24)
        end
    elseif self.state == "ACTION" and self.elapsed_time > self.total_time then
        self.state = "PAUSE"
    elseif self.state == "PAUSE" and self:canAdvancePause() then
        self.state = "END"
        self:clearText()
    elseif self.state == "END" and self:canAdvanceEnd() then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end

    if self.state == "ACTION" and self.camera_frame and self.camera_frame.snapped then
        local white_overlay = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        white_overlay:setColor(COLORS.white)
        white_overlay:setLayer(BATTLE_LAYERS["top"])
        white_overlay:fadeOutAndRemove(12/30)
        Game.battle:addChild(white_overlay)

        local camera_frame = self.camera_frame
        local width, height = camera_frame.target_width, camera_frame.target_height
        local x, y = camera_frame.x - width / 2, camera_frame.y - height / 2
        self.photo = ResultPhoto(camera_frame.canvas, camera_frame.border_on, x, y, width, height)
        self:addChild(self.photo)

        self.alpha = 0
        self.state = "PAUSE"

        local success = self.challenge_controller:checkSuccessFinal()

        if success then
            local text = {
                "* Good, good, EYE approve!",
                "* Confidence, baby, CONFIDENCE!"
            }
            self:setText(Utils.pick(text), true)
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:addMercy(self.success_add)
            end

            self.text = Text("[color:#ffff00]Great shot!", 380, 200)
            self.text:addFX(OutlineFX(COLORS.black, { thickness = 2 }))
            self.text:setScale(0.5)
            self:addChild(self.text)
            self.enemy.last_challenge = self.challenge
            self.enemy.last_challenge_fail = false
        else
            self:setText("* That's okay, baby! Give it another SSSHOT!", true)
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:addMercy(self.miss_add)
            end
            self.enemy.last_challenge = self.challenge
            self.enemy.last_challenge_fail = true
        end
        self:handleChallengeDone()
        self:resetBattlerPositions()
    end

    if self.state == "PAUSE" and not self.photo and not self.pause_text_set then
        self.pause_text_set = true
        self.camera_frame:remove()
        Assets.playSound('error')
        self:handleChallengeDone()
        self:resetBattlerPositions()
        self:setText("* UUMM!! Maybe actually press [bind:confirm] to take a photo next time?", true)
        self.enemy.last_challenge = self.challenge
        self.enemy.last_challenge_fail = true
    end

    if self.state == "PAUSE" and self.text then
        self.text.y = Utils.ease(280, 230, (self.pause_time - 15) / 10, 'outBack')
        self.text.alpha = Utils.lerp(0, 1, (self.pause_time - 15) / 8 )
    end

    if self.state == "PAUSE" and not Game.battle.battle_ui.encounter_text:isTyping() and Input.pressed("confirm") then
        self.pause_text_advanced = true
    end

    if self.state == "END" and self.photo then
        self.photo:moveDown()
    end

    if self.state == "END" and self.text then
        self.text:remove()
    end

    if self.camera_frame then
        local success = self.challenge_controller:checkSuccessAction()
        if self.last_success ~= success then Assets.playSound('ui_move') end
        self.last_success = success
        self.camera_frame:setReticleGreen(success)
    end
    
    -- Debug code
    -- if Input.down("1")  then self.elapsed_time = -999 * 30 end
    -- if Input.down("0")  then self.elapsed_time = self.total_time end

    super.update(self)
end

function ShuttahSnapAct:drawBar()
    Draw.setColor(1/2, 1, 1, self.alpha)
    love.graphics.setLineWidth(10)
    local line_length = 180 * (1 - Utils.clamp(self.elapsed_time / self.total_time, 0, 1))
    love.graphics.line(200, 295, 200 + line_length, 295)
end

function ShuttahSnapAct:draw()
    super.draw(self)

    if Utils.containsValue({"INSTRUCTION", "START", "ACTION"}, self.state) then self:drawBar()
    else
        self.clock_sprite.alpha = 0
        if self.camera_frame and not self.camera_frame:isRemoved() then self.camera_frame:remove() end
    end
end

return ShuttahSnapAct