local actor, super = Class(Actor, "rudy")

function actor:init()
    super.init(self)

    self.name = "Rudy"

    self.width = 22
    self.height = 60

    self.hitbox = {0, 0, 22, 60}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "world/npcs/rudy"
    self.default = "d"

    self.voice = "rudy"
    self.portrait_path = "face/rudy"
    self.portrait_offset = {-19, -20}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["cough"] = {"cough", 1/8, true},
        ["laugh"] = {"laugh", 1/8, true},
    }

    self.offsets = {}
end

return actor