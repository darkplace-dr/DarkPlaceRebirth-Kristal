local MikeVending, super = Class(Shop)

function MikeVending:init()
    super.init(self)
    self.encounter_text = "* (It's a vending machine.)"
    self.shop_text = "* (It's a vending machine.)"
    self.leaving_text = ""
    self.buy_menu_text = "(Select\nan item.)"
    self.buy_confirmation_text = "Take it?"
    self.buy_refuse_text = "(Select\nan item.)"
    self.buy_text = "(Item\ntaken.)"
    self.buy_storage_text = "(Item\nplaced in\nSTORAGE.)"
    self.buy_too_expensive_text = "(Not\nenough\nspace.)"
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

    self:registerItem("wood_blade", {stock = 1, price = 0, description = "WEAPON\nHeroic type"})
    self:registerItem("mane_ax", {stock = 1, price = 0, description = "WEAPON\nDragon type"})
    self:registerItem("red_scarf", {stock = 1, price = 0, description = "WEAPON\nMagic type"})
    self:registerItem("frayedbowtie", {stock = 1, price = 0, description = "ARMOR\nLooks nice"})
    
    self.hide_world = false
	self.bg_cover.visible = false
    self.menu_options = {
        {"Borrow",  "BUYMENU"},
        {"Check", "TALKMENU"},
        {"Exit", "LEAVE"}
    }
end

function MikeVending:postInit()
    super.postInit(self)
end

function MikeVending:onLeave()
    self:setState("LEAVING")
end

function MikeVending:onStateChange(old,new)
    Game.key_repeat = false
    self.buy_confirming = false
    self.sell_confirming = false
	if new == "TALKMENU" then
        self:startDialogue({"* (You CHECKed the vending machine.)[wait:5]\n* (... an unknown, microphone-headed person is smiling on the back of it.)"}, "MAINMENU")
		return
    end
	super.onStateChange(self, old, self.state)
end

function MikeVending:drawBuyItems(draw_soul)
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
				love.graphics.print("FREE", 60 + 240, y)
            end
        end

        if draw_soul and (i == self.current_selected_item) then
            -- Draw the soul if we're selecting this option
            Draw.setColor(Game:getSoulColor())
            Draw.draw(self.heart_sprite, heart_pos, y + 10)
        end
    end
end

function MikeVending:drawBuyConfirm()
    Draw.setColor(Game:getSoulColor())
    Draw.draw(self.heart_sprite, 450, 320 + (self.current_selecting_choice * 30))

    Draw.setColor(COLORS.white)

    local lines = StringUtils.split(
        string.format(
            self.buy_confirmation_text,
            "FREE"
        ),
        "\n"
    )

    for i = 1, #lines do
        love.graphics.print(lines[i], 460, 420 - 160 + ((i - 1) * 30))
    end

    love.graphics.print("Yes", 480, 420 - 80)
    love.graphics.print("No", 480, 420 - 80 + 30)
end

return MikeVending