local ATMVending, super = Class(Shop)

function ATMVending:init()
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

    self.hide_world = false
	self.bg_cover.visible = false
    self.menu_options = {
        {"Exchange",  "BUYMENU"},
        {"Exit", "LEAVE"}
    }
end

function ATMVending:postInit()
    super.postInit(self)
end

function ATMVending:onLeave()
    self:setState("LEAVING")
end

function ATMVending:onStateChange(old,new)
    Game.key_repeat = false
    self.buy_confirming = false
    self.sell_confirming = false
	if new == "BUYMENU" then
		self:setState("LEAVING")
		Game.world:startCutscene("tvfloor.atm_vending_exchange")
		return
	end
	super.onStateChange(self, old, self.state)
end

function ATMVending:draw()
    if self.state ~= "MAINMENU" then
		super.draw(self)
	else
		-- Don't draw money
		self:drawBackground()
		super.super.draw(self)
		love.graphics.setFont(self.font)
        Draw.setColor(COLORS.white)
        for i = 1, #self.menu_options do
            love.graphics.print(self.menu_options[i][1], 480, 220 + (i * 40))
        end
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 450, 230 + (self.main_current_selecting * 40))
		Draw.setColor(0, 0, 0, self.fade_alpha)
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	end
end

return ATMVending