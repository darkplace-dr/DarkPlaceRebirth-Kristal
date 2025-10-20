local actor, super = Class(Actor, "noelle_dark_transition")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Noelle"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 46

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/noelle/dark_transition"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "run"
end

return actor