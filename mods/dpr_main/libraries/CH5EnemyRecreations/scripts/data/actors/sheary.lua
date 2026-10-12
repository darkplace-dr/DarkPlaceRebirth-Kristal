local actor, super = Class(Actor, "sheary")

function actor:init()
    super.init(self)

    self.name = "Sheary"

    self.width = 46
    self.height = 51

    self.hitbox = {3, 11, 41, 40}

    self.flip = "right"

    self.path = "battle/enemies/sheary"
    self.default = "idle"

    self.animations = {
        ["idle"] = { "idle", 1 / (30 * 0.16666666666666666), true },
        ["hurt"] = { "idle_1", 1, true },
    }
end

return actor