local item, super = Class("light/holiday_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "HoliPencil"

    self.price = 8
end

return item