local ChurchPiano, super = Class(Event, "piano")

function ChurchPiano:init(data)
    super.init(self, data)
	
    local properties = data.properties or {}

	self.prop = properties["cutscene"]
	
	self.draw_children_above = 1
	self.solid = true
	self.leader_x = data.center_x
	self.leader_y = self.y + self.height + 24
	self.catafollow = true
	self.con = 0
	self.forceend = false
	self.timer = 0
	self.resetlight = false
	self.instrument = "piano"
	self.buffer = 0
	self.soundtoplay = -1
	self.difficulty = 0
	self.canceltimer = 0
	self.canceltime = 15
	self.drawspace = 30
	self.engaged = false
	self.siner = 0
	self.dontdrawmenu = false
	self.drawalpha = 0
	self.memvolume = -1
	self.progress = {}
	self.solution = properties["solution"] or "777335"
	self.solution_nums = {}
	self.arrowspr = "ui/arrow_10x10"
	self.circlespr = "ui/circle_7x7"
	self.drawunits = {}
	self.cutscene = properties["cutscene"] or nil
	self.clear_darkness = properties["cleardark"] ~= false
	self.destroy_hints = properties["destroyhints"] ~= false
	self.destroy_switches = properties["destroyswitches"] ~= false
	self.destroy_cages = properties["destroycages"] ~= false
	self.doomtime = properties["doomtime"] or 30
	self.doomstyle = properties["doomstyle"] or 2
	self.doomkind = properties["doomkind"] or "out"
	self.flag = properties["flag"]
	local space = 28
	table.insert(self.drawunits, {sound = 3, x = 0, y = space, offx = 5, offy = 5, rot = math.rad(0), tex = self.arrowspr})
	table.insert(self.drawunits, {sound = 5, x = space, y = 0, offx = 5, offy = 5, rot = math.rad(-90), tex = self.arrowspr})
	table.insert(self.drawunits, {sound = 7, x = 0, y = -space, offx = 5, offy = 5, rot = math.rad(180), tex = self.arrowspr})
	table.insert(self.drawunits, {sound = 1, x = -space, y = 0, offx = 5, offy = 5, rot = math.rad(-270), tex = self.arrowspr})
	table.insert(self.drawunits, {sound = 0, x = 0, y = 0, offx = 3, offy = 3, rot = math.rad(0), tex = self.circlespr})
	self.show_instructions = false
end

function ChurchPiano:onAdd(parent)
    super.onAdd(self,parent)
    if not Game.stage:getObjects(TutorialText)[1] then
		local tuttext = TutorialText(1, self)
		Game.world:addChild(tuttext)
	end
    local i = 1
    while i <= StringUtils.len(self.solution) do
        local solution_num = tonumber(StringUtils.sub(self.solution, i, i))
		table.insert(self.solution_nums, solution_num)
        i = i + 1
    end
	if self.flag and Game:getFlag(self.flag, false) then
		self.solved = true
	end
end

local function scr_returnwait(x1, y1, x2, y2, spd)
	return math.max(1, MathUtils.round(MathUtils.dist(x1, y1, x2, y2) / spd))
end

local function scr_piano_determinepitch(sound)
	if sound == 0 then
		return 1
	elseif sound == 1 then
		return 1.12
	elseif sound == 2 then
		return 1.155
	elseif sound == 3 then
		return 1.19
	elseif sound == 4 then
		return 1.0414285714285714
	elseif sound == 5 then
		return 0.8928571428571428
	elseif sound == 6 then
		return 0.6964285714285714
	elseif sound == 7 then
		return 0.5
	elseif sound == 8 then
		return 0.3035714286
	end
end

function ChurchPiano:onInteract(player, dir)
	if self.con == 0 and self.buffer <= 0 then
		if not self.solved then
			self.progress = {}
		end
		if Game.stage:getObjects(TutorialText)[1] then
			Game.stage:getObjects(TutorialText)[1].target = self
		end
		if Game.world.music then
			self.memvolume = Game.world.music.volume
			Game.world.music:fade(self.memvolume * 0.125, 15/30)
		end
		local cutscene = self.world:startCutscene(function(cutscene)
			cutscene:detachCamera()
			cutscene:detachFollowers()
			local leader = cutscene:getCharacter(Game.party[1]:getActor().id)
			local party2, party3, party4 = nil, nil, nil
			if #Game.party >= 2 then
				party2 = cutscene:getCharacter(Game.party[2]:getActor().id)
			end
			if #Game.party >= 3 then
				party3 = cutscene:getCharacter(Game.party[3]:getActor().id)
			end
			if #Game.party >= 4 then
				party4 = cutscene:getCharacter(Game.party[4]:getActor().id)
			end
			local pointdist = MathUtils.dist(self.leader_x, self.leader_y, leader.x, leader.y)
			if pointdist > 4 then
				local walkwait = math.min(scr_returnwait(leader.x, leader.y, self.leader_x, self.leader_y, 4), 15)
				cutscene:wait(cutscene:walkToSpeed(leader, self.leader_x, self.leader_y, walkwait, "up"))
			else
				leader.x = self.leader_x
				leader.y = self.leader_y
				cutscene:look(leader, "up")
				print("no need to move")
			end
			if self.catafollow then
				if party2 then
					local p2x, p2y = self.leader_x + 30, self.leader_y + 30
					pointdist = MathUtils.dist(p2x, p2y, party2.x, party2.y)
					if pointdist > 4 then
						local walkwait = math.min(scr_returnwait(party2.x, party2.y, p2x, p2y, 4), 15)
						cutscene:wait(cutscene:walkToSpeed(party2, p2x, p2y, walkwait, "up"))
					else
						party2.x = p2x
						party2.y = p2y
						cutscene:look(party2, "up")
					end
				end
				if party3 then
					local p3x, p3y = self.leader_x - 30, self.leader_y + 30
					pointdist = MathUtils.dist(p3x, p3y, party3.x, party3.y)
					if pointdist > 4 then
						local walkwait = math.min(scr_returnwait(party3.x, party3.y, p3x, p3y, 4), 15)
						cutscene:wait(cutscene:walkToSpeed(party3, p3x, p3y, walkwait, "up"))
					else
						party3.x = p3x
						party3.y = p3y
						cutscene:look(party3, "up")
					end
				end
				if party4 then
					local p4x, p4y = self.leader_x, self.leader_y + 30
					pointdist = MathUtils.dist(p4x, p4y, party4.x, party4.y)
					if pointdist > 4 then
						local walkwait = math.min(scr_returnwait(party4.x, party4.y, p4x, p4y, 4), 15)
						cutscene:wait(cutscene:walkToSpeed(party4, p4x, p4y, walkwait, "up"))
					else
						party4.x = p4x
						party4.y = p4y
						cutscene:look(party4, "up")
					end
				end
			end
			self.resetlight = true
			cutscene:wait(1/30)
			cutscene:interpolateFollowers()
			cutscene:attachFollowers()
		end)
		cutscene:after(function()
			Game.lock_movement = true
			self.con = 0.2
		end)
		return true
	end
end

function ChurchPiano:update()
	super.update(self)
	if self.buffer > 0 then
		self.buffer = self.buffer - 1 * DTMULT
	end
	
	if self.resetlight then
		self.resetlight = false
	end
	
	if self.con == 0.2 then
		self.con = 1
		self.show_instructions = true
		self.engaged = true
	end
	
	if self.con == 1 then
		Game.lock_movement = true
		if Input.down("cancel") then
			self.canceltimer = self.canceltimer + 1 * DTMULT
		else
			self.canceltimer = 0
		end
		
		if self.canceltimer >= self.canceltime or self.forceend then
			local skipcamreset = 0
			
			--[[if Game.world.camera.x == 0 or Game.world.camera.x == (Game.world.map.width * Game.world.map.tile_width) - SCREEN_WIDTH then
				skipcamreset = 2
			end]]
			if skipcamreset == 0 then
				if Game.world.music and self.memvolume ~= -1 then
					Game.world.music:fade(self.memvolume, 15/30)
				end
				local tx, ty = Game.world.camera:getTargetPosition()
				Game.world.camera:panTo(tx, ty, 4/30, "linear", function() Game.world:setCameraAttached(true) end)
				Game.world.timer:after(8/30, function() self.con = 4 end)
			else
				if skipcamreset == 2 then
					if Game.world.music and self.memvolume ~= -1 then
						Game.world.music:fade(self.memvolume, 5/30)
					end
					local tx, ty = Game.world.camera:getTargetPosition()
					Game.world:setCameraAttached(true)
					Game.world.camera:setPosition(tx, ty)
				end
				self.show_instructions = false
				self.con = 4
			end
		end
		
		self.soundtoplay = -1
		if self.difficulty == 0 then
			if not Input.down("left") and not Input.down("down") and not Input.down("right") and not Input.down("up") then
				self.soundtoplay = 0
			end
			if Input.down("left") then
				self.soundtoplay = 1
			end
			if Input.down("down") then
				self.soundtoplay = 3
			end
			if Input.down("right") then
				self.soundtoplay = 5
			end
			if Input.down("up") then
				self.soundtoplay = 7
			end
		end
		if self.difficulty == 1 then
			if not Input.down("left") and not Input.down("down") and not Input.down("right") and not Input.down("up") then
				self.soundtoplay = 0
			end
			if Input.down("left") and not Input.down("down") and not Input.down("right") and not Input.down("up") then
				self.soundtoplay = 1
			end
			if Input.down("left") and Input.down("down") and not Input.down("right") and not Input.down("up") then
				self.soundtoplay = 2
			end
			if Input.down("down") and not Input.down("left") and not Input.down("right") and not Input.down("up") then
				self.soundtoplay = 3
			end
			if Input.down("down") and Input.down("right") and not Input.down("left") and not Input.down("up") then
				self.soundtoplay = 4
			end
			if Input.down("right") and not Input.down("left") and not Input.down("down") and not Input.down("up")  then
				self.soundtoplay = 5
			end
			if Input.down("up") and Input.down("right") and not Input.down("down") and not Input.down("left") then
				self.soundtoplay = 6
			end
			if Input.down("up") and not Input.down("down") and not Input.down("right") and not Input.down("left") then
				self.soundtoplay = 7
			end
			if Input.down("up") and Input.down("left") and not Input.down("down") and not Input.down("right") then
				self.soundtoplay = 8
			end
		end
		local soundplayed = false
		if Input.pressed("confirm") and self.soundtoplay ~= -1 and not Input.down("cancel") then
			local mypitch = scr_piano_determinepitch(self.soundtoplay)
			Assets.playSound(self.instrument, 0.7, mypitch)
			soundplayed = true
			self.notesplayed = true
			self.buffer = 0
		end
		
		if soundplayed and not self.solved then
			table.insert(self.progress, self.soundtoplay)
			if #self.progress > #self.solution_nums then
				table.remove(self.progress, 1)
			end
			
			if Utils.equal(self.progress, self.solution_nums) then
				self.con = 30
				self.timer = 0
				self.solplayed = 1
				Game.world.timer:after(1/30, function()
					Assets.playSound("noise")
				end)
				Game.world.timer:after(30/30, function()
					Game.world.timer:script(function(wait)
						while self.solplayed < #self.solution_nums+1 do
							local mypitch = scr_piano_determinepitch(self.solution_nums[self.solplayed])
							Assets.playSound(self.instrument, 1, mypitch)
							self.solplayed = self.solplayed + 1
							wait(11/60)
						end
						wait(10/30)
						self.solved = true
						self.con = 1
						Game.world:startCutscene(function(cutscene, event)
							if self.prop then
								cutscene:gotoCutscene(self.prop, self)
							else
								Assets.playSound("sparkle_gem")
								self.forceend = true
								self.timer = 0
								if self.flag then
									Game:setFlag(self.flag, true)
								end
								if self.clear_darkness then
									for _, dark in ipairs(Game.world.map:getEvents("darkness")) do
										Game.world.timer:lerpVar(dark, "alpha", 1, 0, MathUtils.round(self.doomtime * 1.5), self.doomstyle, self.doomkind)
									end
								end
								if self.destroy_switches then
									for _, button in ipairs(Game.world.map:getEvents("tilebutton")) do
										Game.world.timer:lerpVar(button, "alpha", 1, 0, self.doomtime, self.doomstyle, self.doomkind)
										Game.world.timer:after(self.doomtime/30, function() button:remove() end)
									end
									for _, button in ipairs(Game.world.map:getEvents("churchtilebutton")) do
										Game.world.timer:lerpVar(button, "alpha", 1, 0, self.doomtime, self.doomstyle, self.doomkind)
										Game.world.timer:after(self.doomtime/30, function() button:remove() end)
									end
								end
								if self.destroy_hints then
									for _, hint in ipairs(Game.world.map:getEvents("pianohint")) do
										Game.world.timer:lerpVar(hint, "hintalpha", 1, 0, self.doomtime, self.doomstyle, self.doomkind)
										Game.world.timer:after(self.doomtime/30, function() hint:remove() end)
									end
								end
								if self.destroy_cages then
									for _, cage in ipairs(Game.world.map:getEvents("steelcage")) do
										if not cage.flag or cage.flag == self.flag then
											cage:remove()
										end
									end
								end
							end
						end)
					end)
				end)
			end
		end
	end
	
	if self.con == 30 then
	end
	
	if self.con == 4 then
		self.forceend = false
		self.show_instructions = false
		self.con = 0
		self.timer = 0
		self.buffer = 6
		self.canceltimer = 0
		self.dontdrawmenu = false
		Game.lock_movement = false
	end
end

function ChurchPiano:draw()
	super.draw(self)
	
	self.siner = self.siner + 1 * DTMULT
	if self.con == 1 then
		self.engaged = true
	else
		self.engaged = false
	end
	
	local alphtarg = 0
	if self.con == 1 and not self.dontdrawmenu then
		alphtarg = 1
	end
	self.drawalpha = MathUtils.lerp(self.drawalpha, alphtarg, 0.1*DTMULT)
	self.drawspace = 18
	local drawx = 0 + self.width/2
	local drawy = 0 - 80
	love.graphics.setColor(0,0,0,self.drawalpha*0.5)
	love.graphics.circle("fill", drawx, drawy, 44 + math.sin(self.siner / 64) * 2)
	local litblue = ColorUtils.hexToRGB("#698DE6FF")
	local sinstrength = 2
	local basealpha = 0.35
	for i, unit in ipairs(self.drawunits) do
		local bonusalpha = 0
		local xloc = drawx + unit.x
		local yloc = drawy + unit.y + (math.sin((self.siner + (i * 42)) / 9) * sinstrength)
		
		if self.soundtoplay == unit.sound then
			bonusalpha = 0.6
			if Input.pressed("confirm") and self.con == 1 and not Input.down("cancel") then
                local note = Sprite(unit.tex, xloc, yloc)
				note.layer = self.layer + 1
                note:setColor(litblue)
				note:setScale(2,2)
				note:setOriginExact(unit.offx, unit.offy)
				note.rotation = unit.rot
                note.physics.direction = math.rad(MathUtils.random(360))
                note.physics.speed = 5
                note.physics.friction = 0.35
				note.physics.direction = unit.rot + math.rad(90)
				if self.soundtoplay == 0 then
					note.physics.speed = 0
				end
				Game.world.timer:lerpVar(note, "alpha", 1, 0, 20, 2, "out")
				Game.world.timer:after(20/30, function()
					note:remove()
				end)
				self:addChild(note)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * self.drawalpha)
		Draw.draw(Assets.getTexture(unit.tex), xloc, yloc, unit.rot, 2, 2, unit.offx, unit.offy)
	end
	love.graphics.setColor(1,1,1,1)
end

return ChurchPiano