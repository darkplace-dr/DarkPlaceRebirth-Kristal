local CarTurner, super = Class(Event)

function CarTurner:init(data)
    super.init(self, data)

    local pr = data.properties

    -- The direction cars that hit this turner will start moving (defaults to `"right"`)
    self.walkdir = pr["walkdir"] or "right"
    -- Whether to use the unused "speedadjust" mechanism, slowing down the car while close to the player (defaults to `false`)
    self.speedadjust = pr["speedadjust"] or false
    -- The minimum speed of the car in speedadjust mode (defaults to `10`)
    self.speedadjust_min = pr["speedadjust_min"] or 10
    -- The maximum/normal speed of the car in speedadjust mode (defaults to `24`)
    self.speedadjust_max = pr["speedadjust_max"] or 24
    -- The proximity between the player and the car when speedadjust mode should start (defaults to `200`)
    self.speedadjust_proximity = pr["speedadjust_proximity"] or 200
    -- The divisor of the character distance used to determine the car's speed in speedadjust mode (defaults to `16`)
    self.speedadjust_divisor = pr["speedadjust_divisor"] or 16
end

return CarTurner