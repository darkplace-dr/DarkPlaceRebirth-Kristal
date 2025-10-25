local RimshotStars, super = Class(Wave)

function RimshotStars:init()
    super.init(self)

    self.time = 260/30
    self.type = 128

    self.btimer = 99
    self.made = false
    self.side1 = 0
    self.side2 = 0
    self.my_angle = MathUtils.random(360)
	self.stoptimerconds = 0
end

function RimshotStars:onStart()
    local arena = Game.battle.arena

    --[[self.timer:after(11/30, function()
        self:spawnBullet("tenna/lensflare_manager", arena.x + (math.cos(-math.rad(self.my_angle)) * 60), arena.y + (math.sin(-math.rad(self.my_angle)) * 60))
    end)

    self.timer:after(26/30, function()
        self:spawnBullet("tenna/lensflare_manager", arena.x + (math.cos(-math.rad(self.my_angle + 180)) * 60), arena.y + (math.sin(-math.rad(self.my_angle + 180)) * 60))
    end)]]
end

function RimshotStars:update()
    super.update(self)

    local arena = Game.battle.arena

    self.btimer = self.btimer + (1 * DTMULT)

    if not self.made then
        self.made = true

        self.side1 = MathUtils.randomInt(3)
        self.side2 = self.side1 + 1
        self.side1 = self.side1 * 90
        self.side2 = self.side2 * 90
    end
	if self.stoptimerconds == 0 then
		if MathUtils.round(self.btimer) == 103 or (self.type == 128 and MathUtils.round(self.btimer) == 117) then
			local dir
			if MathUtils.round(self.btimer) == 103 then
				dir = self.side1
			else
				dir = self.side2
			end

			local maindist = 150
			local sidedist = 0
			local xdist = (math.cos(-math.rad(dir)) * maindist) + (math.cos(-math.rad(dir + 90)) * sidedist)
			local ydist = (math.sin(-math.rad(dir)) * maindist) + (math.sin(-math.rad(dir + 90)) * sidedist) 
			local firedir = math.rad(142 + dir + 11 * (MathUtils.round(self.btimer) == 103 and 1 or 0))

			local rimshot_star = self:spawnBullet("tenna/rimshot_star", arena.x + xdist, arena.y + ydist, firedir, 6)
			self.timer:lerpVar(rimshot_star.physics, "speed_x", rimshot_star.physics.speed_x, 3.75, 1)
			self.timer:lerpVar(rimshot_star.physics, "speed_y", rimshot_star.physics.speed_y, 3.75, 1)
			if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
				self.stoptimerconds = self.btimer
			end
		end

		local rate1 = 78
		local rate2 = 50

		if self.type == 129 then
			rate1 = 27
			rate2 = 20
		end

		if (MathUtils.round(self.btimer) % rate1) == rate2 then
			Assets.playSound("rimshot")

			for _, bullet in ipairs(Game.stage:getObjects(Registry.getBullet("tenna/rimshot_star"))) do
				bullet.rimshot_timer = 74
			end
			if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
				self.stoptimerconds = self.btimer
			end
		end
	end
	if self.stoptimerconds ~= 0 and self.btimer >= self.stoptimerconds+0.6 then
		self.stoptimerconds = 0
	end
end

return RimshotStars