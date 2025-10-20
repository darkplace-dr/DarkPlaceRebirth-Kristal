local id = "shadowguy_car"
local actor, super = Class(Actor, id)

function actor:init()
    super.init(self)
    self.name = "Shadowguy"

    -- Width and height for this actor, used to determine its center
    self.width = 95
    self.height = 75

	local xoffset = self.width * .25

    self.hitbox = {xoffset, 0, self.width - (xoffset * 2), self.height}

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