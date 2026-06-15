local notDiamonStore, super = Class(Shop)

function notDiamonStore:init()
  	local talktext_rand = love.math.random(1, 11)
  	super.init(self)

  	notDiamonStore.BACKGROUND_SHADER = Assets.getShader("kristal/main_menu_background")

	self.background_image_wave = Assets.getTexture("world/npcs/arlee/shop/background")
	self.fader_alpha = 1
    self.animation_sine = 0
    self.background_alpha = 0

	self.shop_music = nil
	
	self.shopkeeper:setActor("arlee_shop")
	
	self.encounter_text = "[emote:happyClosed]hey there!!"

	self.shop_text = "[emote:happyClosed]make yourself at home!"
	self.leaving_text = "[emote:happyClosed]good night!"
	self.buy_menu_text = "what are you buying?"
	self.buy_confirmation_text = "you sure?"
	self.buy_refuse_text = "[emote:sad]aww......"
	self.buy_text = "[emote:happyClosed]thx!"
	self.buy_storage_text = "[emote:face]deorganized ass ngl"
	self.buy_too_expensive_text = "[emote:face]ya cant make a scene if you dont have the green"
	self.buy_no_space_text = "[emote:face]sorry your full"
	self.sell_menu_text = "[emote:face]dont got a lot of money but sure!1"
	self.sell_no_price_text = "[emote:face]i cant afford that"
	self.sell_nothing_text = "[emote:face]yknow air is free right?"
	self.sell_confirmation_text = "ill buy if for \n%s"
	self.sell_everything_text = "[emote:happyClosed]thats all!"
	self.sell_refuse_text = "[emote:angry]didnt want you junk anyway!!!"
	self.sell_text = "[emote:face]i dunno where ill store this"
	self.sell_no_storage_text = "[emote:face]you dont have anything...."

	self.talk_text = "[emote:face]about me?"

	self.sell_options_text["items"]   = "[emote:face]what you got?"
	self.sell_options_text["weapons"] = "[emote:face]what you got?"
	self.sell_options_text["armors"]  = "[emote:face]what you got?"
	self.sell_options_text["storage"] = "[emote:face]what you got?"

	self:registerItem("lpolyarmlet")
	self:registerItem("tinkatinHammer")
	self:registerItem("cubeBadge", {stock = 1})
	self:registerItem("StarBit")
	
	self:registerTalk("Yourself")

	local quest = Game:getFlag("package_quest")
	if quest and quest == 1 then
		self:registerTalkAfter("Delivery?", 1)
	end
end

function notDiamonStore:postInit()
    -- im sorry for stealing your whole swag diamond....... i should kill myself......

    self:processReplacements()

    -- Construct the UI
    self.large_box = UIBox()
    local left, top = self.large_box:getBorder()
    self.large_box:setOrigin(0, 1)
    self.large_box.x = left
    self.large_box.y = SCREEN_HEIGHT - top + 1
    self.large_box.width = SCREEN_WIDTH - (top * 2) + 1
    self.large_box.height = 213 - 37 + 1
    self.large_box:setLayer(SHOP_LAYERS["large_box"])

    self.large_box.visible = false

    self:addChild(self.large_box)

    self.left_box = UIBox()
    local left, top = self.left_box:getBorder()
    self.left_box:setOrigin(0, 1)
    self.left_box.x = left
    self.left_box.y = SCREEN_HEIGHT - top + 1
    self.left_box.width = 338 + 14
    self.left_box.height = 213 - 37 + 1
	
    self.left_box:setLayer(SHOP_LAYERS["left_box"])

    self:addChild(self.left_box)

    self.right_box = UIBox()
    local left, top = self.right_box:getBorder()
    self.right_box:setOrigin(1, 1)
    self.right_box.x = SCREEN_WIDTH - left + 1
    self.right_box.y = SCREEN_HEIGHT - top + 1
    self.right_box.width = 20 + 156 + 1
    self.right_box.height = 213 - 37 + 1
    self.right_box:setLayer(SHOP_LAYERS["right_box"])

    self:addChild(self.right_box)

    self.info_box = UIBox()
    local left, top = self.info_box:getBorder()
    local right_left, right_top = self.right_box:getBorder()
    self.info_box:setOrigin(1, 1)
    self.info_box.x = SCREEN_WIDTH - left + 1
    -- find a more elegant way to do this...
    self.info_box.y = SCREEN_HEIGHT - top - self.right_box.height - (right_top * 2) + 16 + 1
    self.info_box.width = 20 + 156 + 1
    self.info_box.height = 213 - 37
    self.info_box:setLayer(SHOP_LAYERS["info_box"])

    self.info_box.visible = false

    self:addChild(self.info_box)

    local emoteCommand = function(text, node)
        self:onEmote(node.arguments[1])
    end

    self.dialogue_text = DialogueText("", 30, 270, 372, 194)
    self.dialogue_text:addFX(OutlineFX())
    self.dialogue_text:getFX():setColor(0, 0, 0)
    self.dialogue_text:registerCommand("emote", emoteCommand)

    self.dialogue_text:setLayer(SHOP_LAYERS["dialogue"])
    self:addChild(self.dialogue_text)
    self:setDialogueText(self.encounter_text)

    self.right_text = DialogueText("", 30 + 420, 260, 176, 206)
    self.right_text:addFX(OutlineFX())
    self.right_text:getFX():setColor(0, 0, 0)
    self.right_text:registerCommand("emote", emoteCommand)

    self.right_text:setLayer(SHOP_LAYERS["dialogue"])
    self:addChild(self.right_text)
    self:setRightText("")

    self.talk_dialogue = {self.dialogue_text, self.right_text}

    self.large_box:remove()
	self.left_box:remove()
    self.right_box:remove()
    self.info_box:remove()
    self.bg_cover:remove()
    self.ui_hold_sprite = Assets.getTexture("ui/shop/ui_hold_alpha")
    self.ui_storage_sprite = Assets.getTexture("ui/shop/ui_storage_alpha")
    self.ui_armor_sprite = Assets.getTexture("ui/shop/ui_armor_alpha")
    self.ui_weapon_sprite = Assets.getTexture("ui/shop/ui_weapon_alpha")
    self.ui_pocket_sprite = Assets.getTexture("ui/shop/ui_pocket_alpha")
    self.ui_badge_sprite = Assets.getTexture("ui/shop/ui_badge_alpha")
    self.ui_bp_sprite = Assets.getTexture("ui/shop/ui_bp_alpha")
end

function notDiamonStore:setDialogueText(text)
    if type(text) ~= "table" then
        text = {text}
    else
        text = TableUtils.copy(text)
    end
    for i,line in ipairs(text) do
		text[i] = line
	end
	super.setDialogueText(self, text)
end

function notDiamonStore:setRightText(text)
    self.right_text:setText(self:getVoicedText(text))
end

function notDiamonStore:startTalk(talk)
	if talk == "Yourself" then
		self:startDialogue({
            "[emote:face]ya want to know more about me?",
            "[emote:face]well im really sorry but i like",
            "[emote:happy]dont spread my personals like a pro gossiper",
            "[emote:face]so yea sorry",
        })
	end
end

function notDiamonStore:printOutline(text, x, y, r, sx, sy, ox, oy, kx, ky)
    local old_color = { love.graphics.getColor() }

    Draw.setColor(0, 0, 0)

    local drawn = {}
    for i = -1, 1 do
        for j = -1, 1 do
            if i ~= 0 or j ~= 0 then
                love.graphics.print(text, x + i, y + j, r, sx, sy, ox, oy, kx, ky)
            end
        end
    end

    Draw.setColor(unpack(old_color))

    love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end

function notDiamonStore:drawTextureOutlined(texture, x, y, r, sx, sy, ox, oy, kx, ky)
    local old_color = { love.graphics.getColor() }

    Draw.setColor(0, 0, 0)

    local drawn = {}
    for i = -1, 1 do
        for j = -1, 1 do
            if i ~= 0 or j ~= 0 then
				Draw.draw(texture, x + i, y + j, r, sx, sy, ox, oy, kx, ky)
            end
        end
    end

    Draw.setColor(unpack(old_color))

    Draw.draw(texture, x, y, r, sx, sy, ox, oy, kx, ky)
end

function notDiamonStore:drawBackground()
    local background_index = self.animation_sine / 12
    local background_mult = self.background_alpha * 20
    local background_offset = 10 - background_mult
    local background_offset_inv = -10 - background_mult

        local bg_canvas = Draw.pushCanvas(320, 240)
        love.graphics.clear(0, 0, 0, 1)

        love.graphics.setShader(self.BACKGROUND_SHADER)
        self.BACKGROUND_SHADER:send("bg_sine", self.animation_sine)
        self.BACKGROUND_SHADER:send("bg_mag", 6)
        self.BACKGROUND_SHADER:send("wave_height", 240)
        self.BACKGROUND_SHADER:send("texsize", { self.background_image_wave:getWidth(), self.background_image_wave:getHeight() })

        self.BACKGROUND_SHADER:send("sine_mul", 1)
        Draw.setColor(1, 1, 1, self.background_alpha * 0.8)
        Draw.draw(self.background_image_wave, 0, math.floor(background_offset_inv))
        self.BACKGROUND_SHADER:send("sine_mul", -1)
        Draw.draw(self.background_image_wave, 0, math.floor(background_offset_inv))
        Draw.setColor(1, 1, 1, 1)

        love.graphics.setShader()

        Draw.popCanvas()

        Draw.setColor(1, 1, 1, self.background_fade)
        Draw.draw(bg_canvas, 0, 0, 0, 2, 2)

    Draw.setColor(1, 1, 1, 1)
end

function notDiamonStore:draw()
    self:drawBackground()

    super.draw(self)

	love.graphics.setFont(self.font)
    if self.state == "MAINMENU" then
        Draw.setColor(COLORS.white)
        for i = 1, #self.menu_options do
            self:printOutline(self.menu_options[i][1], 480, 220 + (i * 40))
        end
        Draw.setColor(Game:getSoulColor())
        self:drawTextureOutlined(self.heart_sprite, 450, 230 + (self.main_current_selecting * 40))
    elseif self.state == "BUYMENU" then

        while self.current_selecting - self.item_offset > 5 do
            self.item_offset = self.item_offset + 1
        end

        while self.current_selecting - self.item_offset < 1 do
            self.item_offset = self.item_offset - 1
        end

        if self.item_offset + 5 > #self.items + 1 then
            if #self.items + 1 > 5 then
                self.item_offset = self.item_offset - 1
            end
        end

        if #self.items + 1 == 5 then
            self.item_offset = 0
        end

        -- Item type (item, key, weapon, armor)
        for i = 1 + self.item_offset, self.item_offset + math.max(4, math.min(5, #self.items)) do
            if i == math.max(4, #self.items) + 1 then break end
            local y = 220 + ((i - self.item_offset) * 40)
            local item = self.items[i]
            if not item then
                -- If the item is null, add some empty space
                Draw.setColor(COLORS.dkgray)
                self:printOutline("--------", 60, y)
            elseif item.options["stock"] and (item.options["stock"] <= 0) then
                -- If we've depleted the stock, show a "sold out" message
                Draw.setColor(COLORS.gray)
                self:printOutline("--SOLD OUT--", 60, y)
            else
                Draw.setColor(item.options["color"])
                self:printOutline(item.options["name"], 60, y)
                if not self.hide_price then
                    Draw.setColor(COLORS.white)
                    self:printOutline(string.format(self.currency_text, item.options["price"] or 0), 60 + 240, y)
                end
            end
        end
        Draw.setColor(COLORS.white)
        if self.item_offset == math.max(4, #self.items) - 4 then
            self:printOutline("Exit", 60, 220 + (math.max(4, #self.items) + 1 - self.item_offset) * 40)
        end
        Draw.setColor(Game:getSoulColor())
        if not self.buy_confirming then
            self:drawTextureOutlined(self.heart_sprite, 30, 230 + ((self.current_selecting - self.item_offset) * 40))
        else
            self:drawTextureOutlined(self.heart_sprite, 30 + 420, 230 + 80 + 10 + (self.current_selecting_choice * 30))
            Draw.setColor(COLORS.white)
            local lines = StringUtils.split(
                string.format(
                    self.buy_confirmation_text,
                    string.format(
                        self.currency_text,
                        self.items[self.current_selecting].options["price"] or 0
                    )
                ),
                "\n"
            )
			local text_canvas = {}
            for i = 1, #lines do
				text_canvas[i] = Draw.pushCanvas(180, 32, { stencil = false })
                love.graphics.print(lines[i], 0, 0)
				Draw.popCanvas(true)
            end
			local col = ColorUtils.hexToRGB("#ffffff")
            Draw.setColor(ColorUtils.mergeColor(COLORS.black, col, 0.3))
            for i = 1, #lines do
				self:printOutline(lines[i], 60 + 400, 420 - 160 + ((i - 1) * 30))
				self:printOutline(lines[i], 60 + 400 + 1, 420 - 160 + ((i - 1) * 30) + 1)
			end
            Draw.setColor(1, 1, 1)
			local shader = Kristal.Shaders["GradientV"]
			local last_shader = love.graphics.getShader()
            love.graphics.setShader(shader)
            shader:sendColor("from", COLORS.white)
            shader:sendColor("to", col)
            for i = 1, #lines do
				Draw.draw(text_canvas[i], 60 + 400, 420 - 160 + ((i - 1) * 30))
			end
            love.graphics.setShader(last_shader)

            self:printOutline("Yes", 60 + 420, 420 - 80)
            self:printOutline("No", 60 + 420, 420 - 80 + 30)
        end
        Draw.setColor(COLORS.white)

        if (self.current_selecting <= #self.items) then
            local current_item = self.items[self.current_selecting]
            local box_left, box_top = self.info_box:getBorder()

            local left = self.info_box.x - math.floor(self.info_box.width) - (box_left / 2) * 1.5
            local top = self.info_box.y - math.floor(self.info_box.height) - (box_top / 2) * 1.5
            local width = math.floor(self.info_box.width) + box_left * 1.5
            local height = math.floor(self.info_box.height) + box_top * 1.5

            Draw.pushScissor()
            Draw.scissor(left, top, width, height)

            Draw.setColor(COLORS.white)
            self:printOutline(current_item.options["description"], left + 32, top + 20)

            if current_item.item.type == "armor" or current_item.item.type == "weapon" then
                for i = 1, #Game.party do
                    -- Turn the index into a 2 wide grid (0-indexed)
                    local transformed_x = (i - 1) % 2
                    local transformed_y = math.floor((i - 1) / 2)

                    -- Transform the grid into coordinates
                    local offset_x = transformed_x * 100
                    local offset_y = transformed_y * 45

                    local party_member = Game.party[i]
                    local can_equip = party_member:canEquip(current_item.item)
                    local head_path

                    love.graphics.setFont(self.plain_font)
                    Draw.setColor(COLORS.white)

                    if can_equip then
                        head_path = Assets.getTexture(party_member:getHeadIcons() .. "/head")
                        if current_item.item.type == "armor" then
                            self:drawTextureOutlined(self.stat_icons["defense_1"], offset_x + 470, offset_y + 127 + top)
                            self:drawTextureOutlined(self.stat_icons["defense_2"], offset_x + 470, offset_y + 147 + top)

                            for j = 1, 2 do
                                self:drawBonuses(party_member, party_member:getArmor(j), current_item.options["bonuses"], "defense", offset_x + 470 + 21, offset_y + 127 + ((j - 1) * 20) + top)
                            end

                        elseif current_item.item.type == "weapon" then
                            self:drawTextureOutlined(self.stat_icons["attack"], offset_x + 470, offset_y + 127 + top)
                            self:drawTextureOutlined(self.stat_icons["magic"], offset_x + 470, offset_y + 147 + top)

                            self:drawBonuses(
                                party_member,
                                party_member:getWeapon(),
                                current_item.options["bonuses"],
                                "attack",
                                offset_x + 470 + 21,
                                offset_y + 127 + top
                            )

                            self:drawBonuses(
                                party_member,
                                party_member:getWeapon(),
                                current_item.options["bonuses"],
                                "magic",
                                offset_x + 470 + 21,
                                offset_y + 147 + top
                            )
                        end
                    else
                        head_path = Assets.getTexture(party_member:getHeadIcons() .. "/head_error")
                    end

                    self:drawTextureOutlined(head_path, offset_x + 426, offset_y + 132 + top)
                end
            elseif current_item.item.type == "badge" then
                local bp_text = current_item.item:getBadgePoints() .. " BP"
                Draw.setColor(COLORS.orange)
                if current_item.item:getBadgePoints() > (Game.total_bp -  Game:getUsedBadgePoints()) then
                    Draw.setColor(COLORS.gray)
                end
                self:printOutline(bp_text, left + width - 32 - self.font:getWidth(bp_text), top + 20)
            end

            Draw.popScissor()

            Draw.setColor(COLORS.white)

            if not self.hide_storage_text then
                local current_storage = Game.inventory:getDefaultStorage(current_item.item)
                if not Game:getConfig("newShopSpaceUI") then
					local space = Game.inventory:getFreeSpace(current_storage)
					love.graphics.setFont(self.plain_font)

					if space <= 0 then
						self:printOutline("NO SPACE", 521, 430)
					else
						self:printOutline("Space:" .. space, 521, 430)
					end
				else
                    local item_type = current_item.item.type
                    
                    local space = Game.inventory:getFreeSpace(current_storage, false)
                    local space_count = Game.inventory:getItemCount(current_storage, false)
                    local total_space = space + space_count
                    
                    local storage_space = Game.inventory:getFreeSpace("storage")
                    local storage_space_count = Game.inventory:getItemCount("storage")
                    local storage_total_space = storage_space + storage_space_count
                    
                    love.graphics.setFont(self.space_font)
                    if item_type ~= "armor" and item_type ~= "weapon" and item_type ~= "key" and item_type ~= "badge" then
                        self:drawTextureOutlined(self.ui_hold_sprite, 555, 398)
                        self:printOutline(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), 556, 412, 0, 0.5, 0.5)
                        self:drawTextureOutlined(self.ui_storage_sprite, 555, 430)
                        self:printOutline(string.format("%02d", storage_space_count) .. "/" .. string.format("%02d", storage_total_space), 556, 444, 0, 0.5, 0.5)
                    else
                        if item_type == "badge" then
                            self:drawTextureOutlined(self.ui_badge_sprite, 555, 398)
                            self:drawTextureOutlined(self.ui_hold_sprite, 555, 410)
                            self:printOutline(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), 556, 424, 0, 0.5, 0.5)
                            self:drawTextureOutlined(self.ui_bp_sprite, 555, 444)
                            if current_item.item:getBadgePoints() > (Game.total_bp -  Game:getUsedBadgePoints()) then
                                Draw.setColor(COLORS.gray)
                            end
                            self:printOutline(string.format("%02d", Game:getUsedBadgePoints()) .. "/" .. string.format("%02d", Game.total_bp), 576, 444, 0, 0.5, 0.5)
                            Draw.setColor(COLORS.white)
                        else
                            self:printOutline(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), 556, 436, 0, 0.5, 0.5)
                            self:drawTextureOutlined(self.ui_hold_sprite, 555, 422)
                            if item_type == "armor" then
                                self:drawTextureOutlined(self.ui_armor_sprite, 555, 410)
                            elseif item_type == "weapon" then
                                self:drawTextureOutlined(self.ui_weapon_sprite, 555, 410)
                            elseif item_type == "key" then
                                self:drawTextureOutlined(self.ui_pocket_sprite, 555, 410)
                            end
                        end
                    end
				end
            end
        end
    elseif self.state == "SELLMENU" then
        Draw.setColor(Game:getSoulColor())
        self:drawTextureOutlined(self.heart_sprite, 50, 230 + (self.sell_current_selecting * 40))
        Draw.setColor(COLORS.white)
        love.graphics.setFont(self.font)
        for i, v in ipairs(self.sell_options) do
            self:printOutline(v[1], 80, 220 + (i * 40))
        end
        self:printOutline("Return", 80, 220 + ((#self.sell_options + 1) * 40))
    elseif self.state == "SELLING" then
        if self.item_current_selecting - self.item_offset > 5 then
            self.item_offset = self.item_offset + 1
        end

        if self.item_current_selecting - self.item_offset < 1 then
            self.item_offset = self.item_offset - 1
        end

        local inventory = Game.inventory:getStorage(self.state_reason[2])

        if inventory and inventory.sorted then
            if self.item_offset + 5 > #inventory then
                if #inventory > 5 then
                    self.item_offset = self.item_offset - 1
                end
            end
            if #inventory == 5 then
                self.item_offset = 0
            end
        end

        Draw.setColor(Game:getSoulColor())

        self:drawTextureOutlined(self.heart_sprite, 30, 230 + ((self.item_current_selecting - self.item_offset) * 40))
        if self.sell_confirming then
            self:drawTextureOutlined(self.heart_sprite, 30 + 420, 230 + 80 + 10 + (self.current_selecting_choice * 30))
            Draw.setColor(COLORS.white)
            local lines = StringUtils.split(
                string.format(
                    self.sell_confirmation_text,
                    string.format(
                        self.currency_text,
                        inventory[self.item_current_selecting]:getSellPrice()
                    )
                ),
                "\n"
            )
			local text_canvas = {}
            for i = 1, #lines do
				text_canvas[i] = Draw.pushCanvas(180, 32, { stencil = false })
                love.graphics.print(lines[i], 0, 0)
				Draw.popCanvas(true)
            end
			local col = ColorUtils.hexToRGB("#ffffff")
            Draw.setColor(ColorUtils.mergeColor(COLORS.black, col, 0.3))
            for i = 1, #lines do
				self:printOutline(lines[i], 60 + 400, 420 - 160 + ((i - 1) * 30))
				self:printOutline(lines[i], 60 + 400 + 1, 420 - 160 + ((i - 1) * 30) + 1)
			end
            Draw.setColor(1, 1, 1)
			local shader = Kristal.Shaders["GradientV"]
			local last_shader = love.graphics.getShader()
            love.graphics.setShader(shader)
            shader:sendColor("from", COLORS.white)
            shader:sendColor("to", col)
            for i = 1, #lines do
				Draw.draw(text_canvas[i], 60 + 400, 420 - 160 + ((i - 1) * 30))
			end
            love.graphics.setShader(last_shader)
			
            self:printOutline("Yes", 60 + 420, 420 - 80)
            self:printOutline("No", 60 + 420, 420 - 80 + 30)
        end

        Draw.setColor(COLORS.white)

        if inventory then
            for i = 1 + self.item_offset, self.item_offset + math.min(5, inventory.max) do
                local item = inventory[i]
                love.graphics.setFont(self.font)

                if item then
                    Draw.setColor(COLORS.white)
                    self:printOutline(item:getName(), 60, 220 + ((i - self.item_offset) * 40))
                    if item:isSellable() then
                        self:printOutline(string.format(self.currency_text, item:getSellPrice()), 60 + 240, 220 + ((i - self.item_offset) * 40))
                    end
                else
                    Draw.setColor(COLORS.dkgray)
                    self:printOutline("--------", 60, 220 + ((i - self.item_offset) * 40))
                end
            end

            local max = inventory.max
            if inventory.sorted then
                max = #inventory
            end

            Draw.setColor(COLORS.white)

            if max > 5 then

                for i = 1, max do
                    local percentage = (i - 1) / (max - 1)
                    local height = 129

                    local draw_location = percentage * height

                    local tocheck = self.item_current_selecting
                    if self.sell_confirming then
                        tocheck = self.current_selecting_choice
                    end

					Draw.setColor(COLORS.black)
                    if i == tocheck then
                        love.graphics.rectangle("fill", 372 - 1, 292 + draw_location - 1, 11, 11)
                    elseif inventory.sorted then
                        love.graphics.rectangle("fill", 372 + 3 - 1, 292 + 3 + draw_location - 1, 5, 5)
                    end
					Draw.setColor(COLORS.white)
                    if i == tocheck then
                        love.graphics.rectangle("fill", 372, 292 + draw_location, 9, 9)
                    elseif inventory.sorted then
                        love.graphics.rectangle("fill", 372 + 3, 292 + 3 + draw_location, 3, 3)
                    end
                end

                -- Draw arrows
                if not self.sell_confirming then
                    local sine_off = math.sin((Kristal.getTime() * 30) / 6) * 3
                    if self.item_offset + 4 < (max - 1) then
                        self:drawTextureOutlined(self.arrow_sprite, 370, 149 + sine_off + 291)
                    end
                    if self.item_offset > 0 then
                        self:drawTextureOutlined(self.arrow_sprite, 370, 14 - sine_off + 291 - 25, 0, 1, -1)
                    end
                end
            end
        else
            self:printOutline("Invalid storage", 60, 220 + (1 * 40))
        end
    elseif self.state == "TALKMENU" then
        Draw.setColor(Game:getSoulColor())
        self:drawTextureOutlined(self.heart_sprite, 50, 230 + (self.current_selecting * 40))
        Draw.setColor(COLORS.white)
        love.graphics.setFont(self.font)
        for i = 1, math.max(4, #self.talks) do
            local v = self.talks[i]
            if v then
                Draw.setColor(v[2].color)
                self:printOutline(v[1], 80, 220 + (i * 40))
            else
                Draw.setColor(COLORS.dkgray)
                self:printOutline("--------", 80, 220 + (i * 40))
            end
        end
        Draw.setColor(COLORS.white)
        self:printOutline("Exit", 80, 220 + ((math.max(4, #self.talks) + 1) * 40))
    end

    if self.state == "MAINMENU" or
    self.state == "BUYMENU" or
    self.state == "SELLMENU" or
    self.state == "SELLING" or
    self.state == "TALKMENU" then
        Draw.setColor(COLORS.white)
        love.graphics.setFont(self.font)
        self:printOutline(string.format(self.currency_text, self:getMoney()), 440, 420)
    end
end

function notDiamonStore:update()
	self.animation_sine = self.animation_sine + DTMULT

    if self.background_alpha < 1 then
        self.background_alpha = self.background_alpha + (0.04 - (self.background_alpha / 14)) * DTMULT
    end

  	super.update(self)

	self.talktext_rand = love.math.random(1, 12)
	self.talktext = ({
		"[emote:sad]i miss her",
		"[emote:face]making games is hard",
		"[emote:face]and boring sometimes",
		"[emote:face]soooo how are you?",
		"[emote:face]the weathers not bad today",
		"[emote:sad]are my items that ass??",
		"[emote:face]buy smth please",
		"[emote:happy]mama said id be rich in the future",
		"[emote:angry]cmon i need this money",
		"[emote:face]do you have a super nintendo?",
		"[emote:face]im not tweaking cuz im crazy im nervous",
		"brrrrrrrr"
	})[self.talktext_rand]

	self.shop_text = self.talktext

	self.talktext_rand = love.math.random(1, 4)
	self.ttalktext = ({
		"[emote:face]whats it gonna be?",
		"[emote:happy]if you want i can make a suggestion!",
		"[emote:face]just buy already",
		"[emote:happyClosed]my items are amazing!!"
	})[self.talktext_rand]

	self.buy_menu_text = self.ttalktext
end

return notDiamonStore