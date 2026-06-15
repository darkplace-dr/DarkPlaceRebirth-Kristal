local badge, super = Class(Badge, "thermometer")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Thermometer"

    self.type = "badge"

    -- Menu description
    self.description = "Displays the current temperature in battle.\nToggle between C & F in the settings."

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 300
end

return badge