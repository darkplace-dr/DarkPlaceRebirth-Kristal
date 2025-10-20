local actor, super = Class(Actor, "carol")

function actor:init()
    super.init(self)

    self.name = "Carol"

    self.width = 25
    self.height = 52

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs/carol"
    self.default = "walk"

    self.voice = "carol"
    self.portrait_path = "face/carol"
    self.portrait_offset = {-13, -8}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {}

    self.offsets = {}
end

return actor