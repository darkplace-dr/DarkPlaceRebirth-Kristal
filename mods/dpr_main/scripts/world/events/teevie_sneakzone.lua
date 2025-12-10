local TeevieSneakZone, super = Class(Event)

function TeevieSneakZone:init(data)
    super.init(self, data)

	local properties = data.properties or {}
	self.sneaking = false
	self.was_sneaking = false
	self.timer = 0
	self.stealth_timer = 0
	self.lerp_strength = 0.1
	
	self.arrow_color = properties["linecol"] or {136/255, 72/255, 35/255}
	self.footprint_color = properties["footprintcol"] or {65/255, 35/255, 17/255}
	self.stealth_speed = properties["speed"] or 16
	
	self.facing = "right"
	self.old_facing = self.facing
	self.plx = -1
	self.ply = -1
	self.flx = {}
	self.fly = {}
	self.flx[1] = -1
	self.fly[1] = -1
	self.flx[2] = -1
	self.fly[2] = -1
	self.player_frame = 0
	self.follower_frame = {}
	self.follower_frame[1] = 0
	self.follower_frame[2] = 0
end

function TeevieSneakZone:onLoad()
	super.onLoad(self)
	
	self.downarrow1 = Sprite("world/events/teevie_sneakzone/downarrow", self.x - 4,  self.y + 10 - 40)
	self.downarrow1:setScale(2,2)
	self.downarrow1:setColor(self.arrow_color)
	self.downarrow1:setLayer(self.layer)
	Game.world:addChild(self.downarrow1)
	self.downarrow2 = Sprite("world/events/teevie_sneakzone/downarrow", self.x + 4 + self.width + 4,  self.y + 10 - 40)
	self.downarrow2:setScale(-2,2)
	self.downarrow2:setColor(self.arrow_color)
	self.downarrow2:setLayer(self.layer)
	Game.world:addChild(self.downarrow2)
	self.line = Sprite("world/events/teevie_sneakzone/line", self.x + 18, self.y + 10 - 40)
	self.line.wrap_texture_x = true
	self.line:setScale(2,2)
	self.line:setColor(self.arrow_color)
	self.line:setLayer(self.layer)
	self.line:addFX(ScissorFX(0, 0, self.width-32, 40))
	Game.world:addChild(self.line)
	self.footprints = {}
	for i = 1, self.width/40 do
		local xpos = self.x + ((i-1) * 40)
		if (i-1) % 3 == 0 then
			xpos = xpos + 4
		end
		local ypos = self.y + 4
		if (i-1) % 2 == 0 then
			ypos = ypos + 6
		end
		self.footprints[i] = Sprite("world/events/teevie_sneakzone/footprint", xpos, ypos)
		self.footprints[i]:setScale(2,2)
		self.footprints[i]:setColor(self.footprint_color)
		self.footprints[i]:setLayer(self.layer)
		Game.world:addChild(self.footprints[i])
	end
	Game:setFlag("sneaking_give_points", false)
end

function TeevieSneakZone:update()
    super.update(self)
	self.timer = self.timer + DTMULT
	
	if self.sneaking == true then
		self.stealth_timer = self.stealth_timer + DTMULT
		if self.stealth_timer > 6 then
			self.stealth_timer = 6
		end
		self.lerp_strength = MathUtils.lerp(self.lerp_strength, 0.5, 0.2*DTMULT)
		if Game.world.player:isMovementEnabled() then
			local walk_x = 0
			local walk_y = 0

			if     Input.down("left")  then walk_x = walk_x - 1
			elseif Input.down("right") then walk_x = walk_x + 1 end
			if     Input.down("up")    then walk_y = walk_y - 1
			elseif Input.down("down")  then walk_y = walk_y + 1 end

			self.moving_x = walk_x
			self.moving_y = walk_y

			local speed = math.max(2, (self.stealth_speed * self.stealth_timer) / 6)
			
			local movex, movey = walk_x * (speed * DTMULT), walk_y * (speed * DTMULT)
			Game.world.player:moveX(movex, movey)
			Game.world.player:moveY(movey, movex)
					
			if Input.down("right") then self.facing = "right" end
			if Input.down("left") then self.facing = "left" end
		end
		if self.facing ~= self.old_facing then
			Game.world.player:setSprite("sneak/"..self.facing)
			for _, follower in ipairs(self.world.followers) do
				follower:setSprite("sneak/"..self.facing)
			end
			self.old_facing = self.facing
		end
		local su_xoff = 16
		local su_yoff = -8
		local ra_xoff = -24
		local ra_yoff = -8
		if self.facing == "left" then
			su_xoff = -16
			ra_xoff = 24
		end
		if MathUtils.dist(Game.world.player.x, Game.world.player.y, self.plx, self.ply) > 1 then
			self.player_frame = self.player_frame + 0.125 * DTMULT
		end
		if MathUtils.dist(Game.world.player.x, Game.world.player.y, self.plx, self.ply) > 2 then
			self.player_frame = self.player_frame + 0.0625 * DTMULT
		end
		Game.world.player.sprite:setFrame(1 + math.floor(self.player_frame))
		self.plx = Game.world.player.x
		self.ply = Game.world.player.y
		if Game.world.followers[1] then
			Game.world.followers[1].x = MathUtils.lerp(Game.world.followers[1].x, Game.world.player.x + su_xoff, self.lerp_strength*DTMULT)
			Game.world.followers[1].y = MathUtils.lerp(Game.world.followers[1].y, Game.world.player.y + su_yoff, (self.lerp_strength*1.5)*DTMULT)
			if MathUtils.dist(Game.world.followers[1].x, Game.world.followers[1].y, self.flx[1], self.fly[1]) > 1 then
				self.follower_frame[1] = self.follower_frame[1] + 0.125 * DTMULT
			end
			if MathUtils.dist(Game.world.followers[1].x, Game.world.followers[1].y, self.flx[1], self.fly[1]) > 2 then
				self.follower_frame[1] = self.follower_frame[1] + 0.0625 * DTMULT
			end
			Game.world.followers[1].sprite:setFrame(1 + math.floor(self.follower_frame[1]))
			self.flx[1] = Game.world.followers[1].x
			self.fly[1] = Game.world.followers[1].y
		end
		if Game.world.followers[2] then
			Game.world.followers[2].x = MathUtils.lerp(Game.world.followers[2].x, Game.world.player.x + ra_xoff, self.lerp_strength*DTMULT)
			Game.world.followers[2].y = MathUtils.lerp(Game.world.followers[2].y, Game.world.player.y + ra_yoff, (self.lerp_strength*1.5)*DTMULT)
			if MathUtils.dist(Game.world.followers[2].x, Game.world.followers[2].y, self.flx[2], self.fly[2]) > 1 then
				self.follower_frame[2] = self.follower_frame[2] + 0.125 * DTMULT
			end
			if MathUtils.dist(Game.world.followers[2].x, Game.world.followers[2].y, self.flx[2], self.fly[2]) > 2 then
				self.follower_frame[2] = self.follower_frame[2] + 0.0625 * DTMULT
			end
			Game.world.followers[2].sprite:setFrame(1 + math.floor(self.follower_frame[2]))
			self.flx[2] = Game.world.followers[2].x
			self.fly[2] = Game.world.followers[2].y
		end
	else
		self.lerp_strength = MathUtils.lerp(self.lerp_strength, 0.1, 0.1*DTMULT)
	end
end

function TeevieSneakZone:onEnter(chara)
	if chara.is_player then
		self.sneaking = true
		Game.world.player:setState("SNEAK")
		Game.world.player:setSprite("sneak/"..self.facing)
        for _, follower in ipairs(Game.world.followers) do
			follower:setSprite("sneak/"..self.facing)
			follower.following = false
		end
		self.plx = Game.world.player.x
		self.ply = Game.world.player.y
		Game:setFlag("sneaking_give_points", true)
	end
end

function TeevieSneakZone:onExit(chara)
	if chara.is_player then
		self.sneaking = false
		self.stealth_timer = 0
		Game.world.player:setState("WALK")
		Game.world.player:resetSprite()
        for _, follower in ipairs(Game.world.followers) do
			follower:resetSprite()
			follower.following = true
		end
		Game.world.player:interpolateFollowers()
		Game:setFlag("sneaking_give_points", false)
	end
end

return TeevieSneakZone