local actor, super = Class(Actor, "silver")

function actor:init()
    super.init(self)

    self.name = "Silver"

    self.width = 27
    self.height = 59

    self.hitbox = {-6, 39, 39, 20}

    self.color = {1, 1, 1}

    self.flip = nil

    self.path = "world/npcs/silver"
    self.default = "diagleft_down"

    self.voice = "silver"
    self.portrait_path = "face/silver"
    self.portrait_offset = {-29, -12}

    self.talk_sprites = {}

    self.animations = {
        ["diagleft_down"] = {"diagleft_down", 0.25, true},
        ["diagright_down"] = {"diagright_down", 0.25, true},
        ["diagright_up"] = {"diagright_up", 0.25, true},
    }

    self.offsets = {
        ["diagleft_down"] = {-13, 0},
        ["diagright_down"] = {-16, 0},
        ["diagright_up"] = {-16, 0},
    }
end

return actor