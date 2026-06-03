local actor, super = Class(Actor, "jigsaw_joe")

function actor:init()
    super.init(self)

    self.name = "Jigsaw Joe"

    self.width = 34
    self.height = 30

    self.hitbox = {0, 15, self.width, 15}

    self.flip = nil

    self.path = "world/npcs/jigsaw_joe"
    self.default = "idle"

    self.talk_sprites = {
        ["idle"] = 1/(30 * 1/6),
    }

    self.animations = {
        ["shock"]   = {"shock1", 1/(30 * 1/6), true},
        ["shocked"] = {"shock2", 1/(30 * 1/6), true},
    }

    self.offsets = {
        ["shock1"] = {-1, -1},
        ["shock2"] = {-1, -1}
    }
end

return actor