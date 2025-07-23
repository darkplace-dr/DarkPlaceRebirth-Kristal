local item, super = Class(Item, "cerobas_staff")

function item:init()
    super.init(self)

    self.name = "Ceroba's Staff"

    self.type = "weapon"
    self.icon = "ui/menu/icon/staff_c"

    self.effect = ""
    self.shop = ""
    self.description = "A powerful staff that has been transformed by\nthe dark to be even more powerful."

    self.price = 400
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 1,
        magic = 3,
    }

    self.can_equip = {
        ceroba = true,
    }

    self.reactions = {
        susie = "A stick with a ribbon? Seriously?",
        ralsei = "Not sure if I can use this...",
		dess = "not on my wizard shit rn srry",
        noel = "I want it, but I don't want to use it.",
        noelle = "*ding* I love the bell!",
        ceroba = "Back where it belongs.",
        jamm = "Nope, definitely not!"
    }
end

function item:convertToLightEquip(chara)
    return "light/cerobas_staff"
end

return item