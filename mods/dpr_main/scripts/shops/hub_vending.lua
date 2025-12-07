local GreenVending, super = Class(Shop)

function GreenVending:init()
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

    self:registerItem("dark_candy", {price = 40, description = "ITEM\nNot a badge,\nbut heals\n40HP"})
    self:registerItem("stellar_lens", {price = 150, description = "BADGE\nIncreases\nSTAR damage\nfor spells"})
    self:registerItem("less_ruder", {price = 350, description = "BADGE\nPaciBuster\ninto the\nPacify"})
    self:registerItem("jackpot_jab", {price = 800, description = "BADGE\nScaling\ndamage\nfor Hero"})
    
    self.hide_world = false
	self.bg_cover.visible = false
    self.menu_options = {
        {"Buy",  "BUYMENU"},
        {"Sell", "SELLMENU"},
        {"Check", "TALKMENU"},
        {"Exit", "LEAVE"}
    }
end

function GreenVending:postInit()
    super.postInit(self)
end

function GreenVending:onLeave()
    self:setState("LEAVING")
end

function GreenVending:onStateChange(old,new)
    Game.key_repeat = false
    self.buy_confirming = false
    self.sell_confirming = false
	if new == "SELLMENU" then
        self:startDialogue({"* (You wanted to sell something, but you've noticed that the shop on the left also can sell the items.)"}, "MAINMENU")
		return
	end
	if new == "TALKMENU" then
        self:startDialogue({"* (You CHECKed the vending machine.)[wait:5]\n* (It says: \"Don't forget, the TV Floor!\".)"}, "MAINMENU")
		return
	end
	super.onStateChange(self, old, self.state)
end

return GreenVending