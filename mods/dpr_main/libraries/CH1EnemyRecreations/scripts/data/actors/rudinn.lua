local actor, super = Class(Actor, "rudinn")

function actor:init()
    super.init(self)

    self.name = "Rudinn"

    self.width = 35
    self.height = 40

    self.hitbox = {3, 24, 24, 16}

    self.flip = "right"

    self.path = "battle/enemies/rudinn"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"idle", 0.2, true},
        ["tired"] = {"tired", 0.2, true},
        ["spared"] = {"spared", 0.2, true},
        ["hurt"] = {"hurt", 0, false},

        ["overworld"] = {"overworld", 0.2, true},
    }
	
    self.talk_sprites = {
        [""] = 0.15
    }

    self.offsets = {
        ["hurt"] = {0, -7},
    }
end

return actor