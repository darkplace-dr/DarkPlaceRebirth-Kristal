local item, super = Class(LightEquipItem, "light/dusty_axe")

function item:init()
    super.init(self)

    self.name = "Dusty Axe"
    self.short_name = "DustyAxe"

    self.type = "weapon"
    self.light = true

    self.description = "An axe stained with the dust of Monsters. Also lowers defense."

    self.check = "Weapon 15 AT -4 DF\n* An axe stained with the dust of Monsters. Also lowers defense."

    self.usable_in = "all"

    self.price = nil
    self.can_sell = false

    self.bonuses = {
        attack = 15,
        defense = -4
    }

    self.equipable = {
        susie = true
    }

    self.dark_item = "berserkeraxe"
end

return item