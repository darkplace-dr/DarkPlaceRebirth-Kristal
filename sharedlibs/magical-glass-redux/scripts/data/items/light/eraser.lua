local item, super = Class("light/eraser", true)

function item:init()
    super.init(self)

    self.price = 5
end

return item