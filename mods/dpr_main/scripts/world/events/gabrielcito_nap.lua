-- Extend the Event class, and set the ID to "pinwheel"
-- This is what you'll use to refer to the event in Tiled
local GabrielcitoNap, super = Class(Event, "gabrielcito_nap")

-- `data` is the data directly from Tiled
function GabrielcitoNap:init(data)
    -- Place the event at the correct position, and make the size 20x20
    super.init(self, data)

    -- Any custom properties are stored in `data.properties`, but we don't use any.

    -- Just some variables for the pinwheel
    self.min_speed = 2
    self.speed_slowdown = 0.5
    self.speed = self.min_speed
    self.pinwheel_rotation = 0

    -- Most events in DELTARUNE are 2x sized (not this one)
    self:setScale(1)

    -- We placed a single point in Tiled, which we want to be the bottom center of the pinwheel
    self:setOrigin(0.5, 1)
    self:setSprite("world/maps/floor2/darkjam_26/gabrielcito_nap", 1.4)
end

-- Update gets called every frame
function GabrielcitoNap:update()
    super.update(self)

    -- Make it rotate using the speed
    self.pinwheel_rotation = self.pinwheel_rotation + (self.speed * DTMULT)

    -- If it's going too fast, slow it down
    if self.speed > self.min_speed then
        self.speed = self.speed - self.speed_slowdown * DTMULT
    end

    -- Make sure it doesn't go below the minimum speed
    self.speed = math.max(self.speed, self.min_speed)
end

-- When we interact with the pinwheel, make it spin faster!
function GabrielcitoNap:onInteract()
    self.speed = 60
end

return GabrielcitoNap