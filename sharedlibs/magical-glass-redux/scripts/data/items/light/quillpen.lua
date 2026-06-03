local item, super = Class("light/quillpen", true)

function item:init()
    super.init(self)

    self.sell_price = 5
end

return item