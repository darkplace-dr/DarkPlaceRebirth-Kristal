local actor, super = Class(Actor, "stranger")

function actor:init()
    super.init(self)

    self.name = "stranger"

    self.width = 37
    self.height = 89

    self.hitbox = {10, 80, 27, 4}
    self.flip = true

    self.path = "world/npcs/cliffside"

    self.default = "stranger"
end

return actor