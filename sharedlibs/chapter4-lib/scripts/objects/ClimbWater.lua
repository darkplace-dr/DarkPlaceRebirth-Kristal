local ClimbWater, super = Class(Object)

function ClimbWater:init(x, y, watertype, movetimer, moverate, tilelimit, fallingtimer, falldir, spawnrate, activetime)
    super.init(self, x, y)
	self.waterheight = 0
	self.moverate = 4
	self.movetimer = 0
	self.fallingtimer = 10
	self.tilecount = 0
	self.timelimit = 12
	self.bad = 0
	self.damage = 0
	self.sndplayed = false
	self.drawx = 0
	self.drawy = 0
	self.totaltimer = 0
	self.falldir = "down"
	self.height = 40
	self.waterinit = false
	self.ending = false
	self.starty = self.y
	self.endy = self.y
	self.triggered = false
	self.animindex = 0
	self.watertile_top = Assets.getFrames("world/events/climbwater/dw_church_watertile_top")
	self.scaley = 1
	self.watertype = watertype
	self.movetimer = movetimer
	self.moverate = moverate
	self.tilelimit = tilelimit
	self.fallingtimer = fallingtimer
	self.falldir = falldir
	self.spawnrate = spawnrate
	self.activetime = activetime
	self:initWater()
end

function ClimbWater:update()
    super.update(self)
	if not self.waterinit then return end
	self.movetimer = self.movetimer + DTMULT
	self.totaltimer = self.totaltimer + DTMULT
	if self.watertype == 2 then
		if self.totaltimer < 15 then
			self.movetimer = self.movetimer - (1 - ((1/15) * self.totaltimer)) * DTMULT
		end
	end
	if self.falldir == "down" then
		self.drawy = (self.movetimer / self.moverate) * 40
	end
	if self.falldir == "right" then
		self.drawx = (self.movetimer / self.moverate) * 40
	end
	if self.falldir == "up" then
		self.drawy = -(self.movetimer / self.moverate) * 40
	end
	if self.falldir == "left" then
		self.drawx = -(self.movetimer / self.moverate) * 40
	end
	if self.movetimer >= self.moverate then
		self.movetimer = 0
		if self.falldir == "down" then
			self.y = self.y + 40
		end
		if self.falldir == "right" then
			self.x = self.x + 40
		end
		if self.falldir == "up" then
			self.y = self.y - 40
		end
		if self.falldir == "left" then
			self.x = self.x - 40
		end
		self.drawx = 0
		self.drawy = 0
		self.tilecount = self.tilecount + 1
		if self.watertype == 1 or self.watertype == 2 then
			if self.y > self.endy + 10 then
				self:remove()
			end
		end
	end
	if self.y >= Game.world.camera.y - SCREEN_HEIGHT/2 + 740 then
		self:remove()
	end		
	local topy = MathUtils.clamp(self.drawy, self.starty - self.y, self.endy - self.y)
	local boty = MathUtils.clamp(-40 + (self.scaley * 40) + self.drawy, self.starty - self.y, self.endy - self.y)
	self:setHitbox(0, topy, 40, boty - topy)
	if not self.triggered and Game.world.player.state_manager.state == "CLIMB" and not Game.lock_movement then
		local topy = MathUtils.clamp(self.drawy, self.starty - self.y, self.endy - self.y)
		local boty = MathUtils.clamp(-40 + (self.scaley * 40) + self.drawy, self.starty - self.y, self.endy - self.y)
		local width = 40
		local yoff = 8
		local adjustment = 0
		if self.watertype == 2 then
			width = 12
			yoff = 14 * self.scaley
			adjustment = 20
		end
		if boty - (topy + yoff) > 8 then
			Object.startCache()
			local collider = Hitbox(self, adjustment + 8, topy + yoff, adjustment + width - 16, boty - topy - 8)
			if Game.world.player:collidesWith(collider) then
				if Game.world.player.falling == 0 and Game.world.player.neutralcon == 1 or Game.world.player.jumpchargecon >= 1 then
					Game.world.player.falldir = self.falldir
					Game.world.player.falling = 1
					Game.world.player.fallingtimer = self.fallingtimer
					Game.world.player.cancel = 1
					self.triggered = true
					if not self.sndplayed then
						self.sndplayed = true
						Assets.playSound("motor_upper_2")
						Game.world.timer:after(1/30, function()
							Assets.playSound("motor_upper_2", 0.6, 0.75)
						end)
					end
				end
			end
			Object.endCache()
		end
	end
end

function ClimbWater:initWater()
	if not self.waterinit then
		if self.watertype == 1 or self.watertype == 2 then
			self.beginy = self.y
			self.scaley = 1 * (self.activetime / self.spawnrate)
			self.waterheight = self.scaley
			self.y = self.y - (self.scaley - 1) * 40
			self.endy = self.y + (self.scaley * 40) + (self.tilelimit * 40)
			local altendy = -1
			for i = 0, self.tilelimit + 4 do
				if altendy == -1 then
					Object.startCache()
					for _,bucket in ipairs(Game.world.map:getEvents("climbwaterbucket")) do
						local xx, yy = -(Game.world.camera.x-SCREEN_WIDTH/2), -(Game.world.camera.y-SCREEN_HEIGHT/2)
						local collider = Hitbox(self, xx, yy + 40 * i, 40, 40)
						if bucket:collidesWith(collider) and not bucket.generator then
							self.endy = bucket.y
							altendy = 1
						end
					end
					Object.endCache()
				end
			end
			self.waterinit = true
		end
	end
end

function ClimbWater:draw()
    super.draw(self)
	if not self.waterinit then return end
	local xx = 0
	local yy = 0
	if self.watertype == 1 then
		local watcol = ColorUtils.hexToRGB("0EBBE9FF")
		local topy = MathUtils.clamp(self.drawy, self.starty - self.y + 10, self.endy - self.y)
		local boty = MathUtils.clamp(-40 + (self.scaley * 40) + self.drawy, self.starty - self.y + 20, self.endy - self.y)
		local alph = MathUtils.clamp(self.animindex + (math.sin(self.animindex * 4) * 0.25), 0, 0.8)
		self.animindex = self.animindex + 0.25
		self.col = {ColorUtils.hexToRGB("00AAE9FF"),
		ColorUtils.hexToRGB("00AAE9FF"),
		ColorUtils.hexToRGB("0EBBE9FF"),
		ColorUtils.hexToRGB("00AAE9FF"),
		ColorUtils.hexToRGB("00B3EAFF")}
		local colindex = (math.floor(self.animindex) % 4) + 1
		local watcol = self.col[colindex]
		local offset = -8
		if self.ending then
			offset = 0
			alph = alph * Utils.clamp((boty - topy) / 20, 0, 1)
		end
		love.graphics.setBlendMode("add")
		Draw.setColor(ColorUtils.mergeColor({0,0,0,1}, {1,1,1,1}, alph))
 		Draw.draw(self.watertile_top[colindex], xx, yy + topy, 0, 2, 2, 0, 8)
		if not self.ending then
			Draw.draw(self.watertile_top[colindex], xx, yy + boty - 8, 0, 2, -2, 0, 8)
		end
		Draw.setColor(ColorUtils.mergeColor({0,0,0,1}, watcol, alph))
 		Draw.draw(Assets.getTexture("bubbles/fill"),  xx, yy + topy, 0, 20 * 2, (boty - topy) + offset)
		Draw.setColor(1,1,1,1)
		love.graphics.setBlendMode("alpha")
	end
	if DEBUG_RENDER then
		local topy = MathUtils.clamp(self.drawy, self.starty - self.y, self.endy - self.y)
		local boty = MathUtils.clamp(-40 + (self.scaley * 40) + self.drawy, self.starty - self.y, self.endy - self.y)
		local kris = 0
		local width = 40
		local yoff = 8
		local adjustment = 0
		local collider = Hitbox(self, adjustment + 8, topy + yoff, adjustment + width - 16, boty - topy - 8)
		collider:draw(1,0,0)
		if self.collider then
			self.collider:draw(0,1,0)
		end
	end
end

return ClimbWater