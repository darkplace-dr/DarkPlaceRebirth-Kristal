local PunchOutHero, super = Class(Object)

function PunchOutHero:init()
    super.init(self, 640, 650, 99, 90)

    self.sprite = Sprite("idle", 0, 0, nil, nil, "minigames/punch_out/hero")
    self.sprite:setOrigin(44/99, 1)
    --self.sprite:play(1/8, true)
    self:addChild(self.sprite)
    self.layer = Game.minigame.rectbg.layer - 0.002

    self.collider = Hitbox(self, -14, -60, 20, 59)
    self.janky_collider = Hitbox(self, -14-self.y/2, -60-self.x/2, 20, 59)

    self.base_x = self.x
    self.base_y = self.y
    self.draw_flip = 1

    self.can_control = false
    self.can_punch = 1
    
    self.dead = false
    
    self.buffer_z = 0
    self.buffer_x = 0
    self.buffer_l = 0
    self.buffer_r = 0
    self.buffer_d = 0
    
    self.state = "IDLE"
    self.state_timer = 0
    self.state_progress = 0

    self.last_punch_side = 0
    
    self.x_shake = 0
    self.dodging = 0
    self.ducking = 0
    
    self.hurt_length = 11
    self.invuln_timer = 0

    self.reset_timer = 0
    self.janky_pos = true

    self.last_punched_dir = -1
    self.times_blocked = 0
    local party = Game.party[1]
    if party and party.icon_color then
        self.sprite.color = party.icon_color
    elseif party and party.color then
        self.sprite.color = party.color
    else
        self.sprite.color = {0, 162/255, 232/255}
    end
end

function PunchOutHero:update()
    super.update(self)
    self.state_timer = self.state_timer + DTMULT
    self.invuln_timer = Utils.approach(self.invuln_timer, 0, DTMULT)
    self.reset_timer = Utils.approach(self.reset_timer, 0, DTMULT)
    if self.can_control == true and self.reset_timer == 0 then
        if Input.pressed("confirm") and self.can_punch then
            self.buffer_z = 5
        end
        if Input.pressed("cancel") and self.can_punch then
            self.buffer_x = 5
        end
        if Input.pressed("down") then
            self.buffer_d = 3
        end
        if Input.pressed("right") then
            self.buffer_r = 3
        end
        if Input.pressed("left") then
            self.buffer_l = 3
        end
    end
    if self.state == "IDLE" then
        if self.buffer_z > 0 then
            self.draw_flip = 0
            self:setState("PUNCH")
        elseif self.buffer_x > 0 then
            self.draw_flip = 1
            self:setState("PUNCH")
        elseif self.buffer_l > 0 then
            self.draw_flip = 1
            self:setState("DODGE")
        elseif self.buffer_r > 0 then
            self.draw_flip = 0
            self:setState("DODGE")
        elseif self.buffer_d > 0 then
            self:setState("DUCK")
        end
        if Input.pressed("up") then
            --self:tryHurt(15, 11, 0, 1)
        end
    elseif self.state == "PUNCH" then
        if self.state_progress == 0 then
            self.hit_attempt = 0
            if Game.minigame.pacifist == 1 then
                Game.minigame.pacifist = 0
            end
            self.x = self.base_x
            self.y = self.base_y
            self.sprite:setSprite("punch")
            self.sprite:setFrame(1)
            self.physics.speed_y = -24
            if self.draw_flip == 1 then
                self.physics.speed_x = 8
            else
                self.physics.speed_x = -8
            end
            self.physics.friction = 4
            local src = Assets.playSound("minigames/punch_out/motor_upper_quick_high_bc")
            src:setPitch(1.25)
            self.state_timer = 0
            self.state_progress = 1
        end
        if self.state_progress == 1 then
            if self.state_timer >= 3 then
                self.physics.speed_x = 0
                self.state_timer = 0
                self.state_progress = 2
            end
        end
        if self.state_progress == 2 then
            self.sprite:setFrame(2)
            self.physics.friction = 1.2
            self.y = self.y - 40
            self.physics.speed_y = -20
            self.state_progress = 3
            self.state_timer = 0
            if self.hit_attempt == 0 then
                self.hit_attempt = 1
                local q_miss = false
                if self.draw_flip == 0 and Game.minigame.boxing_queen.invincible_l == 1 then
                    q_miss = true
                end
                if self.draw_flip == 1 and Game.minigame.boxing_queen.invincible_r == 1 then
                    q_miss = true
                end
                if Game.minigame.queen_hp < 1 then
                    q_miss = true
                end
                if not q_miss then
                    local can_block = false
                    if Game.minigame.boxing_queen.blocking == self.draw_flip and can_block == true then
                        self.y = self.y + 20
                        self.times_blocked = self.times_blocked + 1
                        self.x_shake = 6
                        self.x = self.x - 6
                        self.physics.speed_x = 0
                        self.physics.speed_y = 0
                        self.physics.friction = 0
                        Assets.playSound("minigames/punch_out/bell_bc")
                        Game.minigame.boxing_queen.draw_flip = self.draw_flip
                        Game.minigame.boxing_queen:setState("BLOCK")
                        self.state_progress = 5
                    else
                        Game.minigame.queen_hp = Game.minigame.queen_hp - 30
                        if Game.minigame.boxing_queen.state == "ATTACK" then
                            if Game.minigame.boxing_queen.attack_type == "PUNCH" and Game.minigame.boxing_queen.state_progress == 4 then
                                Game.minigame.queen_hp = Game.minigame.queen_hp - 20
                            end
                            if Game.minigame.boxing_queen.attack_type ~= "PUNCH" then
                                Game.minigame.queen_hp = Game.minigame.queen_hp - 20
                            end
                        end
                        Game.minigame.boxing_queen.combo = 1
                        if Game.minigame.boxing_queen.combo == 1 then
                            Game.minigame.boxing_queen.times_hit_in_a_row = Game.minigame.boxing_queen.times_hit_in_a_row + 1
                        end
                        self.last_punched_dir = self.draw_flip
                        if Game.minigame.boxing_queen.times_hit_in_a_row >= 2 then
                            if Game.minigame.boxing_queen.draw_flip == 0 then
                                Game.minigame.boxing_queen.draw_flip = 1
                            else
                                Game.minigame.boxing_queen.draw_flip = 0
                            end
                        else
                            if self.last_punched_dir == 0 then
                                Game.minigame.boxing_queen.draw_flip = 1
                            else
                                Game.minigame.boxing_queen.draw_flip = 0
                            end
                        end
                        local src = Assets.playSound("minigames/punch_out/punch_ish_1_bc")
                        src:setPitch(1)
                        Game.minigame.boxing_queen:setState("HIT")
                        self.x = self.base_x
                        self.physics.speed_y = 0
                        self.state_timer = 0
                        self.state_progress = 4
                    end
                end
            end
        end
        if self.state_progress == 3 then
            if self.state_timer == 0 then
                Assets.playSound("minigames/punch_out/motor_upper_quick_bc")
            end
            if self.state_timer % 1 == 0 then
                self.physics.speed_y = self.physics.speed_y * 0.81
            end
            if self.physics.speed_y >= -2 then
                self.state_timer = 0
                self.state_progress = 6
                self.physics.speed_y = 6
            end
        end
        if self.state_progress == 4 then
            self.physics.speed_y = 0
            self.physics.speed_x = 0
            self.physics.gravity = 0
            self.physics.friction = 0
            if self.state_timer >= 5 then
                self.state_timer = 0
                self.state_progress = 3
            end
        end
        if self.state_progress == 5 then
            self.physics.speed_y = 0
            self.physics.speed_x = 0
            self.physics.friction = 0
            if self.state_timer % 2 == 1 then
                self.x = self.x + self.x_shake
                if self.x_shake > 0 then
                    self.x_shake = self.x_shake - 1
                end
                if self.x_shake < 0 then
                    self.x_shake = self.x_shake + 1
                end
                self.x_shake = -self.x_shake
                if math.abs(self.x_shake) == 1 then
                    self.x_shake = 0
                end
            end
            if self.state_timer >= 11 then
                self.state_timer = 0
                self.state_progress = 6
                self.buffer_z = 0
                self.buffer_x = 0
                self.buffer_l = 0
                self.buffer_r = 0
                self.buffer_d = 0
            end
        end
        if self.state_progress == 6 then
            self.physics.speed_y = self.physics.speed_y + (6 * DTMULT)
            if self.y >= self.base_y then
                self.physics.speed_y = 0
                self.physics.friction = 0
                self.y = self.base_y
                self.state_timer = 0
                self.state_progress = 7
                self.buffer_z = 0
                self.buffer_x = 0
                self.buffer_l = 0
                self.buffer_r = 0
                self.buffer_d = 0
            end
        end
        if self.state_progress == 7 then
            if self.buffer_z > 0 then
                self.draw_flip = 0
                self:setState("PUNCH")
            elseif self.buffer_x > 0 then
                self.draw_flip = 1
                self:setState("PUNCH")
            elseif self.buffer_l > 0 then
                self.draw_flip = 1
                self.x = self.base_x
                self.y = self.base_y
                self.physics.speed_x = 0
                self.physics.speed_y = 0
                self.physics.friction = 0
                self:setState("DODGE")
            elseif self.buffer_r > 0 then
                self.draw_flip = 0
                self.x = self.base_x
                self.y = self.base_y
                self.physics.speed_x = 0
                self.physics.speed_y = 0
                self.physics.friction = 0
                self:setState("DODGE")
            elseif self.buffer_d > 0 then
                self.x = self.base_x
                self.y = self.base_y
                self.physics.speed_x = 0
                self.physics.speed_y = 0
                self.physics.friction = 0
                self:setState("DUCK")
            else
                self.sprite:setFrame(1)
                if self.state_timer >= 5 then
                    self.state_timer = 0
                    self.state_progress = 0
                    self:setState("IDLE")
                end
            end
        end
    elseif self.state == "DODGE" then
        local long_dodge = 0
        if (self.draw_flip == 1 and Input.down("right")) or (self.draw_flip == 0 and Input.down("left")) then
            long_dodge = 1
        end
        if self.state_progress == 0 then
            self.x = self.base_x
            self.y = self.base_y
            self.sprite:setSprite("dodge")
            if self.draw_flip == 0 then
                self.physics.speed_x = 36
            else
                self.physics.speed_x = -36
            end
            self.state_timer = 0
            self.state_progress = 1
        end
        if self.state_progress == 1 then
            if self.state_timer == 1 then
                self.dodging = 1
            end
            if self.state_timer >= 8 then
                self.dodging = 0
            end
            if self.state_timer % 1 == 0 then
                self.physics.speed_x = self.physics.speed_x * 0.6400000000000001
            end
            if (math.abs(self.physics.speed_x) <= 10 and long_dodge == 0) or math.abs(self.physics.speed_x) <= 0.4 then
                self.state_timer = 0
                self.state_progress = 2
            end
        end
        if self.state_progress == 2 then -- I don't know why they did this LOL
            self.dodging = 0
            self.x = Utils.round(self.x)
            self.state_timer = 0
            self.state_progress = 3
        end
        if self.state_progress == 3 then
            if self.draw_flip == 1 then
                self.physics.speed_x = self.physics.speed_x + 1 * DTMULT
                if long_dodge == 0 then
                    self.physics.speed_x = self.physics.speed_x + 0.6 * DTMULT
                end
                if self.x >= self.base_x + 16 then
                    self.physics.speed_x = 0
                    self.x = self.base_x
                    self.dodging = 0
                    self.state_timer = 0
                    self.state_progress = 4
                end
            else
                self.physics.speed_x = self.physics.speed_x - 1 * DTMULT
                if long_dodge == 0 then
                    self.physics.speed_x = self.physics.speed_x - 0.6 * DTMULT
                end
                if self.x <= self.base_x - 16 then
                    self.physics.speed_x = 0
                    self.x = self.base_x
                    self.dodging = 0
                    self.state_timer = 0
                    self.state_progress = 4
                end
            end
        end
        if self.state_progress == 4 then
            self.state_timer = 0
            self.state_progress = 0
            self:setState("IDLE")
        end
    elseif self.state == "DUCK" then
        local long_duck = 0
        if Input.down("down") then
            long_duck = 1
        end
        if self.state_progress == 0 then
            self.x = self.base_x
            self.y = self.base_y
            self.ducking = 1
            self.sprite:setSprite("duck")
            self.physics.speed_y = 10
            self.state_timer = 0
            self.state_progress = 1
        end
        if self.state_progress == 1 then
            if self.state_timer % 1 == 0 then
                self.physics.speed_y = self.physics.speed_y * 0.81
            end
            if (math.abs(self.physics.speed_y) <= 2 and long_duck == 0) or math.abs(self.physics.speed_y) <= 0.6 then
                self.state_timer = 0
                self.state_progress = 2
            end
        end
        if self.state_progress == 2 then -- Again???
            self.y = Utils.round(self.y)
            self.state_timer = 0
            self.state_progress = 3
        end
        if self.state_progress == 3 then
            self.physics.speed_y = self.physics.speed_y - 1 * DTMULT
            if self.state_timer >= 6 then
                self.ducking = 0
            end
            if self.y <= self.base_y + 6 then
                self.physics.speed_y = 0
                self.y = self.base_y
                self.state_timer = 0
                self.state_progress = 4
            end
        end
        if self.state_progress == 4 then
            self.state_timer = 0
            self.state_progress = 0
            self:setState("IDLE")
        end
    elseif self.state == "HURT" then
        if self.state_progress == 0 then
            Assets.playSound("minigames/punch_out/hurt1_bc")
            Assets.playSound("minigames/punch_out/punchmed_bc")
            Assets.playSound("minigames/punch_out/metalhit_bc")
            self.sprite:setSprite("hurt")
            self.physics.speed_y = 10
            self.physics.friction = 2
            if self.draw_flip == 0 then
                self.physics.speed_x = 6
            else
                self.physics.speed_x = -6
            end
            self.state_timer = 0
            self.state_progress = 1
        end
        if self.state_progress == 1 then
            if self.state_timer >= self.hurt_length then
                self.physics.speed_x = 0
                self.physics.speed_y = 0
                self.physics.friction = 0
                self.state_timer = 0
                self.state_progress = 0
                self:setState("IDLE")
            end
        end   
    end
    if self.draw_flip == 1 then
        self.sprite.x = -99
        self.sprite.flip_x = true
    elseif self.draw_flip == 0 then
        self.sprite.x = 0
        self.sprite.flip_x = false
    end
    --[[if (Game.minigame.boxing_phase == 0 or Game.minigame.boxing_phase == 3) then
        if self.y ~= self.base_y - 35 then
            self.y = Utils.lerp(self.y, self.base_y - 35, 0.5*DTMULT)
            if math.abs(self.y - self.base_y - 35) <= 2 then
                self.y = self.base_y - 35
            end
        end
        if self.x ~= self.base_x - 70 then
            self.x = Utils.lerp(self.x, self.base_x - 70, 0.5*DTMULT)
            if math.abs(self.x - self.base_x - 70) <= 2 then
                self.x = self.base_x - 70
            end
        end
    end
    if Game.minigame.boxing_phase == 1 then
        if self.y ~= self.base_y then
            self.y = Utils.lerp(self.y, self.base_y, 0.5*DTMULT)
            if math.abs(self.y - self.base_y) <= 2 then
                self.y = self.base_y
            end
        end
        if self.x ~= self.base_x then
            self.x = Utils.lerp(self.x, self.base_x, 0.5*DTMULT)
            if math.abs(self.x - self.base_x) <= 2 then
                self.x = self.base_x
            end
        end
    end]]
end

function PunchOutHero:tryHurt(damage, hurt, invuln, flip)
    if Game.minigame.hero_hp <= 0 or self.invuln_timer > 0 then
        return false
    end
    Game.minigame.hero_hp = math.max(Game.minigame.hero_hp - damage, 0)
    self.physics.speed_x = 0
    self.physics.speed_y = 0
    self.physics.friction = 0
    self.state_timer = 0
    self.state_progress = 0
    if Game.minigame.hero_hp <= 0 then
        Assets.playSound("minigames/punch_out/hurt1_bc")
        Assets.playSound("minigames/punch_out/punchmed_bc")
        Assets.playSound("minigames/punch_out/metalhit_bc")
        self:setState("DEAD")
        return true
    end
    self:setState("HURT")
    Game.minigame.boxing_queen.attack_success = 1
    self.hurt_length = hurt or 16
    self.invuln_timer = invuln or 0
    self.draw_flip = flip or 1
    return true
end

function PunchOutHero:setState(state)
    local last_state = self.state
    self.state = state
    self.state_timer = 0
    self.state_progress = 0
    self:onStateChange(last_state, state)
end

function PunchOutHero:onStateChange(old, new)
    if new == "IDLE" then
        self.x = self.base_x
        self.y = self.base_y
        self.buffer_z = 0
        self.buffer_x = 0
        self.buffer_l = 0
        self.buffer_r = 0
        self.buffer_d = 0
        self.dodging = 0
        self.ducking = 0
        self.draw_flip = 1
        self.sprite:setSprite("idle")
    elseif new == "PUNCH" then
        self.buffer_z = 0
        self.buffer_x = 0
        self.buffer_l = 0
        self.buffer_r = 0
        self.buffer_d = 0
    elseif new == "DODGE" then
        self.buffer_z = 0
        self.buffer_x = 0
        self.buffer_l = 0
        self.buffer_r = 0
        self.buffer_d = 0
        Assets.playSound("minigames/punch_out/motor_upper_quick_high_bc")
    elseif new == "DUCK" then
        self.buffer_z = 0
        self.buffer_x = 0
        self.buffer_l = 0
        self.buffer_r = 0
        self.buffer_d = 0
        Assets.playSound("minigames/punch_out/motor_upper_quick_high_bc")
    elseif new == "DEAD" then
        self.buffer_z = 0
        self.buffer_x = 0
        self.buffer_l = 0
        self.buffer_r = 0
        self.buffer_d = 0
        self.sprite.visible = false
        Game.minigame:makeVectorExplosion(self.x/2, (self.y - 45)/2, Game.minigame.bg.layer + 10)
        Game.minigame.timer:after(40/30, function() Game.minigame:setState("DEAD") end)
    end
end

function PunchOutHero:draw()
    super.draw(self)

    if DEBUG_RENDER then
        if self.collider then
            self.collider:draw(1,0,0,1)
        end
    end
end

return PunchOutHero
