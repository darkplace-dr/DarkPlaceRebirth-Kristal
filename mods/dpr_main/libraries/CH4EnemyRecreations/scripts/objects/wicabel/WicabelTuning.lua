local WicabelTuning, super = Class(Object)

function WicabelTuning:init(enemy, battler, isdouble)
    super.init(self, 0, 0)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.enemy = enemy
    self.battler = battler
    self.double = isdouble or false

    self.alpha = 0
    self.alpha2 = 0
    self.xscale = 0

    self.timer = 0
    self.con = 0
    self.automiss = false
    self.mercy = 0
    self.success = 0
    self.bar_x = 0

    self.tuning_fork = Sprite("ui/battle/tuning/tuning_fork", 304, 80)
    self.tuning_fork:setOriginExact(0, 0)
    self.tuning_fork.alpha = 0
    self.tuning_fork.debug_select = false
    self:addChild(self.tuning_fork)

    self.text = Text("HIT IT!", 278, 260)
    self.text.alpha = 0
    self.text.debug_select = false
    self:addChild(self.text)

    -- original x coord is (x + bar_x - 137 - 7 - 60)
    self.bar = Sprite("ui/battle/tuning/ut_combat_bar", 116, 188)
    self.bar:setOriginExact(0, 0)
    self.bar:setScale(0.5)
    self.bar.alpha = 0
    self.bar.debug_select = false
    self:addChild(self.bar)

    Input.clear("confirm")
    self:setText("* Press button with the right\ntiming!", true)
end

function WicabelTuning:setText(text, can_skip)
    can_skip = can_skip or false
    local encounter_text = Game.battle.battle_ui.encounter_text
    encounter_text:setSkippable(can_skip)
    encounter_text:setAdvance(can_skip)
    encounter_text:setText(text)
end

function WicabelTuning:clearText()
    Game.battle.battle_ui:clearEncounterText()
end

function WicabelTuning:setFinalText()
    self.finaltext = true
    local firstline = "* A bit off-tune!"
    if self.success == 1 then
        firstline = "* Perfectly in tune!"
    elseif self.success == 2 then
        firstline = "* Somewhat in tune!"
    end
    self:setText(firstline.."\n* All musical ACTs became stronger!", true)
end

function WicabelTuning:progress(argument0, argument1, argument2, argument3, argument4) -- port from Gamemaker
    return MathUtils.clamp((argument3 + (argument0 - argument1) / (argument2 - argument1) * (argument4 - argument3)), argument3, argument4)
end

function WicabelTuning:onPress()
    local maxmercy = 70
    if self.double then
        maxmercy = 60
    end

    local bar_x = self.bar_x -- I THINK it's accurate??? Maybe not really??????
    if bar_x < 86 or bar_x > 334 then
        maxmercy = 0
    end

    local maximperfectmercy = math.max((maxmercy - 1), 0)
    local ind
    if bar_x >= 86 and bar_x < 196 then
        ind = self:progress(bar_x, 86, 196, 0, 1)
        self.mercy = math.ceil(Utils.ease(ind, maximperfectmercy, 1, "outCubic"))
    end
    if bar_x > 224 then
        ind = self:progress(bar_x, 334, 224, 0, 1)
        self.mercy = math.ceil(Utils.ease(ind, maximperfectmercy, 1, "outCubic"))
    end
    if bar_x >= 196 and bar_x <= 224 then
        self.success = 1
        Game.battle.wicabel_tuning = true
        Assets.playSound("tuning_fork")
        self.tuning_fork:shake()
        Assets.playSound("laz_c")
        self.tuning_fork:play(1/33)
        if self.double then
            Game.battle:getPartyBattler("susie"):setAnimation("battle/attack", function() Game.battle:getPartyBattler("susie"):setAnimation("battle/idle") end)
        else
            self.battler:setAnimation("battle/attack", function() self.battler:setAnimation("battle/idle") end)
        end
        local attacksprite = self.battler.chara:getWeapon() and self.battler.chara:getWeapon():getAttackSprite(self.battler) or self.battler.chara:getAttackSprite()
        local attack
        if self.double then
            Assets.playSound("impact")
            attack = Sprite("effects/attack/mash", self.tuning_fork.x + 20, self.tuning_fork.y + 30)
            attack:play(1/15, false, function() attack:remove() end)
        else
            attack = Sprite(attacksprite, self.tuning_fork.x + 20, self.tuning_fork.y + 30)
            attack:play(1/10, false, function() attack:remove() end)
        end
        attack:setOrigin(0.5, 0.5)
        attack:setScale(2)
        self:addChild(attack)
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        -- self.mercy doesn't give a perfect number and I dunno why so we're bruteforcing it
        local mercy = 70
        if self.double then mercy = 60 end
        if self.enemy.mercy < 100 then self.enemy:addMercy(mercy) end
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy and enemy.mercy < 100 then
                enemy:addMercy(20)
            end
        end
        if not self.double then self:setFinalText() end
    elseif self.mercy < 10 then
        self.success = 0
        Assets.playSound("laz_c")
        if self.double then
            Game.battle:getPartyBattler("susie"):setAnimation("battle/attack", function() Game.battle:getPartyBattler("susie"):setAnimation("battle/idle") end)
        else
            self.battler:setAnimation("battle/attack", function() self.battler:setAnimation("battle/idle") end)
        end
        local attacksprite = self.battler.chara:getWeapon() and self.battler.chara:getWeapon():getAttackSprite(self.battler) or self.battler.chara:getAttackSprite()
        local attack
        if self.double then
            attack = Sprite("effects/attack/mash", self.tuning_fork.x + 90, self.tuning_fork.y + 30)
            attack:play(1/15, false, function() attack:remove() end)
        else
            attack = Sprite(attacksprite, self.tuning_fork.x + 90, self.tuning_fork.y + 30)
            attack:play(1/10, false, function() attack:remove() end)
        end
        attack:setOrigin(0.5, 0.5)
        attack:setScale(2)
        self:addChild(attack)
        if not self.double then self:setFinalText() end
    else
        self.success = 2
        Game.battle.wicabel_tuning = true
        Assets.playSound("tuning_fork")
        self.tuning_fork:shake()
        Assets.playSound("laz_c")
        self.tuning_fork:play(1/33)
        if self.double then
            Game.battle:getPartyBattler("susie"):setAnimation("battle/attack", function() Game.battle:getPartyBattler("susie"):setAnimation("battle/idle") end)
        else
            self.battler:setAnimation("battle/attack", function() self.battler:setAnimation("battle/idle") end)
        end
        local attacksprite = self.battler.chara:getWeapon() and self.battler.chara:getWeapon():getAttackSprite(self.battler) or self.battler.chara:getAttackSprite()
        local attack
        if self.double then
            Assets.playSound("impact")
            attack = Sprite("effects/attack/mash", self.tuning_fork.x + 20, self.tuning_fork.y + 30)
            attack:play(1/15, false, function() attack:remove() end)
        else
            attack = Sprite(attacksprite, self.tuning_fork.x + 20, self.tuning_fork.y + 30)
            attack:play(1/10, false, function() attack:remove() end)
        end
        attack:setOrigin(0.5, 0.5)
        attack:setScale(2)
        self:addChild(attack)
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        if self.enemy.mercy < 100 then self.enemy:addMercy(self.mercy) end
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy and enemy.mercy < 100 then
                enemy:addMercy(20)
            end
        end
        if not self.double then self:setFinalText() end
    end
end

function WicabelTuning:update()
    super.update(self)

    self.bar.x = (320 + self.bar_x - 204)

    if self.con ~= 1 and not Game.battle.battle_ui.encounter_text:isTyping() then
        if self.alpha < 1 then
            self.alpha = self.alpha + 0.1 * DTMULT
            self.tuning_fork.alpha = self.alpha
            self.text.alpha = self.alpha
        end
        if self.xscale < 0.5 then
            self.xscale = self.xscale + 0.05 * DTMULT
        end
        if self.bar_x > 324 then
            self.bar.alpha = self.bar.alpha - 0.1 * DTMULT
            if self.bar.alpha <= 0 then
                self.automiss = true
            end
            self.bar_x = self.bar_x + 7 * DTMULT
        elseif self.text.alpha >= 1 then
            if self.bar.alpha < 1 then
                self.bar.alpha = self.bar.alpha + 0.1 * DTMULT
            end
            self.bar_x = self.bar_x + 7 * DTMULT
        end
    end

    if self.con == 1 then
        self.timer = self.timer + 1 * DTMULT
        if self.timer > 12 then
            if self.double then
                self.double = false
                self.con = 0
                self.bar.alpha = 0
                self.bar_x = 0
            else
                self.alpha = self.alpha - 0.1 * DTMULT
                self.tuning_fork.alpha = self.alpha
                if self.alpha <= 0 then
                    self.bar.alpha = 0
                end
            end
        end
    end

    if ((Input.pressed("confirm") or Input.pressed("cancel") or Input.pressed("menu") or self.automiss == true) and self.bar_x >= 70 and self.con == 0 and self.alpha >= 0.6) then
        self.con = 1
        if self.double then
            self.automiss = false
        else
            self.text.alpha = 0
        end
        self:onPress()
    end

    if self.finaltext and not Game.battle.battle_ui.encounter_text:isTyping() and Input.pressed("confirm") then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

function WicabelTuning:draw()
    Draw.draw(Assets.getTexture("ui/battle/tuning/ut_combat_board"), 320, 220, 0, self.xscale, 0.5, 273, 57)

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

    super.draw(self)
end

return WicabelTuning