local ShiIntimidate, super = Class(Object)

function ShiIntimidate:init(enemy, battler, flowery_mode, alone)
    super.init(self)

    self.enemy = enemy
    self.battler = battler
    self.flowery_mode = flowery_mode or false
    self.alone = alone or false

    self.con = -1
    self.timer = 0
    self.mercy = 0
    self.box_scale_x = 0
    self.box_scale_y = 0.5
    self.alpha1 = 0
    self.alpha2 = 0
    self.alpha3 = 0
    self.bar_x = 0

    self.create_afterimage = false
    self.create_afterimage_timer = 0
    self.success = 0
    self.result_text = false

    self.font = Assets.getFont("main")

    self.box = Assets.getTexture("ui/battle/intimidate/ut_tpose_board")
    self.bar = Assets.getTexture("ui/battle/intimidate/ut_tpose_bar")

    if self.flowery_mode then
        self:moveInRecruits()
    end

    Input.clear("confirm")
    if self.flowery_mode then
        local line_end = "* Press with the right timing to POSE!"
        if self.alone then
            self:setText("* You posed alone!\n" .. line_end, true)
        else
            self:setText("* Everyone posed together!\n" .. line_end, true)
        end
    else
        self:setText("* Press with the right timing to INTIMIDATE!", true)
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

function ShiIntimidate:moveInRecruits()
    if Game:hasRecruit("shi") then
        self.shi = Sprite("battle/enemies/shi/base", -200, 40)
        self.shi:setScale(-2, 2)
        self.shi:setLayer(BATTLE_LAYERS["above_battlers"])
        Game.battle:addChild(self.shi)
        self.shi:slideTo(290, self.shi.y, 8 / 30)
    end
    if Game:hasRecruit("shinobeetle") then
        self.shinobeetle = Sprite("battle/enemies/shinobeetle/base", -200, 120)
        self.shinobeetle:setScale(-2, 2)
        self.shinobeetle:setLayer(BATTLE_LAYERS["above_battlers"])
        Game.battle:addChild(self.shinobeetle)
        self.shinobeetle:slideTo(270, self.shinobeetle.y, 8 / 30)
    end
    if Game:hasRecruit("kawkaw") then
        self.kawkaw = Sprite("battle/enemies/kawkaw/blow_wind", -200, 240)
        self.kawkaw:setScale(2)
        self.kawkaw:setLayer(BATTLE_LAYERS["above_battlers"])
        Game.battle:addChild(self.kawkaw)
        self.kawkaw:slideTo(180, self.kawkaw.y, 8 / 30)
    end
end

function ShiIntimidate:moveOutRecruits()
    if Game:hasRecruit("shi") then
        self.shi:slideTo(self.shi.init_x, self.shi.init_y, 8 / 30, nil, function() self.shi:remove() end)
    end
    if Game:hasRecruit("shinobeetle") then
        self.shinobeetle:slideTo(self.shinobeetle.init_x, self.shinobeetle.init_y, 8 / 30, nil, function() self.shinobeetle:remove() end)
    end
    if Game:hasRecruit("kawkaw") then
        self.kawkaw:slideTo(self.kawkaw.init_x, self.kawkaw.init_y, 8 / 30, nil, function() self.kawkaw:remove() end)
    end
end

function ShiIntimidate:poseRecruits()
    if Game:hasRecruit("shi") then
        self.shi:setSprite("battle/enemies/shi/taunt")
        self.shi:setOriginExact(-8, -8)
        self.shi.x = self.shi.x - 10
    end
    if Game:hasRecruit("shinobeetle") then
        self.shinobeetle:setSprite("battle/enemies/shinobeetle/pose")
    end
    if Game:hasRecruit("kawkaw") then
        self.kawkaw:setSprite("battle/enemies/kawkaw/happy_2")
        self.kawkaw:setOriginExact(1, 3)
        self.kawkaw:setScale(-2, 2)
        self.kawkaw.x = self.kawkaw.x + 82
    end
end

function ShiIntimidate:poseRecruitsWrong()
    if Game:hasRecruit("shi") then
        self.shi:setSprite("battle/enemies/shi/spare")
        self.shi.x = self.shi.x - 10
    end
    if Game:hasRecruit("shinobeetle") then
        self.shinobeetle:setSprite("battle/enemies/shinobeetle/spare_alone")
    end
    if Game:hasRecruit("kawkaw") then
        self.kawkaw:setSprite("battle/enemies/kawkaw/tongue")
        self.kawkaw:setOriginExact(10, 11)
        self.kawkaw:setScale(-2, 2)
        self.kawkaw.x = self.kawkaw.x + 82
    end
end

function ShiIntimidate:result()
    self.result_text = true

    if self.success == 0 then
        self:setText("* The pose was mistaken![wait:5] It wasn't very effective!", true)
    elseif self.success == 1 then
        self:setText("* You engaged in a perfect pose![wait:5] It was highly effective!", true)
    elseif self.success == 2 then
        self:setText("* You engaged in a superior pose![wait:5] It was very effective!", true)
    end
end

function ShiIntimidate:onPress()
    local perfectmercy = 100
    local maxmercy = 70
    local minmercy = 50

    if self.flowery_mode then
        perfectmercy = 10
        maxmercy = 8
        minmercy = 5
        if perfectmercy + self.enemy.mercy > 10 then
            perfectmercy = 10 - self.enemy.mercy
        end
        if maxmercy + self.enemy.mercy > 10 then
            maxmercy = 10 - self.enemy.mercy
        end
        if minmercy + self.enemy.mercy > 10 then
            minmercy = 10 - self.enemy.mercy
        end
    end

    if self.bar_x < 86 or self.bar_x > 334 then
        maxmercy = 0
    end

    if self.bar_x >= 86 and self.bar_x < 196 then
        self.mercy = math.ceil(MathUtils.lerp(minmercy, maxmercy, (self.bar_x - 86) / 90))
    end

    if self.bar_x >= 224 and self.bar_x < 334 then
        self.mercy = math.ceil(MathUtils.lerp(minmercy, maxmercy, (self.bar_x - 244) / 90))
    end

    if self.bar_x >= 196 and self.bar_x <= 224 then
        self.success = 1

        Assets.stopAndPlaySound("boost")

        self.create_afterimage = true

        if self.alone then
            self:setPoseSprite(self.battler)
        else
            for _, battler in ipairs(Game.battle.party) do
                self:setPoseSprite(battler)
            end
        end
        if self.flowery_mode then
            self:poseRecruits()
        end

        self.bar_x = 196
        self.mercy = maxmercy

        self.enemy:addMercy(perfectmercy)
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy then
                enemy:addMercy(10)
            end
        end
    elseif self.bar_x < 86 or self.bar_x > 334 then
        self.success = 0

        Assets.playSound("error")

        if self.alone then
            self:setWrongPoseSprite(self.battler)
        else
            for _, battler in ipairs(Game.battle.party) do
                self:setWrongPoseSprite(battler)
            end
        end
        if self.flowery_mode then
            self:poseRecruitsWrong()
        end

        self.enemy:addMercy(minmercy)
    else
        self.success = 2

        Assets.stopAndPlaySound("boost")

        if self.alone then
            self:setPoseSprite(self.battler)
        else
            for _, battler in ipairs(Game.battle.party) do
                self:setPoseSprite(battler)
            end
        end
        if self.flowery_mode then
            self:poseRecruits()
        end

        self.enemy:addMercy(self.mercy)
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy ~= self.enemy then
                enemy:addMercy(10)
            end
        end
    end

    self:result()

    local x, y = 320, 220
    local afterimage = Sprite("ui/battle/intimidate/ut_tpose_bar", ((x + self.bar_x) - 137 - 7 - 60) + 8, (y - 17) + 18)
    afterimage:setOriginExact(14, 18)
    afterimage:setLayer(self.layer + 1)
    afterimage.graphics.grow = 0.2
    afterimage.graphics.fade = 0.1
    afterimage.graphics.fade_callback = function() afterimage:remove() end
    Game.battle:addChild(afterimage)

    self.con = 1
end

function ShiIntimidate:afterimageEffect(battler)
    local afterimage1 = AfterImage(battler, 1)
    local afterimage2 = AfterImage(battler, 0.6)
    afterimage1.physics.speed_x = 2.5
    afterimage2.physics.speed_x = 5

    afterimage1.layer = afterimage1.layer - 1
    afterimage2.layer = afterimage1.layer - 1

    afterimage1.debug_select = false
    afterimage2.debug_select = false

    battler:addChild(afterimage1)
    battler:addChild(afterimage2)
end

function ShiIntimidate:setPoseSprite(battler)
    if battler.chara.id == "kris" then
        battler:setSprite("t_pose")
        self:afterimageEffect(battler)
    elseif battler.chara.id == "susie" then
        battler:setSprite("t_pose")
        self:afterimageEffect(battler)
    elseif battler.chara.id == "ralsei" then
        battler:setSprite("t_pose")
        self:afterimageEffect(battler)
    end
end

function ShiIntimidate:setWrongPoseSprite(battler)
    if battler.chara.id == "kris" then
        battler:setSprite("y_pose")
        self:afterimageEffect(battler)
    elseif battler.chara.id == "susie" then
        battler:setSprite("m_pose")
        self:afterimageEffect(battler)
    elseif battler.chara.id == "ralsei" then
        battler:setSprite("c_pose")
        self:afterimageEffect(battler)
    end
end

function ShiIntimidate:update()
    super.update(self)

    if self.con == -1 and not Game.battle.battle_ui.encounter_text:isTyping() then
        Assets.playSound("ghostappear", 1, 1.2)
        Assets.playSound("ghostappear", 1, 1.1)
        self.con = 0
    end

    local automiss = false

    if self.con == 0 then
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

    if (Input.pressed("confirm") or Input.pressed("cancel") or Input.pressed("menu") or automiss) and self.bar_x >= 70 and self.con == 0 and self.alpha1 >= 0.6 then
        self:onPress()
    end

    if self.con == 1 then
        self.timer = self.timer + DTMULT

        if self.timer > 12 then
            self.alpha1 = self.alpha1 - 0.1 * DTMULT
            self.alpha2 = self.alpha2 - 0.1 * DTMULT
            self.alpha3 = self.alpha3 - 0.1 * DTMULT
        end
    end

    if self.create_afterimage then
        local function afterimage(battler)
            local x, y = battler:getRelativePos()
            local offsets = battler:getActiveSprite():getOffset()
            local a = SpriteAfterImageFog(battler:getActiveSprite():getTexture(), x + offsets[1] * battler.scale_x, y + offsets[2] * battler.scale_y, 0.1)
            a:setScale(battler.scale_x, battler.scale_y)
            a:setColor(battler.color)
            a:setLayer(battler.layer - 1)
            a.rotation = battler.rotation
            a.physics.speed = 2.7
            a.physics.direction = -math.rad(MathUtils.randomInt(361))
            Game.battle:addChild(a)
        end

        local function afterimageRecruit(sprite)
            local x, y = sprite:getRelativePos()
            local a = SpriteAfterImageFog(sprite:getTexture(), x, y, 0.1)
            a:setScale(sprite.scale_x, sprite.scale_y)
            a:setColor(sprite.color)
            a:setLayer(sprite.layer - 1)
            a.rotation = sprite.rotation
            a.physics.speed = 2.7
            a.physics.direction = -math.rad(MathUtils.randomInt(361))
            Game.battle:addChild(a)
        end

        self.create_afterimage_timer = self.create_afterimage_timer + DTMULT

        if self.create_afterimage_timer >= 6 then
            self.create_afterimage_timer = 1
            if not self.flowery_mode or (self.flowery_mode and Kristal.getLibConfig("CH5EnemyRecreations", "perfect_pose_fix")) then
                if self.alone then
                    afterimage(self.battler)
                else
                    for _, battler in ipairs(Game.battle.party) do
                        afterimage(battler)
                    end
                end
            end
            if self.flowery_mode and Kristal.getLibConfig("CH5EnemyRecreations", "perfect_pose_fix") then
                if Game:hasRecruit("shi") then
                    afterimageRecruit(self.shi)
                end
                if Game:hasRecruit("shinobeetle") then
                    afterimageRecruit(self.shinobeetle)
                end
                if Game:hasRecruit("kawkaw") then
                    afterimageRecruit(self.kawkaw)
                end
            end
        end
    end

    if self.result_text and not Game.battle.battle_ui.encounter_text:isTyping() and (Input.pressed("confirm") or Input.pressed("menu")) then
        if self.flowery_mode then
            self:moveOutRecruits()
        end
        self:clearText()
        Game.battle:finishAction()
        self:remove()
    end
end

function ShiIntimidate:draw()
    local x, y = 320, 220
    local r, g, b = ColorUtils.unpackColor(COLORS.black)

    Draw.setColor(r, g, b, self.alpha3 / 1.4)
    Draw.rectangle("fill", 0, y - 42, SCREEN_WIDTH + 1, 80 + 42 + 1)
    r, g, b = ColorUtils.unpackColor(COLORS.white)
    Draw.setColor(r, g, b, 1)

    if self.box_scale_x < 0.5 and self.con == 0 then
        self.box_scale_x = self.box_scale_x + 0.05 * DTMULT
    end

    super.draw(self)

    Draw.setColor(r, g, b, self.alpha1)
    Draw.draw(self.box, x, y, 0, self.box_scale_x, self.box_scale_y, 273, 57)

    love.graphics.setFont(self.font)

    if self.alpha2 < 1 and self.con == 0 then
        self.alpha2 = self.alpha2 + 0.1 * DTMULT
    end

    if self.con == 0 then
        Draw.setColor(r, g, b, self.alpha2)
        love.graphics.print("HIT IT!", x - 42, y + 40)

        Draw.setColor(r, g, b, self.alpha3)
        Draw.draw(self.bar, (x + self.bar_x) - 137 - 7 - 60, y - 17, 0, 1, 1)
    end
end

return ShiIntimidate