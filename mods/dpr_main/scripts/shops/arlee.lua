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
	
	self.encounter_text = "[emote:face]hi there"

	self.shop_text = "make yourself at home"
	self.leaving_text = "good night"
	self.buy_menu_text = "what are you buying"
	self.buy_confirmation_text = "you sure?\n(costs %s)"
	self.buy_refuse_text = "sucks to suck"
	self.buy_text = "thx"
	self.buy_storage_text = "deorganized ass ngl"
	self.buy_too_expensive_text = "broke"
	self.buy_no_space_text = "sorry your full"
	self.sell_menu_text = "dont got a lot of money but sure"
	self.sell_no_price_text = "i cant afford that"
	self.sell_nothing_text = "yknow air is free right?"
	self.sell_confirmation_text = "ill buy it for \n%s"
	self.sell_everything_text = "thats all"
	self.sell_refuse_text = "a shame"
	self.sell_text = "i dunno where ill store this"
	self.sell_no_storage_text = "you dont have space hehehe space"

	self.talk_text = "about me?"

	self.sell_options_text["items"]   = "what you got?"
	self.sell_options_text["weapons"] = "what you got?"
	self.sell_options_text["armors"]  = "what you got?"
	self.sell_options_text["storage"] = "what you got?"

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
            "ya want to know more about me?",
            "well im really sorry but i like",
            "dont spread my personals like a pro gossiper",
            "so yea sorry",
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

function notDiamonStore:drawBonuses(party_member, old_item, bonuses, stat, x, y)
    local old_stat = 0

    if old_item then
        old_stat = old_item:getStatBonus(stat) or 0
    end

    local amount = (bonuses[stat] or 0) - old_stat
    local amount_string = tostring(amount)
    if amount < 0 then
        Draw.setColor(COLORS.aqua)
    elseif amount == 0 then
        Draw.setColor(COLORS.white)
    elseif amount > 0 then
        Draw.setColor(COLORS.yellow)
        amount_string = "+" .. amount_string
    end
    self:printOutline(amount_string, x, y)
    Draw.setColor(COLORS.white)
end

function notDiamonStore:drawMainMenu()
    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)

    for i = 1, #self.menu_options do
        self:printOutline(self.menu_options[i][1], 480, 220 + (i * 40))
    end

    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 450, 230 + (self.current_selected_main_option * 40))
end

--- The draw function responsible for drawing the items in the buy menu states.
---@param draw_soul boolean Whether to draw the soul cursor next to the currently selected item.
function notDiamonStore:drawBuyItems(draw_soul)
    local heart_pos = 30
    local text_pos = 60

    local total_items = #self.items + 1
    local visible_items = 5

    local first_item = 1 + self.item_offset
    local last_item = self.item_offset + visible_items

    local return_index = math.max(last_item, total_items)

    -- Show items
    for i = first_item, last_item do
        local y = 220 + ((i - self.item_offset) * 40)
        local item = self.items[i]

        if i == return_index then
            Draw.setColor(COLORS.white)
            self:printOutline("Exit", text_pos, y)
        elseif item == nil then
            -- If there's no item there, show empty slot
            Draw.setColor(COLORS.dkgray)
            self:printOutline("--------", text_pos, y)
        elseif item.options["stock"] and (item.options["stock"] <= 0) then
            -- If we've depleted the stock, show a "sold out" message
            Draw.setColor(COLORS.gray)
            self:printOutline("--SOLD OUT--", text_pos, y)
        else
            -- Valid item, show it
            Draw.setColor(item.options["color"])
            self:printOutline(item.options["name"], text_pos, y)
            if not self.hide_price then
                Draw.setColor(COLORS.white)
                self:printOutline(string.format(self.currency_text, item.options["price"] or 0), 300, y)
            end
        end

        if draw_soul and (i == self.current_selected_item) then
            -- Draw the soul if we're selecting this option
            Draw.setColor(Game:getSoulColor())
            self:drawTextureOutlined(self.heart_sprite, heart_pos, y + 10)
        end
    end
end

---@param box_y number The y offset of the info box.
---@param item Item The item being previewed.
---@param item_options table The options for the item being previewed.
function notDiamonStore:drawPartyBonusInfo(box_y, item, item_options, box_x, box_w)
    if item.type == "armor" or item.type == "weapon" then
		for i = 1, #Game.party do
			-- Turn the index into a 2 wide grid (0-indexed)
			local transformed_x = (i - 1) % 2
			local transformed_y = math.floor((i - 1) / 2)

			-- Transform the grid into coordinates
			local offset_x = transformed_x * 100
			local offset_y = transformed_y * 45

			local party_member = Game.party[i]
			local can_equip = party_member:canEquip(item)
			local head_path

			Draw.setColor(COLORS.white)

			if can_equip then
				head_path = Assets.getTexture(party_member:getHeadIcons() .. "/head_alpha")
				if item.type == "armor" then
					self:drawTextureOutlined(self.stat_icons["defense_1"], offset_x + 470, offset_y + 127 + box_y)
					self:drawTextureOutlined(self.stat_icons["defense_2"], offset_x + 470, offset_y + 147 + box_y)

					for j = 1, 2 do
						self:drawBonuses(party_member, party_member:getArmor(j), item_options["bonuses"], "defense", offset_x + 470 + 20, offset_y + 127 + ((j - 1) * 20) + box_y)
					end

				elseif item.type == "weapon" then
					self:drawTextureOutlined(self.stat_icons["attack"], offset_x + 470, offset_y + 127 + box_y)
					self:drawTextureOutlined(self.stat_icons["magic"], offset_x + 470, offset_y + 147 + box_y)

					self:drawBonuses(
						party_member,
						party_member:getWeapon(),
						item_options["bonuses"],
						"attack",
						offset_x + 470 + 20,
						offset_y + 127 + box_y
					)

					self:drawBonuses(
						party_member,
						party_member:getWeapon(),
						item_options["bonuses"],
						"magic",
						offset_x + 470 + 20,
						offset_y + 147 + box_y
					)
				end
			else
				head_path = Assets.getTexture(party_member:getHeadIcons() .. "/head_error_alpha")
			end

			self:drawTextureOutlined(head_path, offset_x + 426, offset_y + 132 + box_y)
		end
	elseif item.type == "badge" then
        local bp_text = item:getBadgePoints() .. " BP"
        Draw.setColor(COLORS.orange)
        if item:getBadgePoints() > (Game.total_bp -  Game:getUsedBadgePoints()) then
            Draw.setColor(COLORS.gray)
        end
        self:printOutline(bp_text, box_x + box_w - 32 - self.font:getWidth(bp_text), box_y + 20)
    end
end

function notDiamonStore:drawItemDisplay()
    Draw.setColor(COLORS.white)

    local current_item = self.items[self.current_selected_item]
    if current_item == nil then
        return
    end

    local box_left, box_top = self.info_box:getBorder()

    local left = self.info_box.x - math.floor(self.info_box.width) - (box_left / 2) * 1.5
    local top = self.info_box.y - math.floor(self.info_box.height) - (box_top / 2) * 1.5
    local width = math.floor(self.info_box.width) + box_left * 1.5
    local height = math.floor(self.info_box.height) + box_top * 1.5

    Draw.pushScissor()
    Draw.scissor(left, top, width, height)

    Draw.setColor(COLORS.white)
    self:printOutline(current_item.options["description"], left + 32, top + 20)

    if current_item.item.type == "armor" or current_item.item.type == "weapon" or current_item.item.type == "badge" then
        self:drawPartyBonusInfo(top, current_item.item, current_item.options, left, width)
    end

    Draw.popScissor()
end

function notDiamonStore:drawOldStorageDisplay()
    local current_item = self.items[self.current_selected_item]

    if current_item == nil then
        return
    end

    local current_storage = Game.inventory:getDefaultStorage(current_item.item)

    Draw.setColor(COLORS.white)
    local space = Game.inventory:getFreeSpace(current_storage)
    love.graphics.setFont(self.plain_font)

    if space <= 0 then
        self:printOutline("NO SPACE", 520, 430)
    else
        self:printOutline("Space:" .. space, 520, 430)
    end
end

function notDiamonStore:drawStorageDisplay()
    local current_item = self.items[self.current_selected_item]

    if current_item == nil then
        return
    end

    local current_storage = Game.inventory:getDefaultStorage(current_item.item)

    Draw.setColor(COLORS.white)
    local item_type = current_item.item.type

    local space = Game.inventory:getFreeSpace(current_storage, false)
    local space_count = Game.inventory:getItemCount(current_storage, false)
    local total_space = space + space_count

    local storage_space = Game.inventory:getFreeSpace("storage")
    local storage_space_count = Game.inventory:getItemCount("storage")
    local storage_total_space = storage_space + storage_space_count

    local display_x = 545

    love.graphics.setFont(self.space_font)
    if item_type ~= "armor" and item_type ~= "weapon" and item_type ~= "key" and item_type ~= "badge" then
        self:drawTextureOutlined(self.ui_hold_sprite, display_x, 398)
        self:printOutline(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), display_x + 1, 412, 0, 0.5, 0.5)
        self:drawTextureOutlined(self.ui_storage_sprite, display_x, 430)
        self:printOutline(string.format("%02d", storage_space_count) .. "/" .. string.format("%02d", storage_total_space), display_x + 1, 444, 0, 0.5, 0.5)
    elseif item_type ~= "key" then
        if item_type == "badge" then
            self:drawTextureOutlined(self.ui_badge_sprite, display_x, 398)
            self:drawTextureOutlined(self.ui_hold_sprite, display_x, 410)
            self:printOutline(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), display_x + 1, 424, 0, 0.5, 0.5)
            self:drawTextureOutlined(self.ui_bp_sprite, display_x, 444)
            if current_item.item:getBadgePoints() > (Game.total_bp -  Game:getUsedBadgePoints()) then
                Draw.setColor(COLORS.gray)
            end
            self:printOutline(string.format("%02d", Game:getUsedBadgePoints()) .. "/" .. string.format("%02d", Game.total_bp), display_x + 21, 444, 0, 0.5, 0.5)
            Draw.setColor(COLORS.white)
        else
            love.graphics.print(string.format("%02d", space_count) .. "/" .. string.format("%02d", total_space), display_x + 1, 436, 0, 0.5, 0.5)
            self:drawTextureOutlined(self.ui_hold_sprite, display_x, 422)
            if item_type == "armor" then
                self:drawTextureOutlined(self.ui_armor_sprite, display_x, 410)
            elseif item_type == "weapon" then
                self:drawTextureOutlined(self.ui_weapon_sprite, display_x, 410)
            end
		end
    end
end

function notDiamonStore:drawBuyConfirm()
    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 450, 320 + (self.current_selecting_choice * 30))

    Draw.setColor(COLORS.white)

    local lines = StringUtils.split(
        string.format(
            self.buy_confirmation_text,
            string.format(
                self.currency_text,
                self.items[self.current_selected_item].options["price"] or 0
            )
        ),
        "\n"
    )
	
    for i = 1, #lines do
        self:printOutline(lines[i], 460, 420 - 160 + ((i - 1) * 30))
    end
	
    self:printOutline("Yes", 60 + 420, 420 - 80)
    self:printOutline("No", 60 + 420, 420 - 80 + 30)
end

function notDiamonStore:drawSellMenu()
    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 50, 230 + (self.current_selecting_storage * 40))

    Draw.setColor(COLORS.white)
    love.graphics.setFont(self.font)

    for i, v in ipairs(self.sell_options) do
        self:printOutline(v[1], 80, 220 + (i * 40))
    end

    self:printOutline("Return", 80, 220 + ((#self.sell_options + 1) * 40))
end

---@param confirming boolean
function notDiamonStore:drawSellItems(confirming)
    local inventory = Game.inventory:getStorage(self.selected_storage)

    if inventory == nil then
        Draw.setColor(COLORS.ltgray)
        self:printOutline("Invalid storage", 60, 260)
        return
    end

    -- Draw the soul
    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 30, 230 + ((self.current_selected_item - self.item_offset) * 40))

    Draw.setColor(COLORS.white)

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

            local tocheck = self.current_selected_item

            if confirming and (Game.chapter <= 2) then
                -- DR bug -- if in the confirming menu, use the wrong variable
                -- TODO: Game.chapter usage!
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
        if not confirming then
            local sine_off = math.sin((Kristal.getTime() * 30) / 6) * 3
            if self.item_offset + 4 < (max - 1) then
                self:drawTextureOutlined(self.arrow_sprite, 370, 149 + sine_off + 291)
            end
            if self.item_offset > 0 then
                self:drawTextureOutlined(self.arrow_sprite, 370, 14 - sine_off + 291 - 25, 0, 1, -1)
            end
        end
    end
end

function notDiamonStore:drawSellConfirm()
    local inventory = Game.inventory:getStorage(self.selected_storage)

    if inventory == nil then
        return
    end

    -- Draw the soul
    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 30 + 420, 230 + 80 + 10 + (self.current_selecting_choice * 30))

    Draw.setColor(COLORS.white)

    local lines = StringUtils.split(
        string.format(
            self.sell_confirmation_text,
            string.format(
                self.currency_text,
                inventory[self.current_selected_item]:getSellPrice()
            )
        ),
        "\n"
    )
	
    for i = 1, #lines do
        self:printOutline(lines[i], 60 + 400, 420 - 160 + ((i - 1) * 30))
    end

    self:printOutline("Yes", 60 + 420, 420 - 80)
    self:printOutline("No", 60 + 420, 420 - 80 + 30)
end

function notDiamonStore:drawTalkMenu()
    Draw.setColor(Game:getSoulColor())
    self:drawTextureOutlined(self.heart_sprite, 50, 230 + (self.current_selected_item * 40))
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

function notDiamonStore:drawMoney()
    Draw.setColor(COLORS.white)
    love.graphics.setFont(self.font)
    self:printOutline(string.format(self.currency_text, self:getMoney()), 440, 420)
end

function notDiamonStore:drawBonuses(party_member, old_item, bonuses, stat, x, y)
    love.graphics.setFont(self.plain_font)

    local old_stat = 0

    if old_item then
        old_stat = old_item:getStatBonus(stat) or 0
    end

    local amount = (bonuses[stat] or 0) - old_stat
    local amount_string = tostring(amount)
    if amount < 0 then
        Draw.setColor(COLORS.aqua)
    elseif amount == 0 then
        Draw.setColor(COLORS.white)
    elseif amount > 0 then
        Draw.setColor(COLORS.yellow)
        amount_string = "+" .. amount_string
    end
    self:printOutline(amount_string, x, y)
    Draw.setColor(COLORS.white)
end

function notDiamonStore:update()
	self.animation_sine = self.animation_sine + DTMULT

    if self.background_alpha < 1 then
        self.background_alpha = self.background_alpha + (0.04 - (self.background_alpha / 14)) * DTMULT
    end

  	super.update(self)

	self.talktext_rand = love.math.random(1, 12)
	self.talktext = ({
		"making games is hard",
		"soooo how are you?",
		"the weathers not bad today",
		"are my items that ass",
		"buy smth please",
		"mama said id be rich in the future",
		"cmon i need this money",
		"do you have a super nintendo?",
		"brrrrrrrr"
	})[self.talktext_rand]

	self.shop_text = self.talktext

	self.talktext_rand = love.math.random(1, 4)
	self.ttalktext = ({
		"whats it gonna be",
		"if you want i can make a suggestion",
		"just buy already",
		"my items are amazing"
	})[self.talktext_rand]

	self.buy_menu_text = self.ttalktext
end

return notDiamonStore