local item, super = Class("light/pencil", true)

function item:init()
    super.init(self)

    self.sell_price = 2
end

return item