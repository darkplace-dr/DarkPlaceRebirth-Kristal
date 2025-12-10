local TeevieQuiz, super = Class(Event)

function TeevieQuiz:init(data)
    super.init(self, data)
	
	self.base_texture = Assets.getFrames("world/events/teevie_tvs/base")
	self.base_texture_thin = Assets.getFrames("world/events/teevie_tvs/base_thin")
	self.quiz_timer_sprite = Assets.getFrames("world/events/teevie_quiz/timer")
	self.green_circle = Assets.getFrames("world/events/teevie_quiz/green_circle")
	self.red_x = Assets.getFrames("world/events/teevie_quiz/red_x")
	self.quiz_static = Assets.getFrames("world/events/teevie_tvs/static")
	self.base_color = {91/255, 39/255, 69/255}
	local properties = data.properties or {}
	
	self.drawborders = properties["borders"] ~= false
	self.quiz_max = properties["quiz_max"] or 2
	self.flag = properties["flag"]
    self.once = properties["once"] or true
	
	self.quiz_question = 1
	
	self.quiz_question_text = Utils.parsePropertyMultiList("quiz_text_", properties)
	self.quiz_answer_a_text = Utils.parsePropertyMultiList("quiz_answer_a_", properties)
	self.quiz_answer_b_text = Utils.parsePropertyMultiList("quiz_answer_b_", properties)
	self.quiz_correct = Utils.parsePropertyMultiList("quiz_correct_", properties)
	self.quiz_time = Utils.parsePropertyMultiList("quiz_time_", properties)
	
	self.tv_columns = math.ceil(self.width / 80)
	self.tv_rows = math.ceil(self.height / 80)
	self.tv_screens = {}
	local can_kill = Game:getFlag("can_kill", false)
	for i = 1, self.tv_columns do
		self.tv_screens[i] = {}
		for j = 1, self.tv_rows do
			local ii = i - 1
			local jj = j - 1
			table.insert(self.tv_screens[i], {x = ii*80, y = jj*80, sprite = nil, timer = 0, frame = 1, con = 0, color = COLORS["white"], index = i})
			self:setScreen(self.tv_screens[i][j])
			if can_kill then
				self:setOff(self.tv_screens[i][j])
			end
		end
	end
	
	self.timer = 0
	self.font = Assets.getFont("8bit")
	self.bigfont = Assets.getFont("main")
	self.gameshowblue = {0, 162/255, 232/255}
	self.gameshowdblue = {0, 104/255, 149/255}
	
	self.screen_anim = 0
	self.quiz_timer = 0
	self.word_scale_timer = 0
	self.word_max_scale = 9
	
	self.quiz_state = "intro"
	self.mode = 0
	self.countdown_timer = 10
	self.max_time = 10
	self.answer = nil
	self.party2_select = false
	self.party3_select = false
	self.dess_wrong_answer = nil
	self.dess_answer_wrong = Game:hasPartyMember("dess") ~= false
	self.dess_position = 0
	
	self.is_paused = false
	self.quiz_bullets = false
	self.started_bullets = false
	self.bullet_pos_list = {}
	self.bullet_pos_index = 1
	self.shooter_list = {}
	self.bullet_screen_sprite = self.red_x
	self.shoot_sequence = false
	self.shoot_sequence_con = 0
	self.shoot_sequence_timer = 0
	self.button = {}
	self.spikes = {}
	self.spikessolid = {}
	self.spike_height = 3
	self.show_static_display = false
	self.answered = false
	self.can_continue_quiz = false
	self.cur_question_text = "???"
	self.cur_answer_a = "???"
	self.cur_answer_b = "???"
	self.cur_correct_answer = nil
	self.quizzed = false
	if can_kill then
		self:setFlag("solved", true)
		if self.flag then
			Game:setFlag(self.flag, true)
		end
		self.quizzed = true
	end

	-- Table to store spisific party member answers
	self.party_answers = {}
	self.all_party_answers = {}
	for i = 1, self.quiz_max do
		self.all_party_answers[i] = {}
		for j = 1, #Game.party do
			self.all_party_answers[i][Game.party[j].id] = false
		end
	end
end

function TeevieQuiz:onLoad()
    super.onLoad(self)
	if self.once and self:getFlag("solved") then
		self.quizzed = true
	end
	for i = 1, 2 do	
		self.spikes[i] = {}
		for j = 1, self.spike_height do
			self.spikes[i][j] = Sprite("world/events/teevie_quiz/spikes_down", -80 + i*200, self.height + (j-1)*40)
			self.spikes[i][j].visible = self.quizzed
			self.spikes[i][j]:setScale(2, 2)
			self:addChild(self.spikes[i][j])
		end
		self.spikessolid[i] = Registry.createEvent("teevie_quizsolid", {x = self.x - 80 + i*200, y = self.y + self.height})
		self.spikessolid[i]:setScale(1, self.spike_height)
		self.spikessolid[i].solid = false
		self.spikessolid[i].visible = false
		Game.world:spawnObject(self.spikessolid[i])
	end
	if self.dess_answer_wrong then
		for i,party in ipairs(Game.party) do
			if party.id == "dess" then
				self.dess_position = i
			end
		end
	end
end

function TeevieQuiz:setScreen(screen)
	screen.timer = -100 + math.floor(Utils.random(100))
	screen.frame = 1
	screen.sprite = Utils.pick({"lanino", "smooch", "tvloop", "elnina", "shadowguy", "asgore", "toriel", "pippins", "tvtime", "pattern", "retro", "arlee", "rickroll"})
	screen.con = 0
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

function TeevieQuiz:setOff(screen)
	screen.timer = 0
	screen.frame = 1
	screen.sprite = "off"
	screen.con = 6
	screen.broken = true
	screen.color = COLORS["black"]
    super.update(self)
end

function TeevieQuiz:setStatic(screen)
	screen.timer = 0
	screen.frame = 1
	screen.sprite = "static"
	screen.con = 1
	screen.color = COLORS["white"]
end

function TeevieQuiz:showStatic()
	Assets.stopSound("tv_static")
	Assets.playSound("tv_static")
	self.show_static_display = true
end

function TeevieQuiz:hideStatic()
	Assets.stopSound("tv_static")
	self.show_static_display = false
end

function TeevieQuiz:showResults()
	self.quiz_state = "result"
	self.quiz_timer = 0
	self.answer = nil
	self.answered = false
	Game.world:startCutscene(function(cutscene)
		local player = Game.world.player
		local party2 = nil
		local party3 = nil
		if Game.party[2] then
			party2 = cutscene:getCharacter(Game.party[2].id)
		end
		if Game.party[3] then
			party3 = cutscene:getCharacter(Game.party[3].id)
		end
		-- Defines win and loss poses for each party member
		-- Defaults to the "default" id if the party member isn't specified
		-- A value of -1 means the sprite doesn't change (like Kris)
		local winpose = {
			default = "pose",
			dess = "sonic_adventure"
		}
		local losepose = {
			default = "battle/hurt",
			kris = -1,
			susie = "shock_right",
			ralsei = "shocked_left",
			dess = "angreh"
		}
		if self.dess_wrong_answer ~= nil and (self.cur_correct_answer == "A" or self.cur_correct_answer == "B") then
			winpose["dess"] = "teehee"
			losepose["dess"] = "teehee"
			if self.result == true then
				if winpose[Game.party[1].id] ~= -1 then
					player:setSprite(winpose[Game.party[1].id] or winpose["default"])
				end
				if Game.party[2] and winpose[Game.party[2].id] ~= -1 then
					party2:setSprite(winpose[Game.party[2].id] or winpose["default"])
				end
				if Game.party[3] and winpose[Game.party[3].id] ~= -1 then
					party3:setSprite(winpose[Game.party[3].id] or winpose["default"])
				end
			else
				if losepose[Game.party[1].id] ~= -1 then
					player:setSprite(losepose[Game.party[1].id] or losepose["default"])
				end
				if Game.party[2] and losepose[Game.party[2].id] ~= -1 then
					party2:setSprite(losepose[Game.party[2].id] or losepose["default"])
				end
				if Game.party[3] and losepose[Game.party[3].id] ~= -1 then
					party3:setSprite(losepose[Game.party[3].id] or losepose["default"])
				end
			end
			Assets.playSound("won")
			Assets.playSound("error")
			cutscene:wait(45/30)
			if math.abs(math.abs(Game.world.player.x - math.abs(self.x + 220+20))) > 10 then
				Assets.playSound("wing")
			end
			player:resetSprite()
			player:setFacing("up")
			if Game.party[2] then
				party2:resetSprite()
				party2:setFacing("up")
			end
			if Game.party[3] then
				party3:resetSprite()
				party3:setFacing("up")
			end
			Game.world.timer:tween(10/30, player, {x = self.x + 220+20}, "out-cubic")
			Game.world.timer:tween(10/30, player, {y = self.y + self.height + 70}, "out-cubic")
			if Game.party[2] then
				Game.world.timer:tween(10/30, party2, {x = self.x + 420+20}, "out-cubic")
				Game.world.timer:tween(10/30, party2, {y = self.y + self.height + 70}, "out-cubic")
			end
			if Game.party[3] then
				Game.world.timer:tween(10/30, party3, {x = self.x + 15+20}, "out-cubic")
				Game.world.timer:tween(10/30, party3, {y = self.y +  self.height + 70}, "out-cubic")
			end
			cutscene:wait(10/15)
			Game.lock_movement = false
			self.quiz_bullets = true
			cutscene:wait(function() return not self.quiz_bullets end)
			self:showStatic()
			Game.lock_movement = true
			Game.world.timer:tween(10/30, player, {x = self.x + 220+20}, "out-cubic")
			Game.world.timer:tween(10/30, player, {y = self.y + self.height + 70}, "out-cubic")
			cutscene:wait(15/30)
			if self.quiz_question >= self.quiz_max then
				self.quiz_state = "done"
				for i,button in ipairs(self.button) do
					if button then
						button:reset()
					end
				end
				self.party2_select = false
				self.party3_select = false
				Game.world.timer:tween(15/30, self.overlay, {alpha = 0}, "linear")
				Game.world.timer:after(15/30, function()
					self.overlay:remove()
				end)
				for _,v in ipairs(Game.world:getEvents("teevie_light")) do
					v:unpause()
				end
				Game.world:hideHealthBars()	
				for i,button in ipairs(self.button) do
					if button then
						button.layer = self.layer + 10
						Game.world.timer:tween(math.floor(button.spawn_order*5)/30, button, {y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60}, "out-quart")
						Game.world.timer:after(20/30, function()
							button:remove()
						end)
					end
				end
				for i = 1, 2 do
					for j = 1, self.spike_height do
						self.spikessolid[i].solid = false
						self.spikes[i][j]:setSprite("world/events/teevie_quiz/spikes_down")
					end
				end
				self:setFlag("solved", true)
				if self.flag then
					Game:setFlag(self.flag, true)
				end
				Game.world.can_open_menu = true
				local player = Game.world.player
				Assets.playSound("jump")
				player:setFacing("up")
				cutscene:jumpTo(player, self.x + 271+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
				local party2 = nil
				local party3 = nil
				if Game.party[2] then
					party2 = cutscene:getCharacter(Game.party[2].id)
					party2:setFacing("up")
					cutscene:jumpTo(party2, self.x + 219+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
				end
				if Game.party[3] then
					party3 = cutscene:getCharacter(Game.party[3].id)
					party3:setFacing("up")
					cutscene:jumpTo(party3, self.x + 167+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
				end
				cutscene:wait(20/30)
				Assets.stopSound("tv_static")
				self.mode = 0
				cutscene:attachCamera(15/30)
				cutscene:wait(15/30)
				cutscene:interpolateFollowers()
				cutscene:attachFollowers()
				player:setFacing("down")
				if party2 then
					party2:setFacing("right")
				end
				if party3 then
					party3:setFacing("right")
				end
				cutscene:endCutscene()
				Game.world.timer:after(1/30, function()
					Game.world:startCutscene("tvfloor.after_quiz", self.all_party_answers)
				end)
			else
				self:hideStatic()
				self.is_paused = false
				self.quiz_question = self.quiz_question + 1
				self.party2_select = false
				self.party3_select = false
				for i,button in ipairs(self.button) do
					if button then
						button:reset()
					end
				end
				self.started_bullets = false
				self.shoot_sequence = false
				self.shoot_sequence_con = 0
				self.shoot_sequence_timer = 0
				self.dess_wrong_answer = nil
				self.quiz_state = "ready"
				self.word_scale_timer = 0
				self.quiz_timer = 0
			end
		else
			self.dess_wrong_answer = nil
			if self.result == true then
				Assets.playSound("won")
				if winpose[Game.party[1].id] ~= -1 then
					player:setSprite(winpose[Game.party[1].id] or winpose["default"])
				end
				if Game.party[2] and winpose[Game.party[2].id] ~= -1 then
					party2:setSprite(winpose[Game.party[2].id] or winpose["default"])
				end
				if Game.party[3] and winpose[Game.party[3].id] ~= -1 then
					party3:setSprite(winpose[Game.party[3].id] or winpose["default"])
				end
				cutscene:wait(45/30)
				if math.abs(math.abs(Game.world.player.x - math.abs(self.x + 220+20))) > 10 then
					Assets.playSound("wing")
				end
				player:resetSprite()
				player:setFacing("up")
				if Game.party[2] then
					party2:resetSprite()
					party2:setFacing("up")
				end
				if Game.party[3] then
					party3:resetSprite()
					party3:setFacing("up")
				end
				Game.world.timer:tween(10/30, player, {x = self.x + 220+20}, "out-cubic")
				Game.world.timer:tween(10/30, player, {y = self.y + self.height + 70}, "out-cubic")
				if Game.party[2] then
					Game.world.timer:tween(10/30, party2, {x = self.x + 420+20}, "out-cubic")
					Game.world.timer:tween(10/30, party2, {y = self.y + self.height + 70}, "out-cubic")
				end
				if Game.party[3] then
					Game.world.timer:tween(10/30, party3, {x = self.x + 15+20}, "out-cubic")
					Game.world.timer:tween(10/30, party3, {y = self.y + self.height + 70}, "out-cubic")
				end
				cutscene:wait(1)
				if self.quiz_question >= self.quiz_max then
					self:showStatic()
					cutscene:wait(15/30)
					self.quiz_state = "done"
					for i,button in ipairs(self.button) do
						if button then
							button:reset()
						end
					end
					self.party2_select = false
					self.party3_select = false
					Game.world.timer:tween(15/30, self.overlay, {alpha = 0}, "linear")
					Game.world.timer:after(15/30, function()
						self.overlay:remove()
					end)
					for _,v in ipairs(Game.world:getEvents("teevie_light")) do
						v:unpause()
					end
					Game.world:hideHealthBars()	
					for i,button in ipairs(self.button) do
						if button then
							button.layer = self.layer + 10
							Game.world.timer:tween((math.floor(i/2)*5)/30, button, {y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60}, "out-quart")
							Game.world.timer:after(20/30, function()
								button:remove()
							end)
						end
					end
					for i = 1, 2 do
						for j = 1, self.spike_height do
							self.spikessolid[i].solid = false
							self.spikes[i][j]:setSprite("world/events/teevie_quiz/spikes_down")
						end
					end
					self:setFlag("solved", true)
					if self.flag then
						Game:setFlag(self.flag, true)
					end
					Game.world.can_open_menu = true
					local player = Game.world.player
					Assets.playSound("jump")
					player:setFacing("up")
					cutscene:jumpTo(player, self.x + 271+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					local party2 = nil
					local party3 = nil
					if Game.party[2] then
						party2 = cutscene:getCharacter(Game.party[2].id)
						party2:setFacing("up")
						cutscene:jumpTo(party2, self.x + 219+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					if Game.party[3] then
						party3 = cutscene:getCharacter(Game.party[3].id)
						party3:setFacing("up")
						cutscene:jumpTo(party3, self.x + 167+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					cutscene:wait(20/30)
					Assets.stopSound("tv_static")
					self.mode = 0
					cutscene:attachCamera(15/30)
					cutscene:wait(15/30)
					cutscene:interpolateFollowers()
					cutscene:attachFollowers()
					player:setFacing("down")
					if party2 then
						party2:setFacing("right")
					end
					if party3 then
						party3:setFacing("right")
					end
					cutscene:endCutscene()
					Game.world.timer:after(1/30, function()
						Game.world:startCutscene("tvfloor.after_quiz", self.all_party_answers)
					end)
				else
					self:showStatic()
					cutscene:wait(15/30)
					self:hideStatic()
					self.is_paused = false
					self.quiz_question = self.quiz_question + 1
					self.party2_select = false
					self.party3_select = false
					for i,button in ipairs(self.button) do
						if button then
							button:reset()
						end
					end
					self.started_bullets = false
					self.shoot_sequence = false
					self.shoot_sequence_con = 0
					self.shoot_sequence_timer = 0
					self.dess_wrong_answer = nil
					self.quiz_state = "ready"
					self.word_scale_timer = 0
					self.quiz_timer = 0
				end
			else
				Assets.playSound("error")
				if losepose[Game.party[1].id] ~= -1 then
					player:setSprite(losepose[Game.party[1].id] or losepose["default"])
				end
				if Game.party[2] and losepose[Game.party[2].id] ~= -1 then
					party2:setSprite(losepose[Game.party[2].id] or losepose["default"])
				end
				if Game.party[3] and losepose[Game.party[3].id] ~= -1 then
					party3:setSprite(losepose[Game.party[3].id] or losepose["default"])
				end
				cutscene:wait(45/30)
				if math.abs(math.abs(Game.world.player.x - math.abs(self.x + 220+20))) > 10 then
					Assets.playSound("wing")
				end
				player:resetSprite()
				player:setFacing("up")
				if Game.party[2] then
					party2:resetSprite()
					party2:setFacing("up")
				end
				if Game.party[3] then
					party3:resetSprite()
					party3:setFacing("up")
				end
				Game.world.timer:tween(10/30, player, {x = self.x + 220+20}, "out-cubic")
				Game.world.timer:tween(10/30, player, {y = self.y + self.height + 70}, "out-cubic")
				if Game.party[2] then
					Game.world.timer:tween(10/30, party2, {x = self.x + 420+20}, "out-cubic")
					Game.world.timer:tween(10/30, party2, {y = self.y +  self.height + 70}, "out-cubic")
				end
				if Game.party[3] then
					Game.world.timer:tween(10/30, party3, {x = self.x + 15+20}, "out-cubic")
					Game.world.timer:tween(10/30, party3, {y = self.y + self.height + 70}, "out-cubic")
				end
				cutscene:wait(10/15)
				Game.lock_movement = false
				self.quiz_bullets = true
				cutscene:wait(function() return not self.quiz_bullets end)
				self:showStatic()
				Game.lock_movement = true
				Game.world.timer:tween(10/30, player, {x = self.x + 220+20}, "out-cubic")
				Game.world.timer:tween(10/30, player, {y = self.y + self.height + 70}, "out-cubic")
				cutscene:wait(15/30)
				if self.quiz_question >= self.quiz_max then
					self.quiz_state = "done"
					for i,button in ipairs(self.button) do
						if button then
							button:reset()
						end
					end
					self.party2_select = false
					self.party3_select = false
					Game.world.timer:tween(15/30, self.overlay, {alpha = 0}, "linear")
					Game.world.timer:after(15/30, function()
						self.overlay:remove()
					end)
					for _,v in ipairs(Game.world:getEvents("teevie_light")) do
						v:unpause()
					end
					Game.world:hideHealthBars()	
					for i,button in ipairs(self.button) do
						if button then
							button.layer = self.layer + 10
							Game.world.timer:tween((math.floor(i/2)*5)/30, button, {y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60}, "out-quart")
							Game.world.timer:after(20/30, function()
								button:remove()
							end)
						end
					end
					for i = 1, 2 do
						for j = 1, self.spike_height do
							self.spikessolid[i].solid = false
							self.spikes[i][j]:setSprite("world/events/teevie_quiz/spikes_down")
						end
					end
					self:setFlag("solved", true)
					if self.flag then
						Game:setFlag(self.flag, true)
					end
					Game.world.can_open_menu = true
					local player = Game.world.player
					Assets.playSound("jump")
					player:setFacing("up")
					cutscene:jumpTo(player, self.x + 271+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					local party2 = nil
					local party3 = nil
					if Game.party[2] then
						party2 = cutscene:getCharacter(Game.party[2].id)
						party2:setFacing("up")
						cutscene:jumpTo(party2, self.x + 219+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					if Game.party[3] then
						party3 = cutscene:getCharacter(Game.party[3].id)
						party2:setFacing("up")
						cutscene:jumpTo(party3, self.x + 167+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					cutscene:wait(20/30)
					Assets.stopSound("tv_static")
					self.mode = 0
					cutscene:attachCamera(15/30)
					cutscene:wait(15/30)
					cutscene:interpolateFollowers()
					cutscene:attachFollowers()
					player:setFacing("down")
					if party2 then
						party2:setFacing("right")
					end
					if party3 then
						party3:setFacing("right")
					end
				else
					self:hideStatic()
					self.is_paused = false
					self.quiz_question = self.quiz_question + 1
					self.party2_select = false
					self.party3_select = false
					for i,button in ipairs(self.button) do
						if button then
							button:reset()
						end
					end
					self.started_bullets = false
					self.shoot_sequence = false
					self.shoot_sequence_con = 0
					self.shoot_sequence_timer = 0
					self.dess_wrong_answer = nil
					self.quiz_state = "ready"
					self.word_scale_timer = 0
					self.quiz_timer = 0
				end
			end
		end
	end)
end

function TeevieQuiz:update()
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
				if math.abs(screen.timer) >= 120 then
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
				if math.abs(screen.timer) >= 120 then
					self:setStatic(screen)
				end
			elseif screen.con == 3 then
				if math.abs(screen.timer) % 6 == 0 then
					screen.frame = screen.frame + 1
				end
				if screen.timer >= 120 then
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

	if self.mode == 1 then
		self.screen_anim = self.screen_anim + 0.2 * DTMULT
		self.quiz_timer = self.quiz_timer + DTMULT
		if self.quiz_state == "intro" then
			if self.quiz_timer >= 30 then
				self.quiz_state = "ready"
				self.word_scale_timer = 0
				self.quiz_timer = 0
				self.overlay = Rectangle(Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT)
				self.overlay.layer = self.layer - 0.01
				self.overlay:setColor(0,0,0)
				self.overlay.alpha = 0
				Game.world:addChild(self.overlay)
				Game.world.timer:tween(15/30, self.overlay, {alpha = 0.75}, "linear")
				for _,v in ipairs(Game.world:getEvents("teevie_light")) do
					v:pause()
				end
				Game.world:startCutscene(function(cutscene)
					local player = Game.world.player
					Assets.playSound("jump")
					cutscene:jumpTo(player, self.x + 220+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					local party2 = nil
					local party3 = nil
					if Game.party[2] then
						party2 = cutscene:getCharacter(Game.party[2].id)
						cutscene:jumpTo(party2, self.x + 420+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					if Game.party[3] then
						party3 = cutscene:getCharacter(Game.party[3].id)
						cutscene:jumpTo(party3, self.x + 15+20, self.y + self.height + 70, 20, 15/30, "jump_ball", "walk/up")
					end
					cutscene:wait(20/30)
					if Game.world.player then
						self.button[1] = Registry.createEvent("teevie_keyboardtile", {x = player.x - 80, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[1].letter = "A"
						self.button[1]:setLetter()
						self.button[1].layer = self.layer + 10
						self.button[1].spawn_order = 2
						Game.world.timer:tween((2*5)/30, self.button[1], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[1])
						self.button[2] = Registry.createEvent("teevie_keyboardtile", {x = player.x + 40, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[2].letter = "B"
						self.button[2]:setLetter()
						self.button[2].layer = self.layer + 10
						self.button[2].spawn_order = 2
						Game.world.timer:tween((2*5)/30, self.button[2], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[2])
					end
					if Game.party[2] then
						self.button[3] = Registry.createEvent("teevie_keyboardtile", {x = party2.x - 80, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[3].letter = "A"
						self.button[3]:setLetter()
						self.button[3].layer = self.layer + 10
						self.button[3].spawn_order = 3
						Game.world.timer:tween((3*5)/30, self.button[3], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[3])
						self.button[4] = Registry.createEvent("teevie_keyboardtile", {x = party2.x + 40, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[4].letter = "B"
						self.button[4]:setLetter()
						self.button[4].layer = self.layer + 10
						self.button[4].spawn_order = 3
						Game.world.timer:tween((3*5)/30, self.button[4], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[4])
					end
					if Game.party[3] then
						self.button[5] = Registry.createEvent("teevie_keyboardtile", {x = party3.x - 80, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[5].letter = "A"
						self.button[5]:setLetter()
						self.button[5].layer = self.layer + 1010
						self.button[5].spawn_order = 1
						Game.world.timer:tween((1*5)/30, self.button[5], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[5])
						self.button[6] = Registry.createEvent("teevie_keyboardtile", {x = party3.x + 40, y = Game.world.camera.y-SCREEN_HEIGHT/2 - 60})
						self.button[6].letter = "B"
						self.button[6]:setLetter()
						self.button[6].layer = self.layer + 1010
						self.button[6].spawn_order = 1
						Game.world.timer:tween((1*5)/30, self.button[6], {y = self.y + self.height + 40}, "out-quart")
						Game.world:spawnObject(self.button[6])
					end
					for i = 1, 2 do
						for j = 1, self.spike_height do
							self.spikes[i][j]:setSprite("world/events/teevie_quiz/spikes_up")
							self.spikes[i][j].visible = true
							self.spikessolid[i].solid = true
						end
					end
					cutscene:wait(20/30)
					for i,button in ipairs(self.button) do
						if button then
							button.layer = self.layer
						end
					end
				end)
			end
			Game.lock_movement = true
		elseif self.quiz_state == "ready" then
			Game.lock_movement = true
			if self.quiz_timer >= 45 then
				Game.lock_movement = false
				self.cur_correct_answer = nil
				for i,answer in ipairs(self.quiz_correct[1]) do
					if i == self.quiz_question then
						self.cur_correct_answer = answer
					end
				end
				self.cur_question_text = "???"
				for i,question in ipairs(self.quiz_question_text[1]) do
					if i == self.quiz_question then
						self.cur_question_text = question
					end
				end
				self.cur_answer_a = "???"
				for i,answer in ipairs(self.quiz_answer_a_text[1]) do
					if i == self.quiz_question then
						self.cur_answer_a = answer
					end
				end
				self.cur_answer_b = "???"
				for i,answer in ipairs(self.quiz_answer_b_text[1]) do
					if i == self.quiz_question then
						self.cur_answer_b = answer
					end
				end
				self.max_time = 10
				for i,time in ipairs(self.quiz_time[1]) do
					if i == self.quiz_question then
						self.max_time = time
					end
				end
				self.countdown_timer = self.max_time
				self.quiz_state = "display"
				self.quiz_timer = 0
			end
		elseif self.quiz_state == "display" then
			if not self.is_paused then
				self.countdown_timer = self.countdown_timer - DT
			end
			if self.answered then
				Game.lock_movement = true
			end
			if self.countdown_timer <= 0 and not self.answered then
				self.countdown_timer = 0
				self.is_paused = true
				self.result = false
				Game.world.timer:after(1, function()
					self:showResults()
				end)
				self.answered = true
			else
				local button_press = nil
				if self.button[1].pressed then
					self.answer = "A"
				elseif self.button[2].pressed then
					self.answer = "B"
				end
				if self.answer ~= nil and not self.answered then
					self.is_paused = true
					
					--Part that handles party member answers
					Game.world:startCutscene(function(cutscene)

						local function handlePartyAnswer(party, indexA, indexB, chara)

							local quiz_ans
							local quiz_ans_bad

							if self.answer == "A" then
								quiz_ans = indexB
								quiz_ans_bad = indexA
							else
								quiz_ans = indexA
								quiz_ans_bad = indexB
							end

							if chara == "dess" and self.dess_answer_wrong then
								cutscene:wait(cutscene:walkTo(party, self.button[quiz_ans_bad].x+20, party.y, 6/30))
								self.button[quiz_ans_bad]:press()
								if self.answer == "A" then
									self.dess_wrong_answer = "B"
									self.party_answers[chara] = "B"
								else
									self.dess_wrong_answer = "A"
									self.party_answers[chara] = "A"
								end
							elseif chara == "noel" then

								local a, b = 5, 6
								if Game.party[2].id == "noel" then
									a, b = 3, 4
								end

								local noel_save = Noel:getFlag("teevie_quiz" ..self.cur_question_text)
								local noel_table = {a, b}
								local pick = b
								self.party_answers[chara] = "B"
								if Noel:getFlag("teevie_quiz" ..self.cur_question_text) then
									if noel_save == "A" then
                                        pick = a
										self.party_answers[chara] = "A"
									end
								else
									local meth = math.random(1, 2)
									local pick = noel_table[meth]
									self.party_answers[chara] = "A"
									if meth == 2 then self.party_answers[chara] = "B" end
									Noel:setFlag("teevie_quiz" ..self.cur_question_text, self.cur_correct_answer)
								end
								cutscene:wait(cutscene:walkTo(party, self.button[pick].x+20, party.y, 6/30))
								self.button[pick]:press()
							else
								cutscene:wait(cutscene:walkTo(party, self.button[quiz_ans].x+20, party.y, 6/30))
								self.button[quiz_ans]:press()
								self.party_answers[chara] = self.answer
							end
							if chara then
								if self.party_answers[chara] == self.cur_correct_answer then
									self.all_party_answers[self.quiz_question][chara] = true
								else
									self.all_party_answers[self.quiz_question][chara] = false
								end
							end
							party:setFacing("up")
						end
						
						cutscene:wait(2/30)

						if Game.party[3] then
							local party3 = cutscene:getCharacter(Game.party[3].id)
							handlePartyAnswer(party3, 6, 5, Game.party[3].id)
							self.party3_select = true
						end

						cutscene:wait(2/30)

						if Game.party[2] then
							local party2 = cutscene:getCharacter(Game.party[2].id)
							handlePartyAnswer(party2, 4, 3, Game.party[2].id)
							self.party2_select = true
						end
					end)




					if self.answer == self.cur_correct_answer then
						self.result = true
					else
						self.result = false
					end
					Game.world.timer:after(2, function()
						self:showResults()
					end)
					self.answered = true
				end
			end
		end
		if self.quiz_bullets then
			if not self.started_bullets then
				Game.world.timer:script(function(wait)
					wait(1/30)
					Game.world:setBattle(true)
					self.bullet_pos_list = {}
					self.bullet_pos_index = 1
					local face_count = 0
					local max_face_count = 12
					if self.dess_wrong_answer ~= nil then
						if #Game.party == 2 then
							max_face_count = 6
						else
							if self.result == true then
								max_face_count = 4
							else
								max_face_count = 8
							end
						end
					end
					while (face_count < max_face_count) do
						local random_i = math.floor(Utils.random(self.width/80))
						local random_j = math.floor(Utils.random(self.height/80))
						local tile_x = random_i
						local tile_y = random_j
						local exists = false
						for _,list in ipairs(self.bullet_pos_list) do
							if list.x == tile_x and list.y == tile_y then
								exists = true
								break
							end
						end
						
						if not exists then
							table.insert(self.bullet_pos_list, {x = tile_x, y = tile_y})
							face_count = face_count + 1
							if face_count >= max_face_count then break end
						end
					end
					wait(1/30)
					self.shoot_sequence = true
					while self.shoot_sequence == true do
						wait(1/30)
					end
					wait(45/30)
					for i,shooter in ipairs(self.shooter_list) do
						table.remove(self.shooter_list,i)
						shooter:remove()
					end
					Game.world:setBattle(false)
					wait(15/30)
					self.quiz_bullets = false
				end)
				self.started_bullets = true
			end
			if self.shoot_sequence == true then
				self.shoot_sequence_timer = self.shoot_sequence_timer + DTMULT
				if self.shoot_sequence_timer >= 1 and self.shoot_sequence_con == 0 then
					local current_screen_tile = self.bullet_pos_list[self.bullet_pos_index]
					local xpos = (self.x + current_screen_tile.x * 80)
					local ypos = (self.y + current_screen_tile.y * 80)
					local shooter = TeevieShooter(xpos, ypos)
					shooter.screen_x = current_screen_tile.x+1
					shooter.screen_y = current_screen_tile.y+1
					shooter.layer = self.layer + 1
					table.insert(self.shooter_list, shooter)
					Game.world:addChild(shooter)
					self.shoot_sequence_con = 1
				end
				if self.shoot_sequence_timer >= 6 then
					self.bullet_pos_index = self.bullet_pos_index + 1
					if self.bullet_pos_index < #self.bullet_pos_list then
						self.shoot_sequence_timer = 0
						self.shoot_sequence_con = 0
					else
						self.shoot_sequence = false
						self.shoot_sequence_timer = 0
						self.shoot_sequence_con = 0
						self.bullet_pos_index = 1
					end
				end
			end
		end
	else
		if Game.world and Game.world.player and not self.quizzed then
			if math.abs((self.x + self.width/2) - (Game.world.player.x - Game.world.player.width/2)) < 20 and Game.world.player.y >= self.y + self.height and Game.world.player.y < self.y + self.height + 320 then 
				self:initQuiz()
				self.quizzed = true
				Game.world:startCutscene(function(cutscene)
					for k,v in ipairs(Game.party) do
						party = Game.world:getPartyCharacter(v)
						cutscene:detachCamera()
						cutscene:detachFollowers()
						party:setFacing("up")
					end
				end)
				Game.world.camera:panToSpeed(self.x + self.width/2, self.y + self.height - 40, 8)
			end
		end
	end

    super.update(self)
end

function TeevieQuiz:initQuiz()
	Assets.playSound("quiztime")
	self.quiz_state = "intro"
	self.quiz_timer = 0
	Game.world.can_open_menu = false
	self.mode = 1
end

function TeevieQuiz:draw()
    super.draw(self)
	
	if self.mode == 0 then
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
				Draw.setColor(1,1,1,1)
				Draw.draw(frames[6], screen.x, screen.y, 0, 2, 2)
			end
		end
	elseif self.mode == 1 then
		Draw.setColor(self.gameshowblue)
		Draw.rectangle("fill", 0, 0, self.width, self.height)
		Draw.setColor(1,1,1,1)
		love.graphics.setFont(self.font)
		if self.quiz_state == "intro" then
			local word_alpha = 1
			Draw.setColor(self.gameshowdblue[1],self.gameshowdblue[2],self.gameshowdblue[3],word_alpha)
			local quiztext = "QUIZ!"
			self.word_scale_timer = self.word_scale_timer + 0.1 * DTMULT
			local scale = Utils.clampMap(self.word_scale_timer, 0, 1, 1, 0, "out-back") + 1
			local sscale = 3*scale
			love.graphics.print(quiztext, 260-((self.font:getWidth(quiztext)*sscale)/2), 130+2-((self.font:getHeight(quiztext)*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext, 260+2-((self.font:getWidth(quiztext)*sscale)/2), 130+2-((self.font:getHeight(quiztext)*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext, 260+2-((self.font:getWidth(quiztext)*sscale)/2), 130-((self.font:getHeight(quiztext)*sscale)/2)-6, 0, sscale, sscale)
			Draw.setColor(1,1,1,1)
			love.graphics.print(quiztext, 260-((self.font:getWidth(quiztext)*sscale)/2), 130-((self.font:getHeight(quiztext)*sscale)/2)-6, 0, sscale, sscale)
		elseif self.quiz_state == "ready" then
			local word_alpha = 1
			Draw.setColor(self.gameshowdblue[1],self.gameshowdblue[2],self.gameshowdblue[3],word_alpha)
			local quiztext = {}
			quiztext[1] = "GET\n"
			quiztext[2] = "\nREADY!"
			quiztext[3] = "GET\nREADY!"
			self.word_scale_timer = self.word_scale_timer + 0.1 * DTMULT
			local scale = Utils.clampMap(self.word_scale_timer, 0, 1, 1, 0, "out-back") + 1
			local sscale = 3*scale
			love.graphics.print(quiztext[1], 260-((self.font:getWidth(quiztext[1])*sscale)/2), 130+2-((self.font:getHeight(quiztext[1])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[1], 260+2-((self.font:getWidth(quiztext[1])*sscale)/2), 130+2-((self.font:getHeight(quiztext[1])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[1], 260+2-((self.font:getWidth(quiztext[1])*sscale)/2), 130-((self.font:getHeight(quiztext[1])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[2], 2600-((self.font:getWidth(quiztext[2])*sscale)/2), 130+2-((self.font:getHeight(quiztext[2])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[2], 260+2-((self.font:getWidth(quiztext[2])*sscale)/2), 130+2-((self.font:getHeight(quiztext[2])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[2], 260+2-((self.font:getWidth(quiztext[2])*sscale)/2), 130-((self.font:getHeight(quiztext[2])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			Draw.setColor(1,1,1,1)
			love.graphics.print(quiztext[1], 260-((self.font:getWidth(quiztext[1])*sscale)/2), 130-((self.font:getHeight(quiztext[1])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
			love.graphics.print(quiztext[2], 260-((self.font:getWidth(quiztext[2])*sscale)/2), 130-((self.font:getHeight(quiztext[2])*sscale)/2)-((self.font:getHeight(quiztext[3])*sscale)/2)-6, 0, sscale, sscale)
		elseif self.quiz_state == "display" then
			local border_margin = 10
			local border_offset = 4
			local border_radius = 6
			Draw.setColor(1,1,1,1)
			Draw.rectangle("fill", border_margin, border_margin, 470 - border_margin, 70 - border_margin)
			Draw.setColor(self.gameshowblue)
			Draw.rectangle("fill", border_margin + border_offset, border_margin + border_offset, 470 - border_margin - border_offset*2, 70 - border_margin - border_offset*2)
			local gauge_margin = 4
			local gauge_x = border_margin
			local gauge_y = border_margin
			local gauge_offset = 4
			local gauge_width = 460 - border_offset - gauge_margin
			local gauge_height = 60 - gauge_margin
			Draw.setColor(self.gameshowblue)
			Draw.rectangle("fill", gauge_x + gauge_margin, gauge_y + gauge_margin, gauge_width - gauge_margin, gauge_height - gauge_margin)
			local _min = gauge_margin
			local _max = gauge_width
			local progress = self.countdown_timer / self.max_time
			local gauge_progress = Utils.clamp(gauge_width * progress, gauge_margin, gauge_width)
			if progress > 0 then
				Draw.setColor(self.gameshowdblue)
				Draw.rectangle("fill", gauge_x + gauge_margin, gauge_y + gauge_margin, Utils.round(gauge_progress * 2) / 2, gauge_height - gauge_margin)
			end
			local text_left_margin = 0
			local text_margin = 22
			Draw.setColor(self.gameshowdblue)
			love.graphics.print(self.cur_question_text, text_margin + text_left_margin, text_margin + 2-3, 0, 1, 1)
			love.graphics.print(self.cur_question_text, text_margin + text_left_margin + 2, text_margin + 2-3, 0, 1, 1)
			love.graphics.print(self.cur_question_text, text_margin + text_left_margin + 2, text_margin-3, 0, 1, 1)
			Draw.setColor(1,1,1,1)
			love.graphics.print(self.cur_question_text, text_margin + text_left_margin, text_margin-3, 0, 1, 1)
			Draw.setColor(self.gameshowdblue)
			Draw.draw(self.quiz_timer_sprite[1 + math.floor(28 - ((self.countdown_timer / self.max_time) * 28))], 210, 90 + 2, 0, 4, 4)
			Draw.draw(self.quiz_timer_sprite[1 + math.floor(28 - ((self.countdown_timer / self.max_time) * 28))], 210 + 2, 90 + 2, 0, 4, 4)
			Draw.draw(self.quiz_timer_sprite[1 + math.floor(28 - ((self.countdown_timer / self.max_time) * 28))], 210 + 2, 90, 0, 4, 4)
			Draw.setColor(1,1,1,1)
			Draw.draw(self.quiz_timer_sprite[1 + math.floor(28 - ((self.countdown_timer / self.max_time) * 28))], 210, 90, 0, 4, 4)
			local answer_color = {1,1,1,1}
			love.graphics.setFont(self.bigfont)
			if self.answer == "A" then
				answer_color = {1,1,0,1}
			end
			if self.answer then
				if self.party2_select and self.party_answers then

					Draw.setColor(self.gameshowdblue)
					
					if self.party_answers[Game.party[2].id] == "A" then
						love.graphics.print("A", 150-6-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("A", 150-6 + 2-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("A", 150-6 + 2-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
						Draw.setColor({1,1,0,1})
						love.graphics.print("A", 150-6-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
					else
						love.graphics.print("B", 390-6-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("B", 390-6 + 2-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("B", 390-6 + 2-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
						Draw.setColor({1,1,0,1})
						love.graphics.print("B", 390-6-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
					end
				end
				if self.party3_select and self.party_answers then

					Draw.setColor(self.gameshowdblue)

					if self.party_answers[Game.party[3].id] == "A" then
						love.graphics.print("A", 90-6-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("A", 90-6 + 2-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("A", 90-6 + 2-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
						Draw.setColor({1,1,0,1})
						love.graphics.print("A", 90-6-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
					else
						love.graphics.print("B", 330-6-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("B", 330-6 + 2-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
						love.graphics.print("B", 330-6 + 2-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
						Draw.setColor({1,1,0,1})
						love.graphics.print("B", 330-6-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
					end
				end
			end
			Draw.setColor(self.gameshowdblue)
			love.graphics.print("A", 120-6-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
			love.graphics.print("A", 120-6 + 2-self.bigfont:getWidth("A")/2, 90 + 2, 0, 2, 2)
			love.graphics.print("A", 120-6 + 2-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
			Draw.setColor(answer_color)
			love.graphics.print("A", 120-6-self.bigfont:getWidth("A")/2, 90, 0, 2, 2)
			love.graphics.setFont(self.font)
			Draw.setColor(self.gameshowdblue)
			local answer_a = self.cur_answer_a
			love.graphics.print(answer_a, 120-self.font:getWidth(answer_a)/2, 170 + 2-3, 0, 1, 1)
			love.graphics.print(answer_a, 120 + 2-self.font:getWidth(answer_a)/2, 170 + 2-3, 0, 1, 1)
			love.graphics.print(answer_a, 120 + 2-self.font:getWidth(answer_a)/2, 170-3, 0, 1, 1)
			Draw.setColor(answer_color)
			love.graphics.print(answer_a, 120-self.font:getWidth(answer_a)/2, 170-3, 0, 1, 1)
			
			love.graphics.setFont(self.bigfont)
			answer_color = {1,1,1,1}
			if self.answer == "B" then
				answer_color = {1,1,0,1}
			end
			Draw.setColor(self.gameshowdblue)
			love.graphics.print("B", 360-6-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
			love.graphics.print("B", 360-6 + 2-self.bigfont:getWidth("B")/2, 90 + 2, 0, 2, 2)
			love.graphics.print("B", 360-6 + 2-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
			Draw.setColor(answer_color)
			love.graphics.print("B", 360-6-self.bigfont:getWidth("B")/2, 90, 0, 2, 2)
			love.graphics.setFont(self.font)
			Draw.setColor(self.gameshowdblue)
			local answer_b = self.cur_answer_b
			love.graphics.print(answer_b, 360-self.font:getWidth(answer_b)/2, 170 + 2-3, 0, 1, 1)
			love.graphics.print(answer_b, 360 + 2-self.font:getWidth(answer_b)/2, 170 + 2-3, 0, 1, 1)
			love.graphics.print(answer_b, 360 + 2-self.font:getWidth(answer_b)/2, 170-3, 0, 1, 1)
			Draw.setColor(answer_color)
			love.graphics.print(answer_b, 360-self.font:getWidth(answer_b)/2, 170-3, 0, 1, 1)
			Draw.setColor(1,1,1,1)
		elseif self.quiz_state == "result" then
			for i = 1, self.tv_columns do
				for j,screen in ipairs(self.tv_screens[i]) do
					Draw.setColor(1,1,1,1)
					if self.result == true then
						if self.dess_wrong_answer ~= nil and (screen.index % #Game.party) + 2 == self.dess_position then
							Draw.draw(self.red_x[(math.floor(self.screen_anim - 1) % #self.red_x) + 1], screen.x, screen.y, 0, 2, 2)
						else
							Draw.draw(self.green_circle[(math.floor(self.screen_anim - 1) % #self.green_circle) + 1], screen.x, screen.y, 0, 2, 2)
						end
					else
						if self.dess_wrong_answer ~= nil and (screen.index % #Game.party) + 2 == self.dess_position then
							Draw.draw(self.green_circle[(math.floor(self.screen_anim - 1) % #self.green_circle) + 1], screen.x, screen.y, 0, 2, 2)
						else
							Draw.draw(self.red_x[(math.floor(self.screen_anim - 1) % #self.red_x) + 1], screen.x, screen.y, 0, 2, 2)
						end
					end
				end
			end
		end
		
		if self.quiz_bullets then
			for i = 1, self.tv_columns do
				for j,screen in ipairs(self.tv_screens[i]) do
					Draw.setColor(1,1,1,1)
					local bullet_screen_sprite = self.red_x[(math.floor(self.screen_anim - 1) % #self.red_x) + 1]
					if self.result == true then
						if self.dess_wrong_answer ~= nil and (screen.index % #Game.party) + 2 ~= self.dess_position then
							bullet_screen_sprite = self.green_circle[(math.floor(self.screen_anim - 1) % #self.green_circle) + 1]
						end
					else
						if self.dess_wrong_answer ~= nil and (screen.index % #Game.party) + 2 == self.dess_position then
							bullet_screen_sprite = self.green_circle[(math.floor(self.screen_anim - 1) % #self.green_circle) + 1]
						end
					end
					for _,shooter in ipairs(self.shooter_list) do
						if shooter.screen_x == i and shooter.screen_y == j and shooter.alpha > 0 then
							bullet_screen_sprite = shooter.screen_anim
						end
					end
					Draw.draw(bullet_screen_sprite, screen.x, screen.y, 0, 2, 2)
				end
			end
		end
		if self.show_static_display then
			for i = 1, self.tv_columns do
				for j,screen in ipairs(self.tv_screens[i]) do
					Draw.setColor(1,1,1,1)
					Draw.draw(self.quiz_static[(math.floor(self.screen_anim - 1) % #self.quiz_static) + 1], screen.x, screen.y, 0, 2, 2)
				end
			end
		end
		for i = 1, self.tv_columns do
			for j,screen in ipairs(self.tv_screens[i]) do
				Draw.setColor(1,1,1,1)
				Draw.draw(self.base_texture_thin[5], screen.x, screen.y, 0, 2, 2)
				Draw.setColor(Utils.mergeColor(self.base_color, screen.color, 0.6 + (math.sin((self.timer / 4) + screen.x + screen.y) * 0.1)))
				Draw.draw(self.base_texture_thin[2], screen.x, screen.y, 0, 2, 2)
				Draw.setColor(Utils.mergeColor(self.base_color, COLORS["black"], 0.5))
				Draw.draw(self.base_texture_thin[3], screen.x, screen.y, 0, 2, 2)
				Draw.setColor(self.base_color)
				Draw.draw(self.base_texture_thin[4], screen.x, screen.y, 0, 2, 2)
				Draw.setColor(1,1,1,1)
				Draw.draw(self.base_texture_thin[6], screen.x, screen.y, 0, 2, 2)
			end
		end
	end
	Draw.setColor(1,1,1,1)
end

return TeevieQuiz