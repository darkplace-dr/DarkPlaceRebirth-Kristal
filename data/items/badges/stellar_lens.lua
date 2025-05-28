local badge, super = Class(Badge, "stellar_lens")

function badge:init()
    super.init(self)

    self.name = "Stellar Lens"

    self.type = "badge"

    self.description = "Increases the effectiveness of STAR Element spells by 20%."

    self.badge_points = 1

    self.price = 180
end

return badge