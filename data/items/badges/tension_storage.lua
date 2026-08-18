local badge, super = Class(Badge, "tension_storage")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Keep Tension"

    self.type = "badge"

    -- Menu description
    self.description = "Keep your tension, to cast spells in the overworld."
    self.shop = "Keeps tension\nafter battle"
    -- The cost of putting it on
    self.badge_points = 4

    -- Default shop price (sell price is halved)
    self.price = 830
end

function Badge:onBadgeEquipped()
    Game:setFlag("tension_storage", true)
    Game.world.tension_bar:show()
end

function Badge:onBadgeRemoved()
    Game:setFlag("tension_storage", false)
    Game.world.tension_bar:hide()
    Game:setTension(0)
end

return badge