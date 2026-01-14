local BlendMenu, super = Class(Object)

function BlendMenu:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self:setParallax(0, 0)

    self.draw_children_below = 0

    self.font = Assets.getFont("main")
    self.font_small = Assets.getFont("plain")

    self.ui_blend_made = Assets.newSound("locker")
    self.ui_cant_select = Assets.newSound("ui_cant_select")

    self.arrow_left = Assets.getTexture("ui/flat_arrow_left")
    self.arrow_right = Assets.getTexture("ui/flat_arrow_right")
    self.up = Assets.getTexture("ui/page_arrow_up")
    self.down = Assets.getTexture("ui/page_arrow_down")

    self.heart = Sprite("player/heart", 62, 216)
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setColor(Game:getSoulColor())
    self.heart.layer = 100
    self:addChild(self.heart)

    self.description_box = Rectangle(0, 0, SCREEN_WIDTH, 121)
    self.description_box:setColor(0, 0, 0)
	self.description_box.layer = -1
    self:addChild(self.description_box)

    self.description = Text("---", 20, 20, SCREEN_WIDTH - 20, 100)
    self.description_box:addChild(self.description)

    -- SELECT, SWAP
    self.state = "SELECT"

    self.heart_target_x = 62
    self.heart_target_y = 216
	
	self.blends = {
		{
			name = "Hatsell Blend",
			id = "hatsell_blend",
			desc = "A blend that raises ATK for the user by 1.",
			bdarkess = 10, 
			bfountain = 0,
			bspam = 20, 
			bbinari = 0
		},
		{
			name = "Friva Blend",
			id = "friva_blend",
			desc = "A blend that raises DEF for the user by 1.",
			bdarkess = 20, 
			bfountain = 0,
			bspam = 10, 
			bbinari = 0
		}
	}
	
	self.selected = 1
	self.selected_confirm = 1

	self.page = 1
	self.pages = math.ceil(#self.blends/5)

    self:updateDescription()
    self.error_flash_timer = 0
end

function BlendMenu:updateDescription()
    local new_text = "---"
    if self.blends[self.selected] then
        new_text = self.blends[self.selected].desc
    end
    if self.description.text ~= new_text then
        self.description:setText(new_text)
    end
end

function BlendMenu:update()
	super.update(self)
    if self.state == "SELECT" then
		if Input.pressed("cancel", false) then
			Game.world:closeMenu()
			return
		end
		if Input.pressed("confirm", false) then
			if Game:getFlag("darkess_beans", 0) >= self.blends[self.selected].bdarkess and Game:getFlag("fountain_beans", 0) >= self.blends[self.selected].bfountain and Game:getFlag("spam_beans", 0) >= self.blends[self.selected].bspam and Game:getFlag("binaribeans", 0) >= self.blends[self.selected].bbinari then
				self.state = "CONFIRM"
			else
				self.ui_cant_select:stop()
				self.ui_cant_select:play()
                self.error_flash_timer = 10
			end
			return
		end
		local old = self.selected
		if Input.pressed("up", true) then
			self.selected = self.selected - 1
		end
		if Input.pressed("down", true) then
			self.selected = self.selected + 1
		end
		if self.selected < 1 then self.selected = #self.blends end
		if self.selected > #self.blends then self.selected = 1 end
		if self.selected ~= old then
			for i=1,self.pages do
				if (self.selected >= 1 + 5 * (i - 1)) and (self.selected <= 5 * (i)) then
					self.page = i
				end
			end
			self.error_flash_timer = 0
		end
		-- Update the heart target position
		self.heart_target_x = 62
		self.heart_target_y = 216 + ((self.selected - 1)-(5*(self.page-1))) * 40
    elseif self.state == "CONFIRM" then
		if Input.pressed("cancel", false) then
            self.state = "SELECT"
			return
		end
		if Input.pressed("confirm", false) then
			if self.selected_confirm == 1 then
				if Game:getFlag("darkess_beans", 0) >= self.blends[self.selected].bdarkess and Game:getFlag("fountain_beans", 0) >= self.blends[self.selected].bfountain and Game:getFlag("spam_beans", 0) >= self.blends[self.selected].bspam and Game:getFlag("binaribeans", 0) >= self.blends[self.selected].bbinari then
					local success = Game.inventory:addItem(self.blends[self.selected].id)
					if success then
						self.ui_blend_made:stop()
						self.ui_blend_made:play()
						Game:addFlag("darkess_beans", -self.blends[self.selected].bdarkess)
						Game:addFlag("fountain_beans", -self.blends[self.selected].bfountain)
						Game:addFlag("spam_beans", -self.blends[self.selected].bspam)
						Game:addFlag("binaribeans", -self.blends[self.selected].bbinari)
						self.state = "SELECT"
					else
						Game.world:startCutscene("devroom.blend_invfull")
					end
				end
				return
			elseif self.selected_confirm == 2 then
				self.state = "SELECT"
				return
			end
		end
		local old = self.selected
		if Input.pressed("left", false) then
			self.selected_confirm = self.selected_confirm - 1
			if self.selected_confirm < 1 then
				self.selected_confirm = 2
			end
		end
		if Input.pressed("right", false) then
			self.selected_confirm = self.selected_confirm + 1
			if self.selected_confirm > 2 then
				self.selected_confirm = 1
			end
		end
		-- Update the heart target position
		if self.selected_confirm == 1 then
			self.heart_target_x = 358
		elseif self.selected_confirm == 2 then
			self.heart_target_x = 458
		end
		self.heart_target_y = 416
    end
    self.error_flash_timer = math.max(self.error_flash_timer - DTMULT, 0)

    self:updateDescription()

    -- Move the heart closer to the target
    if (math.abs((self.heart_target_x - self.heart.x)) <= 2) then
        self.heart.x = self.heart_target_x
    end
    if (math.abs((self.heart_target_y - self.heart.y)) <= 2) then
        self.heart.y = self.heart_target_y
    end
    self.heart.x = self.heart.x + ((self.heart_target_x - self.heart.x) / 2) * DTMULT
    self.heart.y = self.heart.y + ((self.heart_target_y - self.heart.y) / 2) * DTMULT
end

function BlendMenu:draw()
    love.graphics.setLineWidth(4)
    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("line", 42, 122, 557, 307)
    Draw.setColor(PALETTE["world_fill"])
    love.graphics.rectangle("fill", 44, 124, 553, 303)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font)
	love.graphics.setLineWidth(4)
    Draw.setColor(PALETTE["world_border"])
	
	love.graphics.line(300, 181, 300, 427)
	love.graphics.line(44, 181, 597, 181)
	
	love.graphics.print("Result", 128, 140)
	love.graphics.print("Ingredients", 360, 140)
	for k,v in pairs(self.blends) do
		if (k >= 1 + 5 * (self.page - 1)) and (k <= 5 * (self.page)) then
			if k == self.selected then
				if Game:getFlag("darkess_beans", 0) >= v.bdarkess and Game:getFlag("fountain_beans", 0) >= v.bfountain and Game:getFlag("spam_beans", 0) >= v.bspam and Game:getFlag("binaribeans", 0) >= v.bbinari then
					love.graphics.setColor(1, 1, 0, 1)
				else
					love.graphics.setColor(0.5, 0.5, 0.5, 1)
				end
			else
				if Game:getFlag("darkess_beans", 0) >= v.bdarkess and Game:getFlag("fountain_beans", 0) >= v.bfountain and Game:getFlag("spam_beans", 0) >= v.bspam and Game:getFlag("binaribeans", 0) >= v.bbinari then
					love.graphics.setColor(1, 1, 1, 1)
				else
					love.graphics.setColor(0.5, 0.5, 0.5, 1)
				end
			end
			love.graphics.print(v.name, 82, 200 + (40 * ((k-5*(self.page-1))-1)))
		end
	end
	
	love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.font_small)
	local darkesscount = Game:getFlag("darkess_beans", 0) .. "/" .. self.blends[self.selected].bdarkess
	local fountaincount = Game:getFlag("fountain_beans", 0) .. "/" .. self.blends[self.selected].bfountain
	local spamcount = Game:getFlag("spam_beans", 0) .. "/" .. self.blends[self.selected].bspam
	local binaricount = Game:getFlag("binaribeans", 0) .. "/" .. self.blends[self.selected].bbinari
	if Game:getFlag("darkess_beans", 0) < self.blends[self.selected].bdarkess then
		love.graphics.setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.red, math.max((self.error_flash_timer / 10) - 0.1, 0)))
	end
	love.graphics.print("Darkess Beans", 320, 200)
	love.graphics.print(darkesscount, 570 - self.font_small:getWidth(darkesscount), 200)
	love.graphics.setColor(1, 1, 1, 1)
	if Game:getFlag("fountain_beans", 0) < self.blends[self.selected].bfountain then
		love.graphics.setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.red, math.max((self.error_flash_timer / 10) - 0.1, 0)))
	end
	love.graphics.print("Fountain Beans", 320, 220)
	love.graphics.print(fountaincount, 570 - self.font_small:getWidth(fountaincount), 220)
	love.graphics.setColor(1, 1, 1, 1)
	if Game:getFlag("spam_beans", 0) < self.blends[self.selected].bspam then
		love.graphics.setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.red, math.max((self.error_flash_timer / 10) - 0.1, 0)))
	end
	love.graphics.print("Spam Beans", 320, 240)
	love.graphics.print(spamcount, 570 - self.font_small:getWidth(spamcount), 240)
	love.graphics.setColor(1, 1, 1, 1)
	if Game:getFlag("binaribeans", 0) < self.blends[self.selected].bbinari then
		love.graphics.setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.red, math.max((self.error_flash_timer / 10) - 0.1, 0)))
	end
	love.graphics.print("Binaribeans", 320, 260)
	love.graphics.print(binaricount, 570 - self.font_small:getWidth(binaricount), 260)
	love.graphics.setColor(1, 1, 1, 1)

    Draw.setColor(1, 1, 1, 1)
    if self.pages > 1 then
        local left_arrow_x, left_arrow_y = 320, 108
        local right_arrow_x, right_arrow_y = 320, 428
        local offset = MathUtils.round(math.sin(Kristal.getTime() * 5)) * 2
        Draw.draw(self.arrow_left, left_arrow_x, left_arrow_y - offset, math.rad(90), 2, 2)
        Draw.draw(self.arrow_right, right_arrow_x, right_arrow_y + offset, math.rad(90), 2, 2)
    end
	
	if self.state == "CONFIRM" then
		love.graphics.setFont(self.font)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 377, SCREEN_WIDTH, SCREEN_HEIGHT)

		love.graphics.setLineWidth(4)
		love.graphics.setColor(1, 1, 1)
		love.graphics.line(0, 377, SCREEN_WIDTH, 377)

		love.graphics.print("Make this blend?", 60, 400)

		if self.selected_confirm == 1 then
			love.graphics.setColor(1, 1, 0)
		else
			love.graphics.setColor(1, 1, 1)
		end

		love.graphics.print("Yes", 380, 400)

		if self.selected_confirm == 2 then
			love.graphics.setColor(1, 1, 0)
		else
			love.graphics.setColor(1, 1, 1)
		end

		love.graphics.print("No", 480, 400)
	end

    super.draw(self)
end

function BlendMenu:close()
    Game.world.menu = nil
    self:remove()
end

return BlendMenu