local Magic_Book, super = Class(Bullet)

function Magic_Book:init(x, y, index)
    super.init(self, x, y, "battle/bullets/bibliox/book_idle")
    self.destroy_on_hit = false
    self.scale_x = 1
    self.scale_y = 1

    self.timer = 0
    self.bullets = 2
    self.open_side = 1
    self.physics.speed_y = -1
    self.spell = 2
    --self.image_speed = 0
    self.sprite:stop()
    self.sprite:setFrame(index)
    self.fadetarg = 1
    self.alpha = 0
    self.dog = false

    if (MathUtils.randomInt(49) == 0) then
        self.dog = true
    end

    self.bubble_ratio = self:getEnemyRatio()

    self.wind = nil

    self.xtarg = 0
    self.ytarg = 0
    self.flip = 0

    self.fire = nil
    self.add_fire = nil
    self.flip_start = 0
end

function Magic_Book:update()
    self.timer = self.timer + 1 * DTMULT
    self.physics.speed_x = self:scr_approach_curve(self.physics.speed_x, 0, 10)
    self.physics.speed_y = self:scr_approach_curve(self.physics.speed_y, 0, 12)
    self.alpha = Utils.approach(self.alpha, self.fadetarg, 0.08333333333333333)

    if (self.timer == 8) then
        self.sprite:setFrame(4)
    end
    if (self.timer == 12) then
        if (self.dog) then
            self.sprite:setFrame(8)
        else
            self.sprite:setFrame(4 + self.spell)
        end
    end
    if (self.sprite.frame > 4) then
        if (self.spell == 1) and (((self.timer - 12) % (12 + math.ceil(9 * self.bubble_ratio))) == 6) then
            local lifetime = 25 + Utils.pick { 0, 1, 2, 3, 4, 5 }
            local bubble = self.wave:spawnBullet("bibliox/bubble_bullet", self.x, self.y)
            bubble.alarm_0 = lifetime
            bubble.physics.direction = Utils.angle(bubble.x, bubble.y, Game.battle.soul.x, Game.battle.soul.y) +
            math.rad(Utils.random(-15, 15))
            bubble.physics.speed = 8 + Utils.random(4)
            --bubble.layer = self.layer - 1
            Game.battle.timer:lerpVar(bubble.physics, "speed", bubble.physics.speed / 2, 0.5, lifetime - 3)
            Game.battle.timer:lerpVar(bubble.physics, "speed", bubble.physics.speed, 1.35, 11)
        end

        if (self.spell == 2) then
            if (self.timer == 20) then
                local offset = -40

                while offset <= 40 do
                    self.wind = self.wave:spawnBullet("bibliox/wind_bullet", self.x, self.y)
                    self.wind.physics.direction = Utils.angle(self.wind.x, self.wind.y, Game.battle.soul.x,
                        Game.battle.soul.y) + math.rad(offset)
                    self.wind.physics.speed = 5
                    offset = offset + 80 / (3 - ((self.ratio > 1) and 1 or 0))
                end
            end

            if (self.timer == 35) then
                local offset = -52

                while offset <= 52 do
                    self.wind = self.wave:spawnBullet("bibliox/wind_bullet", self.x, self.y)
                    self.wind.physics.direction = Utils.angle(self.wind.x, self.wind.y, Game.battle.soul.x,
                        Game.battle.soul.y) + math.rad(offset)
                    self.wind.physics.speed = 5
                    offset = offset + 104 / (4 - ((self.ratio > 1) and 1 or 0))
                end
            end
        end

        if (self.spell == 3) then
            if (self.timer == 16) then
                if(self.sameattack == 1 or self.boost == 1 or Utils.pick{0, 1, 2, 3, 4} < 2) then
                    self.xtarg = Game.battle.soul.x
                    self.ytarg = Game.battle.soul.y - 10
                else
                    self.xtarg = (Game.battle.arena.x - 75) + Utils.random(150)
                    self.ytarg = (Game.battle.arena.y - 75) + Utils.random(150)
                end
                self.flip = math.rad(Utils.pick{180, 0})
                if(self.flip == math.rad(180)) then
                    self.flip_start = 1
                end
            end

            if(((self.timer % 3) == 1 and self.timer >= 16 and self.timer < 32)) then
                self.fire = self.wave:spawnBullet("bibliox/fire_bullet", self.x, self.y)
                self.fire.physics.speed_y = 10
                self.fire.physics.gravity_direction = math.rad(270)
                self.fire.physics.gravity = 0.5
                self.fire.physics.speed_x = (self.xtarg - self.fire.x) / 15
                self.fire.physics.speed_y = self.fire.physics.speed_y + ((self.ytarg - self.fire.y) / ((2 * self.fire.physics.speed_y) / self.fire.physics.gravity))
                Game.battle.timer:lerpVar(self.fire.physics, "speed_x", self.fire.physics.speed_x, 0, 30)
            end

            if (self.boost == 1 and self.timer > 38 and self.timer % Utils.round(3) == 0 and #Game.battle:getActiveEnemies() == 1) then
                local _y = ((self.ytarg + 120) - ((self.timer - 38) * 10)) + 11 -- ((self.ytarg + 100) - ((self.timer - 38) * 10)) + 11

                if (_y < (Game.battle.arena.y + 100) and _y > (Game.battle.arena.y - 80)) then
                    self.add_fire = self.wave:spawnBullet("bibliox/rouxls_fire", self.xtarg, (_y + Utils.random(5)) - 10)
                    self.add_fire.physics.direction = self.flip
                    if(self.flip_start == 1) then
                        self.add_fire.physics.speed_x = -2
                        self.flip_start = 0
                    else
                        self.add_fire.physics.speed_x = 2
                        self.flip_start = 1
                    end
                    self.add_fire.layer = self.layer - 10
                    self.add_fire.rotation = self.add_fire.physics.direction
                    self.add_fire.scale_x = 0.1
                    Game.battle.timer:lerpVar(self.add_fire, "scale_x", 0, 1, 10)
                    Game.battle.timer:lerpVar(self.add_fire, "x", self.add_fire.x, self.add_fire.x + (self.add_fire.physics.speed_x * 15), 18)
                    Game.battle.timer:lerpVar(self.add_fire.physics, "speed_x", 0, self.add_fire.physics.speed_x * 5, 18)
                    self.flip = self.flip + math.rad(180)
                end

            end

            if(self.fire ~= nil and self.fire.physics.speed_y < -12) then
                self.fire.physics.speed_y = -12
            end

        end
    end

    if (self.timer == (50 + (15 * self.boost))) then
        self.sprite:setFrame(4)
        self:setLayer(self.layer + 1)
    end

    if (self.timer == (54 + (15 * self.boost))) then
        self.sprite:setFrame(self.spell)
    end

    if (self.timer == (60 + (15 * self.boost))) then
        self.physics.speed_x = 4 * self.open_side
        self.physics.speed_y = -10
        self.fadetarg = 0
    end

    if (self.sprite.frame > 3) then
        self.scale_x = self.open_side
    end
    super.update(self)
end

function Magic_Book:scr_approach_curve(arg0, arg1, arg2)
    local diff = math.abs(arg1 - arg0)
    local step = math.max(0.1, diff / arg2)
    return Utils.approach(arg0, arg1, step)
end

function Magic_Book:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 0
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return Magic_Book
