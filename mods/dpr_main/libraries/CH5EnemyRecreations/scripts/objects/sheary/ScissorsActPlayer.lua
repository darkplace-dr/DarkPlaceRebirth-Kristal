local ScissorsActPlayer, super = Class(Sprite)

function ScissorsActPlayer:init(x, y, controller)
    super.init(self, "ui/battle/cut/scissor", x, y)

    self:setScale(2)
    self:setOriginExact(14, 16)

    self.physics.match_rotation = true

    self.controller = controller

    self.cuttimer = 0
    self.spd = 2
    self.linex1 = self.x
    self.liney1 = self.y
    self.linex2 = 0
    self.liney2 = 0
    self.linecount = 0
    self.saloncut = self.controller.saloncut or false
    self.valuecut = self.controller.valuecut or false
    self.hypercut = self.controller.hypercut or false
    self.haircut = {}
    for _, battler in ipairs(Game.battle.party) do
        self.haircut[battler.chara.id] = false
    end

    if self.valuecut then
        self.spd = 3
    end
    if self.hypercut then
        self.spd = 4
    end
end

function ScissorsActPlayer:checkBattlerCollision()
    for _, battler in ipairs(Game.battle.party) do
        if battler and battler.chara:getHealth() > 0 and not self.haircut[battler.chara.id] then
            local x, y = battler:getRelativePos()
            if battler.chara.id == "kris" then
                if self.x > x and self.x < x + 40 and self.y > y + 5 and self.y < y + 70 then
                    self.haircut[battler.chara.id] = true
                    self:onBattlerCollision(battler)
                end
            elseif battler.chara.id == "susie" then
                if self.x > x + 22 and self.x < x + 62 and self.y > y + 5 and self.y < y + 60 then
                    self.haircut[battler.chara.id] = true
                    self:onBattlerCollision(battler)
                end
            elseif battler.chara.id == "ralsei" then
                if self.x > x + 22 and self.x < x + 62 and self.y > y + 5 and self.y < y + 60 then
                    self.haircut[battler.chara.id] = true
                    self:onBattlerCollision(battler)
                end
            else
                x, y = battler.x, battler.y
                if self.x > x - battler.width and self.x < x + battler.width and self.y > y - battler.height * 2 and self.y < y then
                    self.haircut[battler.chara.id] = true
                    self:onBattlerCollision(battler)
                end
            end
        end
    end
end

function ScissorsActPlayer:onBattlerCollision(battler)
    if battler.chara.id == "kris" then
        Assets.playSound("bump")
        battler.hurt_timer = 0
        if self.saloncut then
            battler:setAnimation("battle/idle")
        end
        battler:setAnimation("battle/hurt")
    elseif battler.chara.id == "susie" then
        Assets.playSound("magicsprinkle")
        local x, y = battler:getRelativePos()
        for i = 0, 7 do
            local cloud = ShinobeetleSmokecloud(x + 35, y + 30)
            cloud.layer = battler.layer + 1
            cloud:setFrame(i + 1)
            cloud:stop()
            cloud.physics.direction = -math.rad(45 + (i * 90))
            cloud.physics.speed = 2 + MathUtils.random(1)
            cloud.alpha = cloud.alpha - MathUtils.random(0.07)
            Game.battle:addChild(cloud)
        end
        local oy = -2 / 2
        battler:setActSprite("party/susie/dark/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -3 - 18, -1 - 2 + oy)
    elseif battler.chara.id == "ralsei" then
        Assets.playSound("magicsprinkle")
        local x, y = battler:getRelativePos()
        for i = 0, 7 do
            local cloud = ShinobeetleSmokecloud(x + 30, y + 30)
            cloud.layer = battler.layer + 1
            cloud:setFrame(i + 1)
            cloud:stop()
            cloud.physics.direction = -math.rad(45 + (i * 90))
            cloud.physics.speed = 2 + MathUtils.random(1)
            cloud.alpha = cloud.alpha - MathUtils.random(0.07)
            Game.battle:addChild(cloud)
        end
        if battler.actor:getSpritePath() == "party/ralsei/dark_ch1" then
            local ox, oy = -2 / 2, -6 / 2
            battler:setActSprite("party/ralsei/dark_ch1/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -3 + ox, -2 + oy)
        else
            local oy = -2 / 2
            battler:setActSprite("party/ralsei/dark/hairs_" .. TableUtils.pick({ 1, 2, 3, 4 }), -2 + 1, -6 + 2 + oy)
        end
    end
end

function ScissorsActPlayer:update()
    if Input.down("up") then
        self.x = self.x + MathUtils.lengthDirX(self.spd, -self.rotation)
        self.y = self.y + MathUtils.lengthDirY(self.spd, -self.rotation)
        self.cuttimer = self.cuttimer + DTMULT
        if self.cuttimer == 2 then
            self:setFrame(1)
        end
        if self.cuttimer == 5 then
            self.linex2 = self.x
            self.liney2 = self.y
            local line = ScissorsLine(self.linex1, self.liney1, self.linex2, self.liney2, self.linecount, self.controller)
            line:setScale(self.spd * 5, 2)
            line.rotation = MathUtils.angle(self.linex1, self.liney1, self.linex2, self.liney2)
            line.color = COLORS.red
            Game.battle:addChild(line)
            self.linecount = self.linecount + 1
            self.linex1 = self.x
            self.liney1 = self.y
            self:setFrame(2)
            self.cuttimer = 0
            Assets.playSound("break1", 0.8, 1.1)
        end
        self.controller.acttimerstart = true
    end

    if self.valuecut then
        if Input.down("left") then
            self.rotation = self.rotation + -math.rad(6)
        end
        if Input.down("right") then
            self.rotation = self.rotation - -math.rad(6)
        end
    elseif self.hypercut then
        if Input.down("left") then
            self.rotation = self.rotation + -math.rad(8)
        end
        if Input.down("right") then
            self.rotation = self.rotation - -math.rad(8)
        end
    else
        if Input.down("left") then
            self.rotation = self.rotation + -math.rad(4)
        end
        if Input.down("right") then
            self.rotation = self.rotation - -math.rad(4)
        end
    end

    if self.x < 0 or self.x > SCREEN_WIDTH or self.y < 0 or self.y > SCREEN_HEIGHT then
        self.controller.truancy = true
        Assets.playSound("crowd_gasp")
        self.controller:finish()
    end

    self:checkBattlerCollision()

    super.update(self)
end

return ScissorsActPlayer
