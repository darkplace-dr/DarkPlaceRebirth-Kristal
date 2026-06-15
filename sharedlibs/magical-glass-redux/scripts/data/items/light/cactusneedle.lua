local item, super = Class("light/cactusneedle", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "CactusNedle"

    self.sell_price = 7
end

return item