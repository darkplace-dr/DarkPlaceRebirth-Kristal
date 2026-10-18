local ScissorsActController, super = Class(Object)

function ScissorsActController:init(enemy)
    super.init(self)

    self.enemy = enemy

    self.timer = 0
    self.con = 0
    self.failsafe_timer = 0
    self.type = 0
    self.acttimerstart = false
    self.acttimer = 0
    self.acttimermax = 390
    self.mercy = 0
    self.saloncut = self.enemy.saloncut or false
    self.valuecut = self.enemy.valuecut or false
    self.hypercut = self.enemy.hypercut or false

    self.cuttextcon = 0
    self.cuttexttimer = 30
    self.truancy = false

    self.finished = false

    if Game:getFlag("scissors_act_uses", 0) == 1 then
        self.type = 1
    elseif Game:getFlag("scissors_act_uses", 0) == 2 then
        self.type = 2
    elseif Game:getFlag("scissors_act_uses", 0) > 2 then
        self.type = TableUtils.pick({ 0, 1, 2 })
    end

    if self.hypercut then
        self.acttimermax = 260
    elseif self.valuecut then
        self.acttimermax = 390
    elseif self.saloncut then
        self.acttimermax = 460
    end

    if self.type == 1 and (self.valuecut or self.hypercut) then
        self.acttimermax = self.acttimermax + 40
    end

    Game:addFlag("scissors_act_uses", 1)

    self:nodesSetup()

    self:setText("* Press the directions to CUT on the dotted line!", true)
end

function ScissorsActController:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function ScissorsActController:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function ScissorsActController:nodesSetup()
    if self.type == 0 then
        Game.battle:addChild(ScissorsActPlayer(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 2, self))
        local a = 0
        for _ = 1, 10 do
            Game.battle:addChild(ScissorsActNodeSmall(320 + MathUtils.lengthDirX(73, math.rad(36 * a)), MathUtils.lengthDirY(73, math.rad(36 * a)) + 171, self))
            a = a + 1
        end
    elseif self.type == 1 then
        Game.battle:addChild(ScissorsActPlayer(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 12, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 58, 170 + 59, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 30, 170 + 59, self))
        Game.battle:addChild(ScissorsActNodeSmall(320, 170 + 59, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 30, 170 + 59, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 58, 170 + 59, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 58, 170 - 58, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 30, 170 - 58, self))
        Game.battle:addChild(ScissorsActNodeSmall(320, 170 - 58, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 30, 170 - 58, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 58, 170 - 58, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 58, 170 - 30, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 58, 170, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 58, 170  + 30, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 58, 170 - 30, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 58, 170, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 58, 170 + 30, self))
    elseif self.type == 2 then
        Game.battle:addChild(ScissorsActPlayer(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 2, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 60, 170 + 75, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 30, 170 + 75, self))
        Game.battle:addChild(ScissorsActNodeSmall(320, 170 + 75, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 30, 170 + 75, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 60, 170 + 75, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 45, 170 + 53, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 45, 170 + 53, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 25, 170 + 35, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 25, 170 + 35, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 30, 170 + 10, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 30, 170 + 10, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 45, 170 - 10, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 48, 170 - 10, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 45, 170 - 38, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 53, 170 - 38, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 - 26, 170 - 64, self))
        Game.battle:addChild(ScissorsActNodeSmall(320 + 31, 170 - 64, self))
        Game.battle:addChild(ScissorsActNodeSmall(320, 170 - 71, self))
    end
end

function ScissorsActController:setActSprites()
    for _, battler in ipairs(Game.battle.party) do
        if battler.chara.id == "kris" then
            battler:setActSprite("party/kris/dark/papersnow_done", -2, -1)
        elseif battler.chara.id == "susie" then
            battler:setActSprite("party/susie/dark/papersnow_done", -3 + 5, -1 + 2)
        elseif battler.chara.id == "ralsei" then
            battler:setActSprite("party/ralsei/dark/papersnow_done", -2, -6 + 6)
        end
    end
end

function ScissorsActController:finish(truancy)
    self.finished = true
    self:cleanUp()
    self:result()
end

function ScissorsActController:cleanUp()
    local scissors = Game.stage:getObjects(ScissorsActPlayer)
    for _, scissor in ipairs(scissors) do
        scissor:remove()
    end

    local lines = Game.stage:getObjects(ScissorsLine)
    for _, line in ipairs(lines) do
        line.con = 1
    end

    local nodes_small = Game.stage:getObjects(ScissorsActNodeSmall)
    for _, node in ipairs(nodes_small) do
        if node.con == 1 then
            if self.type == 0 then
                self.mercy = self.mercy + 3
            elseif self.type == 1 then
                self.mercy = self.mercy + 2.5
            elseif self.type == 2 then
                self.mercy = self.mercy + 2
            end
        end
        node:remove()
    end

    local nodes_big = Game.stage:getObjects(ScissorsActNodeBig)
    for _, node in ipairs(nodes_big) do
        if node.con == 1 then
            if self.type == 0 then
                self.mercy = self.mercy + 7
            elseif self.type == 1 then
                self.mercy = self.mercy + 4
            elseif self.type == 2 then
                self.mercy = self.mercy + 4
            end
        end
        node:remove()
    end

    self.mercy = MathUtils.round(self.mercy)
    if self.mercy == 99 then
        self.mercy = 100
    end
    if self.mercy > 100 then
        self.mercy = 100
    end
    if self.hypercut and self.mercy < 25 then
        self.mercy = 25
    end
    if self.hypercut and self.mercy > 99 then
        self.mercy = 99
    end

    Game.battle:addChild(CutText(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 120))
end

function ScissorsActController:result()
    if not self.truancy then
        self.enemy:addMercy(self.mercy)
    end
    if self.truancy then
        self:setText("* Truancy.\n* Failure.", true)
    elseif self.mercy < 40 then
        self:setText("* Arts and crafts failure!", true)
    elseif self.mercy >= 40 and self.mercy < 80 then
        self:setText("* Not bad!", true)
    elseif self.mercy >= 80 and self.mercy < 94 then
        self:setText("* Great job!", true)
    elseif self.mercy >= 94 then
        if self.saloncut then
            self:setActSprites()
        end
        self:setText("* Amazing cutting skills!!!", true)
    end
end

function ScissorsActController:update()
    if self.finished and not Game.battle.battle_ui.encounter_text:isTyping() and (Input.pressed("confirm") or Input.down("menu")) then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end

    super.update(self)
end

function ScissorsActController:draw()
    self.failsafe_timer = self.failsafe_timer + DTMULT
    if self.failsafe_timer >= 900 then
        self.acttimerstart = true
    end

    if self.acttimerstart then
        self.acttimer = self.acttimer + DTMULT
    end

    if self.acttimer >= self.acttimermax and not self.finished then
        self:finish()
    end

    if not self.finished then
        Draw.setColor(ColorUtils.unpackColor(COLORS.white))
        if self.type == 0 then
            Draw.draw(Assets.getTexture("ui/battle/cut/circle"), 320, 170, 0, 2, 2, 37, 37)
        elseif self.type == 1 then
            Draw.draw(Assets.getTexture("ui/battle/cut/square"), 320 - 2, 170 - 19, 0, 2, 2, 29, 20)
        elseif self.type == 2 then
            Draw.draw(Assets.getTexture("ui/battle/cut/lock"), 320, 170, 0, 2, 2, 37, 37)
        end

        Draw.draw(Assets.getTexture("ui/clock"), 240, 295, 0, 2, 2, 9, 9)
        Draw.setColor(ColorUtils.unpackColor(COLORS.aqua))
        Draw.rectangle("fill", 258, 290, MathUtils.lerp(140, 0, self.acttimer / self.acttimermax), 300 - 290 + 1)
    end

    super.draw(self)
end

return ScissorsActController
