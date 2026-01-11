---@class Textbox : Textbox
local DialogueText, super = Utils.hookScript(DialogueText)

function DialogueText:init(text, x, y, w, h, options)
	super.init(self, text, x, y, w, h, options)
	
	self.mike_mode = false
	self.mike_ignore_fast_skip = false
	self.mike_hand_five_no_advance = false
	self.left_click_pressed = false
	self.mike_advance_time = 60
	self.mike_extra_time = 0
	self.mike_advance_timer = 0
end

function DialogueText:update()
	if self.mike_mode then
		local speed = self.state.speed
		local mike_enc = Game.battle.encounter or nil
		self.left_click_pressed = false
		if Kristal.isConsole() then
			if Input.pressed("confirm") then
				self.left_click_pressed = true
			end
		else
			if Input.mousePressed(1) then
				self.left_click_pressed = true
			end
		end

		if not OVERLAY_OPEN then
			if Input.pressed("menu") and not self.mike_ignore_fast_skip then
				self.fast_skipping_timer = 1
			end

			local input = self.left_click_pressed or (Input.down("menu") and self.fast_skipping_timer >= 1 and not self.mike_ignore_fast_skip)
				
			if self.can_advance then
				self.mike_advance_timer = self.mike_advance_timer + 1 * DTMULT
				if input then
					if not self.mike_hand_five_no_advance or (self.mike_hand_five_no_advance and mike_enc and mike_enc.hand.hand_type ~= 5) then
						self.mike_advance_timer = math.huge
					end
				end
			end
			if self.skippable and input then
				if not self.mike_hand_five_no_advance or (self.mike_hand_five_no_advance and mike_enc and mike_enc.hand.hand_type ~= 5) then
					self.state.skipping = true
				end
			end
			if self.mike_advance_timer >= self.mike_advance_time + self.mike_extra_time then
				self.should_advance = false
				if not self.state.typing then
					self:advance()
				end
				self.mike_advance_timer = 0
			end

			if Input.down("menu") and not self.mike_ignore_fast_skip then
				if self.fast_skipping_timer < 1 then
					self.fast_skipping_timer = self.fast_skipping_timer + DTMULT
				end
			else
				self.fast_skipping_timer = 0
			end
		end

		if self.state.waiting == 0 then
			self.state.progress = self.state.progress + (DT * 30 * speed)
		else
			self.state.waiting = math.max(0, self.state.waiting - DT)
		end

		if self.state.typing then
			self:drawToCanvas(function ()
				while (math.floor(self.state.progress) > self.state.typed_characters) or self.state.skipping do
					local current_node = self.nodes[self.state.current_node]

					if current_node == nil then
						self.state.typing = false
						break
					end

					self:playTextSound(current_node)
					self:processNode(current_node, false)

					if self.state.skipping then
						self.state.progress = self.state.typed_characters
					end

					self.state.current_node = self.state.current_node + 1
				end
			end)
		end

		self:updateTalkSprite(self.state.talk_anim and self.state.typing)

		super.super.update(self)

		self.last_talking = self.state.talk_anim and self.state.typing
	else
		super.update(self)
	end
end

return DialogueText