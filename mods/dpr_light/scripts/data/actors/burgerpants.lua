local actor, super = Class(Actor, "burgerpants")

function actor:init()
    super.init(self)

    self.name = "Pizzapants"

    self.width = 23
    self.height = 33

    self.hitbox = {5, 22, 19, 11}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "burgerpants_sit_phone"

    self.voice = nil
    self.portrait_path = "face/burgerpants"
    self.portrait_offset = {-11, -12}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {}

    self.offsets = {}
end

return actor