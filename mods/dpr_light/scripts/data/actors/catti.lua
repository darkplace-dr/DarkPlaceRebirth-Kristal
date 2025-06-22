local actor, super = Class(Actor, "catti")

function actor:init()
    super.init(self)

    self.name = "Catti"

    self.width = 31
    self.height = 44

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "cattiwaitress"

    self.voice = nil
    self.portrait_path = "face/catti"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {}

    self.offsets = {}
end

return actor