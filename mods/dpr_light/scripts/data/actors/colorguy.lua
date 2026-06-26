local actor, super = Class(Actor, "colorguy")

function actor:init()
    super.init(self)

    self.name = "colorguy"

    -- Width and height for this actor, used to determine its center
    self.width = 21
    self.height = 50

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, self.height/2, self.width-2, self.height/2}

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/hometown/colorguy"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    self.talk_sprites = {
        ["talk"] = 0.15
    }

    self.animations = {
        ["talk"] = {"talk", 1/2, true}
    }
end

return actor