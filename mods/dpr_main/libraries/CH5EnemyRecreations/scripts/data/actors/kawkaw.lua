local actor, super = Class(Actor, "kawkaw")

function actor:init()
    super.init(self)

    self.name = "Kawkaw"

    self.width = 40
    self.height = 28

    self.hitbox = {7, 15, 29, 12}

    self.flip = "right"

    self.path = "battle/enemies/kawkaw"
    self.default = "idle"

    self.animations = {
        ["idle"]   = { "idle", 1 / 5, true },
        ["hurt"]   = { "hurt", 1, true },
        ["spared"] = { "bobhead", 1 / 5, true },
    }

    self.offsets = {
        ["hurt"]   = { 0, -3 },
        ["bobhead"] = { -2, -3 },
    }
end

return actor