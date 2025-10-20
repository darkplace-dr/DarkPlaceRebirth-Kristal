local actor, super = Class(Actor, "pebblin")

function actor:init()
    super.init(self)

    self.name = "Pebblin"

    self.width = 50
    self.height = 45

    self.hitbox = {0, 25, 19, 14}

    self.color = {1, 0, 0}

    self.flip = "right"

    self.path = "battle/enemies/pebblin"
    self.default = "idle"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"idle", 0.175, true},
        ["hurt"] = {"hurt", 0, false},
    }

    self.offsets = {
        ["idle"] = {0, 0},
        ["hurt"] = {0, 0},
    }
end

return actor