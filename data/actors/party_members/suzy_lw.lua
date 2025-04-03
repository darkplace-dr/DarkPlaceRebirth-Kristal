local actor, super = Class(Actor, "suzy_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Suzy"

    self.width = 33
    self.height = 42

    self.hitbox = {5, 24, 19, 14}

    self.soul_offset = {15, 25}

    self.color = {1, 1, 1}

    self.path = "party/suzy/light"

    self.default = "walk"

    self.voice = "suzy"

    --self.portrait_path = "face/"

    self.portrait_offset = nil

    self.can_blush = false

    self.animations = {

    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    self.offsets = {
    }
end

return actor