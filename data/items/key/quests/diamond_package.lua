local item, super = Class(Item, "diamond_package")

function item:init()
    super.init(self)

    self.name = "DimondPack"
    self.use_name = nil

    self.type = "key"
    self.icon = nil

    self.effect = ""

    self.shop = ""

    self.description = "* A package built out of solid diamond."
    self.price = 0
    self.can_sell = false
    self.target = "none"
    self.usable_in = "world"
    self.result_item = nil
    self.instant = false
    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil
    self.can_equip = {}
    self.reactions = {}
end

function item:onWorldUse()
    Game.world:showText({
        "* You tried to open the package,[wait:5] but...",
        "* ...[wait:5]nothing happened.",
        "* You would need to be some kind of giant to open this thing."
     })
end

return item