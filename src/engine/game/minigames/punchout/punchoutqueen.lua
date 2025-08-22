local PunchOutQueen, super = Class(Object)

function PunchOutQueen:init()
    super.init(self, 640, 558, 99, 150)

    self.sprite = Sprite("idle", 0, 0, 99, 150, "minigames/punch_out/queen")
    self.sprite:setOrigin(58/99, 1)
    --self.sprite:play(1/8, true)
    self:addChild(self.sprite)
    self.layer = Game.minigame.rectbg.layer - 0.001

    self.collider = Hitbox(self, self.width/4 - 5, self.height/4, self.width/2 + 10, self.height + 3)

    self.base_x = self.x
    self.base_y = self.y
    self.draw_flip = 1
    self.flipped = 1
    
    self.invincible_l = 0
    self.invincible_r = 0
    self.blocking = -1
    self.make_dizzy = 0
    self.dizzy_timer = 0
    self.no_attack = 0
    self.my_turn = 0

    self.combo = 0
    
    self.state = "IDLE"
    self.state_timer = 0
    self.state_subtimer = 0
    self.state_progress = 0
    self.state_subprogress = 0
    
    self.attack_type = 0
    self.attack_amount = 0
    self.first_quick_punch = 0
    self.janky_pos = true

    self.move_precise_type = -1
    self.move_precise_count = 0
    self.move_precise_max = 0
    self.move_precise_xx = {0,0,0,0,0,0,0,0}
    self.move_precise_yy = {0,0,0,0,0,0,0,0}
    self.move_precise_active = false
    self.move_precise_xorient = 2
    self.move_precise_yorient = 2
    self.hurt_fx1_timer = 0
    self.hurt_fx1_timer2 = 0
    self.move_timer = 0
    
    self.times_hit_in_a_row = 0

    self.force_draw_flip = -1

    self.kick_amount = 1
    self.kick_progress = 0
    self.ohpitch = 0

    self.wheel_count = 0
    self.wheel_spawn = 0
    self.wheel_sound = nil
    self.first_octagon_attack = 0
    self.first_wheel_attack = 0

    self.can_attack = false
    self.flash_timer = 0
    self.white_flash = false
end

function PunchOutQueen:update()
    super.update(self)
    self.state_timer = self.state_timer + DTMULT
    self.state_subtimer = self.state_subtimer + DTMULT
    if self.move_precise_active == true then
        if self.move_precise_count >= self.move_precise_max then
            self.move_precise_active = false
        else
            self.x = self.x + self.move_precise_xx[self.move_precise_count] * self.move_precise_xorient
            self.y = self.y + self.move_precise_yy[self.move_precise_count] * self.move_precise_yorient
            self.move_precise_count = self.move_precise_count + 1
        end
    end
    if self.draw_flip == 1 then
        self.sprite.x = -99
        self.sprite.flip_x = true
    elseif self.draw_flip == 0 then
        self.sprite.x = 0
        self.sprite.flip_x = false
    end
    if self.state == "IDLE" then
        if self.state_subtimer >= 5 and self.state_progress == 0 then
            self.y = self.base_y
            self.physics.speed_y = -6 * 0.7
            self.state_progress = 1
        end
        if self.state_subtimer >= 6 and self.state_progress == 1 then
            self.physics.speed_y = self.physics.speed_y + (0.35 * (2 * 1.6) * 0.7) * DTMULT
            if self.y >= self.base_y then
                local qframe = self.sprite.frame
                if qframe == 1 then
                    self.sprite:setFrame(2)
                else
                    self.sprite:setFrame(1)
                end
                self.physics.speed_y = 0
                self.y = self.base_y
                self.state_subtimer = 3
                self.state_progress = 0
            end
        end
        self.can_attack = true
        if Game.minigame.pacifist == 1 and Game.minigame.round_timer >= 2669 then
            self.can_attack = false
        end
        if Game.minigame.state == "DEAD" or Game.minigame.hero_hp < 1 then
            self.can_attack = false
        end
        if Game.minigame.state == "PACIFIST" then
            self.can_attack = false
        end
        if self.can_attack == true then
            if self.state_timer >= Game.minigame.attack_threshold and Game.minigame.boxing_hero.dead == false then
                if Game.minigame.attack_count_max > 0 then
                    self:setState("ATTACK")
                else
                    self.state_timer = 0
                end
            end
        end
    elseif self.state == "BLOCK" then
        if self.state_timer >= 8 then
            self.sprite:setFrame(1)
        end
        if self.state_timer >= 16 then
            self.state_timer = Game.minigame.attack_threshold
            self:setState("ATTACK")
        end
    elseif self.state == "HIT" then
        if self.times_hit_in_a_row > 1 and Game.minigame.queen_hp > 0 then
            self.invincible_l = 1
            self.invincible_r = 1
            self.state_timer = Game.minigame.attack_threshold
            self.physics.friction = 0
            self.physics.gravity = 0
            self.hurt_fx1_timer = self.hurt_fx1_timer + 1
            if self.hurt_fx1_timer >= 1 and self.state_subprogress == 0 then
                self.state_subprogress = 1
            end
            if self.hurt_fx1_timer > 7 then
                self.hurt_fx1_timer = 1
            end
            if self.hurt_fx1_timer > 0 and self.hurt_fx1_timer < 38 then
                self.move_timer = self.move_timer - 1
                if self.state_subprogress == 1 then
                    if self.hurt_fx1_timer >= 3 then
                        self.state_subprogress = 2
                    end
                    if self.draw_flip == 1 then
                        self.x = self.x + (5 - self.hurt_fx1_timer) * 5
                    end
                    if self.draw_flip == 0 then
                        self.x = self.x - (5 - self.hurt_fx1_timer) * 5
                    end
                    self.y = self.y - (5 - self.hurt_fx1_timer) * 2
                end
                if self.state_subprogress == 2 then
                    self.hurt_fx1_timer2 = self.hurt_fx1_timer2 + 1
                    if self.hurt_fx1_timer2 > 5 then
                        if self.draw_flip == 1 or self.force_draw_flip == 1 then
                            self.x = self.x - 12.5
                        end
                        if self.draw_flip == 0 or self.force_draw_flip == 0 then
                            self.x = self.x + 12.5
                        end
                        self.y = self.y + 12.5
                    end
                    if self.hurt_fx1_timer2 > 7 then
                        self.x = self.base_x
                        self.y = self.base_y
                        self.hurt_fx1_timer = 0
                        self.hurt_fx1_timer2 = 0
                        self.state_subtimer = 0
                        self.state_timer = 0
                        self.state_progress = 2
                        self.state_subprogress = 0
                        self.times_hit_in_a_row = 0
                        self.invincible_l = 0
                        self.invincible_r = 0
                        self.move_timer = 70
                        self.dizzy_timer = 0
                        self.short_combo_end = 0
                        self:setState("ATTACK")
                    end
                end
            end
            return
        end
        --[[if self.act_punch_timer > 0 then
            self.act_punch_timer = self.act_punch_timer + 1
        end]]
        if self.state_timer >= 2 then
            if self.y >= self.base_y then
                self.y = self.base_y
                self.physics.speed_y = 0
            end
        end
        if self.physics.speed_x > 0 and self.x > self.base_x then
            self.physics.speed_x = 0
            self.x = self.base_x
        end
        local hurttime_ext = 20
        if self.combo == 0 then
            local hurttime_ext = 9
        end
        if self.state_timer >= hurttime_ext then
            if self.dizzy_timer <= 15 then
                self.dizzy_timer = 0
                if (self.no_attack >= 3 and self.my_turn == 1) or self.combo == 0 then
                    self.x = self.base_x
                    self.y = self.base_y
                    self.state_timer = Game.minigame.attack_threshold
                    self:setState("ATTACK")
                else
                    self.x = self.base_x
                    self.y = self.base_y
                    local removetimer = self.state_timer
                    self:setState("IDLE")
                    self.state_timer = removetimer
                end
            end
        end
    elseif self.state == "ATTACK" then
        if self.attack_type == "PUNCH" then
            if self.state_progress == 0 then
                self.make_dizzy = 75
                self.blocking = -1
                self.sprite:setSprite("punchready")
                --Game.minigame.draw_arrows_mode = 1
                self.sprite:setFrame(2)
                self.physics.friction = 0
                self.physics.gravity = 0
                if Game.minigame.boxing_hero.last_punched_dir == 0 then
                    self.draw_flip = 1
                    self.force_draw_flip = 1
                elseif Game.minigame.boxing_hero.last_punched_dir == 1 then
                    self.draw_flip = 0
                    self.force_draw_flip = 0
                end
                self.invincible_l = 1
                self.invincible_r = 1
                if self.draw_flip == 0 then
                    self.physics.speed_x = -6
                    self.flipped = -1
                else
                    self.physics.speed_x = 6
                    self.flipped = 1
                end
                self.physics.speed_y = -4
                self.state_subtimer = 0
                self.state_timer = 0
                self.state_progress = 1
            end
            if self.state_progress == 1 then
                self.attack_threshold_a = 10
                self.attack_threshold_b = 15
                self.attack_threshold_c = 18
                self.attack_threshold_d = 50
                self.attack_threshold_e = 50
                local punch_delay = 0
                if self.state_timer >= self.attack_threshold_a / 2 then
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                end
                if self.state_timer >= self.attack_threshold_c / 2 and self.state_subprogress == 0 then
                    Assets.playSound("minigames/punch_out/bell_bc")
                    self.sprite:setFrame(1)
                    self.state_subprogress = 1
                end
                if self.state_timer >= 4 + self.attack_threshold_c / 2 and self.state_subprogress == 1 then
                    self.sprite:setFrame(2)
                    self.state_subprogress = 2
                end
                if self.state_timer >= punch_delay + self.attack_threshold_d / 2 then
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 2
                    self.state_subprogress = 0
                    self.sprite:setSprite("punch")
                    self.sprite:setFrame(1)
                    Assets.playSound("minigames/punch_out/motor_swing_down_bc")
                end
            end
            if self.state_progress == 2 then
                self.attack_success = 0
                self.invincible_l = 1
                self.invincible_r = 1
                if self.state_timer >= DTMULT and self.state_subprogress == 0 then
                    self.y = self.y + 25 * DTMULT
                    self.x = self.x - (6 * self.flipped) * DTMULT
                    if self.state_timer >= 1 then
                        self.state_subprogress = 1
                    end
                end
                if self.state_timer >= 1+DTMULT and self.state_subprogress == 1 then
                    self.y = self.y + 15 * DTMULT
                    self.x = self.x - (4 * self.flipped) * DTMULT
                    if self.state_timer >= 2 then
                        self.state_subprogress = 2
                    end
                end
                if self.state_timer >= 2+DTMULT and self.state_subprogress == 2 then
                    self.y = self.y + 10 * DTMULT
                    self.x = self.x - (2 * self.flipped) * DTMULT
                    if self.state_timer >= 3 then
                        self.state_subprogress = 3
                    end
                end
                if self.state_timer >= 3+DTMULT and self.state_subprogress == 3 then
                    self.y = self.y + 5 * DTMULT
                    self.x = self.x - (2 * self.flipped) * DTMULT
                    if self.state_timer >= 4 then
                        self.sprite:setFrame(2)
                        self.state_subtimer = 0
                        self.state_progress = 3
                        self.state_subprogress = 0
                    end
                end
                if (self.attack_type == 2 or self.attack_type == 3) and self.first_quick_punch == 1 then
                    self.first_quick_punch = 0
                end
            end
            if self.state_progress == 3 then
                if self.state_timer >= 1 and self.state_subprogress == 0 then
                    local attack_hitbox = PunchOutHitbox(self.x/2, (self.y/2)-60, 28, 100)
                    --local attack_hitbox = PunchOutHitbox(100, 100, 100, 100)
                    attack_hitbox.damage = 25
                    if self.attack_variant == 2 or self.attack_variant == 3 then
                        attack_hitbox.damage = 15
                    end
                    attack_hitbox.hurt_length = 16
                    attack_hitbox.inuvln_length = 16
                    attack_hitbox.timer = 2.5
                    attack_hitbox.hit_dir = self.draw_flip
                    Game.minigame:addChild(attack_hitbox)
                    --Game.minigame.draw_arrows_mode = 0
                    self.state_subprogress = 1
                end
                if self.state_timer >= 2 then
                    self.make_dizzy = 45
                    self.invincible_l = 0
                    self.invincible_r = 0
                    self.blocking = -1
                end
                if self.attack_type == 1 or self.attack_type == 2 then
                    self.attack_success = 0
                end
                if self.punch_type == 3 then
                    self.make_dizzy = 50
                end
                if self.state_timer >= (self.attack_threshold_d / 2) - self.attack_success * 10 then
                    self.physics.speed_y = self.physics.speed_y - 12 * DTMULT
                    if self.y <= self.base_y + 20 then
                        self.y = self.base_y
                        self.physics.speed_x = 0
                        self.physics.speed_y = 0
                        self.attack_success = 0
                        self:setState("IDLE")
                    end
                end
            end
        end
        if self.attack_type == "KICK" then
            if self.state_progress == 0 then
                self.blocking = -1
                self.sprite:setSprite("kickready")
                self.sprite:setFrame(1)
                self.physics.friction = 0
                self.physics.gravity = 0
                local src = Assets.playSound("minigames/punch_out/motor_upper_2_bc")
                src:setPitch(0.9)
                if Game.minigame.boxing_hero.last_punched_dir == 0 then
                    self.draw_flip = 1
                    self.force_draw_flip = 1
                elseif Game.minigame.boxing_hero.last_punched_dir == 1 then
                    self.draw_flip = 0
                    self.force_draw_flip = 0
                end
                self.invincible_l = 1
                self.invincible_r = 1
                self.ohpitch = 0
                self.kick_amount = 1
                self.kick_progress = 0
                if self.draw_flip == 0 then
                    if self.kick_amount <= 1 then
                        self.physics.speed_x = -4
                    end
                    self.flipped = -1
                else
                    if self.kick_amount <= 1 then
                        self.physics.speed_x = 4
                    end
                    self.flipped = 1
                end
                self.physics.speed_y = 2
                self.state_timer = 0
                self.state_subtimer = 0
                self.state_progress = 1
                self.state_subprogress = 0
            end
            if self.state_progress == 1 then
                self.flash_timer = Utils.approach(self.flash_timer, 0, DTMULT)  
                if self.flash_timer <= 0 then
                    self.sprite:setFrame(1)
                end
                self.attack_threshold_a = 18
                self.attack_threshold_b = 29
                local kick_delay = 0
                if self.state_timer >= 5 then
                    self.prekick_timer = 0
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.remx = self.x
                    self.remy = self.y
                end
                if self.state_timer >= 10 and self.state_subprogress == 0 then
                    self.sprite:setFrame(2)
                    self.flash_timer = 5
                    self.state_subprogress = 1
                end
                self.kick_turnaround_again = 0
                if self.kick_amount > 1 and self.state_timer >= 7 and self.kick_progress == 0 then
                    self.kick_turnaround_again = 1
                    self.kick_progress = 1
                end
                if self.kick_amount > 2 and self.state_timer >= 14 and self.kick_progress == 1 then
                    self.kick_turnaround_again = 1
                    self.kick_progress = 2
                end
                if self.kick_amount > 3 and self.state_timer >= 21 and self.kick_progress == 2 then
                    self.kick_turnaround_again = 1
                    self.kick_progress = 3
                end
                if self.kick_turnaround_again == 1 then
                    self.ohpitch = self.ohpitch + 1
                    local src = Assets.playSound("minigames/punch_out/motor_upper_2_bc")
                    src:setPitch(1+(self.ohpitch/10))
                    self.flipped = -self.flipped
                    if self.draw_flip == 0 then
                        self.draw_flip = 1
                        self.force_draw_flip = 1
                    else
                        self.draw_flip = 0
                        self.force_draw_flip = 0
                    end
                    self.sprite:setFrame(2)
                    self.flash_timer = 5
                end
                if self.state_timer >= (25/2) + ((self.kick_amount*14) / 2) - 10 and self.state_subtimer > self.attack_threshold_a then
                    self.prekick_timer = self.prekick_timer + DTMULT
                    if self.prekick_timer <= 4 then
                        self.physics.speed_y = self.physics.speed_y - 1.5 * DTMULT
                    end
                    if self.prekick_timer > 4 then
                        self.physics.speed_y = self.physics.speed_y + 1.5 * DTMULT
                        if self.physics.speed_y > 0 then
                            self.physics.speed_y = 0
                        end
                    end
                end
                if self.state_timer >= (25/2) + ((self.kick_amount*14) / 2) and self.state_timer > self.attack_threshold_b then
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                end
                if self.state_timer >= (25/2) + ((self.kick_amount*14) / 2) and self.state_timer > self.attack_threshold_b+kick_delay then
                    self.kicks_done = 0
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 2
                    self.state_subprogress = 0
                    self.sprite:setSprite("kick")
                    self.sprite:setFrame(2)
                end
            end
            if self.state_progress == 2 then
                self.make_dizzy = 50 + (self.kick_amount * 10)
                if self.state_subtimer >= 1 and self.state_subprogress == 0 then
                    Assets.playSound("minigames/punch_out/heavyswing_bc")
                    local src = Assets.playSound("minigames/punch_out/queenhowl_b_bc")
                    src:setPitch(1+self.kick_amount*0.08-self.kicks_done*0.08)
                    self.attack_success = 0
                    local attack_hitbox = PunchOutHitbox(self.x/2, (self.y/2)-50, 30, 100)
                    attack_hitbox.damage = 40
                    if self.kick_amount == 2 then
                        attack_hitbox.damage = math.floor(attack_hitbox.damage * 0.6)
                    end
                    if self.kick_amount >= 3 then
                        attack_hitbox.damage = math.floor(attack_hitbox.damage * 0.5)
                    end
                    attack_hitbox.hurt_length = 17
                    attack_hitbox.inuvln_length = 17
                    attack_hitbox.timer = 2
                    attack_hitbox.hit_dir = self.draw_flip
                    Game.minigame:addChild(attack_hitbox)
                    self.physics.speed_x = -3 * self.flipped
                    self.physics.speed_y = -8
                    self.state_subprogress = 1
                end
                if self.state_subtimer >= 1 then
                    self.physics.speed_y = self.physics.speed_y + DTMULT
                end
                if self.state_subtimer >= 2 and self.state_subprogress == 1 then
                    self.sprite:setFrame(3)
                    self.invincible_l = 0
                    self.invincible_r = 0
                    self.blocking = -1
                    self.state_subprogress = 2
                end
                if self.state_subtimer >= 7 and self.state_subprogress == 2 then
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 3
                    self.state_subprogress = 0
                    self.kicks_done = self.kicks_done + 1
                    local player_hit_by_kick = 1
                    if self.kicks_done >= self.kick_amount and player_hit_by_kick == 0 and self.kick_amount > 2 then
                        self.state_progress = 5
                        self.physics.speed_x = -2 * self.flipped
                        self.physics.speed_y = -3
                        self.physics.gravity = 1.5
                        self.physics.gravity_direction = math.rad(270)
                    else
                        self.physics.speed_x = 0
                        self.physics.speed_y = 0
                    end
                end
            end
            if self.state_progress == 3 then
                self.sprite:setFrame(3)
                if self.kicks_done < self.kick_amount and self.state_timer >= 6 then
                    self.x = self.remx
                    self.y = self.remy
                    self.flipped = -self.flipped
                    if self.draw_flip == 0 then
                        self.draw_flip = 1
                    else
                        self.draw_flip = 0
                    end
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 4
                    self.state_subprogress = 0
                    self.invincible_l = 1
                    self.invincible_r = 1
                    self.sprite:setFrame(1)
                end
                if self.state_timer >= 27.5 + self.kick_amount*2.5 - self.attack_success*(13+self.kick_amount*2.5) then
                    self.y = self.base_y
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.attack_success = 0
                    self:setState("IDLE")
                end
            end
            if self.state_progress == 4 then
                if self.state_subtimer >= 15 / 2 then
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 2
                    self.state_subprogress = 0
                    self.sprite:setFrame(2)
                end
            end
            if self.state_progress == 5 then
                if self.state_subtimer >= 7 and self.state_subprogress == 0 then
                    self.physics.speed_x = -1 * self.flipped
                    self.physics.speed_y = -8
                    self.physics.gravity = 1.5
                    self.physics.gravity_direction = math.rad(270)
                    self.state_subprogress = 1
                end
                if self.state_subtimer >= 16 and self.state_subprogress == 1 then
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.physics.gravity = 0
                    self.state_subprogress = 2
                end
                if self.state_subtimer >= 28 and self.state_subprogress == 2 then
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.physics.gravity = 0
                    self.state_subprogress = 3
                end
                if self.state_subtimer >= 40 then
                    self.sprite:setSprite("idle")
                    self.sprite:setFrame(1)
                    self.physics.gravity = 0
                    local i = 0
                    repeat
                        if self.x < self.base_x then
                            self.x = self.x + 1
                        end
                        if self.x > self.base_x then
                            self.x = self.x - 1
                        end
                        i = i + 1
                    until i >= 10
                end
                if self.state_subtimer >= 45 then
                    self.y = self.base_y
                    self.physics.speed_x = 0
                    self.physics.speed_y = 0
                    self.physics.gravity = 0
                    self.attack_success = 0
                    self:setState("IDLE")
                end
            end
        end
        if self.attack_type == "WHEEL" then
            if self.state_progress == 0 then
                self.attack_success = 0
                self.invincible_l = 1
                self.invincible_r = 1
                self.blocking = -1
                self.sprite:setSprite("idle")
                --Game.minigame.draw_arrows_mode = 1
                self.sprite:setFrame(2)
                self.physics.speed_y = -1
                self.physics.friction = -0.8
                self.wheel_timer = 10
                self.wheel_count = 0
                self.first_wheel_attack_delay = 0
                if self.first_wheel_attack == 0 then
                    self.first_wheel_attack_delay = 10
                end
                self.state_subtimer = 0
                self.state_timer = 0
                self.state_progress = 1
            end
            if self.state_progress == 1 then
                self.wheel_done = 0
                local wheel_delay = 5
                if self.wheel_count > 0 then
                    wheel_delay = 10
                end
                if self.state_subtimer >= ((25 + wheel_delay) - (self.attack_variant * 9)/2) then
                    self.state_subtimer = 0
                    self:spawnWheel(-215, 255, 1)
                    self:spawnWheel(825, 255, -1)
                    self.wheel_count = self.wheel_count + 1
                    if self.attack_variant == 2 and self.wheel_count >= self.attack_amount + 2 then
                        self.wheel_done = 1
                    end
                    if self.attack_variant ~= 2 and self.wheel_count >= self.attack_amount then
                        self.wheel_done = 1
                    end
                    if self.first_octagon_attack == 0 then
                        self.wheel_done = 1
                    end
                end
                if self.state_timer >= 1 and self.state_subprogress == 0 then
                    local src = Assets.playSound("wing")
                    src:setPitch(0.75+Utils.random(1)/2)
                    self.state_subprogress = 1
                end
                if self.state_timer >= 10 and self.state_subprogress == 1 then
                    self.physics.speed_y = 0
                    self.physics.friction = 0
                    Assets.playSound("minigames/punch_out/queen_laugh_bc", 0.5)
                    self.state_subprogress = 2
                end
                if self.wheel_done == 1 then
                    self.state_subtimer = 0
                    self.state_timer = 0
                    self.state_progress = 2
                    self.state_subprogress = 0
                end
            end
            if self.state_progress == 2 then
                if self.state_timer >= 19 + self.first_wheel_attack_delay then
                    self.invincible_l = 0
                    self.invincible_r = 0
                    self.make_dizzy = 90
                end
                if self.state_timer >= 17 + self.first_wheel_attack_delay then
                    if self.y < self.base_y then
                        self.physics.speed_y = self.physics.speed_y + 2 * DTMULT
                        self.first_wheel_attack = 0
                    else
                        self.physics.speed_x = 0
                        self.physics.speed_y = 0
                        self.y = self.base_y
                        self.x = self.base_x
                    end
                end
                if self.state_timer >= 50 + (self.attack_success * 12.5) + self.first_wheel_attack_delay then
                    self.first_octagon_attack = 1
                    self.attack_success = 0
                    self:setState("IDLE")
                end
            end
        end
    end
end

function PunchOutQueen:setState(state)
    local last_state = self.state
    self.state = state
    self.state_timer = 0
    self.state_subtimer = 0
    self.state_progress = 0
    self.state_subprogress = 0
    self:onStateChange(last_state, state)
end

function PunchOutQueen:onStateChange(old, new)
    if new == "IDLE" then
        self.x = self.base_x
        self.y = self.base_y
        self.physics.speed_x = 0
        self.physics.speed_y = 0
        self.sprite:setSprite("idle")
        self.sprite:setFrame(1)
        self.next_draw_flip = Utils.pick({0, 1})
        self.blocking = self.next_draw_flip
        self.make_dizzy = 0
    elseif new == "BLOCK" then
        self.x = self.base_x
        self.y = self.base_y
        self.save_x = self.x
        self.save_y = self.y
        self.physics.speed_x = 0
        self.physics.speed_y = 0
        self.physics.gravity = 0
        self.physics.friction = 0
        self.sprite:setSprite("block")
        self.sprite:setFrame(2)
        self.invincible_l = 0
        self.invincible_r = 0
    elseif new == "HIT" then
        if self.dizzy_timer <= 0 then
            self.no_attack = self.no_attack + 1
        --else
        --    Assets.playSound("minigames/punch_out/metalhit_bc")]]
        end
        self.blocking = -1
        self.sprite:setSprite("hurt")
        self.sprite:setFrame(1)
        self.physics.speed_x = 0
        self.physics.speed_y = 0
        self.physics.speed = 0
        self.physics.gravity = 0
        self.invincible_l = 0
        self.invincible_r = 0
        self.x = self.base_x
        self.y = self.base_y
        if self.times_hit_in_a_row == 1 then
            self.move_precise_type = Utils.pick({1,2})
            self.move_precise_count = 1
            self.move_precise_max = 9
            self.hurt_fx1_timer = 0
            self.hurt_fx_timer2 = 0
            if self.move_precise_type == 0 then
                self.move_precise_xx = {-12,-6,-2,4,6,10,0,0}
                self.move_precise_yy = {0,0,0,0,0,0,0,0}
            end
            if self.move_precise_type == 1 then
                self.move_precise_xx = {-10,5,-3,2,-1,1,0,0}
                self.move_precise_yy = {-3,-1,1,3,0,0,0,0}
            end
            if self.move_precise_type == 2 then
                self.move_precise_xx = {0,0,0,0,0,0,0,0}
                self.move_precise_yy = {-6,-2,0,0,1,3,4,0}
            end
            if self.draw_flip == 1 then
                self.move_precise_xorient = -2
            else
                self.move_precise_xorient = 2
            end
            self.move_precise_yorient = 2
            self.move_precise_active = true
        end
    elseif new == "ATTACK" then
        self.combo = 0
        self.blocking = 0
        self.physics.speed_x = 0
        self.physics.speed_y = 0
        self.physics.speed = 0
        self.x = self.base_x
        self.times_hit_in_a_row = 0
        Game.minigame:changeAttack(Game.minigame.queen_hp, Game.minigame.queen_hp_max)
        if Game.minigame.attack_count >= Game.minigame.attack_count_max then
            self:setState("IDLE")
            Game.minigame.attack_threshold = 0
            Game.minigame.attack_count = 1
        else
            local count = Game.minigame.attack_count
            self.attack_type = Game.minigame.atk_type_list[count]
            self.attack_amount = Game.minigame.atk_amount_list[count]
            self.attack_variant = Game.minigame.atk_variant_list[count]
            Game.minigame.attack_threshold = Game.minigame.atk_wait_list[count]
            Game.minigame.attack_count = count + 1
        end
    end
end

function PunchOutQueen:spawnWheel(x, y, flip)
    if self.wheel_spawn == 0 and not self.wheel_sound then
        self.wheel_sound = Assets.playSound("minigames/punch_out/chain_extend_bc")
        self.wheel_sound:setLooping(true)
        self.wheel_sound:setVolume(0.37)
    end
    local wheel = PunchOutWheel(x, y)
    local wheel_hitbox = PunchOutHitbox(x, y, 119, 68) -- has to be spawned seperately because otherwise the hitbox rotates incorrecty and screws up??????
    wheel.physics.speed_x = wheel.physics.speed_x * flip
    wheel.graphics.spin = wheel.graphics.spin * flip
    wheel_hitbox.damage = 25
    wheel_hitbox.hit_dodging = true
    wheel_hitbox.hit_ducking = false
    wheel_hitbox.hurt_length = 15
    wheel_hitbox.invuln_length = 20
    wheel_hitbox.timer = 300
    wheel_hitbox.hit_dir = 1
    wheel.wheel_hitbox = wheel_hitbox
    Game.minigame:addEntity(wheel)
    Game.minigame:addChild(wheel_hitbox)
    self.wheel_spawn = self.wheel_spawn + 1
end

function PunchOutQueen:onWheelRemove()
    self.wheel_spawn = self.wheel_spawn - 1
    if self.wheel_spawn <= 0 then
        self.wheel_spawn = 0
        if self.wheel_sound then
            self.wheel_sound:stop()
            self.wheel_sound = nil
        end
    end
end

function PunchOutQueen:tryHurt()
    return true
end

function PunchOutHero:draw()
    super.draw(self)

    if DEBUG_RENDER then
        self.collider:draw(0,1,0,1)
    end
end


return PunchOutQueen
