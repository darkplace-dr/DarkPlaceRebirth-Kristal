local Diamond_Store, super = Class(Shop)



function Diamond_Store:init()
  local talktext_rand = love.math.random(1, 11)
  super.init(self)


self.talktext_rand = love.math.random(1, 11)
self.talktext = ({
    "[emote:talk]* I am a big person.[emote:idle]",
    "[emote:talk]* You are a little people.[emote:idle]",
    "[emote:talk]* I hate people.[emote:idle]",
    "[emote:talk]* Why are you here?[emote:idle]",
    "[emote:talk]* Why are you a person?[emote:idle]",
    "[emote:talk]* Do you do crime?[emote:idle]",
    "[emote:talk]* I hate super mario.[emote:idle]",
    "[emote:talk]* This is a story.[emote:idle]",
    "[emote:talk]* I am full of SQUAG.[emote:idle]",
    "[emote:talk]* You make me look like pain.[emote:idle]",
    "[emote:talk]* My crown is too epicness.[emote:idle]"
})[talktext_rand]  -- fallback: "Depa Runts"

  
  self.shop_music = nil
  
  self.shopkeeper:setActor("diamond_giant_shop")
  self.shopkeeper.talk_sprite = true
  self.shopkeeper.slide = true
  self.background = ("shopkeepers/diamond_giant/blink_1")
  
  self.encounter_text = "[emote:talk]* What'a ya buyin?[emote:idle]"


  self.shop_text = "[emote:talk]* Take your time.[emote:idle]"
  self.leaving_text = "[emote:talk]* Merry Christmas.[emote:idle]"
  self.buy_menu_text = "[emote:talk]* Picking?[emote:idle]"
  self.buy_confirmation_text = "* You want\nthis? (%s)"
  self.buy_refuse_text = "[emote:talk]* Well alrighty then.[emote:idle]"
  self.buy_text = "[emote:talk]* Take care of that.[emote:idle]"
  self.buy_storage_text = "[emote:talk]* Empty your pockets for once.[emote:idle]"
  self.buy_too_expensive_text = "[emote:talk]* I sadly can't give it away.[emote:idle]"
  self.buy_no_space_text = "[emote:talk]* You don't have any room![emote:idle]"
  self.sell_menu_text = "[emote:talk]* I am ready to spend.[emote:idle]"
  self.sell_no_price_text = "[emote:talk]* I don't know the value of that...[emote:idle]"
  self.sell_nothing_text = "[emote:talk]* Is that a PLACEBO?.[emote:idle]"
  self.sell_confirmation_text = "* You get %s\nin DARK cash."
  self.sell_refuse_text = "[emote:talk]* Why won't you sell?.[emote:idle]"
  self.sell_text = "[emote:talk]* I might consume this in the future.[emote:idle]"
  self.sell_no_storage_text = "[emote:talk]*Impossible[emote:idle]"

  self.talk_text = "[emote:talk]* What do you want?[emote:idle]"

  self.sell_options_text["items"]   = "[emote:talk]* I am gonna buy.[emote:idle]"
  self.sell_options_text["weapons"] = "[emote:talk]* I am gonna buy.[emote:idle]"
  self.sell_options_text["armors"]  = "[emote:talk]* I am gonna buy.[emote:idle]"
  self.sell_options_text["storage"] = "[emote:talk]* I am gonna buy.[emote:idle]"

  self:registerItem("tension_storage", {stock = 1})
  self:registerItem("tension_plus", {stock = 4})
  self:registerItem("friend_buster", {stock = 1})
  self:registerItem("bp_plus", {stock = 1})
  self:registerItem("tension_health", {stock = 1})
  
  self:registerTalk("Yourself")

  local quest = Game:getFlag("package_quest")
  if quest and quest == 1 then
    self:registerTalkAfter("Delivery?", 1)
  end
  --self:registerTalk("...")
  --self:registerTalk("...")
  --self:registerTalk("...")
end

function Diamond_Store:postInit()
    -- Mutate talks

    self:processReplacements()

    -- Make a sprite for the background
    if self.background and self.background ~= "" then
        self.background_sprite = SpaceBG()
        self.background_sprite.layer = SHOP_LAYERS["background"]
        self:addChild(self.background_sprite)
    end

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

function Diamond_Store:setDialogueText(text)
    if type(text) ~= "table" then
        text = {text}
    else
        text = TableUtils.copy(text)
    end
    for i,line in ipairs(text) do
		text[i] = "[color:#53fff7]"..line
	end
	super.setDialogueText(self, text)
end

function Diamond_Store:setRightText(text)
    self.right_text:setText(self:getVoicedText("[color:#53fff7]".. text))
end

function Diamond_Store:startTalk(talk)
--print(Game.inventory:removeItem("diamond_package"))
	if talk == "Yourself" then
            if Game.party[1].id == "jamm" then
                self:startDialogue({
                "[emote:talk_blink]* Wha-[emote:blink][wait:10] [emote:talk_huh]Jamm...[emote:huh]",
                "[emote:talk_look_left]* I've literally been here for the past [color:yellow]YEAR[color:white].[emote:look_left]",
                "[emote:talk_lookdown]* We've talked on multiple occasions.[emote:lookdown]",
                "[emote:talk_huh]* Pretend you don't know me agian and I'll knock your teeth out...[emote:huh]",
                })
            elseif Game.party[1].id == "brenda" then
                self:startDialogue({
                "[emote:talk_blink]* Brenda you already know me.[emote:blink]",
                "[emote:talk_look_left]* But, in case you forgot.[emote:look_left]",
                "[emote:talk_lookdown]* I live in Germany.[emote:lookdown]",
                })
            elseif Game.party[1].id == "bor" then
                self:startDialogue({
                "[emote:talk_blink]* I don't know.[emote:blink][wait:5][emote:talk_blink] Ask Bor.[emote:blink]",
                })
            else
                self:startDialogue({
                "[emote:talk_huh]* I sell shit.[emote:huh]",
                })
            end
	elseif talk == "Why are you sad?" then
        self:startDialogue({
            "[emote:talk]* Ask that again and nobody will find your body.[emote:idle]",
        })
	elseif talk == "Delivery?" then
        self:startDialogue({
            "[emote:talk]* Oh,[wait:5] thanks?[emote:idle]",
            "[emote:talk]* Um...[emote:idle]",
            "[emote:talk_huh]* You were not meant to deliver that. I sent a thing to do it.[emote:huh]",
            "[emote:talk]* Eh, it doesn't matter.[emote:idle]",
            "[emote:talk]* I'll put some money in your pockets for your troubles.[emote:idle]",
        })
            Game.inventory:removeItem("diamond_package")
            if Game.money < 2000 then
                Game.money = Game.money + 500
            else
                Game.money = Game.money + Game.money/4
            end
            Game:setFlag("package_quest", 2)
            Game:getQuest("a_special_delivery"):setProgress(1)
            self:registerTalkAfter("Yourself", 1)
            DP:completeAchievement("diamond")
	elseif talk == "..." then
        self:startDialogue({
            "[emote:talk]* ...[emote:idle]",
        })
	end
end


function Diamond_Store:drawTextureOutlined(texture, x, y, r, sx, sy, ox, oy, kx, ky)
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

function Diamond_Store:printOutline(text, x, y, r, sx, sy, ox, oy, kx, ky)
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

function Diamond_Store:drawMainMenu()
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
function Diamond_Store:drawBuyItems(draw_soul)
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
function Diamond_Store:drawPartyBonusInfo(box_y, item, item_options, box_x, box_w)
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
        love.graphics.print(bp_text, box_x + box_w - 32 - self.font:getWidth(bp_text), box_y + 20)
    end
end

function Diamond_Store:drawItemDisplay()
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

    if current_item.item.type == "armor" or current_item.item.type == "weapon" then
        self:drawPartyBonusInfo(top, current_item.item, current_item.options, left_width)
    end

    Draw.popScissor()
end

function Diamond_Store:drawOldStorageDisplay()
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

function Diamond_Store:drawStorageDisplay()
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

function Diamond_Store:drawBuyConfirm()
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
    local text_canvas = {}
    for i = 1, #lines do
        text_canvas[i] = Draw.pushCanvas(180, 32, { stencil = false })
        love.graphics.print(lines[i], 0, 0)
        Draw.popCanvas(true)
    end
    local col = ColorUtils.hexToRGB("#53FFF7FF")
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

function Diamond_Store:drawSellMenu()
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
function Diamond_Store:drawSellItems(confirming)
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

function Diamond_Store:drawSellConfirm()
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
    local text_canvas = {}
    for i = 1, #lines do
        text_canvas[i] = Draw.pushCanvas(180, 32, { stencil = false })
        love.graphics.print(lines[i], 0, 0)
        Draw.popCanvas(true)
    end
    local col = ColorUtils.hexToRGB("#53FFF7FF")
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

function Diamond_Store:drawTalkMenu()
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

function Diamond_Store:drawMoney()
    Draw.setColor(COLORS.white)
    love.graphics.setFont(self.font)
    self:printOutline(string.format(self.currency_text, self:getMoney()), 440, 420)
end

function Diamond_Store:drawBonuses(party_member, old_item, bonuses, stat, x, y)
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

function Diamond_Store:update()
  super.update(self)

self.talktext_rand = love.math.random(1, 12)
self.talktext = ({
    "[emote:talk]* I am a big person.[emote:idle]",
    "[emote:talk]* You are a little people.[emote:idle]",
    "[emote:talk]* I hate people.[emote:idle]",
    "[emote:talk]* Why are you here?[emote:idle]",
    "[emote:talk]* Why are you a person?[emote:idle]",
    "[emote:talk]* Do you do crime?[emote:idle]",
    "[emote:talk]* I hate super mario.[emote:idle]",
    "[emote:talk]* This is a story.[emote:idle]",
    "[emote:talk]* I am full of SQUAG.[emote:idle]",
    "[emote:talk]* You make me look like pain.[emote:idle]",
    "[emote:talk]* My crown is too epicness.[emote:idle]",
    "[emote:idle]* I have all day."
})[self.talktext_rand]  -- fallback: "Depa Runts"

  self.shop_text = self.talktext

self.talktext_rand = love.math.random(1, 4)
self.ttalktext = ({
    "[emote:talk]* Look at my wares.[emote:idle]",
    "[emote:talk]* Picking?[emote:idle]",
    "[emote:talk]* Pick an item any item![emote:idle]",
    "[emote:talk]* What you wanna buy?[emote:idle]"
})[self.talktext_rand]  -- fallback: "Depa Runts"

  self.buy_menu_text = self.ttalktext


end

return Diamond_Store