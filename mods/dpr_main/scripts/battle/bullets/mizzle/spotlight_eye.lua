local SpotlightEye, super = Class(Bullet, "mizzle/spotlight_eye")

function SpotlightEye:init(x, y)
    super.init(self, x, y, "battle/bullets/mizzle/eye")

    self:setScale(1)
    self:setOriginExact(17, 10)

    self.timer = 0
    self.con = 0
    self.grazetimer = 0
    self.tp = 3.2

    self.damage = 66
    self.target = "all"
end

function SpotlightEye:update()
    super.update(self)

    if self.con == 0 then
        self.physics.speed_x = self.physics.speed_x + TableUtils.pick({-0.025, 0.025}) * DTMULT
        self.physics.speed_y = self.physics.speed_y + TableUtils.pick({-0.025, 0.025}) * DTMULT
        self.physics.speed = MathUtils.clamp(self.physics.speed, -0.125, 0.125)
    end

    if self.con == 1 then
        self:setSprite("battle/bullets/mizzle/almond")
        self.timer = self.timer + DTMULT
    
        if (self.timer == 14 or (self.timer >= 8 and (self.timer % 2) == 1 and MathUtils.randomInt(3) ~= 1)) then
            self.con = 2
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + -math.rad(180)
            self.physics.speed = 8
            self.physics.speed_x = self.physics.speed_x * 2
            self.physics.speed_y = self.physics.speed_y * 0.5
        end
    end

    if self.con == 2 then
        if self.x > Game.battle.soul.x then
            self.physics.speed_x = self.physics.speed_x - 0.275 * DTMULT
        else
            self.physics.speed_x = self.physics.speed_x + 0.275 * DTMULT
        end
    
        if self.y > Game.battle.soul.y then
            self.physics.speed_y = self.physics.speed_y - 0.275 * DTMULT
        else
            self.physics.speed_y = self.physics.speed_y + 0.275 * DTMULT
        end
    
        self.physics.direction = MathUtils.rotateTowards(self.physics.direction, MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y), 0.75)

        --idk how to handle this part, but I'm just gonna wager a guess here and leave it commented out for now.
        --[[
        for _, id in ipairs(Game.stage:getObjects(Registry.getBullet("mizzle/spotlight_eye"))) do
            if id ~= self then
                if (MathUtils.angle(self.x, self.y, id.x, id.y) < 32) then
                    self.x = self.x + MathUtils.lengthDirX(1, MathUtils.angle(self.x, self.y, id.x, id.y))
                    self.y = self.y + MathUtils.lengthDirY(1, MathUtils.angle(self.x, self.y, id.x, id.y))
                end
            end
        end
        ]]
    
        self.physics.speed = MathUtils.clamp(self.physics.speed, -7, 7)
    end

    self.grazetimer = self.grazetimer + DTMULT
    if self.grazetimer >= 10 then
        self.grazetimer = 0
        self.grazed = false
    end

    --flickering effect
    if self.con ~= 1 or (self.timer % 2) ~= 0 then
        self.visible = true
    else
        self.visible = false
    end
end

return SpotlightEye