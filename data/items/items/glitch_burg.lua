local item, super = Class(HealItem, "glitch_burg")

function item:init()
    super.init(self)

    self.name = "GlitchBurg"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Heals\n50HP"
    self.shop = nil
    self.description = "Heals 50 HP. Does it exist though?"

    self.heal_amount = 50
    self.heal_amounts = {
        ["susie"] = 65,
        ["dess"] = 0,
    }

    self.price = 30
    self.can_sell = false

    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    self.reactions = {
        susie = "Hell yeah! I love eating air!!",
        dess = "mmm nothing im not eating nothing",
        jamm = "Don't know what I just ate but okay..."
    }
end

function item:onWorldUse(target)
	if target.id == "dess" then
		return false
    else
        return super.onWorldUse(self, target)
	end
end

return item
