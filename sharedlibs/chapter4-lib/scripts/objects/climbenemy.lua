local ClimbEnemy, super = Class(Event, "ClimbEnemy")

function ClimbEnemy:init(data)
    super.init(self, data)
	self.x = self.x + 20
	self.y = self.y + 20
    local properties = data and data.properties or {}
    self:setSprite("world/events/climbenemy/enemy_40")
	self.buffer = 0
	self.sprite:setScale(1)
	self.sprite:setOrigin(0.5)
	self:setHitbox(5 - 20, 5 - 20, 30, 30)
	self.damagecon = 0
	self.timer = 0
	self.bactive = true
	self.flashadjustmentx = 0
	self.flashadjustmenty = 0
	self.effectadjustmentx = 0
	self.effectadjustmenty = 0
	self.shakex = 0
	self.hp = properties["hp"] or 1
	self.dir = 2
	self.prefdir = "left"
	self.neutralcon = 0
	self.waittimer = MathUtils.randomInt(0, 30)
	self.updwait = -1
	self.ignoreblocked = false
	self.movetimer = 0
	self.updmove = -1
	self.safex = self.x
	self.safey = self.y
	self.lastdir = -1
	self.failmovecount = 0
	self.failmovethresh = 4
	self.movevistype = 0
	self.angle = 0
	self.invincible = properties["invincible"] or false
	self.damage = properties["damage"] or 30
	self.hp = properties["hp"] or 1
	self.waittime = properties["waittime"] or 0
	self.movetime = properties["speed"] or 12
	self.influenceable = properties["influence"] or true
	self.homedistance = properties["homedist"] or 120
	self.movetype = properties["movetype"] or 0
    self.path = properties["path"]
    self.speed = properties["speed"] or 12
    self.progress = (properties["progress"] or 0) % 1
    self.reverse_progress = false
	if Game.world.map.cyltower then
		self.visible = false
		if Game.world.map.cyltower.appearance == 1 then
			self.x = self.x - 40
			self.flashadjustmentx = -20
			self.flashadjustmenty = 20
			self.effectadjustmentx = -60
			self.effectadjustmenty = 20
		else
			self.flashadjustmentx = -20
			self.flashadjustmenty = -20
			self.effectadjustmentx = -20
			self.effectadjustmenty = -20
		end
	end
	self.climb_obstacle = true
end

function ClimbEnemy:onAdd(parent)
    super.onAdd(self, parent)

    self:snapToPath()
end

function ClimbEnemy:snapToPath()
    if self.path and self.world.map.paths[self.path] then
        local path = self.world.map.paths[self.path]

        local progress = self.progress
        if not path.closed then
            progress = Ease.inOutSine(progress, 0, 1, 1)
        end

        if path.shape == "line" then
            local dist = progress * path.length
            local current_dist = 0

            for i = 1, #path.points - 1 do
                local next_dist = MathUtils.dist(path.points[i].x, path.points[i].y, path.points[i + 1].x, path.points[i + 1].y)

                if current_dist + next_dist > dist then
                    local x = MathUtils.lerp(path.points[i].x, path.points[i + 1].x, MathUtils.clamp((dist - current_dist) / next_dist, 0, 1))
                    local y = MathUtils.lerp(path.points[i].y, path.points[i + 1].y, MathUtils.clamp((dist - current_dist) / next_dist, 0, 1))

                    if self.debug_x and self.debug_y and Kristal.DebugSystem.last_object == self then
                        x = Utils.ease(self.debug_x, x, Kristal.DebugSystem.release_timer, "outCubic")
                        y = Utils.ease(self.debug_y, y, Kristal.DebugSystem.release_timer, "outCubic")
                        if Kristal.DebugSystem.release_timer >= 1 then
                            self.debug_x = nil
                            self.debug_y = nil
                        end
                    end

                    self.x = x
					self.y = y
					self.sprite.rotation = MathUtils.angle(path.points[i].x, path.points[i].y, path.points[i + 1].x, path.points[i + 1].y) - math.rad(90)
                    break
                else
                    current_dist = current_dist + next_dist
                end
            end
        elseif path.shape == "ellipse" then
            local angle = progress * (math.pi * 2)
            local x = path.x + math.cos(angle) * path.rx
            local y = path.y + math.sin(angle) * path.ry

            if self.debug_x and self.debug_y and Kristal.DebugSystem.last_object == self then
                x = Utils.ease(self.debug_x, x, Kristal.DebugSystem.release_timer, "outCubic")
                y = Utils.ease(self.debug_y, y, Kristal.DebugSystem.release_timer, "outCubic")
                if Kristal.DebugSystem.release_timer >= 1 then
                    self.debug_x = nil
                    self.debug_y = nil
                end
            end

            self.x = x
			self.y = y
			self.sprite.rotation = angle
        end
    end
end

function ClimbEnemy:update()
    super.update(self)
	Object.startCache()
	if Game.world.player:collidesWith(self.collider) then
		if Game.world.player.climbcon == 2 then
			if Game.world.player.climb_jumping == 1 then
				if self.damagecon == 0 then
					Game.world.player.climbcon = 10
					Game.world.player.cuttimer = 0
					if Game.world.player.climb_during_timer then
						Game.world.timer:pause(Game.world.player.climb_during_timer)
					end
					if Game.world.player.climb_after_1_timer then
						Game.world.timer:pause(Game.world.player.climb_after_1_timer)
					end
					if Game.world.player.climb_after_2_timer then
						Game.world.timer:pause(Game.world.player.climb_after_2_timer)
					end
					self.damagecon = 1
				end
			elseif Game.world.player.climb_inv_timer <= 0 and Game.world.player:isMovementEnabled() and self.damagecon == 0 then
				Game.world.player:climbHurtParty(self.damage)
			end
		end
	end
	Object.endCache()
	if self.damagecon == 1 then
		if not self.invincible then
			self.damagecon = 2
			self.bactive = false
		else
			self.damagecon = 0
		end
		return
	end
	if self.damagecon == 2 then
		self.timer = 0
		self.color = COLORS.white
		if self.world.map.cyltower then
			local flash = FlashFadeTower(self.sprite.texture, self.x + self.flashadjustmentx + 40, self.y + self.flashadjustmenty)
			Game.world:addChild(flash)
		else
			local flash = self:flash()
			flash.x = flash.x + self.flashadjustmentx
			flash.y = flash.y + self.flashadjustmenty
		end
		Assets.playSound("ui_cancel", 0.4, 1.2)
		Assets.playSound("laz_c", 0.3, 1.2)
		local dmg_sprite = Sprite("effects/attack/cut")
        dmg_sprite:setOrigin(0.5, 0.5)
        dmg_sprite:setScale(2, 2)
        local relative_pos_x, relative_pos_y = self:getRelativePos(-40+self.width / 2, -40+self.height / 2)
        dmg_sprite:setPosition(relative_pos_x, relative_pos_y)
		if self.world.map.cyltower then
			dmg_sprite:setPosition(self.world.map.cyltower.tower_x, self.world.map.cyltower.krisy)
		end
        dmg_sprite.layer = self.layer + 1
        dmg_sprite:play(1 / 15, false, function(s) s:remove() end)
        Game.world:addChild(dmg_sprite)
		self:shake()
		self.hp = self.hp - 1
		if self.hp > 0 then
			self.damagecon = 0
			Game.world.player.falling = 1
			Game.world.player.fallingtimer = 20
		else
			self.damagecon = 3
		end
		return
	end
	if self.damagecon == 3 then
		self.timer = self.timer + DTMULT
		if self.timer >= 8 then
			local dmg_sprite = Sprite("effects/attack/slap_n")
			dmg_sprite:setOrigin(0.5, 0.5)
			dmg_sprite:setScale(2, 2)
			local relative_pos_x, relative_pos_y = self:getRelativePos(-40+self.width / 2, -40+self.height / 2)
			dmg_sprite:setPosition(relative_pos_x, relative_pos_y)
			if self.world.map.cyltower then
				dmg_sprite:setPosition(self.world.map.cyltower.tower_x, self.world.map.cyltower.krisy)
			end
			dmg_sprite.layer = self.layer + 0.01
			dmg_sprite:play(1 / 15, false, function(s) s:remove() end)
			Game.world:addChild(dmg_sprite)
			
			local dmg_sprite_2 = Sprite("effects/attack/slap_n")
			dmg_sprite_2:setColor(COLORS.black)
			dmg_sprite_2:setOrigin(0.5, 0.5)
			dmg_sprite_2:setScale(2, 2)
			dmg_sprite_2:setPosition(relative_pos_x, relative_pos_y)
			if self.world.map.cyltower then
				dmg_sprite_2:setPosition(self.world.map.cyltower.tower_x, self.world.map.cyltower.krisy)
			end
			dmg_sprite_2.layer = self.layer + 0.01
			dmg_sprite_2:play(1 / 15, false, function(s) s:remove() end)
			Game.world:addChild(dmg_sprite_2)
            local afterimage = AfterImage(dmg_sprite_2, 0.5)
			dmg_sprite_2:addChild(afterimage)
			Assets.playSound("ui_cancel", 1, 0.5)
			Assets.playSound("damage", 0.5, 0.5)
			Assets.playSound("punchmed", 0.4, 1)
			if self.world.map.cyltower then	
				local afterimage_2 = AfterImageCutHalfTower(self.sprite.texture_path)
				afterimage_2:setPosition(self.x + self.effectadjustmentx + 40, self.y + self.effectadjustmenty)
				afterimage_2.layer = self.layer
				afterimage_2:setOriginExact(0, 0)
				Game.world:addChild(afterimage_2)
				self:remove()
			else
				local afterimage_2 = AfterImageCutHalf(self.sprite.texture_path)
				afterimage_2:setPosition(self.x + self.effectadjustmentx, self.y + self.effectadjustmenty)
				afterimage_2.layer = self.layer
				afterimage_2:setOriginExact(0, 0)
				Game.world:addChild(afterimage_2)
				self:remove()
			end
		end
		return
	end
	if not Game.world.player:isMovementEnabled() then
		return
	end
	if self.movetype == 9 then
		return
	end
	if self.path then
        if self.world.map.paths[self.path] then
            local path = self.world.map.paths[self.path]

            if self.reverse_progress then
                self.progress = self.progress - (self.speed / path.length) * DTMULT
            else
                self.progress = self.progress + (self.speed / path.length) * DTMULT
            end
            if path.closed then
                self.progress = self.progress % 1
            elseif self.progress > 1 or self.progress < 0 then
                self.progress = MathUtils.clamp(self.progress, 0, 1)
                self.reverse_progress = not self.reverse_progress
            end

            self:snapToPath()
			self.sprite:setFrame(math.floor(((Kristal.getTime()*30) / 4) % 3) + 1)
		end
	else
		if self.neutralcon == 0 then
			self.waittimer = self.waittimer + DTMULT
			if self.waittimer >= self.waittime then
				self.waittimer = 0
				self.movetimer = 0
				
				if self.updmove ~= -1 then
					self.movetime = self.updmove
					self.updmove = -1
				end			
				if self.updwait ~= -1 then
					self.waittime = self.updwait
					self.updwait = -1
				end
				local domove = false
				local normalpath = false
				local seek = false
				local kris = Game.world.player
				
				if self.movetype == 0 then
					normalpath = true
				end
				
				if self.movetype == 1 then
					if kris and MathUtils.dist(self.x, self.y, kris.x, kris.y) <= self.homedist then
						seek = true
					end
					
					if seek == false then
						normalpath = true
					end
				end
				
				if self.movetype == 2 then
					seek = true
					if not kris then
						seek = false
					end
				end

				if self.influenceable then
					Object.startCache()
					local pathturner
					for _, event in ipairs(self.world.stage:getObjects(Event)) do
						self.climb_collider = Hitbox(self, 0, 0, 40, 40)
						if (event.pathturner) and event:collidesWith(self.climb_collider) then
							if event.pathturner then
								pathturner = event
							end
						end
					end
					Object.endCache()
					if pathturner and MathUtils.random(0, 1) <= pathturner.chance then
						seek = false
						normalpath = false
						self.dir = pathturner.dir
						domove = true
					end
				end
				if seek then
					normalpath = false
					local krisdir = MathUtils.angle(self.x, self.y, kris.x, kris.y)
					local card = MathUtils.round(math.deg(krisdir) / 90) + 1
					if card > 3 then
						card = 0
					end
					local good = {true,true,true,true}
					if self.failmovecount < self.failmovethresh then
						if self.lastdir == 0 then
							good[3] = false
						end
						if self.lastdir == 2 then
							good[1] = false
						end
						if self.lastdir == 1 then
							good[4] = false
						end
						if self.lastdir == 3 then
							good[2] = false
						end
					end
						
					for i = 1, 4 do
						local px = 0
						local py = 0
						local potcard = card + (i - 1)
						if potcard > 3 then
								potcard = 0
						end
						if potcard == 0 then
							py = 40
						end
						if potcard == 1 then
							px = 40
						end
						if potcard == 2 then
							py = -40
						end
						if potcard == 3 then
							px = -40
						end
						if good[potcard + 1] then
							Object.startCache()
							local climbarea
							local pathturner
							for _, event in ipairs(self.world.stage:getObjects(Event)) do
								self.climb_collider = Hitbox(self, px, py, 40, 40)
								if (event.climbable) and event:collidesWith(self.climb_collider) then
									if event.climbable then
										climbarea = event
									end
								elseif (event.pathturner) and event:collidesWith(self.climb_collider) then
									if event.pathturner then
										pathturner = event
									end
								end
							end
							Object.endCache()
							if not climbarea then
								good[potcard + 1] = false
							end
							if not good[potcard] and pathturner then
								good[potcard + 1] = true
							end
						end
					end
						
					if good[card] then
						self.dir = card
						domove = true
					end
						
					if not domove then
						local turnleft = MathUtils.wrap(card - 1, 0, 3)
						local turnright = MathUtils.wrap(card + 1, 0, 3)
						
						if card == 0 then
							turnleft = 3
							turnright = 1
						elseif card == 1 then
							turnleft = 2
							turnright = 0
						elseif card == 2 then
							turnleft = 3
							turnright = 1
						elseif card == 3 then
							turnleft = 0
							turnright = 2
						end
							
						local px = 0
						local py = 0
						if good[turnleft] and not good[turnright] then
							self.dir = turnleft
							domove = true
						end
						if good[turnright] and not good[turnleft] then
							self.dir = turnright
							domove = true
						end
						if good[turnright] and good[turnleft] then
							local leftdist = 0
							local rightdist = 0
							potcard = turnleft
							if potcard == 0 then
								py = 40
							end
							if potcard == 1 then
								px = 40
							end
							if potcard == 2 then
								py = -40
							end
							if potcard == 3 then
								px = -40
							end
							leftdist = MathUtils.dist(self.x + px, self.y + py, kris.x, kris.y)
							potcard = turnright
							if potcard == 0 then
								py = 40
							end
							if potcard == 1 then
								px = 40
							end
							if potcard == 2 then
								py = -40
							end
							if potcard == 3 then
								px = -40
							end
							rightdist = MathUtils.dist(self.x + px, self.y + py, kris.x, kris.y)
							if leftdist > rightdist then
								self.dir = turnright
								domove = true
							else
								self.dir = turnleft
								domove = true
							end
						end
					end
						
					if not domove then
						failmovecount = self.failmovecount + 1
					end
				end
				if normalpath then
					for i = 1, 4 do
						if domove then goto continue end
						local px = 0
						local py = 0
						if self.dir == 0 then
							py = 40
						end
						if self.dir == 1 then
							px = 40
						end
						if self.dir == 2 then
							py = -40
						end
						if self.dir == 3 then
							px = -40
						end
						Object.startCache()
						local climbarea
						local pathturner
						for _, event in ipairs(self.world.stage:getObjects(Event)) do
							self.climb_collider = Hitbox(self, px, py, 40, 40)
							if event.climbable then
								climbarea = event
							elseif (event.pathturner) and event:collidesWith(self.climb_collider) then
								if event.pathturner then
									pathturner = event
								end
							end
						end
						Object.endCache()
						if climbarea or pathturner then
							domove = true
						end
						if not domove then
							if self.prefdir == "left" then
								self.dir = self.dir + 1
							else
								self.dir = self.dir - 1
							end
							if self.dir > 3 then
								self.dir = 0
							end
							if self.dir < 0 then
								self.dir = 3
							end
						end
						::continue::
					end
				end
				if domove then
					self.neutralcon = 1
					self.safex = self.x
					self.safey = self.y
				end
			end
		end
		if self.neutralcon == 1 then
			local px = 0
			local py = 0
			if self.dir == 0 then
				py = 40
				self.angle = 0
			end
			if self.dir == 1 then
				px = 40
				self.angle = math.rad(270)
			end
			if self.dir == 2 then
				py = -40
				self.angle = math.rad(180)
			end
			if self.dir == 3 then
				px = -40
				self.angle = math.rad(90)
			end
			
			self.movetimer = self.movetimer + DTMULT
			local prog = MathUtils.clamp(self.movetimer, 0, self.movetime) / self.movetime
			local pointAx = self.safex
			local pointBx = self.safex + px
			local pointAy = self.safey
			local pointBy = self.safey + py
			if self.movevistype == 0 then
				self.x = MathUtils.lerp(pointAx, pointBx, prog)
				self.y = MathUtils.lerp(pointAy, pointBy, prog)
			end
			if self.movevistype == 1 then
				self.x = MathUtils.lerp(pointAx, pointBx, MathUtils.easeInOutAccurate(prog, 2))
				self.y = MathUtils.lerp(pointAy, pointBy, MathUtils.easeInOutAccurate(prog, 2))
			end
			if self.movetimer >= self.movetime then
				self.failmovecount = 0
				self.lastdir = self.dir
				self.x = self.safex + px
				self.y = self.safey + py
				self.neutralcon = 0
				
				if self.updmove ~= -1 then
					self.movetime = self.updmove
					self.updmove = -1
				end			
				if self.updwait ~= -1 then
					self.waittime = self.updwait
					self.updwait = -1
				end
			end
		end
		self.sprite:setFrame(math.floor(((Kristal.getTime()*30) / 4) % 3) + 1)
		self.sprite.rotation = math.rad(-self.dir * 90)
	end
end

return ClimbEnemy