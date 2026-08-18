local badge, super = Class(Badge, "overworld_grazing")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "More Grazing"

    self.type = "badge"

    -- Menu description
    self.description = "Allows you to graze the overworld bullets.\nMay not have much use without other badges..."
    self.shop = "Graze in the\noverworld"
    -- The cost of putting it on
    self.badge_points = 2

    -- Default shop price (sell price is halved)
    self.price = 400
end

function badge:onBadgeEquipped()
    Game:setFlag("overworld_grazing", true)
end

function badge:onBadgeRemoved()
    Game:setFlag("overworld_grazing", false)
end

return badge