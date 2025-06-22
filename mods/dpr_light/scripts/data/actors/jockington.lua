local actor, super = Class(Actor, "jockington")

function actor:init()
    super.init(self)

    self.name = "Jockington"

    self.width = 36
    self.height = 44

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "jockington"

    self.voice = nil
    self.portrait_path = "face/jockington"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {
        ["jockington"] = 0.25
    }

    self.animations = {}

    self.offsets = {}
end

return actor