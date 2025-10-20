local actor, super = Class(Actor, "machine")

function actor:init()
    super.init(self)

    self.name = "machine"

    self.width = 40
    self.height = 62

    --self.hitbox = {0, 1, 37, 29}

    self.flip = "right"

    self.path = "world/npcs/machine"
    self.default = "off"

    self.animations = {
        ["off"] = {"off", 0.1, true},
        ["on"] = {"on", 0.1, true},
        ["down"] = {"down", 0.1, true},
        ["left"] = {"left", 0.1, true},
        ["right"] = {"right", 0.1, true},
        ["up"] = {"up", 0.1, true},
        ["won"] = {"won", 0.1, true},
        ["lost"] = {"lost", 0.1, true}
    }

    self.offsets = {
        ["off"] = {0, 0},
        ["on"] = {0, 0},
        ["down"] = {0, 0},
        ["left"] = {0, 0},
        ["right"] = {0, 0},
        ["up"] = {0, 0},
        ["won"] = {0, 0},
        ["lost"] = {0, 0},
    }
end

return actor