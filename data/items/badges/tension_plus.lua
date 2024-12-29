local badge, super = Class(Badge, "tension_plus")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Tension Plus"

    self.type = "badge"

    -- Menu description
    self.description = "Increases maximum tension points stored."

    self.shop = "Have more\n TP"
    -- The cost of putting it on
    self.badge_points = 5

    -- Default shop price (sell price is halved)
    self.price = 1000
end

return badge