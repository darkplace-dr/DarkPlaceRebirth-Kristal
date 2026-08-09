-- Handles Winglade's arena circling attack separately
local WingladeCircle, super = Class(Object)

function WingladeCircle:init(attacker, wave)
    super.init(self)

    attacker:shiftOrigin(0.5, 0.5)

    self.wave = wave
    self.attacker = attacker

    self.move_factor = 12
    self.anim_timer = 0
    self.timer = 0
    self.action = 0
    self.target_angle = 0
    self.target_dist = 160
    self.turn_rate = 4
    self.reset = false
    self.start_x = attacker.x
    self.start_y = attacker.y
    self.target_x = 0
    self.target_y = 0
    self.original_layer = attacker.layer
    self.timer_shoot = 17
    self.alpha_set = false
    self.shoot_counter = 0

    attacker:setAnimation("retract")
    attacker:setLayer(BATTLE_LAYERS["above_arena"])

    if #wave:getAttackers() > 1 then
        for index, attacker_check in ipairs(wave:getAttackers()) do
            if attacker_check == attacker then
                self.target_angle = 360 * (index / #wave:getAttackers())
                break
            end
        end
    end
end

function WingladeCircle:spawnBullet(...)
    return self.wave:spawnBullet(...)
end

function WingladeCircle:update()
    super.update(self)
    if self.action == 0 then
        self.anim_timer = self.anim_timer + DTMULT
        if self.anim_timer >= 10 then
            self.anim_timer = 0
            self.action = 1
        end
    end

    if self.action == 2 and self.anim_timer < 10 then
        self.anim_timer = Utils.approach(self.anim_timer, 10, DTMULT)
    end
    
    self.timer = self.timer + DTMULT

    self.move_factor = MathUtils.approachCurveDTMULT(self.move_factor, 0, 15)
    self.target_angle = self.target_angle + self.turn_rate * DTMULT

    if self.reset then
        self.action = 2
        self.target_x = self.start_x
        self.target_y = self.start_y
    else
        self.target_x = Game.battle.arena.x + math.cos(math.rad(self.target_angle)) * self.target_dist
        self.target_y = Game.battle.arena.y + 64 + math.sin(math.rad(self.target_angle)) * self.target_dist
    end

    if self.action == 2 then self.move_factor = 4 end

    self.attacker.x = MathUtils.approachCurveDTMULT(self.attacker.x, self.target_x, self.move_factor)
    self.attacker.y = MathUtils.approachCurveDTMULT(self.attacker.y, self.target_y, self.move_factor)

    local sprite = self.attacker.sprite
    local halo_fx, eye_white_fx, eye_pupil_fx = sprite.halo:getFX('colormaskwhite'), sprite.eye_white:getFX('colormaskwhite'), sprite.eye_pupil:getFX('colormaskwhite')
    if halo_fx then halo_fx.amount = halo_fx.amount - 0.2 * DTMULT end
    if eye_white_fx then eye_white_fx.amount = eye_white_fx.amount - 0.2 * DTMULT end
    if eye_pupil_fx then eye_pupil_fx.amount = eye_pupil_fx.amount - 0.2 * DTMULT end

    local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
    if self.timer >= self.timer_shoot - 10 and remaining_time >= 18/30 and not self.alpha_set and not self.reset then
        self.alpha_set = true
        if halo_fx then halo_fx.amount = 1.4 end
        if eye_white_fx then eye_white_fx.amount = 1.4 end
        if eye_pupil_fx then eye_pupil_fx.amount = 1.4 end
        Assets.playSound("bell_bounce_short", 0.5)
    end
    local total_enemies = #Game.battle:getActiveEnemies()
    if self.timer >= math.floor(self.timer_shoot / (total_enemies == 1 and 2 or 2/3)) and remaining_time >= 18/30 and not self.reset then
        Assets.playSound('motor_swing_down')
        local x_pos, y_pos = self.attacker.x, self.attacker.y - 16
        local x_soul, y_soul = Game.battle.soul.x, Game.battle.soul.y
        local angle = Utils.angle(x_pos, y_pos, x_soul, y_soul)
        if total_enemies == 1 and ((self.shoot_counter > 0 and MathUtils.randomInt(0, 2) > 0) or self.shoot_counter > 2) then
            angle = angle + math.rad(TableUtils.pick({-35, -20, 20, 35}))
            self.shoot_counter = self.shoot_counter - 1
        else
            self.shoot_counter = self.shoot_counter + 1
        end
        local bullet = self:spawnBullet("winglade/ring", x_pos, y_pos, angle, 7.5)
        bullet:setLayer(self.attacker.layer - 0.01)
        self.timer = 0
        self.alpha_set = false
    end

    if self.reset and self.attacker.x == self.target_x and self.attacker.y == self.target_y then self:remove() end
end

function WingladeCircle:beforeEnd()
    self.reset = true
    if self.attacker:canSpare() then self.attacker:onSpareable()
    else self.attacker:setAnimation("idle") end
    self.attacker:setLayer(self.original_layer)
end

return WingladeCircle