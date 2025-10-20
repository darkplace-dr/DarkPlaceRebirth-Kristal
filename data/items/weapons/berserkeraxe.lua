local item, super = Class(Item, "berserkeraxe")

function item:init()
    super.init(self)

    self.name = "BerserkerAxe"

    self.type = "weapon"
    self.icon = "ui/menu/icon/axe"

    self.effect = ""
    self.shop = ""
    self.description = "An axe stained from combat. Lowers defense,\nbut critical hits will deal double damage."

    self.price = nil
    self.can_sell = false

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 10,
        defense = -5
    }
    self.bonus_name = "Berserk Crits"
    self.bonus_icon = "ui/menu/icon/angry"

    self.can_equip = {
        susie = true
    }

    self.reactions = {
        susie = {
            susie = "...",
            brenda = "(Is she doing okay...?)"
        },
        ralsei = "Is that... blood on it?",
        noelle = "E-EEK!! TH-THERE'S BLOOD ON IT!",
	    dess = "do i look like a viking to you",
        brenda = "Uh... no.",
        jamm = "I don't feel comfortable with this...",
        ceroba = "(Who's blood is that...?)",
        noel = "Reckless, and soon rusted...",
    }
end

return item
