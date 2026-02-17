local SpinHeart, super = Class(Bullet)

function SpinHeart:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/hathy/spinheart")
    self:setScale(4)

    self.physics.direction = dir
    self.physics.speed = speed
    self.destroy_on_hit = false
    self.collider = PolygonCollider(self, {
        {3,20},
        {0,16},
        {0,7},
        {7,0},
        {20,0},
        {41,20.5},
        {22,40},
        {7,40},
        {0,33},
        {0,24},
        {3,20},
        {8,20},
        {4,15},
        {4,8},
        {9,5},
        {19,5},
        {36,20.5},
        {19,36},
        {9,36},
        {4,32},
        {4,25},
        {8,20}
    })

    self.x, self.y = Game.battle.soul.x, Game.battle.soul.y

    self.joker = false                     --presumably named after Jevil, but is used by Head Hathy.
    self.damage = 100
    self.tp = 2
    self.time_bonus = 0
    self.grazed = false
    self.graze_timer = 0
    self.inv_timer = 2

    self.con = 0
    self.htimer = 0
    self.collider.collidable = false
    self.alpha = 0
    self.rotation = -math.rad(-90)
end

function SpinHeart:update()
    if self.con == 4 then
        self.htimer = self.htimer + (1 * DTMULT)
        if self.htimer >= 10 then
            self.physics.friction = 0
            self.physics.speed = 0
        end

        if self.htimer >= 20 then
            self.damage = 0
            self.alpha = self.alpha - (0.2 * DTMULT)
        end

        if self.htimer >= 25 then
            self.wave.finished = true
        end
    end

    if self.con == 3 then
        self.htimer = self.htimer + (1 * DTMULT)

        if self.htimer >= self.hmax then
            self.physics.direction = self.rotation
            self.physics.speed = 2.5
            self.physics.friction = -0.5

            if self.joker == true then
                self.physics.speed = 5
            end

            self.con = 4
            self.htimer = 0
        end
    end

    if self.con == 2 then
        self.htimer = self.htimer + (1 * DTMULT)
        self.rotation = self.rotation + -math.rad(24) * DTMULT

        if self.htimer >= self.spinmax then
            self.hmax = 19

            if self.joker == true then
                self.hmax = 15
            end

            self.rotation = -math.rad(270 + (self.spinmax * 24))
            self.con = 3
            self.htimer = 0
        end
    end

    if self.con == 1 then
        self.htimer = self.htimer + (1 * DTMULT)

        if self.htimer >= 10 then
            self.spinmax = TableUtils.pick{26.25, 30, 33.75, 37.5}

            if self.joker == true then
                self.spinmax = 15 + MathUtils.random(15)
            end

            self.con = 2
            self.htimer = 0
        end
    end

    if self.con == 0 then
        self.alpha = self.alpha + (0.2 * DTMULT)
        self.scale_x = self.scale_x - (0.2 * DTMULT)
        self.scale_y = self.scale_y - (0.2 * DTMULT)
        self.htimer = self.htimer + (1 * DTMULT)

        if self.htimer >= 5 then
            self.con = 1
            self.htimer = 0
            self.collider.collidable = true
        end
    end

    if self.grazed == true then
        self.graze_timer = self.graze_timer + (1 * DTMULT)
    end

    if self.graze_timer >= 15 then
        self.graze_timer = 0
        self.grazed = false
    end

    super.update(self)
end

return SpinHeart