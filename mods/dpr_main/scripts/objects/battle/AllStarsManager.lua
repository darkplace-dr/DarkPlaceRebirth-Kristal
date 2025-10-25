local AllStarsManager, super = Class(Object)

function AllStarsManager:init(x, y)
    super.init(self, 0, 0)

    self.difficulty = 0
	self.xx = x or SCREEN_WIDTH/2
	self.yy = y or 0
    self.bullet_list = {}
    self.timer = -7
    self.big = -1
    self.num = 2
    self.damage = 5
	self:setLayer(BATTLE_LAYERS["top"])
    self.snd_loop = Assets.getSound("crowd_laughter_loop")
    self.snd_loop:setLooping(true)
    self.snd_loop:play()
	
    self.fadetype = 0
    self.fade = 2.5
    self.fademax = 1
    self.opaq = 0
    self.my_surface = -4
    self.my_surface2 = -4
	self.stoptimerconds = 0
	self.shader = Assets.getShader("luma_to_alpha")
end

function AllStarsManager:spawn_new(side)
    local dir = -1
    
    if side == 1 then
        dir = 1
    end
    
    local total_length = 240
    local init_length = 70
    
    if self.num == 2 then
        self.num = 3
    else
        self.num = 2
    end
    
    local interval = total_length / self.num
    local cent = interval * 0.5
    local range = cent - 12
    
    for a = 0, self.num-1 do
        self.allstar = self.wave:spawnBullet("tenna/allstars_bullet", self.xx - ((init_length + (interval * a) + cent + MathUtils.randomInt(-range, range)) * dir), self.yy, 0, 0)
        self.allstar.damage = self.damage
        
        if self.big == 1 then
            self.allstar.size = 1
        else
            self.allstar.size = 0.5
        end
			
        table.insert(self.bullet_list, self.allstar)

        if self.big == 1 then
            self.allstar.mydir = dir * 1.3
        else
            self.allstar.mydir = dir * 0.7
        end
        
        self.big = self.big * -1
    end
end

function AllStarsManager:update()
    local speedmod = 2 * DTMULT
	
    if self.difficulty == 1 then
        speedmod = 1.75 * DTMULT
    end
	
    if Game.battle.wave_timer >= Game.battle.wave_length-20/30 and self.fadetype == 0 then
        self.fadetype = 1
		
        for _,bullet in ipairs(self.bullet_list) do
			if bullet then
				bullet.state = 1
			end
        end
    end
	
    self.fademax = 1 + (math.sin((Kristal.getTime()*30) * 0.05) * 0.1)
    self.fade = MathUtils.approach(self.fade, self.fademax, (math.abs(self.fade - self.fademax) * 0.15) * DTMULT)
	
    if self.fadetype == 0 then
        self.opaq = MathUtils.approach(self.opaq, 0.75, (math.abs(self.opaq - 0.75) * 0.15) * DTMULT)
    end
	
    if self.fadetype == 1 then
        self.opaq = MathUtils.approach(self.opaq, 0, 0.05 * DTMULT)
    end

    for _,bullet in ipairs(self.bullet_list) do
        if bullet then
            local oldangle = MathUtils.angle(self.xx, self.yy, bullet.x, bullet.y)
            local oldlength = MathUtils.dist(self.xx, self.yy, bullet.x, bullet.y)
			bullet.x = self.xx + math.cos(oldangle + -math.rad(bullet.mydir * speedmod)) * oldlength
			bullet.y = self.yy + math.sin(oldangle + -math.rad(bullet.mydir * speedmod)) * oldlength
			bullet.timer = bullet.timer + math.abs(bullet.mydir) * speedmod
        end
    end
	
    self.timer = self.timer + DTMULT

	if self.stoptimerconds == 0 then
		if self.difficulty == 0 then
			if ((MathUtils.round(self.timer) % 13) == 0 and Game.battle.wave_timer < Game.battle.wave_length-20/30) then
				self:spawn_new(0)
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.timer
				end
			end
		elseif Game.battle.wave_timer < Game.battle.wave_length-20/30 then
			if ((MathUtils.round(self.timer) % 32) == 16) then
				self:spawn_new(0)
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.timer
				end
			end
		
			if ((MathUtils.round(self.timer) % 32) == 0) then
				self:spawn_new(1)
				if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
					self.stoptimerconds = self.timer
				end
			end
		end
	end

	if self.stoptimerconds ~= 0 and self.timer >= self.stoptimerconds+0.6 then
		self.stoptimerconds = 0
	end
    super.update(self)
end

function AllStarsManager:draw()
    super.draw(self)
	local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear(0,0,0,1)
	Draw.setColor(0,0,0,1)
	Draw.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	Draw.setColor(1,1,1,0.5)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 320 * self.fade)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 280 * self.fade)
	Draw.setColor(1,1,1,1)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 240 * self.fade)
	Draw.setColor(0,0,0,0.5)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 120 * self.fade)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 80 * self.fade)
	Draw.setColor(0,0,0,1)
	love.graphics.circle("fill", SCREEN_WIDTH/2, 0, 40 * self.fade)
	Draw.popCanvas()
	
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
	Draw.setColor(1,1,1,self.opaq)
    Draw.drawCanvas(canvas)
	Draw.setColor(1,1,1,1)
    love.graphics.setShader(last_shader)
end

function AllStarsManager:onRemove()
    super.onRemove(self)
	
    self.snd_loop:stop()
end

return AllStarsManager