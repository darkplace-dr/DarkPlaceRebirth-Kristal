local item, super = Class(Item, "monocannon")

function item:init()
    super.init(self)

    self.name = "MonoCannon"

    self.type = "weapon"
    self.icon = "ui/menu/icon/gun"

    self.effect = ""
    self.shop = ""
    self.description = "A monochromatic gun made from Cliffside's stone.\nOnly increases defense."

    self.price = 300
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        attack = 0,
        defense = 2,
    }
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {
        brenda = true,
        pauling = true,
    }

    self.reactions = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        brenda = "",
        jamm = "First time I've ever seen a gun made from stone.",
        ceroba = "How.", -- Axis reference
    }
end

function item:convertToLightEquip(inventory)
    return "light/foam_dart_rifle" -- Placeholder
end

return item
