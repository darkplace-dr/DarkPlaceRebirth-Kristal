local item, super = Class(Item, "blackenedknife")

function item:init()
    super.init(self)

    self.name = "BlckndKnife"

    self.type = "weapon"
    self.icon = "ui/menu/icon/sword"

    self.effect = ""
    self.shop = ""
    self.description = "A darkened blade, black as night.\nChosen weapon of the Roaring Knight."

    self.price = nil
    self.can_sell = false

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = -10,
        defense = 15,
        magic = 55,
    }
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {
        dess = true,
    }

    self.reactions = {
        susie = "... I'm not touching that.",
        ralsei = "...",
        noelle = "(It... reminds me of...)",
	    dess = "aw yeah, evil villain time",
    }
end

function item:convertToLightEquip(chara)
    return "light/pencil"
end

return item