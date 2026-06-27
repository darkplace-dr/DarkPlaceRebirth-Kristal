local actor, super = Class(Actor, "floradinn")

function actor:init()
    super.init(self)

    self.name = "Floradinn"

    self.width = 34
    self.height = 35

    self.hitbox = {3, 24, 24, 16}

    self.flip = "right"

    self.path = "battle/enemies/floradinn"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"hidden", 0.2, true},
        ["mane"] = {"hidden", 0.2, true},
        ["hurt"] = {"hurt", 0.2, true},
        ["spared"] = {"spared", 0.2, true},
        ["overworld"] = {"idle", 0.2, true},
        ["alerted"] = {"idle", 0, true},
        ["chasing"] = {"idle", 0.1, true}
    }
	
    self.parts = {
        ["head"] = {"head"},
        ["body"] = {"body"},
        ["spikes"] = {"spikes"},
        ["spikes_return"] = {"spikes_return"}
    }
end

function actor:createSprite()
    return FloradinnActor(self)
end

return actor