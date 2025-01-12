local item, super = Class("light/mech_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "MechPencil"

    self.price = 8
end

return item