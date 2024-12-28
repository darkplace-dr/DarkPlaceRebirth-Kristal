local item, super = Class(Item, "swissblade")

function item:init()
    super.init(self)

    self.name = "SwissBlade"

    self.type = "weapon"
    self.icon = "ui/menu/icon/sword"

    self.effect = ""
    self.shop = "Don't mind my\nbite marks."
    self.description = "A utility blade made entirely out of Swiss cheese. Heals 1HP every turn."

    self.price = 250
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 1,
    }
    self.bonus_name = "Healing"
    self.bonus_icon = "ui/menu/icon/lollipop"

    self.turn_heal = 1

    self.can_equip = {
        kris = true,
        hero = true,
    }

    self.reactions = {
        susie = "Nah, Swiss cheese is a scam.",
        ralsei = "Um, I don't think you should eat this...",
        noelle = "Y-you're telling me a m-m-mouse had this?",
	    dess = "aint no fuckin WAY the swiss guard uses these",
        brenda = "Ew, Swiss cheese? Really?",
	    jamm = "A lot of holes... You sure it's effective?",
        noel = "",
    }
end

function item:convertToLightEquip(chara)
    return "light/pencil"
end

return item