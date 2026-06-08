local item, super = Class(Item, "life_odometer")

function item:init()
    super.init(self)

    self.name = "LifeOdometer"

    self.type = "armor"
    self.icon = "ui/menu/icon/armor"

    self.effect = ""
    self.shop = ""
    self.description = "A sort-of magical odometer device.\nMakes your HP 'roll' when it changes value."

    self.price = 500
    self.can_sell = true

    self.target = "none"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {
        defense = 3,
    }
    self.bonus_name = "RollingHP"
    self.bonus_icon = "ui/menu/icon/up"

    self.can_equip = {
    }

    -- Character reactions
    self.reactions = {
		ddelta = "how the hey does it work? dunno",
    }
end

return item