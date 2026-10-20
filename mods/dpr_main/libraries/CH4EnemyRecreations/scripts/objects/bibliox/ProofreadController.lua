local ProofreadController, super = Class(Object)

function ProofreadController:init(enemy, easyproof)
    super.init(self)

    self.enemy = enemy

    self.timer = 0
    self.con = 0
    self.easyproof = easyproof or false
    self.movespeed = self.easyproof and 15 or 10
    self.acttimer = 0
    self.acttimermax = self.easyproof and 200 or 110
    self.str1 = "1"
    self.str2 = "2"
    self.str3 = "3"
    self.rand = MathUtils.randomInt(1, 10)
    self.rand2 = TableUtils.pick({ 1, 2 })
    self.currentchoice = 1
    self.correctchoice = TableUtils.pick({ 1, 2, 3 })
    self.creatorid = -1
    self.highlightindex = 0
    self.endtimer = 0
    self.dottedlinecolor1 = "red"
    self.dottedlinecolor2 = "white"
    self.colortimer = 0

    self.result_text_advanced = false

    self.font = Assets.getFont("main")
    self.highlight = Assets.getFrames("ui/battle/proofread/bubble_highlight")
    self.heart = Assets.getTexture("player/heart")

    local str1, str2, str3 = nil, nil, nil
    if self.rand == 1 then
        str1, str2, str3 = "GALLERY", "GALLURY", "GALLORY"
    elseif self.rand == 2 then
        str1, str2, str3 = "ROOTS", "REETS", "RAATS"
    elseif self.rand == 3 then
        str1, str2, str3 = "FESTIVAL", "FESTIAVL", "FESTAVIL"
    elseif self.rand == 4 then
        str1, str2, str3 = "FLASHBACK", "FLESHBECK", "FLOSHBOCK"
    elseif self.rand == 5 then
        str1, str2, str3 = "SWORD", "SORWD", "SOWRD"
    elseif self.rand == 6 then
        str1, str2, str3 = "GUARDIAN", "GAURDIAN", "GAURDAIN"
    elseif self.rand == 7 then
        str1, str2, str3 = "ATRIUM", "ATRUIM", "ARTIUM"
    elseif self.rand == 8 then
        str1, str2, str3 = "SYNTHESIS", "SYNTEHSIS", "SINTHESIS"
    elseif self.rand == 9 then
        str1, str2, str3 = "AMPHITHEATER", "AMPITHEATER", "AMPITHEATRE"
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

    Input.clear("confirm")
    self:setText("[instant]* Select the right spelling!", false)
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

function ProofreadController:result()
    if self.con == 1 then
        Assets.playSound("coin")
        self.enemy:addMercy(100)
        self:setText("* Success!", true)
    elseif self.con == 2 then
        Assets.playSound("error")
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        self:setText("* ...[wait:5] but,[wait:5] it was misspelled!", true)
    else
        Assets.playSound("error")
        self:setText("* Out of time!", true)
    end
end

function ProofreadController:drawHighlight(x, y, color)
    Draw.setColor(ColorUtils.unpackColor(COLORS[color]))
    local frame = math.floor(self.highlightindex) % #self.highlight + 1
    Draw.draw(self.highlight[frame], x, y, 0, 1, 1, 78, 34)
end

function ProofreadController:drawSoul(x, y)
    Draw.setColor(Game:getSoulColor())
    Draw.draw(self.heart, x, y)
end

function ProofreadController:draw()
    super.draw(self)

    if self.acttimer >= 10 then
        self.timer = self.timer + DTMULT
    end

    if self.timer > self.movespeed and self.con == 0 then
        self.timer = 0
        Assets.playSound("ui_move")
        self.currentchoice = self.currentchoice + 1
        if self.currentchoice == 4 then
            self.currentchoice = 1
        end
    end

    local x = SCREEN_WIDTH / 2
    local y = SCREEN_HEIGHT / 2 - 70

    if self.con ~= -1 then
        Draw.setColor(ColorUtils.unpackColor(COLORS.white))
        Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y - 80, 0, 1, 0.62, 68, 43)
        Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y, 0, 1, 0.62, 68, 43)
        Draw.draw(Assets.getTexture("ui/battle/proofread/bubble"), x, y + 80, 0, 1, 0.62, 68, 43)

        Draw.setColor(ColorUtils.unpackColor(COLORS.black))
        love.graphics.setFont(self.font)
        local textscale = 1
        if self.rand == 9 then
            textscale = 0.7
        end
        love.graphics.print(self.str1, x - self.font:getWidth(self.str1) * textscale / 2, y - 80 - 16, 0, textscale, 1)
        love.graphics.print(self.str2, x - self.font:getWidth(self.str2) * textscale / 2, y - 16, 0, textscale, 1)
        love.graphics.print(self.str3, x - self.font:getWidth(self.str3) * textscale / 2, y + 80 - 16, 0, textscale, 1)
        Draw.setColor(ColorUtils.unpackColor(COLORS.white))
    end

    self.highlightindex = self.highlightindex + 0.5 * DTMULT

    if self.con ~= -1 then
        if self.currentchoice == 1 then
            if self.con == 0 then
                self:drawSoul(x - 104, y - 88)
            end
            self:drawHighlight(x, y - 80, self.dottedlinecolor1)
        else
            self:drawHighlight(x, y - 80, self.dottedlinecolor2)
        end
        if self.currentchoice == 2 then
            if self.con == 0 then
                self:drawSoul(x - 104, y - 8)
            end
            self:drawHighlight(x, y, self.dottedlinecolor1)
        else
            self:drawHighlight(x, y, self.dottedlinecolor2)
        end
        if self.currentchoice == 3 then
            if self.con == 0 then
                self:drawSoul(x - 104, y + 72)
            end
            self:drawHighlight(x, y + 80, self.dottedlinecolor1)
        else
            self:drawHighlight(x, y + 80, self.dottedlinecolor2)
        end

        local b = 220 - self.acttimer * 2
        if self.easyproof then
            b = 200 - self.acttimer
        end
        Draw.setColor(ColorUtils.unpackColor(COLORS.aqua))
        Draw.rectangle("fill", 200, 295, b + 1, 305 - 295 + 1)
        Draw.setColor(ColorUtils.unpackColor(COLORS.white))
        Draw.draw(Assets.getTexture("ui/clock"), 200, 300, 0, 2, 2, 9, 9)
    end

    if self.con == 0 then
        self.acttimer = self.acttimer + DTMULT
    end

    if self.acttimer > self.acttimermax and self.con ~= -1 then
        self.con = -1
        self:result()
    end

    if self.con == 0 and self.acttimer > 12 and (Input.pressed("confirm") or Input.pressed("menu")) then
        if self.currentchoice == self.correctchoice then
            self.con = 1
        else
            self.con = 2
        end
        if self.easyproof then
            self.enemy:setTired(true)
        end
        Game.battle.timer:after(1 / 30, self:result())
    end

    if self.con ~= 0 then
        self.endtimer = self.endtimer + DTMULT
    end

    if self.con == 1 then
        self.colortimer = self.colortimer + DTMULT
        if self.colortimer >= 3 then
            self.colortimer = 0
            if self.dottedlinecolor1 == "red" or self.dottedlinecolor1 == "yellow" then
                self.dottedlinecolor1 = "white"
                self.dottedlinecolor2 = "blue"
            elseif self.dottedlinecolor1 == "white" then
                self.dottedlinecolor1 = "yellow"
            end
        end
    elseif self.con == 2 then
        self.colortimer = self.colortimer + DTMULT
        if self.colortimer >= 3 then
            self.colortimer = 0
            if self.dottedlinecolor1 == "red" then
                self.dottedlinecolor1 = "white"
                self.dottedlinecolor2 = "blue"
            elseif self.dottedlinecolor1 == "white" then
                self.dottedlinecolor1 = "red"
            end
        end
    end

    if (self.con ~= 0 and self.endtimer > 17) and not Game.battle.battle_ui.encounter_text:isTyping() and (Input.pressed("confirm") or Input.pressed("menu")) then
        self:clearText()
        self.result_text_advanced = true
    end

    if self.result_text_advanced and (((self.con == 1 or self.con == 2) and self.endtimer >= 60) or self.con == -1) then
        Game.battle:finishAction()
        self:remove()
    end

    super.draw(self)
end

return ProofreadController