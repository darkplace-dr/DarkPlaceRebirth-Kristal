local actor, super = Class(Actor, "bratty")

function actor:init()
    super.init(self)

    self.name = "Bratty"

    self.width = 33
    self.height = 51

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "bratty"

    self.voice = nil
    self.portrait_path = "face/bratty"
    self.portrait_offset = {-5, 4}

    self.can_blush = false

    self.talk_sprites = {
        ["bratty"] = 0.25
    }

    self.animations = {}

    self.offsets = {}
end

return actor