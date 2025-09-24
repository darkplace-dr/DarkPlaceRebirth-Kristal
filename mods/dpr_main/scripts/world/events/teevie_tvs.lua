local TeevieTVs, super = Class(Event)

function TeevieTVs:init(data)
    super.init(self, data)
	
	self.base_texture = Assets.getFrames("world/events/teevie_tvs/base")
	self.base_texture_thin = Assets.getFrames("world/events/teevie_tvs/base_thin")
	self.base_color = {91/255, 39/255, 69/255}
	local properties = data.properties or {}
	
	self.drawborders = properties["borders"] ~= false
	
	local can_kill = Game:getFlag("can_kill", false)
	self.tv_columns = math.ceil(self.width / 80)
	self.tv_rows = math.ceil(self.height / 80)
	self.tv_screens = {}
	for i = 1, self.tv_columns do
		self.tv_screens[i] = {}
		for j = 1, self.tv_rows do
			local ii = i - 1
			local jj = j - 1
			table.insert(self.tv_screens[i], {x = ii*80, y = jj*80, sprite = nil, timer = 0, frame = 1, con = 0, color = COLORS["white"], broken = false, nostatic = false})
			self:setScreen(self.tv_screens[i][j])
			if can_kill then
				self:setOff(self.tv_screens[i][j])
			end
		end
	end
	
	self.timer = 0
end

function TeevieTVs:setScreen(screen)
	screen.timer = -100 + math.floor(Utils.random(100))
	screen.frame = 1
	screen.sprite = Utils.pick({"lanino", "smooch", "tvloop", "elnina", "shadowguy", "asgore", "toriel", "pippins", "tvtime", "pattern", "retro", "arlee", "rickroll"})
	screen.con = 0
	screen.broken = false
	screen.nostatic = false
	if screen.sprite == "lanino" then
		screen.color = COLORS["aqua"]
	elseif screen.sprite == "smooch" then
		screen.color = COLORS["yellow"]
	elseif screen.sprite == "tvloop" then
		screen.color = {1, 212/255, 179/255}
		screen.con = 2
	elseif screen.sprite == "elnina" then
		screen.color = COLORS["aqua"]
		screen.con = 2
	elseif screen.sprite == "shadowguy" then
		screen.color = {1, 212/255, 179/255}
		screen.con = 2
	elseif screen.sprite == "asgore" then
		screen.color = {175/255, 193/255, 112/255}
		screen.con = 2
	elseif screen.sprite == "toriel" then
		screen.color = {1, 138/255, 45/255}
		screen.con = 2
	elseif screen.sprite == "pippins" then
		screen.color = {119/255, 122/255, 52/255}
		screen.con = 3
	elseif screen.sprite == "tvtime" then
		screen.color = COLORS["black"]
		screen.con = 3
	elseif screen.sprite == "pattern" then
		screen.color = {111/255, 149/255, 183/255}
		screen.con = 3
	elseif screen.sprite == "retro" then
		screen.color = {91/255, 168/255, 211/255}
		screen.con = 2
	elseif screen.sprite == "arlee" then
		screen.color = {148/255, 85/255, 172/255}
		screen.con = 2
	elseif screen.sprite == "rickroll" then
		screen.color = {110/255, 129/255, 161/255}
		screen.con = 2
	end
end

function TeevieTVs:setStatic(screen)
	screen.timer = 0
	screen.frame = 1
	screen.sprite = "static"
	screen.con = 1
	screen.color = COLORS["white"]
end

function TeevieTVs:setBroken(screen)
	screen.timer = 0
	screen.frame = 1
	screen.sprite = "broken"
	screen.con = 4
	screen.broken = true
	screen.color = COLORS["black"]
    super.update(self)
end

function TeevieTVs:setOff(screen)
	screen.timer = 0
	screen.frame = 1
	screen.sprite = "off"
	screen.con = 6
	screen.broken = true
	screen.color = COLORS["black"]
    super.update(self)
end

function TeevieTVs:update()
	self.timer = self.timer + DTMULT
	for i = 1, self.tv_columns do
		for j,screen in ipairs(self.tv_screens[i]) do
			local ii = i - 1
			local jj = j - 1
			screen.timer = screen.timer + (1 * DTMULT)
			if screen.con == 0 then
				if math.abs(screen.timer) % 8 == 0 then
					screen.frame = screen.frame + 1
				end
				if math.abs(screen.timer) >= 120 and screen.nostatic == false then
					self:setStatic(screen)
				end
			elseif screen.con == 1 then
				if math.abs(screen.timer) % 2 == 0 then
					screen.frame = screen.frame + 1
				end
				if math.abs(screen.timer) >= 15 then
					self:setScreen(screen)
				end
			elseif screen.con == 2 then
				if math.abs(screen.timer) % 4 == 0 then
					screen.frame = screen.frame + 1
				end
				if math.abs(screen.timer) >= 120 and screen.nostatic == false then
					self:setStatic(screen)
				end
			elseif screen.con == 3 then
				if math.abs(screen.timer) % 6 == 0 then
					screen.frame = screen.frame + 1
				end
				if screen.timer >= 120 and screen.nostatic == false then
					self:setStatic(screen)
				end
			elseif screen.con == 4 then
				if math.abs(screen.timer) >= 2 then
					screen.frame = 2
				end
				if math.abs(screen.timer) >= 4 then
					screen.frame = 3
				end
			elseif screen.con == 5 then
				if math.abs(screen.timer) % 1 == 0 then
					screen.frame = screen.frame + 1
				end
				if screen.timer >= 120 and screen.nostatic == false then
					self:setStatic(screen)
				end
			elseif screen.con == 6 then
				-- nothing
			end
		end
	end
	
    super.update(self)
end

function TeevieTVs:dessBreaksTVs()
	Game.world.timer:script(function(wait)
		for _,follower in ipairs(Game.world.followers) do
			if follower.visible and follower.actor.id == "dess" then
				follower.following = false
			end
		end
		local bscreens = nil
		local dess = Game.world:getCharacter("dess")
		local i = 1
		local keeplooping = true
		while keeplooping do
			if self.tv_screens[i][self.tv_rows].broken == false then
				local bscreen = self.tv_screens[i][self.tv_rows]
				if bscreen.sprite ~= "dess" then
					local walktime = Utils.round(Utils.dist(dess.x, dess.y, self.x + bscreen.x + 40, self.y + bscreen.y + 100) / 8)
					if i > 1 and walktime > 90 then
						keeplooping = false
					else
						if walktime < 1 then
							walktime = 1
						end
						dess:walkTo(self.x + bscreen.x + 40, self.y + bscreen.y + 100, walktime/30)
						wait(walktime/30)
						bscreen.nostatic = true
						if bscreen.sprite == "dess" then
							wait(0.2)
						else
							dess:setAnimation("battle/attack")
							dess.flip_x = true
							wait(0.2)
							Assets.playSound("glassbreak")
							Assets.playSound("mirrorbreak", 1.5)
							for i = 0, 8 do
								local shard = Sprite("world/events/teevie_tvs/shard", self.x + bscreen.x + 40, self.y + bscreen.y + 40)
								shard.physics.direction = math.rad(Utils.random(360))
								shard:setScale(2,2)
								shard.physics.speed = 12
								shard.physics.gravity = 0.8
								shard.layer = self.layer + 0.01
								shard:play(8/30)
								Game.world:addChild(shard)
							end
							self:setBroken(bscreen)
							wait(0.2)
							dess.flip_x = false
							dess:resetSprite()
						end
						wait(0.25)
					end
				end
			end
			i = i + 1
			if i >= self.tv_columns + 1 then keeplooping = false end
		end
		while Utils.dist(dess.x, dess.y, Game.world.player.x, Game.world.player.y) > 64 do
			dess:walkToSpeed(Game.world.player.x, Game.world.player.y, 8)
			wait(1/30)
		end
		dess.physics.move_target = nil
		Game.world.player:interpolateFollowers()
		for _,follower in ipairs(Game.world.followers) do
			if follower.visible and follower.actor.id == "dess" then
				follower.following = true
			end
		end
	end)
end

function TeevieTVs:draw()
    super.draw(self)
	
	Draw.setColor(0,0,0,1)
	Draw.rectangle("fill", 0, 0, self.width, self.height)
	Draw.setColor(1,1,1,1)
	love.graphics.setBlendMode("add")
	for i = 1, self.tv_columns do
		for j,screen in ipairs(self.tv_screens[i]) do
			local frames = Assets.getFrames("world/events/teevie_tvs/"..screen.sprite)
			Draw.draw(frames[((screen.frame - 1) % #frames) + 1], screen.x, screen.y, 0, 2, 2)
		end
	end
	love.graphics.setBlendMode("alpha")
	for i = 1, self.tv_columns do
		for j,screen in ipairs(self.tv_screens[i]) do
			local frames = self.base_texture_thin
			if self.drawborders == true then frames = self.base_texture end
			Draw.setColor(1,1,1,1)
			Draw.draw(frames[5], screen.x, screen.y, 0, 2, 2)
			if screen.con == 4 or screen.con == 6 then
				Draw.setColor(Utils.mergeColor(self.base_color, COLORS["black"], 0.5))
			else
				Draw.setColor(Utils.mergeColor(self.base_color, screen.color, 0.6 + (math.sin((self.timer / 4) + screen.x + screen.y) * 0.1)))
			end
			Draw.draw(frames[2], screen.x, screen.y, 0, 2, 2)
			Draw.setColor(Utils.mergeColor(self.base_color, COLORS["black"], 0.5))
			Draw.draw(frames[3], screen.x, screen.y, 0, 2, 2)
			Draw.setColor(self.base_color)
			Draw.draw(frames[4], screen.x, screen.y, 0, 2, 2)
			if screen.con ~= 4 then
				Draw.setColor(1,1,1,1)
				Draw.draw(frames[6], screen.x, screen.y, 0, 2, 2)
			end
		end
	end
	Draw.setColor(1,1,1,1)
end

return TeevieTVs