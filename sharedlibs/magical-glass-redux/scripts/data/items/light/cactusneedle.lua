local item, super = Class("light/cactusneedle", true)

function item:init()
    super.init(self)

    -- Display name
    self.short_name = "CactusNedle"

    self.price = 10
end

return item