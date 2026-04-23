local badge, super = Class(Badge, "cubeBadge")

function badge:init(mod)
    super.init(self)

    -- Display name
    self.name = "Quadrilateral"

    self.type = "badge"

    self.shop = "Adds something\nnever seen by\n2 Dimensional\nbeings."

    self.description = "Adds something never seen by 2 Dimensional beings."

    self.badge_points = 0

    self.price = 0
end

return badge