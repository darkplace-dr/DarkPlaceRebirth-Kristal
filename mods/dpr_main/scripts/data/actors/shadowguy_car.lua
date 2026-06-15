local actor, super = Class(Actor, "shadowguy_car")

function actor:init()
    super.init(self)
    self.name = "Shadowguy Band"

    -- Width and height for this actor, used to determine its center
    self.width = 95
    self.height = 75

    self.hitbox = {0, 0, 95, 75}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/shadowguy"
    self.default = "car"

    self.animations = {
        ["car"] = {"car", 0.15, true},
	}	

    self.offsets = {
        ["car"] = {-5, -1},
	}
end

return actor