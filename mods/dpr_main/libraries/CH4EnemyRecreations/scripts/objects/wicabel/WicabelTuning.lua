local WicabelTuning, super = Class(Object)

function WicabelTuning:init(enemy, battler, double, battler2)
    super.init(self)

    self.enemy = enemy
    self.battler = battler
    self.battler2 = battler2

    self.con = 0
    self.timer = 0
    self.mercy = 0
    self.loudringing = double or false
    self.box_scale_x = 0
    self.box_scale_y = 0.5
    self.alpha1 = 0
    self.alpha2 = 0
    self.alpha3 = 0
    self.bar_x = 0

    self.success = 0
    self.result_text = false

    self.font = Assets.getFont("main")

    self.box = Assets.getTexture("ui/battle/tuning/ut_combat_board")
    self.bar = Assets.getFrames("ui/battle/tuning/ut_combat_bar")[1]

    self.tuning_fork = Sprite("ui/battle/tuning/tuning_fork", 304, 80)
    self.tuning_fork.alpha = 0
    self.tuning_fork.debug_select = false
    Game.battle:addChild(self.tuning_fork)

    Input.clear("confirm")
    self:setText("* Press button with the right \ntiming!", true)
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

function WicabelTuning:progress(arg0, arg1, arg2, arg3, arg4) -- port from Deltarune
    return MathUtils.clamp(arg3 + (((arg0 - arg1) / (arg2 - arg1)) * (arg4 - arg3)), arg3, arg4)
end

function WicabelTuning:easeOutCubic(arg0, arg1, arg2, arg3) -- port from Deltarune
    return (arg2 * (math.pow((arg0 / arg3) - 1, 3) + 1)) + arg1
end

function WicabelTuning:onPress()
    local config = Kristal.getLibConfig("CH4EnemyRecreations", "wicabel_tuning_fixes")
    local pitch_fix = config.attack_sound_pitch

    local attacker = self.loudringing and self.battler2 or self.battler

    local maxmercy = 70

    if self.loudringing then
        maxmercy = 60
    end

    if self.bar_x < 86 or self.bar_x > 334 then
        maxmercy = 0
    end

    local maximperfectmercy = math.max(maxmercy - 1, 0)

    if self.bar_x >= 86 and self.bar_x < 196 then
        local ind = self:progress(self.bar_x, 86, 196, 0, 1)
        self.mercy = math.ceil(self:easeOutCubic(ind, 0, maximperfectmercy, 1))
    end

    if self.bar_x > 224 then
        local ind = self:progress(self.bar_x, 334, 224, 0, 1)
        self.mercy = math.ceil(self:easeOutCubic(ind, 0, maximperfectmercy, 1))
    end

    if self.bar_x >= 196 and self.bar_x <= 224 then
        self.mercy = maxmercy
        self.success = 1
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.id == "organikk" then
                enemy.wicabell_tuning = true
            end
        end
        self:onTuningForkHit()
        self:createAttackSprite(self.tuning_fork.x + 20, self.tuning_fork.y + 30, false)
        self:onAttack(attacker)
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        self.enemy:addMercy(self.mercy)
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy and enemy.mercy < 100 then
                enemy:addMercy(20)
            end
        end
    elseif self.mercy < 10 then
        self.success = 0
        Assets.playSound("laz_c")
        self:createAttackSprite(self.tuning_fork.x + 90, self.tuning_fork.y + 30, true)
        local miss = Game.battle:addChild(DamageNumber("msg", "miss", self.tuning_fork.x + 90, self.tuning_fork.y + 30))
        miss.layer = self.layer - 1
    else
        self.success = 2
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.id == "organikk" then
                enemy.wicabell_tuning = true
            end
        end
        self:onTuningForkHit()
        self:createAttackSprite(self.tuning_fork.x + 20, self.tuning_fork.y + 30, false)
        self:onAttack(attacker)
        self.enemy.hurt_timer = 1
        self.enemy:onHurt()
        self.enemy:addMercy(self.mercy)
    end

    attacker:setAnimation("battle/attack", function() attacker:setAnimation("battle/idle") end)
    Assets.playSound(attacker.chara:getAttackSound(), pitch_fix and attacker.chara:getAttackPitch() or 1)

    self.con = 1
end

function WicabelTuning:onTuningForkHit()
    Assets.playSound("tuning_fork")
    self.tuning_fork:shake()
    Assets.playSound("laz_c")
    self.tuning_fork:play(1 / 33)
end

function WicabelTuning:createAttackSprite(x, y, miss)
    local config = Kristal.getLibConfig("CH4EnemyRecreations", "wicabel_tuning_fixes")
    local _, sprite_fix, speed_fix, miss_fix = config.attack_sound_pitch, config.attack_sprite_override, config.attack_sprite_speed, config.attack_sprite_miss

    local attacker = self.loudringing and self.battler2 or self.battler
    if miss and not miss_fix then
        attacker = self.battler
    end
    local attacksprite = attacker.chara:getWeapon() and attacker.chara:getWeapon():getAttackSprite(attacker) or attacker.chara:getAttackSprite()
    if not sprite_fix then
        attacksprite = attacker.chara:getAttackSprite()
    end
    local attack = Sprite(attacksprite, x, y)
    attack:setScale(2)
    attack:setOrigin(0.5, 0.5)
    local playspeed = 1 / 15
    if (attacker == self.battler and not speed_fix) or (speed_fix and attacksprite == "effects/attack/shard") then
        playspeed = 1 / 10
    end
    attack:play(playspeed, false, function() attack:remove() end)
    Game.battle:addChild(attack)
end

function WicabelTuning:onAttack(battler)
    if battler.chara.id == "susie" then
        Assets.playSound("impact")
        Game.battle:shakeCamera(4)
    end
end

function WicabelTuning:result()
    self.result_text = true
    local firstline = "* A bit off-tune!"
    if self.success == 1 then
        firstline = "* Perfectly in tune!"
    elseif self.success == 2 then
        firstline = "* Somewhat in tune!"
    end
    self:setText(firstline .. "\n* All musical ACTs became stronger!", true)
end

function WicabelTuning:update()
    super.update(self)

    if not self.result_text and not Game.battle.battle_ui.encounter_text:isTyping() then
        self.tuning_fork.alpha = self.tuning_fork.alpha + 0.1 * DTMULT
    end

    local automiss = false

    if self.con ~= 1 and not Game.battle.battle_ui.encounter_text:isTyping() then
        if self.alpha1 < 1 then
            self.alpha1 = self.alpha1 + 0.1 * DTMULT
        end
        if self.bar_x > 324 then
            self.alpha3 = self.alpha3 - 0.1 * DTMULT
            if self.alpha3 <= 0 then
                automiss = true
            end
            self.bar_x = self.bar_x + 7 * DTMULT
        elseif self.alpha2 >= 1 then
            if self.alpha3 < 1 then
                self.alpha3 = self.alpha3 + 0.1 * DTMULT
            end
            self.bar_x = self.bar_x + 7 * DTMULT
        end
    end

    if ((Input.pressed("confirm") or Input.pressed("cancel") or Input.pressed("menu") or automiss) and self.bar_x >= 70 and self.con == 0 and self.alpha1 >= 0.6) then
        self:onPress()
    end

    if self.con == 1 then
        self.timer = self.timer + DTMULT
        if self.timer > 12 then
            if self.loudringing then
                self.bar_x = 0
                self.alpha3 = 0
                self.con = 0
                self.loudringing = false
            else
                self.alpha1 = self.alpha1 - 0.1 * DTMULT
                self.alpha2 = self.alpha2 - 0.1 * DTMULT
                self.tuning_fork.alpha = self.tuning_fork.alpha - 0.1 * DTMULT
                if self.alpha1 < 0 then
                    self.tuning_fork:remove()
                    self.alpha3 = 0
                    if not self.result_text then
                        self:result()
                    end
                end
            end
        end
    end

    if self.result_text and not Game.battle.battle_ui.encounter_text:isTyping() and (Input.pressed("confirm") or Input.pressed("menu")) then
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

function WicabelTuning:draw()
    if self.box_scale_x < 0.5 and not Game.battle.battle_ui.encounter_text:isTyping() then
        self.box_scale_x = self.box_scale_x + 0.05 * DTMULT
    end

    super.draw(self)

    local x, y = 320, 220
    local r, g, b = ColorUtils.unpackColor(COLORS.white)

    Draw.setColor(r, g, b, self.alpha1)
    Draw.draw(self.box, x, y, 0, self.box_scale_x, self.box_scale_y, 273, 57)

    love.graphics.setFont(self.font)
    if not Game.battle.battle_ui.encounter_text:isTyping() then
        self.alpha2 = self.alpha2 + 0.1 * DTMULT
    end
    if self.con == 0 then
        Draw.setColor(r, g, b, self.alpha2)
        love.graphics.print("HIT IT!", x - 42, y + 40)
    end

    Draw.setColor(r, g, b, self.alpha3)
    Draw.draw(self.bar, (x + self.bar_x) - 137 - 7 - 60, y - 32, 0, 0.5, 0.5)
end

return WicabelTuning