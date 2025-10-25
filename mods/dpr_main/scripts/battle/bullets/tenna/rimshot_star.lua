---@class RimshotStar : Bullet
---@overload fun(...) : RimshotStar
local RimshotStar, super = Class(Bullet, "tenna/rimshot_star")

function RimshotStar:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/tenna/allstars_star")

    self.physics.direction = dir
    self.physics.speed_x, self.physics.speed_y = speed, speed

    self:setScale(1)
    self.alpha = 0
    Game.battle.timer:lerpVar(self, "alpha", 0, 1, 12, 2, "in")
    self.tp = 1.6
    self.element = 5
    self.destroy_on_hit = false
    self.collidable = true
    self.made = false

    self.timer = 0
    self.laugh_timer = 1
    self.rimshot_timer = -1
    self.sway = 0
    self.dosway = true
	if FRAMERATE >= 30 then
		self.max_trail = 14 + (14 * math.max(((FRAMERATE-30)/30), 0))
	else
		self.max_trail = 14 + (14 * math.max(((FPS-30)/30), 0))
	end
	self.stoptimerconds = 0
end

function RimshotStar:update()
    super.update(self)

    if not self.made then
        --tail bullets
        self.bullet1 = self.wave:spawnBullet("tenna/rimshot_ball", self.x, self.y)
        self.bullet1:setLayer(self.layer - 0.01)
        self.bullet1.laugh_timer = self.laugh_timer
        Game.battle.timer:lerpVar(self.bullet1, "alpha", -2, 1, 12, 2, "in")

        self.bullet2 = self.wave:spawnBullet("tenna/rimshot_ball", self.x, self.y)
        self.bullet2:setLayer(self.layer - 0.01)
        self.bullet2.laugh_timer = self.laugh_timer
        Game.battle.timer:lerpVar(self.bullet2, "alpha", -4, 1, 12, 2, "in")

        self.xx, self.yy = {}, {}
        for i = 0, self.max_trail-1 do
            self.xx[i] = self.x
            self.yy[i] = self.y
        end

        self.made = true
    end

    for i = self.max_trail, 1, -1 do
        self.xx[i] = self.xx[i - 1]
        self.yy[i] = self.yy[i - 1]
    end
    self.xx[1] = self.x
    self.yy[1] = self.y

    self.rotation = -math.rad(math.sin(self.sway) * 12)

    if self.dosway then
        self.sway = self.sway + (0.25 * DTMULT)
    end

    if (self.sway % 7.5) == 0 then
        self.grazed = false
        self.bullet1.grazed = false
        self.bullet2.grazed = false
    end

    if (((self.x + self.physics.speed_x) > (Game.battle.arena.x + 64) and self.physics.speed_x > 0) or ((self.x + self.physics.speed_x) < (Game.battle.arena.x - 64) and self.physics.speed_x < 0)) then
        self.physics.speed_x = self.physics.speed_x * -1
    end

    if (((self.y + self.physics.speed_y) > (Game.battle.arena.y + 64) and self.physics.speed_y > 0) or ((self.y + self.physics.speed_y) < (Game.battle.arena.y - 64) and self.physics.speed_y < 0)) then
        self.physics.speed_y = self.physics.speed_y * -1
    end

    self.bullet1.x = self.xx[math.ceil(self.max_trail / 2)]
    self.bullet1.y = self.yy[math.ceil(self.max_trail / 2)]
    self.bullet2.x = self.xx[self.max_trail]
    self.bullet2.y = self.yy[self.max_trail]

	if self.rimshot_timer > 0 then
		self.rimshot_timer = self.rimshot_timer - (1 * DTMULT)
		self.laugh_timer = self.laugh_timer + (0.25 * DTMULT)

		if self.stoptimerconds == 0 then
			if MathUtils.round(self.rimshot_timer) == 73 then
				Game.battle.timer:lerpVar(self.bullet2, "scale_x", 4, 1, 10)
				Game.battle.timer:lerpVar(self.bullet2, "scale_y", 4, 1, 10)
				Game.battle.timer:lerpVar(self.bullet2, "scale_x", 1, 3, 3)
				Game.battle.timer:lerpVar(self.bullet2, "scale_y", 1, 3, 3)
				local afterimage = AfterImage(self, 0.1)
				afterimage.graphics.grow_x = 0.2
				afterimage.graphics.grow_y = 0.2
				self:addChild(afterimage)
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 70 then
				Game.battle.timer:lerpVar(self.bullet1, "scale_x", 4, 1, 10)
				Game.battle.timer:lerpVar(self.bullet1, "scale_y", 4, 1, 10)
				Game.battle.timer:lerpVar(self.bullet1, "scale_x", 1, 3, 3)
				Game.battle.timer:lerpVar(self.bullet1, "scale_y", 1, 3, 3)
				local afterimage = AfterImage(self, 0.1)
				afterimage.graphics.grow_x = 0.2
				afterimage.graphics.grow_y = 0.2
				self:addChild(afterimage)
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 67 then
				self.collidable = false
				self.scale_x = 0.8
				self.scale_y = 0.8
				if FRAMERATE > 30 or FRAMERATE == 0 then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 66 then
				Game.battle.timer:lerpVar(self, "scale_x", 1, 2, 6, 2, "out")
				Game.battle.timer:lerpVar(self, "scale_y", 1, 2, 6, 2, "out")
				self.dosway = false
				self.sway = 0
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 65 then
				for dir = 90, 450-1, 72 do
					local mybullet = self.wave:spawnBullet("tenna/rimshot_triangle")
					mybullet.x = self.x + (math.cos(math.rad(-dir)) * 16) + self.physics.speed_x
					mybullet.y = self.y + (math.sin(math.rad(-dir)) * 16) + self.physics.speed_y
					mybullet:setLayer(self.layer - 0.01)
					mybullet.rotation = -math.rad(dir)
					Game.battle.timer:after(90/30, function() mybullet:remove() end)
					Game.battle.timer:lerpVar(mybullet, "alpha", 4, 0, 48)
					Game.battle.timer:after(36/30, function() mybullet.collidable = false end)
				end
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 61 then
				self.dosway = true
				Game.battle.timer:lerpVar(self, "scale_x", 2, 1, 6, 2, "out")
				Game.battle.timer:lerpVar(self, "scale_y", 2, 1, 6, 2, "out")
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) == 56 then
				self.collidable = true
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.rimshot_timer
				end
			end
		
			if MathUtils.round(self.rimshot_timer) <= 0 then
				self.laugh_timer = 1
				self.rimshot_timer = -1
			end
		end
		if self.stoptimerconds ~= 0 and self.rimshot_timer <= self.stoptimerconds-0.4 then
			self.stoptimerconds = 0
		end
	end
end

function RimshotStar:draw()
    super.draw(self)

    local laugh = Assets.getFrames("battle/bullets/tenna/allstars_laugh")
    local frame = math.floor(self.laugh_timer) % #laugh + 1

    Draw.draw(laugh[frame], 24, 24, 0, 1, 1, 24, 24)
end

return RimshotStar