local BigLaser, super = Class(Wave)

function BigLaser:init()
    super.init(self)
	
	self.time = 9
	self:setArenaSize(240, 110)
	self:setArenaPosition(300, 175)
	
    self.spawn_timer = 0
	
    self.row = 0
    self.rowy = 0
    self.prevrow = 0
    self.prevrowy = 0
	
    self.spawncount = 0
    self.firstspawn = 0
	
    self.debug_render = false
	self.laser_start = nil
	self.laser_rect = nil
	self.laser_hitbox = nil
	self.laser_y = 0
	self.laser_power = 0
	self.charge_sfx = nil
	self.charge_sfx_pitch = 0
end

function BigLaser:onStart()
    self.debug_render = true
	
    self.timer:script(function(wait)
		local omega = Game.battle.enemies[1]
		local arena = Game.battle.arena
		self.laser_y = Utils.pick({arena.top, arena.bottom-arena.height/2})
		while true do
			if self.laser_y == arena.top then
				self.timer:tween(0.2, omega, {y = 700}, "out-cubic")
			else
				self.timer:tween(0.2, omega, {y = 760}, "out-cubic")
			end
			wait(0.1)
			omega:setAnimation("laserprepare")
			self.charge_sfx = Assets.stopAndPlaySound("sneo_overpower")
            self.charge_sfx:setLooping(true)
            self.charge_sfx:setPitch(0.1)
			self.charge_sfx_pitch = 0
			wait(0.2)
			local warning_exc = {}
			local warning_pos = {40, arena.width/2, arena.width-40}
			for i = 1, 3 do
				warning_exc[i] = self:spawnSprite("battle/bullets/omegaspamton/exclamation_mark_appear", arena.left+warning_pos[i], self.laser_y+arena.height/4)
				warning_exc[i]:setScale(1, 1)
				warning_exc[i]:setOrigin(0.5, 0.5)
				warning_exc[i].color = {1, 0, 0}
				warning_exc[i]:play(1/30, false)
			end
			local exc_flash = false
			local warning_rect = self:spawnObject(Rectangle(0, 0, arena.width, arena.height/2), arena.left, self.laser_y)
			warning_rect.line = true
			warning_rect.line_width = 2
			warning_rect.color = {1, 0, 0}
			warning_rect.layer = warning_exc[1].layer + 0.01
			self.timer:every(2/30, function()
				if exc_flash == false then
					warning_exc[1].color = {1, 1, 0}
					warning_exc[2].color = {1, 1, 0}
					warning_exc[3].color = {1, 1, 0}
					warning_rect.color = {1, 1, 0}
					exc_flash = true
				else
					warning_exc[1].color = {1, 0, 0}
					warning_exc[2].color = {1, 0, 0}
					warning_exc[3].color = {1, 0, 0}
					warning_rect.color = {1, 0, 0}
					exc_flash = false
				end
			end, 15)
			wait(0.5)
			while warning_exc[1].frame > 1 do
				for i = 1, 3 do
					warning_exc[i]:setFrame(warning_exc[i].frame - 1)
				end
				wait(1/30)
			end
			warning_exc[1]:remove()
			warning_exc[2]:remove()
			warning_exc[3]:remove()
			warning_rect:remove()
			wait(0.2)
			local omega_x = omega.sprite.x + omega.sprite.partx[3] + omega.sprite.partxoff[3]
			local omega_y = omega.sprite.y + omega.sprite.party[3] + omega.sprite.partorigins[3][2]
			self.charge_sfx:stop()
			self.charge_sfx = nil
			Assets.playSound("sneo_beam")
			omega:setAnimation("laserfire")
			--local laser_start = self:spawnObject(SpamtonLaserTriangle(0, 0, -(arena.height/2), arena.height/2, -16), SCREEN_WIDTH-(omega_x+16), arena.top)
			self.laser_start = self:spawnObject(SpamtonLaserTriangle(0, 0, 0, 0, 64, arena.height/4, 0, arena.height/2), SCREEN_WIDTH-(omega_x+48), self.laser_y)
			self.laser_start.color = {1, 1, 1}
			self.laser_start.layer = omega.layer - 0.01
			self.laser_rect = self:spawnObject(Rectangle(0, 0, SCREEN_WIDTH-(omega_x+48), arena.height/2), 0, self.laser_y)
			self.laser_rect.color = {1, 1, 1}
			self.laser_rect.layer = BATTLE_LAYERS["bullets"]
			self.laser_rect.y = self.laser_y+arena.height/4
			self.laser_rect.height = 0
			self.laser_rect.alpha = 0
			self.laser_start.point_b = arena.height/4
			self.laser_start.point_f = arena.height/4
			self.laser_start.alpha = 0
			self.timer:tween(0.2, self, {laser_power = 1}, "out-cubic")
			self.timer:tween(0.2, self.laser_start, {alpha = 1}, "out-cubic")
			self.timer:tween(0.2, self.laser_rect, {alpha = 1}, "out-cubic")
			self.laser_hitbox = self:spawnBullet("omegaspamton/hitboxbullet", arena.left, self.laser_y)
			wait(1)
			omega:setAnimation("laserend")
			self.timer:tween(0.2, self, {laser_power = 0}, "out-cubic")
			self.timer:tween(0.2, self.laser_start, {alpha = 0}, "out-cubic")
			self.timer:tween(0.2, self.laser_rect, {alpha = 0}, "out-cubic")
			self.timer:tween(0.2, omega.sprite, {laser_fade = 0.01}, "out-cubic")
			wait(0.2)
			self.laser_start:remove()
			self.laser_rect:remove()
			self.laser_hitbox:remove()
			self.laser_start = nil
			self.laser_rect = nil
			self.laser_hitbox = nil
			wait(0.1)
			for i = 1, 4 do
				local guy = self:spawnBullet("omegaspamton/lilguy", 700, 280)
				guy.physics.speed_x = -18
				guy.physics.friction = -0.1
				guy.timer:after(44/30, function() guy:switchToAlternatePhysics() end)
				guy.timer:after(40/30, function() guy:fire() end)
				guy.timer:after(32/30, function() guy:resetAnimationIndex() end)
				guy.physics.gravity = 0.5
				guy.physics.gravity_direction = math.rad(0)
				guy.collider.collidable = true
				guy.change_direction = false
				guy.altdirection = 0
				guy.altspeed = 4
				guy.altfriction = -0.2
				guy.altgravity = 0
				if self.laser_y == arena.top then
					guy.physics.speed_y = -2
				else
					guy.y = 40
					guy.physics.speed_y = 1.5
				end
				wait(5/30)
			end
			--omega:setAnimation("static")
			--self.timer:tween(0.2, omega, {y = 720}, "in-cubic")
			if self.laser_y == arena.top then
				self.laser_y = arena.bottom-arena.height/2
			else
				self.laser_y = arena.top
			end
		end
	end)
end

function BigLaser:update()
    super.update(self)
	
	local omega = Game.battle.enemies[1]
	local arena = Game.battle.arena
	
	if self.laser_start and self.laser_rect and omega then
		local lasersin = (math.sin(omega.sprite.lasertimer2 / 1.5) * 4)
		self.laser_rect.y = self.laser_y+(arena.height/4)-((arena.height/4)-lasersin)*self.laser_power
		self.laser_rect.height = ((arena.height/2)-(lasersin*2))*self.laser_power
		self.laser_start.point_b = (arena.height/4)-((arena.height/4)-lasersin)*self.laser_power
		self.laser_start.point_f = (arena.height/4)+((arena.height/4)-lasersin)*self.laser_power
		if self.laser_hitbox then
			self.laser_hitbox.y = self.laser_y+(arena.height/4)-((arena.height/4)-lasersin)*self.laser_power
			self.laser_hitbox:setHitbox(0, 0, arena.width, self.laser_rect.height)
		end
	end
	
	if self.charge_sfx then
		self.charge_sfx_pitch = self.charge_sfx_pitch + DTMULT
		self.charge_sfx:setPitch(Utils.clampMap(self.charge_sfx_pitch,0,30,0.1,1.5))
	end
	
--[[self.spawn_timer = self.spawn_timer + DTMULT
	
    if self.type == 1 or self.type == 2 or self.type == 3 or self.type == 4 or self.type == 5 or self.type == 6 or self.type == 7 then
        if self.spawn_timer == 1 then
            if self.type == 1 then
                self.row = Utils.pick{0, 1}
                if self.prevrow == 2 then
                    self.row = Utils.pick{0, 1}
                end
            end
			
            if self.type == 2 then
                local aa = Utils.pick{0, 1, 2}
                if prevrow_y == 0 then
                    aa = Utils.pick{1, 2}
                end
                if prevrow_y == 1 then
                    aa = Utils.pick{0, 2}
                end
                if prevrow_y == 2 then
                    aa = Utils.pick{0, 1}
                end
                self.rowy = 210 - 46 * aa
                prevrow_y = aa
                self.row = 2
            end
			
            if self.type == 3 or self.type == 4 then
                self.rowy = 210 - 40 * (Utils.pick{0, 1})
                self.row = Utils.pick{0, 1, 3, 6}
                if self.prevrow == 2 then
                    self.row = Utils.pick{0, 1, 3, 6}
                end
                if self.prevrow == 3 then
                    self.row = Utils.pick{0, 1}
                end
                if self.row == 3 and self.firstspawn == 0 then
                    self.row = Utils.pick{0, 1}
                end
                self.firstspawn = 1
            end
			
            if self.type == 5 then
                self.rowy = 210 - 40 * (Utils.pick{0, 1, 2})
                self.row = Utils.pick{0, 1, 2, 2, 3, 6}
                if self.prevrow == 2 then
                    self.row = Utils.pick{0, 1, 3, 6}
                end
                if self.prevrow == 3 then
                    self.row = Utils.pick{0, 1, 2}
                end
            end
		   
            if self.type == 6 then
                self.row = 6
            end
		   
            if self.type == 7 then
                self.row = 7
            end
        end
		
        if self.spawn_timer == 5 or self.spawn_timer == 10 or self.spawn_timer == 15 or self.spawn_timer == 20 then
            if self.row == 0 or self.row == 1 or self.row == 2 then
                local guy = self:spawnBullet("omegaspamton/lilguy", 700, 280)
                guy.physics.speed_x = -18
                guy.physics.friction = -0.1
                guy.physics.speed_y = -2
                guy.timer:after(44/30, function() guy:switchToAlternatePhysics() end)
                guy.timer:after(40/30, function() guy:fire() end)
                guy.timer:after(32/30, function() guy:resetAnimationIndex() end)
                guy.physics.gravity = 0.5
                guy.physics.gravity_direction = math.rad(0)
                guy.collider.collidable = true
                guy.change_direction = false
                guy.altdirection = 0
                guy.altspeed = 4
                guy.altfriction = -0.2
                guy.altgravity = 0

                if self.type == 2 then
                    guy.timer:after(44/30, function() guy:switchToAlternatePhysics() end)
                end
				
                if self.row == 1 then
                    guy.y = guy.y - 240
                    guy.physics.speed_y = -guy.physics.speed_y
                end
				
                if self.row == 2 then
                    guy.y = guy.y - 120
                    guy.physics.speed_y = 0
                    guy.physics.speed_x = -21
                end
				
                if self.row == 2 and self.type == 2 then
                    guy.physics.speed_x = -21
                    guy.physics.gravity = 0
                    guy.physics.friction = 0.5
                    guy.timer:after(36/30, function() guy:switchToAlternatePhysics() end)
                end
				
                if (self.type == 2 or self.type == 3 or self.type == 4 or self.type == 5) and self.row == 2 then
                    guy.y = self.rowy
                end
		    end
			
            if self.row == 3 and self.spawn_timer ~= 20 then
                for guyi = 0, 1 do
                    local guy = {}
					
                    guy[guyi] = self:spawnBullet("omegaspamton/lilguy", 300, -40 + 400 * guyi)
                    guy[guyi].physics.speed_y = 18 - 36 * guyi
                    guy[guyi].timer:after(44/30, function() guy[guyi]:switchToAlternatePhysics() end)
                    guy[guyi].timer:after(40/30, function() guy[guyi]:fire() end)
                    guy[guyi].timer:after(32/30, function() guy[guyi]:resetAnimationIndex() end)
                    guy[guyi].physics.gravity = -(0.8 - 1.6 * guyi)
                    guy[guyi].physics.gravity_direction = math.rad(90)
                    guy[guyi].collider.collidable = true
                end
            end
			
            if self.row == 6 and self.spawn_timer == 5 then
                self.spawncount = 2
                local a = 0
                for i = 1, self.spawncount do
                    local guy = self:spawnBullet("omegaspamton/lilguy", (445 + (a * 70)), (-20 + 400))
                    guy.physics.speed_y = -15
                    guy.timer:after(44/30, function() guy:switchToAlternatePhysics() end)
                    guy.timer:after(40/30, function() guy:fire() end)
                    guy.timer:after(32/30, function() guy:resetAnimationIndex() end)
                    guy.collider.collidable = true
                    guy.physics.gravity = 0.53
                    guy.physics.gravity_direction = math.rad(90)

                    local guy = self:spawnBullet("omegaspamton/lilguy", (410 + (a * 70)), (-20 + 0))
                    guy.physics.speed_y = 15
                    guy.timer:after(44/30, function() guy:switchToAlternatePhysics() end)
                    guy.timer:after(40/30, function() guy:fire() end)
                    guy.timer:after(32/30, function() guy:resetAnimationIndex() end)
                    guy.collider.collidable = true
                    guy.physics.gravity = -0.53
                    guy.physics.gravity_direction = math.rad(90)
					
                    a = a + DTMULT
                end
            end
        end
		
        if self.type == 2 and self.spawn_timer >= 41 then
            self.spawn_timer = 0
        end
        if self.type == 3 and self.spawn_timer >= 69 then
            self.spawn_timer = 0
        end
        if self.type == 6 and self.spawn_timer >= 69 then
            self.spawn_timer = 0
        end
        if self.type == 4 and self.spawn_timer >= 50 then
            self.spawn_timer = 0
        end
        if self.type == 5 and self.spawn_timer >= 69 then
            self.spawn_timer = 0
        end
        if self.spawn_timer >= 50 then
            self.spawn_timer = 0
        end
        if self.spawn_timer == 0 then
            self.prevrow = self.row
        end
    end]]
end

function BigLaser:draw()
    super.draw(self)
	
	if self.debug_render == true then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(Assets.getFont("main"))

        love.graphics.printf("--BIG LASER DEBUG--", 10, 370, SCREEN_WIDTH*2, "left", 0, 0.5, 0.5)
    end
end

function BigLaser:onEnd()
    self.debug_render = false
	local omega = Game.battle.enemies[1]
	omega:setAnimation("idle")
	if self.charge_sfx then
		self.charge_sfx:stop()
		self.charge_sfx = nil
	end
	Game.battle.timer:tween(0.5, omega, {y = 720}, "out-cubic")
	Assets.stopSound("sneo_overpower")
end

return BigLaser