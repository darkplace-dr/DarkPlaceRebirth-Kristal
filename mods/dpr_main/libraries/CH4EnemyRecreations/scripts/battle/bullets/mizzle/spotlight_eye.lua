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
	self.speed = 0
	self.speed_x = 0
	self.speed_y = 0
	self.direction = 0
	
	self.iris_tex = Assets.getTexture("battle/bullets/mizzle/almond_iris")
	
	self.remove_offscreen = false
end

function SpotlightEye:update()
    super.update(self)

    if self.con == 0 then
        self.speed_x = self.speed_x + TableUtils.pick({-0.025, 0.025}) * DTMULT
        self.speed_y = self.speed_y + TableUtils.pick({-0.025, 0.025}) * DTMULT
		self.direction = MathUtils.angle(0, 0, self.speed_x, self.speed_y)
		self.speed = MathUtils.dist(0, 0, self.speed_x, self.speed_y)
		self.speed_x = MathUtils.lengthDirX(self.speed, -self.direction)
		self.speed_y = MathUtils.lengthDirY(self.speed, -self.direction)
        self.speed = MathUtils.clamp(self.speed, -0.125, 0.125)
    end

    if self.con == 1 then
        self:setSprite("battle/bullets/mizzle/almond")
        self.timer = self.timer + DTMULT
    
        if (self.timer == 14 or (self.timer >= 8 and (self.timer % 2) == 1 and MathUtils.randomInt(3) ~= 1)) then
            self.con = 2
            self.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + math.rad(180)
            self.speed = 8
			self.speed_x = MathUtils.lengthDirX(self.speed, -self.direction)
			self.speed_y = MathUtils.lengthDirY(self.speed, -self.direction)
            self.speed_x = self.speed_x * 2
            self.speed_y = self.speed_y * 0.5
        end
    end

    if self.con == 2 then
        if self.x > Game.battle.soul.x then
            self.speed_x = self.speed_x - 0.275 * DTMULT
        else
            self.speed_x = self.speed_x + 0.275 * DTMULT
        end
    
        if self.y > Game.battle.soul.y then
            self.speed_y = self.speed_y - 0.275 * DTMULT
        else
            self.speed_y = self.speed_y + 0.275 * DTMULT
        end
		
        self.direction = MathUtils.rotateTowards(self.direction, MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y), 0.75 * DTMULT)	
		
		for _, bullet in ipairs(self.wave.bullets) do
			if bullet:isBullet("mizzle/spotlight_eye") and bullet ~= self and not bullet:isRemoved() then
                if (MathUtils.dist(self.x, self.y, bullet.x, bullet.y) < 32) then
					bullet.x = bullet.x + MathUtils.lengthDirX(DTMULT, -MathUtils.angle(self.x, self.y, bullet.x, bullet.y))
					bullet.y = bullet.y + MathUtils.lengthDirY(DTMULT, -MathUtils.angle(self.x, self.y, bullet.x, bullet.y))
                end
            end
        end
		self.direction = MathUtils.angle(0, 0, self.speed_x, self.speed_y)
		self.speed = MathUtils.dist(0, 0, self.speed_x, self.speed_y)
		self.speed_x = MathUtils.lengthDirX(self.speed, -self.direction)
		self.speed_y = MathUtils.lengthDirY(self.speed, -self.direction)
		self.speed = MathUtils.clamp(self.speed, -7, 7)
    end
	
	local final_speed_x = MathUtils.lengthDirX(self.speed, -self.direction)
	local final_speed_y = MathUtils.lengthDirY(self.speed, -self.direction)
	self.x = self.x + final_speed_x * DTMULT
	self.y = self.y + final_speed_y * DTMULT

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

function SpotlightEye:draw()
	if self.con >= 1 then
		Draw.setColor(0.5, 0.5, 0.5, self.alpha)
		Draw.draw(self.sprite.texture, 22+((self.last_x - self.x) * FRAMERATE/30), 14+((self.last_y - self.y) * FRAMERATE/30), 0, 1, 1, 22, 14)
		Draw.setColor(self:getDrawColor())
	end
	super.draw(self)
	if self.con >= 1 then
		Draw.draw(self.iris_tex, 22+MathUtils.lengthDirX(self.speed, -self.direction), 14+MathUtils.lengthDirY(self.speed, -self.direction), 0, 1, 1, 18, 10)
	end
end
return SpotlightEye