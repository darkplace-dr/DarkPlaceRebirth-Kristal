local LightAttackBox, super = Class(Object)

function LightAttackBox:init(x, y)
    super.init(self, x, y)

    self.arena = Game.battle.arena

    self.target_sprite = Game.battle.multi_mode and Sprite("ui/lightbattle/target_multi") or Sprite("ui/lightbattle/target")
    self.target_sprite:setOrigin(0.5, 0.5)
    self.target_sprite:setPosition(self.arena:getRelativePos(self.arena.width / 2, self.arena.height / 2))
    self.target_sprite.layer = LIGHT_BATTLE_LAYERS["above_arena"]
    if not Game:isLight() then
        self.target_sprite:addFX(ShaderFX("hsv", {hue_shift = 180}))
    end
    Game.battle:addChild(self.target_sprite)

    self.bolt_target = Game.battle.multi_mode and self.arena.x / 2 - 34 or self.arena.x

    self.shoe_finished = 0
    self.attackers = Game.battle.normal_attackers
    self.lanes = {}

    self.timer = 0

    self.done = nil
end

function LightAttackBox:createBolts()
    self.shoe_finished = 0
    local offset = 0
    local last_offset = 0
    for i,battler in ipairs(Utils.shuffle(self.attackers)) do
        local lane = {}
        lane.battler = battler
        lane.bolts = {}
        lane.weapon = battler.chara:getWeapon()
        lane.speed = lane.weapon and lane.weapon.getLightBoltSpeed and lane.weapon:getLightBoltSpeed() or 11 + (not Game.battle.multi_mode and Utils.random(0, 2, 1) or 0)
        lane.acceleration = lane.weapon and lane.weapon.getLightBoltAcceleration and lane.weapon:getLightBoltAcceleration() or 0
        lane.attacked = false
        lane.score = 0
        lane.stretch = nil
        lane.direction = Game.battle.multi_mode and "left" or lane.weapon and lane.weapon.getLightBoltDirection and lane.weapon:getLightBoltDirection() or Utils.pick({"right", "left"})

        if (lane.weapon and lane.weapon.getLightBoltCount and lane.weapon:getLightBoltCount() or 1) > 1 then
            lane.attack_type = "shoe"
        else
            lane.attack_type = "slice"
        end

        offset = offset + last_offset
        local randomizer = #self.attackers == 1 and 118 or 118 - offset
        last_offset = Utils.pick{0, 11, 22} * 5
        local start_x
        if lane.direction == "left" then
            start_x = (self.target_sprite.x + self.target_sprite.width / 1.8) - (Game.battle.multi_mode and randomizer or 0)
        elseif lane.direction == "right" then
            start_x = (self.target_sprite.x - self.target_sprite.width / 1.8) + (Game.battle.multi_mode and randomizer or 0)
        else
            error("Invalid attack direction")
        end

        for i = 1, lane.weapon and lane.weapon.getLightBoltCount and lane.weapon:getLightBoltCount() or 1 do
            local bolt
            local scale_y = 1 / #self.attackers
            local sprite_height = 128 * scale_y
            local y = 320 + (sprite_height * (Utils.getIndex(self.attackers, lane.battler) - 1)) - (#self.attackers - 1) * sprite_height / 2
            if i == 1 then
                if lane.direction == "left" then
                    bolt = LightAttackBar(start_x + (lane.weapon and lane.weapon.getLightBoltStart and lane.weapon:getLightBoltStart() or -16), y, battler, scale_y)
                else
                    bolt = LightAttackBar(start_x - (lane.weapon and lane.weapon.getLightBoltStart and lane.weapon:getLightBoltStart() or -16), y, battler, scale_y)
                end
            else
                if lane.direction == "left" then
                    bolt = LightAttackBar(start_x + (lane.weapon and lane.weapon.getLightMultiboltVariance and lane.weapon:getLightMultiboltVariance(i - 1) or 94 + 110 * (i - 2)), y, battler, scale_y)
                else
                    bolt = LightAttackBar(start_x - (lane.weapon and lane.weapon.getLightMultiboltVariance and lane.weapon:getLightMultiboltVariance(i - 1) or 94 + 110 * (i - 2)), y, battler, scale_y)
                end
                bolt.sprite:setSprite(bolt.inactive_sprite)
            end
            bolt.target_magnet = 0
            bolt.layer = LIGHT_BATTLE_LAYERS["above_arena"] + 1
            table.insert(lane.bolts, bolt)
            Game.battle:addChild(bolt)
        end
        table.insert(self.lanes, lane)
    end
end

function LightAttackBox:getClose(battler)
    if battler.attack_type == "shoe" then
        return (battler.bolts[1].x - self.bolt_target) / battler.speed
    elseif battler.attack_type == "slice" then
        return battler.bolts[1].x - self.bolt_target
    end
end

function LightAttackBox:getFirstBolt(battler)
    return battler.bolts[1].x - self.bolt_target
end

function LightAttackBox:evaluateHit(battler, close)
    if close < 1 then
        return 110
    elseif close < 2 then
        return 90
    elseif close < 3 then
        return 80 
    elseif close < 4 then
        return 70
    elseif close < 5 then
        return 50
    elseif close < 10 then
        return 40
    elseif close < 16 then
        return 20
    elseif close < 22 then
        return 15
    elseif close < 28 then
        return 10
    else
        return 0
    end
end

function LightAttackBox:checkAttackEnd(battler, score, bolts, close)
    if #bolts == 0 then
        if battler.attack_type == "shoe" then
            self.shoe_finished = self.shoe_finished + 1
            
            if battler.weapon and battler.weapon:getLightBoltCount() > 4 then
                score = score / battler.weapon:getLightBoltCount() * 4
            end
            
            if score > 430 then
                score = score * 1.8
            end
            if score >= 400 then
                score = score * 1.25
            end
        end
        battler.attacked = true
        if self.shoe_finished >= #self.attackers then
            self.fading = true
        end
        return score
    end
end

function LightAttackBox:hit(battler)
    local bolt = battler.bolts[1]
    bolt:resetPhysics()
    if battler.weapon and battler.weapon.onLightBoltHit then
        battler.weapon:onLightBoltHit(battler)
    end
    if battler.attack_type == "shoe" then
        local close = math.floor(math.abs(self:getClose(battler)) * (Game.battle.multi_mode and self:getClose(battler) <= -20 and 3 or 1))

        local eval = self:evaluateHit(battler, close)
        
        if battler.weapon and battler.weapon.scoreHit then
            battler.score = battler.weapon:scoreHit(battler, battler.score, eval, close)
        else
            battler.score = battler.score + eval
        end

        bolt:burst()

        if close < 1 then
            bolt.x = self.bolt_target
            Assets.stopAndPlaySound("victor")
            bolt.perfect = true
        elseif close < 5 then
            Assets.stopAndPlaySound("hit")
            bolt.sprite:setColor(128/255, 1, 1)
        else
            bolt.sprite:setColor(192/255, 0, 0)
        end

        table.remove(battler.bolts, 1)
        if #battler.bolts > 0 then
            battler.bolts[1].sprite:setSprite(bolt.active_sprite)
        end

        return self:checkAttackEnd(battler, battler.score, battler.bolts, close), Utils.clamp(battler.score / battler.weapon:getLightBoltCount() / 110 * 1.2, 0.5, 1)
    elseif battler.attack_type == "slice" then
        battler.score = math.floor(math.abs(self:getClose(battler)) * (Game.battle.multi_mode and self:getClose(battler) <= -20 and 3 or 1))
        if battler.score == 0 then
            battler.score = 1
        end

        battler.stretch = (self.target_sprite.width - battler.score) / self.target_sprite.width

    if Kristal.getLibConfig("magical-glass", "deltatraveler_crits") then
        bolt:burst()
        if battler.score == 1 then
            Assets.playSound("criticalswing", 0.8)
            bolt.sprite:setColor(Utils.lerp(COLORS.white, COLORS.yellow, 0.8))
        end
    else
        bolt:flash()
    end

        battler.attacked = true
    
        return battler.score, battler.stretch
    end
end

function LightAttackBox:checkMiss(battler)
    if battler.attack_type == "shoe" then
        if battler.direction == "left" then
            return self:getClose(battler) < -(battler.weapon and battler.weapon.getLightAttackMissZone and battler.weapon:getLightAttackMissZone() or 2)
        else
            return self:getClose(battler) > (battler.weapon and battler.weapon.getLightAttackMissZone and battler.weapon:getLightAttackMissZone() or 2)
        end
    elseif battler.attack_type == "slice" then
        return (battler.direction == "left" and self:getClose(battler) - (Game.battle.multi_mode and self.arena.x / 2 + 34 + 3 or 0) <= -(battler.weapon and battler.weapon.getLightAttackMissZone and battler.weapon:getLightAttackMissZone() or 280) or (battler.direction == "right" and self:getClose(battler) - (Game.battle.multi_mode and self.arena.x / 2 + 34 - 3 or 0) >= (battler.weapon and battler.weapon.getLightAttackMissZone and battler.weapon:getLightAttackMissZone() or 280)))
    end
end

function LightAttackBox:miss(battler)
    if battler.attack_type == "shoe" then
        battler.bolts[1]:fade(battler.speed, battler.direction)

        if #battler.bolts > 1 then
            battler.bolts[2].sprite:setSprite(battler.bolts[2].active_sprite)
        end
    else
        battler.bolts[1]:remove()
    end
    table.remove(battler.bolts, 1)
    return self:checkAttackEnd(battler, battler.score, battler.bolts)
end

function LightAttackBox:update()
    super.update(self)
    
    if Game.battle == nil then return end -- prevents a crash
    
    self.timer = self.timer + DTMULT
    
    if self.timer >= 7 and #self.lanes == 0 then
        self:createBolts()
    end
    
    if #self.lanes ~= 0 or #self.attackers == #Game.battle.auto_attackers then

        self.done = true

        for _,battler in ipairs(self.lanes) do
            if not battler.attacked then
                self.done = false
            end
        end

        if not self.done then
            for _,lane in ipairs(self.lanes) do
                local acceleration = (lane.acceleration * (lane.speed / 11)) / 10
                if lane.direction == "right" then
                    for _,bolt in ipairs(lane.bolts) do
                        if not bolt.hit then
                            if acceleration > 0 then
                                if bolt.x >= self.bolt_target - lane.speed and bolt.target_magnet < 1 then
                                    if not bolt.last_speed then
                                        bolt.last_speed = bolt.physics.speed_x
                                    end
                                    bolt:resetPhysics()
                                    bolt.x = self.bolt_target
                                    bolt.target_magnet = bolt.target_magnet + DTMULT
                                else
                                    if bolt.last_speed then
                                        bolt.physics.speed_x = bolt.last_speed
                                        bolt.last_speed = nil
                                    end
                                    bolt.physics.gravity = acceleration
                                    bolt.physics.gravity_direction = math.pi*2
                                end
                            else
                                bolt:move((lane.speed) * DTMULT, 0)
                            end
                        end
                    end
                elseif lane.direction == "left" then
                    for _,bolt in ipairs(lane.bolts) do
                        if not bolt.hit then
                            if acceleration > 0 then
                                if bolt.x <= self.bolt_target + lane.speed and bolt.target_magnet < 1 then
                                    if not bolt.last_speed then
                                        bolt.last_speed = bolt.physics.speed_x
                                    end
                                    bolt:resetPhysics()
                                    bolt.x = self.bolt_target
                                    bolt.target_magnet = bolt.target_magnet + DTMULT
                                else
                                    if bolt.last_speed then
                                        bolt.physics.speed_x = bolt.last_speed
                                        bolt.last_speed = nil
                                    end
                                    bolt.physics.gravity = acceleration
                                    bolt.physics.gravity_direction = math.pi
                                end
                            else
                                bolt:move((-lane.speed) * DTMULT, 0)
                            end
                        end
                    end
                end
            end
        end
        
        if Game.battle.cancel_attack or self.fading then
            if self.shoe_finished < #self.attackers or #self.attackers == 0 then
                self.target_sprite.scale_x = self.target_sprite.scale_x - 0.06 * DTMULT
            end
            self.target_sprite.alpha = self.target_sprite.alpha - 0.08 * DTMULT
            if self.target_sprite.scale_x < 0.08 or self.target_sprite.alpha < 0.08 then
                Game.battle.timer:after(1, function()
                    self:remove()
                end)
            end
        end
    end
end

function LightAttackBox:draw()

    if DEBUG_RENDER then
        local font = Assets.getFont("main", 16)
        love.graphics.setFont(font)

        local offset = 0
        for _,battler in ipairs(self.lanes) do
            Draw.setColor(1, 1, 1, 1)
            if battler.bolts[1] then
                Game.battle:debugPrintOutline("close: "    .. self:getClose(battler),         0, -200)
            end
            if battler.score then
                Game.battle:debugPrintOutline("score: "    .. battler.score,           0, -200 + 16)
            end
            if battler.stretch then
                Game.battle:debugPrintOutline("stretch: "  .. battler.stretch,         0, -200 + 32)
            end
            Game.battle:debugPrintOutline("attacked: "     .. tostring(battler.attacked), 0, -200 + 48)
            break
        end

    end

    super.draw(self)
end

return LightAttackBox