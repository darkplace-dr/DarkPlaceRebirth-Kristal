local item, super = Class("light/halloween_pencil", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "HllwPencil"
    self.dark_name = "Hallow Pencil"

    self.price = 6
end

return item