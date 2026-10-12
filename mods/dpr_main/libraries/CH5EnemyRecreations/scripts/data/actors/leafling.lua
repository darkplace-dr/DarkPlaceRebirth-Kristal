local actor, super = Class(Actor, "leafling")

function actor:init()
    super.init(self)

    self.name = "Leafling"

    self.width = 34
    self.height = 36

    self.hitbox = {7, 15, 29, 12}

    self.flip = "right"

    self.path = "battle/enemies/leafling"
    self.default = "idle"

    self.animations = {
        ["idle"]   = {"idle_b", 1 / 5, true},
        ["hurt"]   = {"hurt", 1, true},
        ["spared"] = {"spare_b", 1 / 5, true},
    }
end

return actor