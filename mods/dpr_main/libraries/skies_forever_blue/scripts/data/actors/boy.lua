local actor, super = Class(Actor, "boy")

function actor:init()
    super.init(self)

    self.name = "boy"

    self.width = 16
    self.height = 16

    self.hitbox = {0.5, 7.5, 15, 8.5}

    self.soul_offset = {8, 8}

    self.color = {0, 0, 1}

    self.path = "party/boy"

    self.default = "walk"

    self.animations = {
        ["slide"]               = {"slide", 4/30, true},
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},
    }
end

return actor