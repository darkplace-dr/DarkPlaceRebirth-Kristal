local MagicBook, super = Class(Bullet)

function MagicBook:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_idle")
    self.sprite:stop()
    self.image_index = 0

    self:setScale(1)
    self.destroy_on_hit = false
    self.fadetarg = 1
    self.alpha = 0

    self.timer = 0
    self.bullets = 2
    self.open_side = 1
    self.physics.speed_y = -1
    self.spell = 2

    self.dog = false
    if (MathUtils.randomInt(50) == 0) then
        self.dog = true
    end
end

function MagicBook:update()
    self.timer = self.timer + DTMULT

    self.physics.speed_x = MathUtils.approachCurveDTMULT(self.physics.speed_x, 0, 10)
    self.physics.speed_y = MathUtils.approachCurveDTMULT(self.physics.speed_y, 0, 12)
    self.alpha = MathUtils.approach(self.alpha, self.fadetarg, 1/12*DTMULT)

    if self.timer == 8 then
        self.image_index = 3
    end

    if self.timer == 12 then
        if self.dog == true then
            self.image_index = 7
        else
            self.image_index = 4 + self.spell
        end
    end

    if self.image_index > 3 then
        if self.spell == 0 and ((self.timer - 12) % (12 + math.ceil(9 * self.ratio))) == 6 then
            local lifetime = 25 + MathUtils.randomInt(6)

            local bubble = self.wave:spawnBullet("bibliox/bubble", self.x, self.y)
            bubble.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + -math.rad(MathUtils.random(-15, 15))
            bubble.physics.speed = 8 + MathUtils.random(4)

            Game.battle.timer:after(lifetime/30, function()
                bubble.image_speed = 1/3
                bubble.sprite_index = "bubble_split"
                bubble.image_index = 0
                bubble.rotation = -math.rad(MathUtils.random(120) - 60)
            end)

            Game.battle.timer:lerpVar(bubble.physics, "speed", bubble.physics.speed / 2, 0.5, lifetime - 3)
            Game.battle.timer:lerpVar(bubble.physics, "speed", bubble.physics.speed, 1.35, 11)
        end

        if self.spell == 1 then
            if self.timer == 20 then
                local offset = -40

                while offset <= 40 do
                    local wind = self.wave:spawnBullet("bibliox/book_bullet", self.x, self.y)
                    wind.sprite_index = "wind"
                    wind.collider = CircleCollider(wind, 28, 30, 12)
                    wind.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + -math.rad(offset)
                    wind.physics.speed = 5
                    offset = offset + 80 / (3 - ((self.ratio > 1) and 1 or 0))
                end
            end

            if (self.timer == 35) then
                local offset = -52

                while offset <= 52 do
                    local wind = self.wave:spawnBullet("bibliox/book_bullet", self.x, self.y)
                    wind.sprite_index = "wind"
                    wind.collider = CircleCollider(wind, 28, 30, 12)
                    wind.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + -math.rad(offset)
                    wind.physics.speed = 5
                    offset = offset + 104 / (4 - ((self.ratio > 1) and 1 or 0))
                end
            end
        end

        if self.spell == 2 then
            if self.timer == 16 then
                if self.sameattack == 1 or self.boost > 0 or MathUtils.randomInt(5) < 2 then
                    self.xtarg = Game.battle.soul.x + 2
                    self.ytarg = Game.battle.soul.y + 2
                else
                    self.xtarg = (Game.battle.arena.x - 75) + MathUtils.random(150)
                    self.ytarg = (Game.battle.arena.y - 75) + MathUtils.random(150)
                end
                
                self.flip = -math.rad(TableUtils.pick{180, 0})
            end

            if ((self.timer % 3) == 1 and self.timer >= 16 and self.timer < 32) then
                local fire = self.wave:spawnBullet("bibliox/book_bullet", self.x, self.y)
                fire.sprite_index = "fire"
                fire.collider = CircleCollider(fire, 32, 32 + 4, 12)
                fire:setSpeed((self.xtarg - fire.x) / 15, 10)
                fire.physics.gravity_direction = -math.rad(90)
                fire.physics.gravity = 0.5
                fire.physics.speed_y = fire.physics.speed_y + ((self.ytarg - fire.y) / ((2 * fire.physics.speed_y) / fire.physics.gravity))
                fire.tp = 0.6
                fire.time_bonus = 1
                fire.bottomfade = 0
                fire.wall_destroy = false
                Game.battle.timer:lerpVar(fire.physics, "speed_x", fire.physics.speed_x, 0, 30)
            end

            if (self.boost > 0 and self.timer > 38 and (self.timer % MathUtils.round(3)) == self.sameattacker) then
                local _y = ((self.ytarg + 100) - ((self.timer - 38) * 10)) + 11

                if (_y < (Game.battle.arena.y + 100) and _y > (Game.battle.arena.y - 80)) then
                    local add_fire = self.wave:spawnBullet("bibliox/book_bullet", self.xtarg, (_y + MathUtils.random(5)) - 10)
                    add_fire.sprite_index = "rouxls_fire"
                    add_fire:setHitbox(33, 5, 10, 7)
                    add_fire.rotation = self.flip
                    add_fire.physics.match_rotation = true
                    add_fire:setSpeed(2, 0)

                    add_fire.layer = self.layer - 10
                    Game.battle.timer:lerpVar(add_fire, "scale_x", 0, 1, 10)
                    Game.battle.timer:lerpVar(add_fire, "x", add_fire.x, add_fire.x + (add_fire.physics.speed_x * 15), 18)
                    Game.battle.timer:lerpVar(add_fire.physics, "speed_x", 0, add_fire.physics.speed_x * 5, 18)
                    add_fire.scale_x = 0
                    self.flip = self.flip + -math.rad(180)
                end

            end

            if fire ~= nil and fire.physics.speed_y < -12 then
                fire.physics.speed_y = -12
            end

            if self.timer == 32 and self.boost == 0 then
                self.timer = 50
            end
        end
    end

    if (self.timer == (50 + (15 * self.boost))) then
        self.image_index = 3
        self:setLayer(self.layer + 1)
    end

    if (self.timer == (54 + (15 * self.boost))) then
        self.image_index = self.spell
    end

    if (self.timer == (60 + (15 * self.boost))) then
        self.physics.speed_x = 4 * self.open_side
        self.physics.speed_y = -10
        self.fadetarg = 0
    end

    if (self.image_index > 2) then
        self.scale_x = self.open_side
    end

    self.sprite:setFrame(1 + math.floor(self.image_index))

    super.update(self)
end

return MagicBook
