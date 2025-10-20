local item, super = Class("light/quillpen", true)

function item:init()
    super.init(self)

    self.price = 10
end

return item