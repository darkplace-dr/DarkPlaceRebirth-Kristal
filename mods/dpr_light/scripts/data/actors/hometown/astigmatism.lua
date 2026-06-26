local actor, super = Class(Actor, "astigmatism")

function actor:init()
    super.init(self)

    self.name = "Astigmatism"

    -- Width and height for this actor, used to determine its center
    self.width = 32
    self.height = 41

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, self.height/2, self.width-2, self.height/2}

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/hometown/astigmatism"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = ""

    self.animations = {}
end

return actor