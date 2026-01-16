local actor, super = Class(Actor, "titan_spawn")

function actor:init()
    super.init(self)

    self.name = "Titan Spawn"

    self.width = 40
    self.height = 46
	
    self.hitbox = {0, 0, self.width, self.height}

    self.flip = "right"

    self.path = "battle/enemies/titanspawn"
    self.default = "idle"

    self.animations = {
	    ["idle"] = {"idle", 0.2, true},
        ["hurt"] = {"hurt", 1, false},
    }

    self.offsets = {
        ["idle"]  = {0, 0},
        ["hurt"]  = {0, 0},
    }
end

return actor