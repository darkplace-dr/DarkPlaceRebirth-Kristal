local item, super = Class(LightEquipItem, "light/_nothing_armor")

function item:init()
    super.init(self)

    self.name = "Nothing"
    self.short_name = "Nothing"

    self.type = "armor"
    self.light = true

    self.price = nil
    self.can_sell = false

    self.description = "The lack of an armor."

    self.check = "* But you don't have anything to check."

    self.usable_in = "none"
end

function item:showEquipText()
    Game.world:showText("* Somehow, you equipped "..self:getName()..".")
end

return item