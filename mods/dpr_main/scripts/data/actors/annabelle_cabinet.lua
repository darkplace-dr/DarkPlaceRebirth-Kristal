local actor, super = Class(Actor, "annabelle_cabinet")

function actor:init()
    super.init(self)

    self.name = "machine"

    self.width = 40
    self.height = 62

    --self.hitbox = {0, 1, 37, 29}

    self.flip = "right"

    self.path = "annabelle_cabinet"
    self.default = ""

    self.animations = {
        [""] = {"", 0.1, true},
    }

    self.offsets = {
        [""] = {0, 0},
    }
end

return actor