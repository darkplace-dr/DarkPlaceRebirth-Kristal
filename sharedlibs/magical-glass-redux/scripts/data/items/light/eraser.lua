local item, super = Class("light/eraser", true)

function item:init()
    super.init(self)

    self.sell_price = 3
end

return item