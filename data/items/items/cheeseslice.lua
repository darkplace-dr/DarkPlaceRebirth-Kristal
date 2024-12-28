local item, super = Class(HealItem, "cheeseslice")

function item:init()
    super.init(self)

    self.name = "CheeseSlice"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Heals\n50HP"
    self.shop = "A classic\nslice of\ncheese!\nHeals 50HP"
    self.description = "Heals 50 HP. A slice of American-style cheese."

    self.heal_amount = 50

    self.price = 50
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
        susie = "Eh, better than nothing.",
        ralsei = "Tastes... okay...?",
        noelle = "It barely tastes like real cheese...",
        dess = "HELL YEAH AN AMERICAN CLASSIC!!!!",
        brenda = "The perfect midnight snack.",
        jamm = "Can't go wrong with a chunk of swiss.",
    }
	self.rdReactions = Utils.copy(self.reactions)
	-- I was about to write her calling it America's biggest disgrace but like...
	-- she would be the kind of person who would honor it in its ease of use
	-- so american cheese is spared for today
	self.rdReactions["dess"] = "America's duty."
end

return item