local RabbickBlowAct, super = Class(Object)

function RabbickBlowAct:init(enemy, all)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.draw_children_below = -1
    self.draw_children_above = -1
    self.blow_timer = 90

    self.enemy = enemy
	self.all_enemies = all
	self.hourglass = Assets.getTexture("ui/hourglass")

	self.blow_timer = 90
	self.blow_wait = false
	self.blow_buffer = 2
	self.blow_amt = 0
	self.blow_anim_timer = {}
end

function RabbickBlowAct:update()
	if self.blow_wait then
		self.blow_timer = self.blow_timer - DTMULT
	end
	self.blow_buffer = self.blow_buffer - DTMULT
	if self.blow_buffer <= 0 and Input.pressed("confirm") then
		self.blow_wait = true
		self.blow_buffer = 2
		if self.all_enemies then
			for i,enemy in ipairs(self.enemy) do
				enemy:getActiveSprite().fake_scale_x = 1 - enemy.blow_amt/200
				enemy:getActiveSprite():shake(5, 0, 1/4, 2/30)
				enemy:getActiveSprite():setSprite("hurt")
				enemy.blow_amt = enemy.blow_amt + 12
				if self.blow_anim_timer[i] then
					Game.battle.timer:cancel(self.blow_anim_timer[i])
				end
				self.blow_anim_timer[i] = Game.battle.timer:after(14/30, function()
					enemy:getActiveSprite():resetSprite()
					if enemy.mercy >= 100 then
						enemy:getActiveSprite():setSprite("spared")
					end
					enemy:getActiveSprite():stopShake()
				end)
				Assets.stopAndPlaySound("whistlebreath", 1, 1 + enemy.blow_amt/100)
			end
		else
			self.enemy:getActiveSprite().fake_scale_x = 1 - self.enemy.blow_amt/200
			self.enemy:getActiveSprite():shake(5, 0, 1/4, 2/30)
			self.enemy:getActiveSprite():setSprite("hurt")
			self.enemy.blow_amt = self.enemy.blow_amt + 12
			if self.blow_anim_timer[1] then
				Game.battle.timer:cancel(self.blow_anim_timer[1])
			end
			self.blow_anim_timer[1] = Game.battle.timer:after(14/30, function()
				self.enemy:getActiveSprite():resetSprite()
				if self.enemy.mercy >= 100 then
					self.enemy:getActiveSprite():setSprite("spared")
				end
				self.enemy:getActiveSprite():stopShake()
			end)
			Assets.stopAndPlaySound("whistlebreath", 1, 1 + self.enemy.blow_amt/100)
		end
		local amt = 0
		while amt < 6 do
			if self.all_enemies then
				for _,enemy in ipairs(self.enemy) do
					enemy:blowAnimation()
				end
			else
				self.enemy:blowAnimation()
			end
			amt = amt + 1
		end
	end
    if self.blow_timer <= 0 then
        Game.battle.battle_ui:clearEncounterText()
        Game.battle:finishAction()
        self:remove()
	end
	if self.all_enemies then
		for _,enemy in ipairs(self.enemy) do
			if enemy.blow_amt >= 100 then
				self:finishBlow()
				return
			end
		end
	else
		if self.enemy.blow_amt >= 100 then
			self:finishBlow()
		end
	end
    super.update(self)
end

function RabbickBlowAct:finishBlow()
	if self.all_enemies then
		for _,enemy in ipairs(self.enemy) do
			if enemy.blow_amt >= 100 then
				enemy:getActiveSprite():stopShake()
				enemy:getActiveSprite().fake_scale_x = 1
				enemy:getActiveSprite():resetSprite()
				enemy:addMercy(100)
				enemy.blown = true
			end
		end
	else
		self.enemy:getActiveSprite():stopShake()
		self.enemy:getActiveSprite().fake_scale_x = 1
		self.enemy:getActiveSprite():resetSprite()
		self.enemy:addMercy(100)
		self.enemy.blown = true
	end
	local amt = 0
	while amt < 15 do
		if self.all_enemies then
			for _,enemy in ipairs(self.enemy) do
				if enemy.blow_amt >= 100 then
					enemy:blowAnimation()
				end
			end
		else
			self.enemy:blowAnimation()
		end
		amt = amt + 1
	end
	Game.battle.battle_ui:clearEncounterText()
	Game.battle:finishAction()
	self:remove()
end

function RabbickBlowAct:draw()
    super.draw(self)

    if Kristal.getLibConfig("rabbick", "show_act_countdown") then
	    local b = 180 - (self.blow_timer * 1.8)
	    love.graphics.setColor(0,1,1,1)
	    love.graphics.rectangle("fill", 240, 290, b, 10)
	    love.graphics.setColor(1,1,1,1)
	    Draw.draw(self.hourglass, 240-18, 295-18, 0, 2, 2)
	end
end

return RabbickBlowAct