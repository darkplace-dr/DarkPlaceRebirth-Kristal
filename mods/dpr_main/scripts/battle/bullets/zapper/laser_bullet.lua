local LaserBullet, super = Class(Bullet)

function LaserBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/zapper/laser")
	self.sprite:stop()
	self.sprite:setFrame(1)
	self:setOriginExact(22, 16)
	self:setScale(1, 0.2)
	self.image_yscale_goal = 1
	self.destroy_on_hit = false
	self.first = false
	self.bounce_offset = 14
	self.do_bounce = false
	if Game.battle.arena then
		self.bottom = Game.battle.arena.bottom
		self.top = Game.battle.arena.top
	end
	self.do_bounce_image = false
	self.neverbounce = false
	self.true_neverbounce = false
	self.blend = ColorUtils.hexToRGB("#898989")
	self.tp = 1.6
	self.afterimage_timer = 0
	self.layer_offset = 0
end

function LaserBullet:update()
	super.update(self)
	if Game.battle.wave_timer >= Game.battle.wave_length - 1/30 then
		self:remove()
	end
	self.do_bounce = false
	if self.y > self.top and self.y < self.bottom and not self.true_neverbounce then
		self.neverbounce = false
	end
	self.rotation = self.physics.direction
	if Game.battle.encounter.volume_up then
		self.scale_y = MathUtils.approach(self.scale_y, self.image_yscale_goal, 0.3 * DTMULT)
		if self.image_yscale_goal < 1 then
			self.scale_x = 0.6
		end
	else
		self.scale_y = MathUtils.approach(self.scale_y, self.image_yscale_goal, 0.2 * DTMULT)
		if self.image_yscale_goal < 1 then
			self.scale_x = 0.6
		end
	end
	self.physics.speed_x, self.physics.speed_y = self:getSpeedXY()
	self.physics.speed, self.physics.direction = 0, 0
	if self.physics.speed_y > 0 and not self.neverbounce then
		if self.y >= self.bottom then
			if math.abs(self.x - Game.battle.arena.x) < 165 then
				for i = 0, 10 do
					if self.y ~= self.bottom then
						self.y = self.y - (self.physics.speed_y * 0.1)
						self.x = self.x - (self.physics.speed_x * 0.1)
					end
					
					if self.y <= self.bottom then
						self.do_bounce = true
						self.sprite:setFrame(2)
						self.blend = ColorUtils.hexToRGB("#EE145B")
						break
					end
				end
			else
				self.neverbounce = true
			end
		end
	end
	if self.physics.speed_y < 0 and not self.neverbounce then
		if self.y <= self.top then
			if math.abs(self.x - Game.battle.arena.x) < 165 then
				for i = 0, 10 do
					if self.y ~= self.top then
						self.y = self.y - (self.physics.speed_y * 0.1)
						self.x = self.x - (self.physics.speed_x * 0.1)
					end
					
					if self.y >= self.top then
						self.do_bounce = true
						self.sprite:setFrame(3)
						self.blend = ColorUtils.hexToRGB("#0072BC")
						break
					end
				end
			else
				self.neverbounce = true
			end
		end
	end
	if self.do_bounce then
		self.physics.speed_y = self.physics.speed_y * -1
		if self.do_bounce_image and self.parent then
			for _, ball in ipairs(self.wave.laserballs) do
				if ball then
					ball.layer = ball.layer - 1
				end
			end
			local ball1 = Sprite("battle/bullets/zapper/laserball", self.x, self.y)
			ball1:setFrame(1)
			ball1:setOrigin(0.5)
			ball1.layer = self.layer + 16
			if Game.battle.encounter.volume_up then
				ball1:setScale(1.125, 1.125)
				Game.battle.timer:lerpVar(ball1, "scale_x", 1.125, 0, 4)
				Game.battle.timer:lerpVar(ball1, "scale_y", 1.125, 0, 4)
			else
				ball1:setScale(0.75, 0.75)
				Game.battle.timer:lerpVar(ball1, "scale_x", 0.75, 0, 4)
				Game.battle.timer:lerpVar(ball1, "scale_y", 0.75, 0, 4)
			end
			Game.battle.timer:after(4/30, function()
				ball1:remove()
			end)
			table.insert(self.wave.laserballs, ball1)
			self.parent:addChild(ball1)
			local ball2 = Sprite("battle/bullets/zapper/laserball", self.x, self.y)
			ball2:setFrame(1)
			ball2:setOrigin(0.5)
			ball2:setColor(self.blend)
			ball2.layer = self.layer - 2
			if Game.battle.encounter.volume_up then
				ball2:setScale(1.35, 1.35)
				Game.battle.timer:lerpVar(ball2, "scale_x", 1.35, 0, 5)
				Game.battle.timer:lerpVar(ball2, "scale_y", 1.35, 0, 5)
			else
				ball2:setScale(0.9, 0.9)
				Game.battle.timer:lerpVar(ball2, "scale_x", 0.9, 0, 5)
				Game.battle.timer:lerpVar(ball2, "scale_y", 0.9, 0, 5)
			end
			Game.battle.timer:after(5/30, function()
				ball2:remove()
			end)
			table.insert(self.wave.laserballs, ball2)
			self.parent:addChild(ball2)
		end
		
		if self.first then
			Assets.playSound("bell", 0.75)
		end
	end
	self.physics.speed, self.physics.direction = self:getSpeedDir()
	self.physics.speed_x, self.physics.speed_y = 0
	self.afterimage_timer = self.afterimage_timer + DTMULT
	if self.afterimage_timer >= 1 then
		if self.parent then
			local img = Sprite("battle/bullets/zapper/laser", self.x, self.y)
			img:stop()
			img:setFrame(self.sprite.frame)
			img:setOriginExact(22, 16)
			img.rotation = self.rotation
			img.scale_x = self.scale_x
			img.scale_y = self.scale_y
			img:setColor(self.blend)
			img.layer = BATTLE_LAYERS["below_bullets"]
			img:fadeOutSpeedAndRemove(0.25)
			self.parent:addChild(img)
			table.insert(self.wave.afterimages, img)
			self.afterimage_timer = 0
		end
	end
	if self.x < -80 then
		self:remove()
	end
	if self.x > 760 then
		self:remove()
	end
	if self.y < -80 then
		self:remove()
	end
	if self.y > 580 then
		self:remove()
	end
end

return LaserBullet