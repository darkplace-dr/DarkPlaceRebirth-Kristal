local actor, super = Class(Actor, "napstablook")

function actor:init()
    super.init(self)

    self.name = "Napstablook"

    self.width = 17
    self.height = 37

    self.hitbox = {1, 19, 15, 18}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "world/npcs/napstablook"
    self.default = "walk"

    self.animations = {}

    self.offsets = {}
end

return actor