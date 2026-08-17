local LegacyVending, super = Class(Shop)

function LegacyVending:init()
    super.init(self)
    self.encounter_text = "* (It's a vending machine.)"
    self.shop_text = "* (It's a vending machine.)"
    self.leaving_text = ""
    self.buy_menu_text = "(Select\nan item.)"
    self.buy_confirmation_text = "Buy it for\n%s ?"
    self.buy_refuse_text = "(Select\nan item.)"
    self.buy_text = "(Item\nbought.)"
    self.buy_storage_text = "(Item\nplaced in\nSTORAGE.)"
    self.buy_too_expensive_text = "(Not\nenough\nmoney.)"
    self.buy_no_space_text = "(Not\nenough\nspace.)"
    self.sell_no_price_text = "(No value.)"
    self.sell_menu_text = "(Select an\nobject.)"
    self.sell_nothing_text = "(It won't\nfit.)"
    self.sell_confirmation_text = "Sell it for\n%s ?"
    self.sell_refuse_text = "(Select an\nobject.)"
    -- Shown when you sell something
    self.sell_text = "(Object sold.)"
    -- Shown when you have nothing in a storage
    self.sell_no_storage_text = "(Nothing\nto sell.)"
    -- Shown when you enter the talk menu.
    self.talk_text = ""

    self.sell_options_text = {}
    self.sell_options_text["items"]   = "(Select\nITEM\nto sell.)"
    self.sell_options_text["weapons"] = "(Select\nWEAPON\nto sell.)"
    self.sell_options_text["armors"]  = "(Select\nARMOR\nto sell.)"
    self.sell_options_text["storage"] = "(Select\nITEM\nto sell.)"

	self.shop_music = nil

    self:registerItem("tvslop", {price = 100})
    self:registerItem("tvslop", {price = 100})
    self:registerItem("tvslop", {price = 100})
    self:registerItem("dark_candy", {name = "FROWN", description = "Show\nsadness at\nthe state\nof this\nroom", price = 1})
    
    self.hide_world = false
	self.bg_cover.visible = false
    self.menu_options = {
        {"Buy",  "BUYMENU"},
        {"Sell", "SELLMENU"},
        {"Exchange", "TALKMENU"},
        {"Exit", "LEAVE"}
    }
end

function LegacyVending:postInit()
    super.postInit(self)
end

function LegacyVending:onLeave()
    self:setState("LEAVING")
end

function LegacyVending:onStateChange(old,new)
    Game.key_repeat = false
    self.buy_confirming = false
    self.sell_confirming = false
	if new == "TALKMENU" then
		self:setState("LEAVING")
		Game.world:startCutscene("tvfloor.legacy_vending_exchange")
		return
	elseif new == "DIALOGUE_FROWN" then
        self.dialogue_text.width = 598
        self:setRightText("")
        self.large_box.visible = false
        self.left_box.visible = true
        self.right_box.visible = true
        self.info_box.visible = false
    end
	super.onStateChange(self, old, self.state)
end

function LegacyVending:drawBuyItems(draw_soul)
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
            love.graphics.print("Exit", text_pos, y)
        elseif item == nil then
            -- If there's no item there, show empty slot
            Draw.setColor(COLORS.dkgray)
            love.graphics.print("--------", text_pos, y)
        elseif item.options["stock"] and (item.options["stock"] <= 0) then
            -- If we've depleted the stock, show a "sold out" message
            Draw.setColor(COLORS.gray)
            love.graphics.print("--SOLD OUT--", text_pos, y)
        else
            -- Valid item, show it
            Draw.setColor(item.options["color"])
            love.graphics.print(item.options["name"], text_pos, y)
            if not self.hide_price then
                Draw.setColor(COLORS.white)
				if item.options["name"] == "FROWN" then
					love.graphics.print("FREE", 60 + 240, y)
				else
					love.graphics.print(string.format(self.currency_text, item.options["price"] or 0), 60 + 240, y)
				end
            end
        end

        if draw_soul and (i == self.current_selected_item) then
            -- Draw the soul if we're selecting this option
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, heart_pos, y + 10)
        end
    end
end

function LegacyVending:drawStorageDisplay()
    local current_item = self.items[self.current_selected_item]

    if current_item == nil or current_item.options["name"] == "FROWN" then
        return
    end
	super.drawStorageDisplay(self)
end

function LegacyVending:buyItem(current_item)
	if current_item.options.name == "FROWN" then
		local frown_dialogue = "* It frowned."
		if (current_item.options["price"] or 0) > self:getMoney() then
			frown_dialogue = "* It still frowned."
		else
            self:removeMoney(current_item.options["price"] or 0)
		end
		self:setState("DIALOGUE_FROWN")
		self:setDialogueText(frown_dialogue)

		self.dialogue_text.advance_callback = (function()
			self:setState("MAINMENU", "DIALOGUE_FROWN")
		end)
	else
		super.buyItem(self, current_item)
	end
end

return LegacyVending