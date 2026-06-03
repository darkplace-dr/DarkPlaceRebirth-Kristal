local item, super = Class("light/holiday_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "HoliPencil"

    self.sell_price = 4
end

return item