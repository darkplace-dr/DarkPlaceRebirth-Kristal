local item, super = Class("light/mech_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "MechPencil"

    self.sell_price = 4
end

return item