local item, super = Class(Item, "k_blade")

function item:init()
    super.init(self)

    self.name = "K. Blade"

    self.type = "weapon"
    self.icon = "ui/menu/icon/katana"

    self.effect = ""
    self.shop = ""
    self.description = "The Ketsukanes Blade. Seen better days,\nbut is still very practical to this day."

    self.price = 640
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 5,
    }

    self.can_equip = {
        kris = true,
        hero = true,
        ceroba = true,
    }

    self.reactions = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "not on my ninja shit rn srry",
        noel = "",
        ceroba = "",
        jamm = ""
    }
end

function item:convertToLightEquip(chara)
    return "light/cerobas_staff"
end

return item