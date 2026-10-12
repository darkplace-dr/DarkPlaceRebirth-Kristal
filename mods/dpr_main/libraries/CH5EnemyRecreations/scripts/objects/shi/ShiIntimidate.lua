local ShiIntimidate, super = Class(Object)

function ShiIntimidate:init(enemy, battler, alone)
    super.init(self, 320, 220)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.enemy = enemy
    self.battler = battler
    self.alone = alone or false

    self:setSprite("ui/battle/intimidate/ut_tpose_board", 273, 57)
    self:setScale(0, 0.5)

    self.alpha = 0
    self.alpha2 = 0
    self.alpha3 = 0
    self.alpha4 = 0

    self.timer = 0
    self.con = -1
    self.automiss = false
    self.mercy = 0
    self.success = 0
    self.bar_x = 0

    Input.clear("confirm")
    self:setText("* Press with the right timing to INTIMIDATE!", true)
end

function ShiIntimidate:setSprite(texture, ox, oy)
    if self.sprite then
        self:removeChild(self.sprite)
    end
    if texture then
        self.sprite = Sprite(texture)
        self.sprite:stop()
        self.sprite.inherit_color = true
        self.sprite.alpha = self.alpha
        self:addChild(self.sprite)
        self:setOriginExact(ox, oy)

        self.width = self.sprite.width
        self.height = self.sprite.height

        return self.sprite
    end
end

function ShiIntimidate:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function ShiIntimidate:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function ShiIntimidate:setFinalText()
    self.finaltext = true
    
    local firstline = "* The pose was mistaken![wait:5] It wasn't very effective!"
    if self.success == 1 then
        firstline = "* You engaged in a perfect pose![wait:5] It was highly effective!"
    elseif self.success == 2 then
        firstline = "* You engaged in a superior pose![wait:5] It was very effective!"
    end

    self:setText(firstline, true)
end

function ShiIntimidate:onPress()
    local automiss     = self.automiss
    local alone        = self.alone
    local perfectmercy = 100
    local maxmercy     = 70
    local minmercy     = 50

    local bar_x = self.bar_x -- I THINK it's accurate??? Maybe not really??????
    if bar_x < 86 or bar_x > 334 then
        maxmercy = 0
    end

    if bar_x >= 86 and bar_x < 196 then
        self.mercy = math.ceil(MathUtils.lerp(minmercy, maxmercy, (bar_x - 86) / 90))
    end

    if bar_x >= 224 and bar_x < 334 then
        self.mercy = math.ceil(MathUtils.lerp(minmercy, maxmercy, (bar_x - 244) / 90))
    end

    if bar_x >= 196 and bar_x <= 224 then
        self.success = 1
        Assets.stopAndPlaySound("boost")

        if not alone then
        end

        self.bar_x = 196
        self.mercy = maxmercy
        if self.enemy.mercy < 100 then self.enemy:addMercy(perfectmercy) end
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy and enemy.mercy < 100 then
                enemy:addMercy(10)
            end
        end

        self:setFinalText()

    elseif bar_x < 86 or bar_x > 334 then
        self.success = 0
        Assets.playSound("error")

        if not alone then
        end

        if self.enemy.mercy < 100 then self.enemy:addMercy(minmercy) end

        self:setFinalText()

    else
        self.success = 2
        Assets.stopAndPlaySound("boost")

        if not alone then
        end

        if self.enemy.mercy < 100 then self.enemy:addMercy(self.mercy) end
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy and enemy.mercy < 100 then
                enemy:addMercy(10)
            end
        end
        
        self:setFinalText()
    end

    local afterimage = SpriteAfterImageGrow("ui/battle/intimidate/ut_tpose_bar", ((self.x + self.bar_x) - 137 - 7 - 60) + 8, (self.y - 17) + 18, 1, 0.1, 0.2)
    afterimage:setScale(1)
    afterimage:setOriginExact(14, 18)
    afterimage:setLayer(self.layer + 1)
    Game.battle:addChild(afterimage)
end

function ShiIntimidate:update()
    super.update(self)

    if self.con == -1 and not Game.battle.battle_ui.encounter_text:isTyping() then
        Assets.playSound("ghostappear", 1, 1.2)
        Assets.playSound("ghostappear", 1, 1.1)
        self.con = 0
    end

    if self.con == 0 then
        if self.alpha < 1 then
            self.alpha = self.alpha + 0.1 * DTMULT
        end

        if self.bar_x > 324 then
            self.alpha3 = self.alpha3 - 0.1 * DTMULT
            if self.alpha3 <= 0 then
                self.automiss = true
            end

            self.bar_x = self.bar_x + 7 * DTMULT

        elseif self.alpha2 >= 1 then
            if self.alpha3 < 1 then
                self.alpha3 = self.alpha3 + 0.1 * DTMULT
            end
            self.bar_x = self.bar_x + 7 * DTMULT
        end
    end

    if self.con == 1 then
        self.timer = self.timer + DTMULT

        if self.timer > 12 then
            self.alpha = self.alpha - 0.1 * DTMULT
            self.alpha2 = self.alpha2 - 0.1 * DTMULT
            self.alpha3 = self.alpha3 - 0.1 * DTMULT
        end
    end

    if ((Input.pressed("confirm") or Input.pressed("cancel") or Input.pressed("menu") or self.automiss == true) and self.bar_x >= 70 and self.con == 0 and self.alpha >= 0.6) then
        self.con = 1
        self:onPress()
    end

    if self.finaltext and not Game.battle.battle_ui.encounter_text:isTyping() and Input.pressed("confirm") then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

local function drawRectangle(x, y, w, h, outline)
    Draw.rectangle(outline, x, y, w - x + 1, h - y + 1)
end

function ShiIntimidate:drawSelf()
    Draw.setColor(0, 0, 0, self.alpha3 / 1.4)
    drawRectangle(0, self.y - 42, SCREEN_WIDTH, self.y + 80, "fill")
    Draw.setColor(1, 1, 1, self.alpha)

    if self.scale_x < 0.5 and self.con == 0 then
        self.scale_x = self.scale_x + 0.05 * DTMULT
    end

    super.drawSelf(self)
    love.graphics.setFont(Assets.getFont("main"))

    if (self.alpha2 < 1 and self.con == 0) then
        self.alpha2 = self.alpha2 + 0.1 * DTMULT
    end

    if self.con == 0 then
        Draw.setColor(1, 1, 1, self.alpha2)
        love.graphics.print("HIT IT!", self.x - 42, self.y + 40)
        
        Draw.setColor(1, 1, 1, self.alpha3)
        Draw.draw(Assets.getTexture("ui/battle/intimidate/ut_tpose_bar"), (self.x + self.bar_x) - 137 - 7 - 60, self.y - 17, 0, 1, 1)
    end


    if DEBUG_RENDER then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(Assets.getFont("main"))
        local dbg = string.format(
            [[bar_x_real = %d    bar_x = %d]],
            320 + self.bar_x - 204,
            self.bar_x
        )
        love.graphics.printf(dbg, 0, 0, SCREEN_WIDTH*2, "right", 0, 0.5, 0.5)
    end
end

return ShiIntimidate