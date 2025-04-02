local badge, super = Class(Badge, "double_pain")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Double Pain"

    self.type = "badge"

    -- Menu description
    self.description = "Doubles the damage you take.\nNo upside."

    -- The cost of putting it on
    self.badge_points = 0

    -- Default shop price (sell price is halved)
    self.price = 30
end

return badge