local item, super = Class(Item, "the_angles_bane")

function item:init()
    super.init(self)

    self.name = "THE ANGEL'S BANE"

    self.type = "weapon"

    self.icon = "ui/menu/icon/sword"

    self.effect = ""

    self.shop = ""

    self.description = "* Allan, Please add details."

    self.price = -10

    self.can_sell = false

    self.target = "none"

    self.usable_in = "all"

    self.result_item = nil

    self.instant = false

    self.bonuses = {
        attack = 10,
        magic = 10,
    }

    self.bonus_name = "Night"
    self.bonus_icon = "ui/menu/icon/up"

    self.can_equip = {
        suzy = true,
    }

    -- Character reactions
    self.reactions = {
        suzy = "YEAH!",
    }
end

function item:convertToLightEquip(chara)
    return "light/pencil"
    --return "light/giant_sword" --To Do: add giant sword
end

return item