-- Handles Winglade's aim attack separately
local WingladeAim, super = Class(Object)

local function approachCurve(val, target, amount)
    return Utils.approach(val, target, math.max(0.1, math.abs(target - val) / amount) * DTMULT)
end

function WingladeAim:init(attacker, wave)
    super.init(self)

    attacker:shiftOrigin(0.5, 0.5)

    self.wave = wave
    self.attacker = attacker

    self.attacker_init_x = attacker.x
    self.attacker_init_y = attacker.y
    
    self.anchor_x_offset = 240
    self.anchor_x = 320 + self.anchor_x_offset
    self.anchor_y = attacker.y
    self.save_x = attacker.x
    self.save_y = attacker.y
    self.temp_x = self.anchor_x
    self.temp_y = self.anchor_y
    self.target_x = attacker.x
    self.target_y = attacker.y
    self.timer = 0
    self.delay_timer = 0
    self.range = 30
    self.temp_angle = 0
    self.save_angle = attacker.rotation
    self.turn = 4
    self.original_layer = attacker.layer

    self.first_turn = false
    self.green_flash = false
    self.wave_end = false

    self.code_1_executed = false
    self.code_2_executed = false
    self.code_3_executed = false
    self.code_4_executed = false
    self.code_5_executed = false

    self.reset = false
    self.attacker.rotation = math.rad(360)

    attacker:setAnimation("stare")
    attacker:setLayer(BATTLE_LAYERS["above_arena"])

    if #wave:getAttackers() > 1 then
        for index, attacker_check in ipairs(wave:getAttackers()) do
            if attacker_check == attacker and index % 2 == 0 then
                self.timer = -20
                break
            end
        end
    end
end

function WingladeAim:spawnBullet(...)
    return self.wave:spawnBullet(...)
end

function WingladeAim:update()
    super.update(self)

    self.timer = self.timer + DTMULT
    if Game.battle.arena then self.anchor_x = Game.battle.arena.x + self.anchor_x_offset end

    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
    if (remaining_time < 12/30 or self.wave_end) and not self.reset then
        self.temp_x = self.attacker_init_x
        self.temp_y = self.attacker_init_y
        self.attacker.physics.speed = 0
        self.attacker.physics.direction = 0
        self.timer = 0
        self.reset = true
    end

    if self.reset then
        self.attacker.rotation = Utils.lerp(self.attacker.rotation, 0, DTMULT * self.timer / 12) % math.rad(360)
    end

    local attackers = #Game.battle.enemies
    local wave_attackers = #self.wave:getAttackers()
    if not self.reset then
        if attackers == wave_attackers then
            if attackers == 1 then
                self.range = 100
                self.anchor_y = Game.battle.arena.y
            end
            if attackers == 2 then
                self.range = 50
                if self.wave:getAttackers()[1] == self.attacker then
                    self.anchor_y = Game.battle.arena.y - 60
                elseif self.wave:getAttackers()[2] == self.attacker then
                    self.anchor_y = Game.battle.arena.y + 60
                end
            end
        end

        if self.timer >= 24 and not self.code_1_executed then
            self.code_1_executed = true
            self.temp_x = self.anchor_x + Utils.random(-20, 60, 1)
            self.temp_y = self.anchor_y + Utils.random(-self.range, self.range, 1)
            if wave_attackers < 2 or Utils.random(0, 2, 1) > 0 then
                self.temp_angle = Utils.angle(self.temp_x, self.temp_y, Game.battle.soul.x, Game.battle.soul.y) + math.rad(Utils.random(-6, 6, 1))
            else
                self.temp_angle = Utils.angle(self.temp_x, self.temp_y, Game.battle.arena.x - Game.battle.arena.width / 2, Game.battle.arena.y)
            end
            self.temp_angle = self.temp_angle % math.rad(360)
            self.turn = Utils.lerp(self.attacker.rotation, self.temp_angle - math.rad(90), 10 * DTMULT) % math.rad(360)
        end
        
        if self.timer >= 19 and not self.code_2_executed then
            self.code_2_executed = true
            self.save_angle = self.attacker.rotation
        end

        if self.timer >= 19 and self.timer <= 24 and not self.first_turn then
            self.attacker.rotation = Utils.lerp(self.attacker.rotation, self.save_angle + math.rad(30), (self.timer - 19) / 5 * DTMULT)
        end
        
        if self.timer >= 24 and self.timer < 34 then
            self.first_turn = true
            self.attacker.rotation = Utils.lerp(self.attacker.rotation, self.temp_angle - math.rad(90), (self.timer - 24) / 10 * DTMULT)
        end

        local fx = self.attacker.sprite:getFX('colormaskgreen')

        if self.timer >= 34 and self.timer < 39 then
            self.attacker.physics.direction = self.temp_angle
            self.attacker.physics.speed = self.attacker.physics.speed - 2 * DTMULT
            if not self.code_5_executed then
                self.code_5_executed = true
                self.save_x = self.attacker.x
                self.save_y = self.attacker.y
                self.target_x = self.attacker.x + math.cos(self.attacker.physics.direction) * 100
                self.target_y = self.attacker.y + math.sin(self.attacker.physics.direction) * 100
            end
            if fx then fx.amount = fx.amount + 0.2 * DTMULT end
        end

        if self.timer >= 39 and self.timer <= 42 then
            self.attacker.physics.speed = 0
            self.attacker.x = Utils.lerp(self.save_x, self.target_x, (self.timer - 39) / 4)
            self.attacker.y = Utils.lerp(self.save_y, self.target_y, (self.timer - 39) / 4)
            if fx then fx.amount = math.max(fx.amount - 0.4 * DTMULT, 0) end
            if not self.code_3_executed then
                self.code_3_executed = true
                Assets.playSound('motor_upper_quick_high')
                self.wave.timer:every(1/30, function()
                    if self.timer > 41 or self.reset then return false end
                    self.attacker.sprite:addChild(AfterImage(self.attacker.sprite, 0.4, 0.04))
                end)
            end
        end

        if self.timer >= 42 and not self.code_4_executed then
            self.code_4_executed = true
            local spawn_x_middle = self.attacker.x + math.cos(self.temp_angle) * 24
            local spawn_y_middle = self.attacker.y + math.sin(self.temp_angle) * 24
            local range = 1
            if attackers == wave_attackers then range = 2 end
            local speed = (3.75 - (0.5 * attackers)) + (0.25 * wave_attackers)
            local friction = -0.035 + 0.015
            for i = -range, range do
                local spawn_x = spawn_x_middle + math.cos(self.temp_angle + math.rad(155) * Utils.sign(i)) * math.abs(i) * 40
                local spawn_y = spawn_y_middle + math.sin(self.temp_angle + math.rad(155) * Utils.sign(i)) * math.abs(i) * 40
                local angle = self.attacker.rotation + math.rad(3 * math.abs(i) + (attackers * 3)) * Utils.sign(i)
                local speed = (3.75 + math.abs(i) * 3.5 - (0.5 * attackers)) + (0.25 * wave_attackers)
                local bullet = self:spawnBullet("winglade/batstab", spawn_x, spawn_y, angle, speed, friction)
                bullet.physics.direction = self.attacker.physics.direction
            end
        end

        local timer_limit
        if attackers == wave_attackers then
            if attackers == 1 then
                timer_limit = 48
            else
                timer_limit = 64
            end
        else
            timer_limit = 48
        end

        if self.timer > timer_limit then
            self.attacker.physics.speed = 0
            self.timer = 20
            self.code_1_executed = false
            self.code_2_executed = falses
            self.code_3_executed = false
            self.code_4_executed = false
            self.code_5_executed = false
        end
    end

    if self.attacker.physics.speed == 0 then
        if self.timer > 42 then
            self.attacker.y = approachCurve(self.attacker.y, self.attacker.y + math.sin(self.timer / 10) * -0.8, 12)
        elseif self.timer < 34 then
            self.attacker.x = approachCurve(self.attacker.x, self.temp_x, 8)
            self.attacker.y = approachCurve(self.attacker.y, self.temp_y, 8)
        end
    end

    if
        self.reset and
        math.abs(self.attacker.x - self.attacker_init_x) <= 1 and
        math.abs(self.attacker_init_y - self.attacker_init_y) <= 1 and
        self.attacker.rotation == 0
    then
        self.attacker.x = self.attacker_init_x
        self.attacker.y = self.attacker_init_y
        self:remove()
    end
end

function WingladeAim:beforeEnd()
    self.wave_end = true
    if self.attacker:canSpare() then self.attacker:onSpareable()
    else self.attacker:setAnimation("idle") end
    self.attacker:setLayer(self.original_layer)
end

return WingladeAim