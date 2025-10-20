local actor, super = Class(Actor, "undyne")

function actor:init()
    super.init(self)

    self.name = "Undyne"

    self.width = 29
    self.height = 53

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs/undyne"
    self.default = "talk"

    self.voice = "undyne"
    self.portrait_path = "face/undyne"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {
        ["talk/down"] = 0.2,
        ["talk/right"] = 0.2,
        ["talk/left"] = 0.2,
        ["talk/up"] = 0.2
    }

    self.animations = {}

    self.offsets = {}
end

return actor