local item, super = Class(HealItem, "rock_candy")

function item:init()
    super.init(self)

    self.name = "Rock Candy"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Heals\n25HP"
    self.shop = nil
    self.description = "Heals 25 HP. A rock coated with sugar.\nDefinitly has some crunch to it."

    self.heal_amount = 25
    self.heal_amounts = {
        ["susie"] = 90,
        ["dess"] = 50,
        ["ceroba"] = nil,
    }

    self.price = 35
    self.can_sell = true

    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    self.reactions = {
        susie = "Hell yeah! My favorite!!",
        ralsei = "Um, I guess I can lick off the sugar?",
        noelle = "O-OW! I th-think I chipped a tooth...",
        hero = "Better than nothing.",
        dess = "mmm yummy rocks",
        ceroba = "That's. A rock.",
    }
end

function item:onWorldUse(target)
	if target.id == "ceroba" then
		return false
    else
        return super.onWorldUse(self, target)
	end
end

return item