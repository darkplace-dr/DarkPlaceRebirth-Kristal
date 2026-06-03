local actor, super = Class(Actor, "rudinnranger")

function actor:init()
    super.init(self)

    self.name = "Rudinn Ranger"

    self.width = 35
    self.height = 40

    self.hitbox = {3, 24, 24, 16}

    self.flip = "right"

    self.path = "battle/enemies/rudinnranger"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"idle", 0.2, true},
        ["spared"] = {"spared", 0.2, true},
        ["hurt"] = {"hurt", 0, false},
    }
	
    self.talk_sprites = {
        [""] = 0.15
    }

    self.offsets = {
        ["hurt"] = {-5, -10},
    }
end

return actor