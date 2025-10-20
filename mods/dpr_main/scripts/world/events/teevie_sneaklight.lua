local TeevieSneakLight, super = Class(Event)

function TeevieSneakLight:init(data)
    super.init(self, data)

	local properties = data.properties or {}
	
	self:setOrigin(0.5)
	self:setScale(1)
	
	self.texture = Assets.getTexture("world/events/teevie_sneaklight/light")
	self.spotlight = Assets.getTexture("world/events/teevie_sneaklight/spotlight")
	
	self.wall_y = properties["wally"] or 240
	self.type = properties["type"] or 1
	self.move_type = properties["movetype"] or 0
	self.path = properties["path"]
	self.speed = properties["speed"] or 100
	self.timer = properties["timer"] or 0
	self.rate = properties["rate"] or 32
	self.path_speed = properties["pathspeed"] or 6
    self.progress = (properties["progress"] or 0) % 1
    self.reverse_progress = false
	self.can_catch = properties["catch"] ~= false
	self.catch_type = properties["catchtype"] or 1
	self.cutscene = properties["cutscene"]
	self.color = properties["color"] or Utils.hexToRgb("#B35B2D")
	self.lamp = properties["lamp"] ~= true
	self.lightpos = properties["lamppos"] or 180
	self.particles_on = properties["particles"] or self.lamp
	self.particle_timer = 0
	self.alerted = false
	self.give_points = true
	self.points_buffer = 0
	
	self.light_width = self.texture:getWidth()
	self.light_height = self.texture:getHeight()
	
	self.yy = self.y
end

function TeevieSneakLight:onAdd(parent)
    super.onAdd(self, parent)

    self:snapToPath()
end

function TeevieSneakLight:draw()
	if self.type == 0 then
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha * 0.5)
		Draw.draw(self.texture, 0 + math.sin(self.timer / 10) * 4, 0 + math.cos(self.timer / 23) * 1, 0, self.scale_x * 2, self.scale_y, 15, 7)
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha * 0.4)
		Draw.draw(self.texture, 0 + math.sin(self.timer / 11) * 4, 0, 0, (self.scale_x * 2) + 0.5, self.scale_y + 0.2, 15, 7)
	else
		local squash_height = 1
		local stretch_height = math.min((self.wall_y - self.y) / 8, self.light_height)
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha * 0.45)
		if stretch_height > 0 then
			Draw.drawPart(self.texture, 0, 0, 0, 0, self.light_width, stretch_height, 0, 4, 8, 15, 0)
		end
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha * 0.6)
		Draw.drawPart(self.texture, 0, 0 + stretch_height * 8, 0, stretch_height, self.light_width, self.light_height - stretch_height, 0, 4, 4, 15, 0)
	end
	if self.lamp then
		local modder = math.sin(self.timer / 10)
		
		love.graphics.setColor(18/255, 15/255, 10/255, 1)
		Draw.draw(Assets.getTexture("bubbles/fill"), (modder*2)-2, (self.yy-self.y - (self.yy-self.y)/4)-self.lightpos, math.rad(-180), 2, 40)
		Draw.draw(Assets.getTexture("bubbles/fill"), (modder*2)+4, (self.yy-self.y - (self.yy-self.y)/4)-self.lightpos, math.rad(-180), 2, 40)
		Draw.draw(Assets.getTexture("bubbles/fill"), (modder*1.5)-2, (self.yy-self.y - (self.yy-self.y)/4)-self.lightpos-40, math.rad(-180), 2, 120)
		Draw.draw(Assets.getTexture("bubbles/fill"), (modder*1.5)+4, (self.yy-self.y - (self.yy-self.y)/4)-self.lightpos-40, math.rad(-180), 2, 120)
		love.graphics.setColor(1,1,1,1)
		Draw.draw(self.spotlight, modder*2, (self.yy-self.y - (self.yy-self.y)/4)-self.lightpos, 0, 2, 2, 10, 0)
	end
	if DEBUG_RENDER and self.type ~= 0 then
		local stretch_height = math.min((self.wall_y - self.y) / 8, self.light_height)
		love.graphics.setColor(1,0,0,1)
		if self.catch_type == 1 and self.y < self.wall_y and math.abs(self.y - self.wall_y) < 110 then 
			Draw.rectangle("line", -18, self.wall_y-self.y-41, 41, 44+self.yy-self.wall_y)
		elseif self.catch_type == 0 then
			Draw.rectangle("line", -9, 15+stretch_height * 4, 23, 37)
		end
	end
	love.graphics.setColor(1,1,1,1)
end

function TeevieSneakLight:isActive()
    return not self.world:hasCutscene() and
           self.world.state ~= "MENU" and
           Game.state == "OVERWORLD"
end

function TeevieSneakLight:doCatch()
	if self.type == 0 then
		return
	end
	self.alerted = true
	Game.lock_movement = true
	self.world.timer:tween(16/30, self, {x = Game.world.player.x}, "out-back")
	if self.catch_type ~= 1 then
		self.world.timer:tween(16/30, self, {y = Game.world.player.y-30}, "out-back")
	end
    if self.cutscene then
		self.world.timer:after(16/30, function()
			self.world:startCutscene(self.cutscene, self)
		end)
    end
end

function TeevieSneakLight:update()
    if self:isActive() then
		self.timer = self.timer + DTMULT
		if not self.alerted then
			if self.path and self.world.map.paths[self.path] then
				local path = self.world.map.paths[self.path]

				if self.reverse_progress then
					self.progress = self.progress - (self.path_speed / path.length) * DTMULT
				else
					self.progress = self.progress + (self.path_speed / path.length) * DTMULT
				end
				if path.closed then
					self.progress = self.progress % 1
				elseif self.progress > 1 or self.progress < 0 then
					self.progress = Utils.clamp(self.progress, 0, 1)
					self.reverse_progress = not self.reverse_progress
				end

				self:snapToPath()
			else
				if self.move_type == 1 then
					self.y = (self.wall_y - 60) + (math.sin(self.timer / self.rate) * self.speed)
				end
			end
		end
		
		self.particle_timer = self.particle_timer + DTMULT
		if self.particle_timer >= 8 and self.particles_on then
			local effect = Sprite("bubbles/fill")
			effect:setScale(2)
			effect:setColor(COLORS["maroon"])
			effect:setPosition(Utils.random(self.x - self.light_width*2 - 10, self.x + self.light_width*2 + 10), self.y - Utils.random(200))
			effect.physics.speed_y = -2
			effect.physics.friction = 0.07
			effect.physics.speed_x = -1 + Utils.random(2)
			effect.layer = self.layer - 0.01
			effect:fadeOutAndRemove(1.5)
			Game.world:addChild(effect)
			self.particle_timer = 0
		end
		
		if self.type ~= 0 then
			if self.can_catch and not self.alerted then
				if self.world.player then
					Object.startCache()
					if self.catch_type == 1 then
						if self.y < self.wall_y and math.abs(self.y - self.wall_y) < 110 then
							local in_radius = self.world.player:collidesWith(Hitbox(self.world, self.x-18, self.wall_y-41, 41, 44+self.yy-self.wall_y))
							if in_radius then
								self:doCatch()
							end
						end
					elseif self.catch_type == 0 then
						local stretch_height = math.min((self.wall_y - self.y) / 8, self.light_height)
						local in_radius = self.world.player:collidesWith(Hitbox(self.world, self.x-9, self.y+15+stretch_height * 4, 23, 37))
						if in_radius then
							self:doCatch()
						end
					end
					if self.give_points and not self.alerted then
						if self.points_buffer < 0 then
							if Game:getFlag("sneaking_give_points", false) then
								if math.abs(self.y - self.world.player.y) < 180 and math.abs(self.world.player.x - self.x) < 10 then
									for _,light in ipairs(self.world:getEvents("teevie_sneaklight")) do
										light.points_buffer = 4
									end
									self.give_points = false
									Assets.playSound("barrel_jump", 0.8, 2)
									self.color = Utils.mergeColor(self.color, COLORS["blue"], 0.1)
									-- todo: points-like reward? i don't know
								end
							end
						else
							self.points_buffer = self.points_buffer - DTMULT
						end
					end
					Object.endCache()
				end
			end
		end
	end

    super.update(self)
end

function TeevieSneakLight:snapToPath()
    if self.path and self.world.map.paths[self.path] then
        local path = self.world.map.paths[self.path]

        local progress = self.progress
        if not path.closed then
            progress = Ease.inOutSine(progress, 0, 1, 1)
        end

        if path.shape == "line" then
            local dist = progress * path.length
            local current_dist = 0

            for i = 1, #path.points-1 do
                local next_dist = Utils.dist(path.points[i].x, path.points[i].y, path.points[i+1].x, path.points[i+1].y)

                if current_dist + next_dist > dist then
                    local x = Utils.lerp(path.points[i].x, path.points[i+1].x, (dist - current_dist) / next_dist)
                    local y = Utils.lerp(path.points[i].y, path.points[i+1].y, (dist - current_dist) / next_dist)

                    if self.debug_x and self.debug_y and Kristal.DebugSystem.last_object == self then
                        x = Utils.ease(self.debug_x, x, Kristal.DebugSystem.release_timer, "outCubic")
                        y = Utils.ease(self.debug_y, y, Kristal.DebugSystem.release_timer, "outCubic")
                        if Kristal.DebugSystem.release_timer >= 1 then
                            self.debug_x = nil
                            self.debug_y = nil
                        end
                    end

                    self:moveTo(x, y)
                    break
                else
                    current_dist = current_dist + next_dist
                end
            end
        elseif path.shape == "ellipse" then
            local angle = progress * (math.pi*2)
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

            self:moveTo(x, y)
        end
    end
end

return TeevieSneakLight