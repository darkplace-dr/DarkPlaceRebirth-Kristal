local item, super = Class("light/lucky_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "LuckPencil"

    self.price = 10
end

return item