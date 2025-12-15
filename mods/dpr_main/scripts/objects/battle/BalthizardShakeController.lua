local BalthizardShakeController, super = Class(Object)

function BalthizardShakeController:init(enemy, shakex)
    super.init(self, 0, 0)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.enemy = enemy
    self.shaketimer = 0
    self.shakex = shakex or false
    self.shakelastpress = 0
    self.speed = 10
    self.offset = 2.5
    self.shakemercystart = self.enemy.mercy
    self.shakemaxmercyhp = 30
    self.mercygained = 0
    if self.shakemercystart >= 50 then
        self.mercylimit = 100 - self.shakemercystart
    else
        self.mercylimit = 90 - self.shakemercystart
    end

    self.clock = Sprite('ui/clock', 200, 295)
    self.clock.debug_select = false
    self.clock:setOrigin(0.5, 0.5)
    self.clock:setScale(2, 2)
    self:addChild(self.clock)

    self.enemy.sprite.shaking = true

    Input.clear("left")
    Input.clear("right")
    self:setText("[instant]* Press Left and Right rapidly to shake!", true)
end

function BalthizardShakeController:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function BalthizardShakeController:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function BalthizardShakeController:onShake()
    Assets.stopAndPlaySound("damage")
    if self.shakelastpress == 1 then
        local smoke = BalthizardSmoke(self.enemy.sprite.x + 13 + self.enemy.sprite.headoffsetx - 7, self.enemy.sprite.y + 28 + self.enemy.sprite.headoffsety)
        smoke.physics.speed = (TableUtils.pick({-3, -4, -5}))/2
        self.enemy.sprite:addChild(smoke)
    else
        local smoke = BalthizardSmoke(self.enemy.sprite.x + 13 + self.enemy.sprite.headoffsetx + 10, self.enemy.sprite.y + 28 + self.enemy.sprite.headoffsety)
        smoke.physics.speed = (TableUtils.pick({3, 4, 5}))/2
        self.enemy.sprite:addChild(smoke)
    end
end

function BalthizardShakeController:addMercyCustom(amount)
    if not self.enemy.temp_mercy then
        self.enemy.temp_mercy = amount
    else
        self.enemy.temp_mercy = self.enemy.temp_mercy + amount
    end
    self.enemy.temp_mercy = MathUtils.clamp(self.enemy.temp_mercy, 0, self.mercylimit)
    if not self.enemy.temp_mercy_percent and Game:getConfig("mercyMessages") then
        Assets.playSound("mercyadd", 0.8, 1.4)
        self.enemy.temp_mercy_percent = self.enemy:statusMessage("mercy", self.enemy.temp_mercy)
        self.enemy.temp_mercy_percent.kill_condition = function() return self.enemy.sprite.shaking == false end
    else
        self.enemy.temp_mercy_percent:setDisplay("mercy", self.enemy.temp_mercy)
    end
end

function BalthizardShakeController:update()
    super.update(self)

    if self.shakelastpress ~= 0 then
        if not self.shakex then
            self.shaketimer = self.shaketimer + 3 * DTMULT
        end
        self.shaketimer = self.shaketimer + 1 * DTMULT
    end

    if Input.pressed("left") then
        self.enemy.sprite.head:setFrame(3)
        self.enemy.sprite.headspeed = self.enemy.sprite.headspeed - self.speed
        self.enemy.sprite.headoffsetx = self.enemy.sprite.headoffsetx - self.offset
        if self.shakex then
            self.mercygained = self.mercygained + 8
            if self.shakemercystart >= 100 then
                self.shakemaxmercyhp = self.shakemaxmercyhp - 8
            else
                self:addMercyCustom(8)
            end
        else
            self.mercygained = self.mercygained + 4
            if self.shakemercystart >= 100 then
                self.shakemaxmercyhp = self.shakemaxmercyhp - 4
            else
                self:addMercyCustom(4)
            end
        end
        self.shakelastpress = -1
        self:onShake()
    end

    if Input.pressed("right") then
        self.enemy.sprite.head:setFrame(17)
        self.enemy.sprite.headspeed = self.enemy.sprite.headspeed + self.speed
        self.enemy.sprite.headoffsetx = self.enemy.sprite.headoffsetx + self.offset
        if self.shakex then
            self.mercygained = self.mercygained + 8
            if self.shakemercystart >= 100 then
                self.shakemaxmercyhp = self.shakemaxmercyhp - 8
            else
                self:addMercyCustom(8)
            end
        else -- why 3, Toby's coders? WHY
            self.mercygained = self.mercygained + 3
            if self.shakemercystart >= 100 then
                self.shakemaxmercyhp = self.shakemaxmercyhp - 3
            else
                self:addMercyCustom(3)
            end
        end
        self.shakelastpress = 1
        self:onShake()
    end

    if (self.mercygained >= self.mercylimit and self.shakemercystart < 100) or (self.shakemercystart >= 100 and self.shakemaxmercyhp < 1) or self.shaketimer >= 180 then
        self.enemy.sprite.shaking = false
        if self.enemy.temp_mercy then
            self.enemy.mercy = self.enemy.mercy + self.enemy.temp_mercy
            self.enemy.temp_mercy = nil
            if self.enemy.temp_mercy_percent then
                self.enemy.temp_mercy_percent = nil
            end
        end
        if self.shakemercystart >= 100 then
            self.enemy:spare()
        end
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

function BalthizardShakeController:draw()
    if not self.timeout then
        Draw.setColor(COLORS["aqua"])
        love.graphics.setLineWidth(10)
        local b = 180 - self.shaketimer
        love.graphics.line(200, 295, 200 + b, 295)
    end

    super.draw(self)
end

return BalthizardShakeController