local actor, super = Class(Actor, "kris_cutout")

function actor:init()
    super.init(self)

    self.name = "Kris?"

    self.width = 19
    self.height = 37

    self.hitbox = {0, 25, 19, 14}

    self.color = {0, 1, 1}

    self.path = "world/npcs/kris_cutout"
	
    if Game:getFlag("fakeKrisKnockedOver") == true then
        self.default = "flat"
    else
        self.default = "idle"
    end

    -- Table of sprite animations
    self.animations = {
        ["idle"]               = {"idle", 4/30, true},
        ["flat"]               = {"flat", 4/30, true},
    }

    self.offsets = {
        -- Movement offsets
        ["idle"] = {0, 0},
        ["flat"] = {-9, 23},
    }
end

return actor