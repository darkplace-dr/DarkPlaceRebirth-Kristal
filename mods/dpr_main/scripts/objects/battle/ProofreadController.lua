local ProofreadController, super = Class(Object)

function ProofreadController:init(enemy, iseasy)
    super.init(self, 0, 0)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.enemy = enemy
    self.timer = 0
    self.colortimer = 0
    self.easy = iseasy or false
    self.movespeed = self.easy and 15 or 10
    self.acttimer = 0
    self.acttimermax = self.easy and 200 or 110
    self.rand = MathUtils.randomInt(1, 10) -- in Deltarune it's mistakingly set to (1, 9) so it makes 9 not a possible outcome lol
    self.rand2 = TableUtils.pick({1, 2})
    self.currentchoice = 1
    self.correctchoice = TableUtils.pick({1, 2, 3})
    self.font = Assets.getFont("main")
    self.wronglastcolor = "white"

    local str1
    local str2
    local str3
    if self.rand == 1 then
        str1 = "GALLERY"
        str2 = "GALLURY"
        str3 = "GALLORY"
    elseif self.rand == 2 then
        str1 = "ROOTS"
        str2 = "REETS"
        str3 = "RAATS"
    elseif self.rand == 3 then
        str1 = "FESTIVAL"
        str2 = "FESTIAVL"
        str3 = "FESTAVIL"
    elseif self.rand == 4 then
        str1 = "FLASHBACK"
        str2 = "FLESHBECK"
        str3 = "FLOSHBOCK"
    elseif self.rand == 5 then
        str1 = "SWORD"
        str2 = "SORWD"
        str3 = "SOWRD"
    elseif self.rand == 6 then
        str1 = "GUARDIAN"
        str2 = "GAURDIAN"
        str3 = "GAURDAIN"
    elseif self.rand == 7 then
        str1 = "ATRIUM"
        str2 = "ATRUIM"
        str3 = "ARTIUM"
    elseif self.rand == 8 then
        str1 = "SYNTHESIS"
        str2 = "SYNTEHSIS"
        str3 = "SINTHESIS"
    elseif self.rand == 9 then
        str1 = "AMPHITHEATER"
        str2 = "AMPITHEATER"
        str3 = "AMPITHEATRE"
    end
    if self.correctchoice == 1 then
        self.str1 = str1
        if self.rand2 == 1 then
            self.str2 = str2
            self.str3 = str3
        elseif self.rand2 == 2 then
            self.str2 = str3
            self.str3 = str2
        end
    elseif self.correctchoice == 2 then
        self.str2 = str1
        if self.rand2 == 1 then
            self.str1 = str2
            self.str3 = str3
        elseif self.rand2 == 2 then
            self.str1 = str3
            self.str3 = str2
        end
    elseif self.correctchoice == 3 then
        self.str3 = str1
        if self.rand2 == 1 then
            self.str2 = str2
            self.str1 = str3
        elseif self.rand2 == 2 then
            self.str2 = str3
            self.str1 = str2
        end
    end

    self.textscale = 1
    if self.rand == 9 then
        self.textscale = 0.7
    end

    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2 - 70

    self.clock = Sprite("ui/clock", 200, 300)
    self.clock.debug_select = false
    self.clock:setOrigin(0.5, 0.5)
    self.clock:setScale(2, 2)
    self:addChild(self.clock)

    self.heart = Sprite("player/heart", x-104, y-88)
    self.heart.debug_select = false
    self.heart:setColor(Game:getSoulColor())
    self:addChild(self.heart)

    self.highlights = {}

    local highlight1 = Sprite("ui/battle/proofread/bubble_highlight", x, y-80)
    highlight1.debug_select = false
    highlight1:setOrigin(0.5, 0.5)
    highlight1:setColor(COLORS["red"])
    highlight1:play(1/6)
    self:addChild(highlight1)

    local highlight2 = Sprite("ui/battle/proofread/bubble_highlight", x, y)
    highlight2.debug_select = false
    highlight2:setOrigin(0.5, 0.5)
    highlight2:play(1/6)
    self:addChild(highlight2)

    local highlight3 = Sprite("ui/battle/proofread/bubble_highlight", x, y+80)
    highlight3.debug_select = false
    highlight3:setOrigin(0.5, 0.5)
    highlight3:play(1/6)
    self:addChild(highlight3)

    self.highlights = {
        [1] = highlight1,
        [2] = highlight2,
        [3] = highlight3,
    }

    Input.clear("confirm")
    self:setText("[instant]* Select the right spelling!", false)
end

function ProofreadController:onHeartMove()
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2 - 70
    if self.currentchoice == 1 then
        self.heart:setPosition(x-104, y-88)
        self.highlights[3]:setColor(COLORS["white"])
        self.highlights[1]:setColor(COLORS["red"])
    elseif self.currentchoice == 2 then
        self.heart:setPosition(x-104, y-8)
        self.highlights[1]:setColor(COLORS["white"])
        self.highlights[2]:setColor(COLORS["red"])
    elseif self.currentchoice == 3 then
        self.heart:setPosition(x-104, y+72)
        self.highlights[2]:setColor(COLORS["white"])
        self.highlights[3]:setColor(COLORS["red"])
    end
end

function ProofreadController:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function ProofreadController:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function ProofreadController:onSelect(correct)
    self.heart.alpha = 0
    if self.currentchoice == 1 then
        self.highlights[1]:setColor(COLORS["white"])
        self.highlights[2]:setColor(COLORS["blue"])
        self.highlights[3]:setColor(COLORS["blue"])
    elseif self.currentchoice == 2 then
        self.highlights[2]:setColor(COLORS["white"])
        self.highlights[1]:setColor(COLORS["blue"])
        self.highlights[3]:setColor(COLORS["blue"])
    elseif self.currentchoice == 3 then
        self.highlights[3]:setColor(COLORS["white"])
        self.highlights[1]:setColor(COLORS["blue"])
        self.highlights[2]:setColor(COLORS["blue"])
    end
    if correct then
        Assets.playSound("coin")
        if self.easy then self.enemy:setTired(true) end
        self.enemy:addMercy(100)
        self:setText("* Success!", true)
    else
        Assets.playSound("error")
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        if self.easy then self.enemy:setTired(true) end
        self:setText("* ...[wait:5] but,[wait:5] it was misspelled!", true)
    end
end

function ProofreadController:onTimeout()
    Assets.playSound("error")
    self.clock.alpha = 0
    self.heart.alpha = 0
    self.highlights[1].alpha = 0
    self.highlights[2].alpha = 0
    self.highlights[3].alpha = 0
    self.alpha = 0
    self:setText("* Out of time!", true)
end

function ProofreadController:update()
    super.update(self)

    self.timer = self.timer + 1 * DTMULT

    if not self.selectionmade then
        self.acttimer = self.acttimer + 1 * DTMULT
        if self.acttimer > self.acttimermax then
            self.selectionmade = true
            self.timeout = true
            self:onTimeout()
        end
    end

    if self.selectionmade and not self.timeout then
        self.colortimer = self.colortimer + 1 * DTMULT
    end

    if self.colortimer == 3 then
        self.colortimer = 0
        if self.wronglastcolor == "white" then
            self.wronglastcolor = "notwhite"
            if self.currentchoice == self.correctchoice then
                self.highlights[self.currentchoice]:setColor(COLORS["yellow"])
            else
                self.highlights[self.currentchoice]:setColor(COLORS["red"])
            end
        else
            self.wronglastcolor = "white"
            self.highlights[self.currentchoice]:setColor(COLORS["white"])
        end
    end

    if self.timer > self.movespeed and not self.selectionmade then
        self.timer = 0
        Assets.playSound("ui_move")
        if self.currentchoice == 3 then
            self.currentchoice = 1
        else
            self.currentchoice = self.currentchoice + 1
        end
        self:onHeartMove()
    end

    if Input.pressed("confirm") and not self.selectionmade then
        Input.clear("confirm")
        self.selectionmade = true
        local correct = false
        if self.currentchoice == self.correctchoice then correct = true end
        self:onSelect(correct)
    end

    if self.selectionmade and not Game.battle.battle_ui.encounter_text:isTyping() and Input.pressed("confirm") then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

function ProofreadController:draw()
    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2 - 70

    Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y - 80, 0, 1, 0.62, 68, 43)
    Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y, 0, 1, 0.62, 68, 43)
    Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y + 80, 0, 1, 0.62, 68, 43)

    if not self.timeout then
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS["black"])
        love.graphics.print(self.str1, x - self.font:getWidth(self.str1)*self.textscale/2, y - 80 - 16, 0, self.textscale, 1)
        love.graphics.print(self.str2, x - self.font:getWidth(self.str2)*self.textscale/2, y - 16, 0, self.textscale, 1)
        love.graphics.print(self.str3, x - self.font:getWidth(self.str3)*self.textscale/2, y + 80 - 16, 0, self.textscale, 1)

        Draw.setColor(COLORS["aqua"])
        love.graphics.setLineWidth(10)
        local b
        if not self.easy then
            b = 220 - self.acttimer * 2
        else
            b = 200 - self.acttimer
        end
        love.graphics.line(200, 300, 200 + b, 300)
    end

    super.draw(self)
end

return ProofreadController