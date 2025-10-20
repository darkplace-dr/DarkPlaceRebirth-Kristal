local actor, super = Class(Actor, "alphys")

function actor:init()
    super.init(self)

    self.name = "Alphys"

    self.width = 29
    self.height = 34

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs/alphys"
    self.default = "walk"

    self.voice = "alphys"
    self.portrait_path = "face/alphys"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {
        ["walk/down"] = 0.2,
        ["walk/right"] = 0.2,
        ["walk/left"] = 0.2,
        ["walk/up"] = 0.2
    }

    self.animations = {}

    self.offsets = {}
end

return actor