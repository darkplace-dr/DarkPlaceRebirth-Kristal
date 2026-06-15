local YellowSoul, super = Class(LightSoul)

function YellowSoul:init(x, y, undertale, angle)
    super.init(self, x, y)
    
    self.undertale = undertale ~= false -- whether to use undertale yellow soul
    
    self.rotation = angle or (-math.pi / (self.undertale and 1 or 2))
    self.color = {1, 1, 0}

    -- customizable variables
    self.can_use_bigshots = not self.undertale -- whether the soul can use bigshots
    self.can_use_shots = true -- whether the soul can use normal shots
    self.can_shoot = true -- whether the soul is allowed to shoot in general
    self.charge_speed = 2
    self.allow_cheat = Kristal.getLibConfig("magical-glass", "yellow_soul_allowcheat") -- whether the player is allowed to chain bigshots rapidly

    -- internal variables
    self.hold_timer = 0
    self.charge_sfx = nil
    self.shot_timer = 0
    self.ut_shot_timer = 0

    self:setMonsterSoul(false)
end

function YellowSoul:update()
    super.update(self)
    
    if self.transitioning then
        if self.charge_sfx then
            self.charge_sfx:stop()
            self.charge_sfx = nil
        end
        self.hold_timer = 0
        self.shot_timer = 0
        self.ut_shot_timer = 0
        return
    end
    
    if self.shot_timer > 0 then
        self.shot_timer = MathUtils.approach(self.shot_timer, 0, DTMULT)
    end
    if self.ut_shot_timer > 0 then
        self.ut_shot_timer = MathUtils.approach(self.ut_shot_timer, 0, DTMULT)
    end

    if not self:canShoot() then return end
    
    if Input.pressed("confirm") and self.shot_timer == 0 and self:canUseShots() then -- fire normal shot
        self:fireShot(false)
    end
    if self:canUseBigShots() then
        -- check release before checking hold, since if held is false it sets the timer to 0
        if Input.released("confirm") then -- fire big shot
            if self.hold_timer >= 10 and self.hold_timer < 40 then -- didn't hold long enough, fire normal shot
                self:fireShot(false)
            elseif self.hold_timer >= 40 then -- fire big shot
                if self:canCheat() and Input.down("confirm") then -- they are cheating
                    self:onCheat()
                end
                self:fireShot(true)
            end
            if not self:canCheat() then -- reset hold timer if cheating is disabled
                self.hold_timer = 0
            end
        end

        if Input.down("confirm") then -- charge a big shot
            self.hold_timer = self.hold_timer + DTMULT * self:getChargeSpeed()

            if self.hold_timer >= 20 and not self.charge_sfx then -- start charging sfx
                self.charge_sfx = Assets.getSound("yellowsoul/chargeshot_charge")
                self.charge_sfx:setLooping(true)
                self.charge_sfx:setPitch(0.1)
                self.charge_sfx:setVolume(0)
                local timer = 0
                Game.battle.timer:during(2/3, function()
                    timer = timer + DT
                    if self.charge_sfx then
                        self.charge_sfx:setVolume(MathUtils.rangeMap(timer, 0,2 / 3, 0,0.3))
                    end
                end, function()
                    if self.charge_sfx then
                        self.charge_sfx:setVolume(0.3)
                    end    
                end)
                self.charge_sfx:play()
            end
            if self.hold_timer >= 20 and self.hold_timer < 40 then
                self.charge_sfx:setPitch(MathUtils.rangeMap(self.hold_timer, 20, 40, 0.1, 1))
            end
        else
            self.hold_timer = 0
            if self.charge_sfx then
                self.charge_sfx:stop()
                self.charge_sfx = nil
            end
        end
    end
end

function YellowSoul:draw()
    local r, g, b, a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    local charge_timer = self.hold_timer - 35
    if charge_timer > 0 then
        local scale = math.abs(math.sin(charge_timer / 10)) + 1
        Draw.setColor(r, g, b, a * 0.3)
        Draw.draw(heart_texture, -heart_w / 2 * scale, -heart_h / 2 * scale, 0, scale)

        scale = math.abs(math.sin(charge_timer / 14)) + 1.2
        Draw.setColor(r, g, b, a * 0.3)
        Draw.draw(heart_texture, -heart_w / 2 * scale, -heart_h / 2 * scale, 0, scale)
    end

    local circle_timer = math.min(self.hold_timer - 15, 35)
    if circle_timer > 0 then
        local circle = Assets.getTexture("effects/yellowsoul/charge")
        Draw.setColor(r ,g ,b ,a * (circle_timer / 5))
        for i = 1, 4 do
            local angle = (i * math.pi / 2) - (circle_timer * math.rad(5))
            local x, y = math.cos(angle) * (35 - circle_timer), math.sin(angle) * (35 - circle_timer)
            local scale = MathUtils.rangeMap(circle_timer, 0, 35, 4, 2)
            x, y = x - circle:getWidth() / 2 * scale, y - circle:getHeight() / 2 * scale
            Draw.draw(circle, x, y, 0, scale)
        end
    end

    if charge_timer > 0 then
        self.color = {1, 1, 1, 1}
    end
    
    super.draw(self)

    self.color = {r, g, b, a}
end

function YellowSoul:onRemoveFromStage(stage)
    super.onRemove(self, stage)
    
    if self.charge_sfx then
        self.charge_sfx:stop()
        self.charge_sfx = nil
    end
end

function YellowSoul:getChargeSpeed()
    return self.charge_speed
end

function YellowSoul:canUseBigShots() return self.can_use_bigshots end
function YellowSoul:canUseShots() return self.can_use_shots end
function YellowSoul:canShoot() return self.can_shoot end
function YellowSoul:canCheat() return self.allow_cheat end

function YellowSoul:fireShot(big)
    local shot
    if big then
        shot = Game.battle:addChild(YellowSoulBigShot(self.x, self.y, self.rotation + math.pi / 2))
        Assets.playSound("yellowsoul/chargeshot_fire")
        self.shot_timer = 5 -- delay normal shots after a bigshot
    elseif self.undertale then
        if #Game.stage:getObjects(YellowSoulShotUndertale) > 0 and self.ut_shot_timer > 0 then return end -- only allow 1 at once or after half a second
        local radius = 2
        local px = math.sin(self.rotation) * radius
        local py = -math.cos(self.rotation) * radius
        shot = Game.battle:addChild(YellowSoulShotUndertale(self.x + px, self.y + py, self.rotation + math.pi / 2))
        Assets.playSound("yellowsoul/heartshot_ut")
        self.ut_shot_timer = 15
    else
        if #Game.stage:getObjects(YellowSoulShot) >= 3 then return end -- only allow 3 at once
        shot = Game.battle:addChild(YellowSoulShot(self.x, self.y, self.rotation + math.pi / 2))
        Assets.playSound("yellowsoul/heartshot")
    end
end

function YellowSoul:onCheat()
    Game.battle.encounter.yellow_funnycheat = Game.battle.encounter.yellow_funnycheat + 1
end

return YellowSoul