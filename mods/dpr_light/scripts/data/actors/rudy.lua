local actor, super = Class(Actor, "rudy")

function actor:init()
    super.init(self)

    self.name = "Rudy"

    self.width = 22
    self.height = 60

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs/alphys"
    self.default = "d"

    self.voice = "rudy"
    self.portrait_path = "face/rudy"
    self.portrait_offset = {-19, -20}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {}

    self.offsets = {}
end

return actor