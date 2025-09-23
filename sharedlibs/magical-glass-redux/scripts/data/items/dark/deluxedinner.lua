local item, super = Class("deluxedinner", true)

function item:init()
    super.init(self)

    self.short_name = "DeluxDiner"
end

return item