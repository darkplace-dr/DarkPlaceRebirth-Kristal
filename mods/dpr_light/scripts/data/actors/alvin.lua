local actor, super = Class(Actor, "alvin")

function actor:init()
    super.init(self)

    self.name = "Alvin"

    -- Width and height for this actor, used to determine its center
    self.width = 25
    self.height = 47

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, self.height/2, self.width-2, self.height/2}

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "alvin_back"

    self.talk_sprites = {
        ["alvin"] = 0.25
    }

    self.offsets = {
        ["alvin_2"] = {0, 1}
    }
end

return actor