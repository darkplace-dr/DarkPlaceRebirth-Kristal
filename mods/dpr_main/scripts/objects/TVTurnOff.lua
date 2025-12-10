local TVTurnOff, super = Class(Object)

function TVTurnOff:init(options)
    super.init(self)

    self:setLayer(9999)
	self:setParallax(0,0)
	
	self.con = 0
	self.subcon = 0
	self.timer = 0
	self.timer2 = 0
	
	local options = options or {}
	
	self.type = options["type"] or 0
	self.dest_map = options["map"]
	self.dest_marker = options["marker"] or "entry_cage"
	self.dest_facing = options["facing"] or "down"
	self.flag = options["flag"]
	
	self.texture_1 = Assets.getTexture("effects/zapper/tvturnoff1")
	self.texture_2 = Assets.getTexture("effects/zapper/tvturnoff2")
	self.xscale1 = 10
	self.yscale1 = 10
	self.xscale2 = 0.1
	self.yscale2 = 0.1
end

function TVTurnOff:update()
	super.update(self)
	
	self.timer = self.timer + DTMULT
	if self.con == 0 then
		if self.timer >= 5 then
			self.con = 1
			self.timer = 0
		end
	elseif self.con == 1 then
		if self.timer >= 4 and self.subcon == 0 then
			Assets.playSound("tvturnoff")
			self.subcon = 1
		end
		if self.timer >= 8 then
			Assets.playSound("tvturnoff2")
			if self.type == 0 then -- overworld
				Game.world.music:pause()
				Game.world.music:setVolume(0)
			elseif self.type == 1 then -- battle
				Game.battle.music:pause()
				Game.battle.music:setVolume(0)
			end
			self.con = 2
			self.subcon = 0
			self.timer = 0
		end
	elseif self.con == 2 then
		self.timer2 = self.timer2 + DTMULT
		if self.timer >= 30 then
			self.con = 3
			Game.fader.alpha = 1
			Game.fader:fadeIn()
			if self.type == 0 then -- overworld
				if self.flag then
					Game:setFlag(self.flag, true)
				end
				Game.world:loadMap(self.dest_map, self.dest_marker, self.dest_facing, nil)
				if Game.world.map.keep_music then
					Game.world.music:resume()
					Game.world.music:fade(1, 0.25)
				end
			elseif self.type == 1 then -- battle
				Game.battle.music:resume()
				Game.battle.music:fade(1, 0.25)
			end
			self:remove()
		end
	end
end

function TVTurnOff:draw()
	super.draw(self)
	
	if self.con > 0 and self.con < 3 then
		love.graphics.setColor(0,0,0,1)
		Draw.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	end
	love.graphics.setColor(1,1,1,1)
	if self.con == 0 then
		local alpha1 = MathUtils.lerp(0, 1, self.timer/5)
		love.graphics.setColor(1,1,1,alpha1)
		Draw.draw(self.texture_1, 320, 240, 0, 6, 10, 70, 119)
		love.graphics.setColor(1,1,1,1)
	elseif self.con == 1 then
		self.yscale1 = MathUtils.lerp(self.yscale1, 0.05, self.timer/8)
		Draw.draw(self.texture_1, 320, 240, 0, 6, self.yscale1, 70, 119)
		Draw.draw(self.texture_2, 320, 240, 0, 0.1, 0.1, 198, 193)
	elseif self.con == 2 then
		if self.timer <= 10 then
			self.xscale1 = MathUtils.lerp(self.xscale1, 0, self.timer/10)
			self.yscale1 = MathUtils.lerp(self.yscale1, 0.01, self.timer/10)
		end
		if self.timer2 <= 5 then
			self.xscale2 = MathUtils.lerp(self.xscale2, 0.4, self.timer2/5)
			self.yscale2 = MathUtils.lerp(self.yscale2, 0.4, self.timer2/5)
		else		
			self.xscale2 = MathUtils.lerp(self.xscale2, 0, (self.timer2-5)/5)
			self.yscale2 = MathUtils.lerp(self.yscale2, 0, (self.timer2-5)/5)
		end
		Draw.draw(self.texture_1, 320, 240, 0, self.xscale1, self.yscale1, 70, 119)
		Draw.draw(self.texture_2, 320, 240, 0, self.xscale2, self.yscale2, 198, 193)
	end
end

return TVTurnOff