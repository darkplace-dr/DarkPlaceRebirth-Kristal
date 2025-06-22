local actor, super = Class(Actor, "catty")

function actor:init()
    super.init(self)

    self.name = "Catty"

    self.width = 36
    self.height = 43

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "catty"

    self.voice = nil
    self.portrait_path = "face/catty"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {
        ["catty"] = 0.25
    }

    self.animations = {}

    self.offsets = {}
end

return actor