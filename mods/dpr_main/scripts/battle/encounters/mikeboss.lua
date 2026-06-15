local MikeBoss, super = Class(Encounter)

function MikeBoss:init()
    super.init(self)

    self.music = "deltarune/mike"
    self.text = "* It's Mike!"

	self.mike_battle = true

    -- Add the dummy enemy to the encounter
    self.mike_a = self:addEnemy("mike")
	self.mic = Mod.mic_controller
	
	self.flee = false

    self.boss_rush = false
	
    if Game:getFlag("mike_defeated") == true then
        self.boss_rush = true
    end
	
	self.draw_children_above = 1

    self.font = Assets.getFont("main")
	self.heart_sprite = Assets.getTexture("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_dodge")
	
	self.line_ypos = -32
	self.arena_mode = "SMALL_CIRCLE"
	self.arena_phase = 0
	self.arena_x = 0
	self.arena_y = 0
	self.arena_new_x = SCREEN_WIDTH/2
	self.arena_new_y = SCREEN_HEIGHT/2 + self.line_ypos
	self.arena_size1 = 0
	self.arena_size2 = 31
	self.arena_size3 = 10
	self.arena_dir = 270
	self.arena_new_dir = 270
	
	self.hand_dist = 140
	self.hand = nil
	self.hand_x = 0
	self.hand_y = 0
	
	self.allow_sensitivity_adjust = false
	self.left_click_pressed = false
	self.left_click_down = false
	local mx = 100
	local my = 0
	local mwidth = 440
	local mheight = 100
	local ly = my + (mheight / 2) + 32
	self.sensitivity_collider = Hitbox(Game.battle, mx + 86, ly - 30, ((mx + mwidth) - 96) - (mx + 86), (ly - 46) - (ly - 30))
	self.party_heals = { -- TODO: find a better way to do this
		apm = 0,
		berdly = 0,
		bor = 0,
		brenda = 0,
		ceroba = 0,
		ddelta = 0,
		dess = 0,
		hero = 0,
		jamm = 0,
		jerdly = 0,
		kris = 0,
		len = 0,
		mario = 0,
		nell = 0,
		noel = 0,
		noelle = 0,
		osw = 0,
		pauling = 0,
		ralsei = 0,
		susie = 0,
		suzy = 0,
	}
	self.display_fake_arena = false
end

function MikeBoss:onBattleStart()
	Game.battle.draw_children_above = 6453
	self.hand = MikeHand(0, 0)
	self.hand.visible = false
	self.hand.layer = 6453
	Game.battle:addChild(self.hand)
end

function MikeBoss:petBattler(battler)
	local battler = battler or nil
	if battler then
		Game.battle:startCutscene(function(cutscene)
			Game.battle.battle_ui.encounter_text.text.mike_mode = true
			Game.battle.battle_ui.encounter_text.text.mike_advance_time = 60
			Game.battle.battle_ui.encounter_text.text.mike_extra_time = 0
			if battler.id == "kris" or battler.id == "hero" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* The Maus offered you a Fruit Bonus!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* It was crunchy, and not very fruit like!")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* It was sort of effective!")
				else
					cutscene:text("* It was effective!")
				end
			elseif battler.id == "susie" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* The Maus was bitten!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* ...", "", "susie")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* Lay off, idiot!", "", "susie")
				else
					cutscene:text("* Touch me and you'll lose a finger, dumb ass!", "", "susie")
				end
			elseif battler.id == "ralsei" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* Ralsei got pet!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* ... petting overdose!", "", "ralsei")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* Haha, i-is it okay to receive this much attention!?", "", "ralsei")
				else
					cutscene:text("* Ahahah! That tickles!", "", "ralsei")
				end
			else
				cutscene:text("* Mike got pet!")
			end
			Game.battle.battle_ui.encounter_text.text.mike_mode = false
			cutscene:endCutscene()
			Game.battle.timer:after(1/30, function()
				Game.battle:startCutscene("mike.enemy_dialogue")
				Game.battle:setState("MIKEENEMYDIALOGUE") 
			end)
		end)
	end
end

function MikeBoss:onStateChange(old,new)
    super.onStateChange(self, old, new)
	if self.hand then
		self.hand_x = self.arena_x
		self.hand_y = self.arena_y
		self.hand.mouse_x = self.hand_x
		self.hand.mouse_y = self.hand_y
	end
	if new == "ACTIONSELECT" then
		Game.battle:setSelectedParty(0)
		Game.battle:setState("MIKEPARTYTURN")
		if self.mic.right_click_mic == 0 then
			self.allow_sensitivity_adjust = true
		end
		self.hand.visible = true
		self.display_fake_arena = true
	elseif new == "MIKEENEMYDIALOGUE" then
		self.hand.visible = false
		self.display_fake_arena = false
	end
end

function MikeBoss:canDisplayFakeArena()
	return self.display_fake_arena
end

function MikeBoss:getArenaMode()
	return self.arena_mode
end

function MikeBoss:inverseLerp(from, to, factor)
	if to == from then
		return 0
	end
    return (factor - from) / (to - from)
end

function MikeBoss:update()
	super.update(self)
	self.left_click_pressed = false
	self.left_click_down = false
	if Kristal.isConsole() then
		if Input.pressed("confirm") then
			self.left_click_pressed = true
		end
		if Input.down("confirm") then
			self.left_click_down = true
		end
	else
		if Input.mousePressed(1) then
			self.left_click_pressed = true
		end
		if Input.mouseDown(1) then
			self.left_click_down = true
		end
	end
	if self:canDisplayFakeArena() then
		local arena = self:getArenaMode()
		if arena == "SMALL_CIRCLE" then
			if self.arena_phase == 0 then
				self.arena_x = self.arena_x + ((self.arena_new_x - self.arena_x) * 0.25) * DTMULT
				self.arena_y = self.arena_y + ((self.arena_new_y - self.arena_y) * 0.25) * DTMULT
				self.arena_x = MathUtils.approach(self.arena_x, self.arena_new_x, 1 * DTMULT)
				self.arena_y = MathUtils.approach(self.arena_y, self.arena_new_y, 1 * DTMULT)
				if self.arena_x == self.arena_new_x and self.arena_y == self.arena_new_y then
					self.arena_size2 = 30
					self.arena_size3 = 13
					self.arena_phase = 1
					self.arena_mode = "SMALL_CIRCLE"
				end
			end
			local new_volume = math.min(12, self.mic.mic_volume / 4)
			if new_volume > 1 then
				self.arena_new_dir = self.arena_new_dir - new_volume * DTMULT
			end
			self.arena_dir = self.arena_dir + ((self.arena_new_dir - self.arena_dir) * 0.25) * DTMULT
			self.arena_size2 = math.max(13, new_volume * 2)
		end
	end
	if Game.battle:getState() == "MIKEPARTYTURN" then
		self.hand_dist = MathUtils.approach(self.hand_dist, 220, 8 * DTMULT)
	end
	if self.hand then
		self.hand_x = self.arena_x
		self.hand_y = self.arena_y
		if self.hand.hand_type == 1 and Game.battle:getState() == "MIKEPARTYTURN" then
			self.hand.juggle = false
		end
		if self.allow_sensitivity_adjust then
			local mx = 100
			local my = 0
			local mwidth = 440
			local mheight = 100
			local ly = my + (mheight / 2) + 32
			local lw = MathUtils.dist(mx + 96, 0, mx + mwidth - 96, 0)
			local lx = mx + 96 + (lw * (self.mic.mic_sensitivity/4))
			if self.hand.hand_type == 3 or self.sensitivity_collider:collidesWith(self.hand.collider) then
				self.hand.juggle = true
				if self.left_click_down then
					self.hand.hand_type = 3
					self.mic.mic_sensitivity = MathUtils.clamp(self:inverseLerp(mx + 86, mx + mwidth - 96, self.hand.mouse_x - 12) * 4, 0.1, 4)
				end
			end
		end
		if self.hand.hand_type == 3 and not self.left_click_down and Game.battle:getState() == "MIKEPARTYTURN" then
			self.hand.hand_type = 1
			self.hand.juggle = false
		end
		self.hand.hand_x = self.hand_x
		self.hand.hand_y = self.hand_y
		self.hand.hand_distance = self.hand_dist
	end
end

function MikeBoss:draw()
	super.draw(self)
	if self:canDisplayFakeArena() then
		local arena = self:getArenaMode()
		if arena == "SMALL_CIRCLE" then
			local center_x = self.arena_x
			local center_y = self.arena_y
			
			for i = 0, 34 do
				local mydir = (Kristal.getTime() * 1000) / 300
				local dir_dist = MathUtils.dist(self.arena_new_dir, 0, self.arena_dir, 0) / 10
				local circle_x = center_x + MathUtils.lengthDirX(math.max(16, self.arena_size1) + (math.sin(i + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
				math.rad(mydir + ((i / 36) * 360)))
				local circle_y = center_y + MathUtils.lengthDirY(math.max(16, self.arena_size1) + (math.sin(i + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
				math.rad(mydir + ((i / 36) * 360)))
				local circle_x2 = center_x + MathUtils.lengthDirX(math.max(16, self.arena_size1) + (math.sin((i - 1) + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
				math.rad(mydir + (((i - 1) / 36) * 360)))
				local circle_y2 = center_y + MathUtils.lengthDirY(math.max(16, self.arena_size1) + (math.sin((i - 1) + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
				math.rad(mydir + (((i - 1) / 36) * 360)))
				Draw.setColor(COLORS.lime)
				if i == 0 then
					local n = 34
					circle_x2 = center_x + MathUtils.lengthDirX(math.max(16, self.arena_size1) + (math.sin(n + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
					math.rad(mydir + ((n / 36) * 360)))
					circle_y2 = center_y + MathUtils.lengthDirY(math.max(16, self.arena_size1) + (math.sin(n + ((Kristal.getTime() * 1000) / 30)) * dir_dist),
					math.rad(mydir + ((n / 36) * 360)))
				end
				love.graphics.setLineWidth(2)
				love.graphics.line(circle_x, circle_y, circle_x2, circle_y2)
			end
			
			self.arena_size1 = self.arena_size1 + ((self.arena_size2 - self.arena_size1) * 0.25) * DTMULT
			self.arena_size2 = self.arena_size2 + ((self.arena_size3 - self.arena_size2) * 0.25) * DTMULT
			self.arena_size1 = MathUtils.approach(self.arena_size1, self.arena_size2, 0.01 * DTMULT)
			self.arena_size2 = MathUtils.approach(self.arena_size2, self.arena_size3, 0.01 * DTMULT)
			
			Draw.setColor(Game:getSoulColor())
			Draw.draw(self.heart_sprite, self.arena_x - 10, self.arena_y - 10)
		end
	end
	if self.allow_sensitivity_adjust then
		local mx = 100
		local my = 0
		local mwidth = 440
		local mheight = 100
		Draw.setColor(1, 1, 1)
		love.graphics.setFont(self.font)	
        love.graphics.print("Adjust Sensitivity", mx + (mwidth / 2) - self.font:getWidth("Adjust Sensitivity")/4, my + 30, 0, 0.5, 0.5)
		local ly = my + (mheight / 2) + 32
		local lw = MathUtils.dist(mx + 96, 0, mx + mwidth - 96, 0) 
		local lx = mx + 96 + (lw * (self.mic.mic_sensitivity/4))
		love.graphics.setColor(COLORS["dkgray"])
		local tri_points = {mx + 86, ly, mx + mwidth - 96}
		love.graphics.polygon("fill", tri_points[1], tri_points[2], tri_points[3], tri_points[2], tri_points[3], tri_points[2] - 16)
		Draw.setColor(1, 1, 1)
		love.graphics.rectangle("fill", lx - 2, ly - 24, 5, 33)
		if DEBUG_RENDER then
			self.sensitivity_collider:draw(1, 0, 0)
		end
	end
end

return MikeBoss
