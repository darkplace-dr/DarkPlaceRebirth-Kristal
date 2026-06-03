local actor, super = Class(Actor, "rabbick_ow")

function actor:init()
    super.init(self)

    self.name = "Rabbick"

    self.width = 37
    self.height = 41

    self.hitbox = {3, 24, 24, 16}

    self.flip = "right"

    self.path = "enemies/rabbick"
    self.default = "overworld"

    self.animations = {
        ["overworld"] = {"overworld", 4/30, true}
    }

    self.offsets = {
        ["overworld"] = {0, 0},
    }
end

return actor