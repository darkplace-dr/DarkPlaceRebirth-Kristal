local badge, super = Class(Badge, "speedbadge")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "SpeedUp"

    self.type = "badge"

    -- Menu description
    self.description = "Move faster in battles."

    -- The cost of putting it on
    self.badge_points = 1

    function badge:update(equipped)
    if equipped then
        Game:setFlag("speed_up", true)
    end
    if not equipped then
        Game:setFlag("speed_up", false)
    end
end

    -- Default shop price (sell price is halved)
    self.price = 100
end

return badge