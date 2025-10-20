local actor, super = Class(Actor, "diamond_giant_shop")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Diamond"
    self.voice = nil
    -- Width and height for this actor, used to determine its center
    self.width = 164
    self.height = 202

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 0, 164, 202}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = 0

    -- Path to this actor's sprites (defaults to "")
    self.path = "shopkeepers/diamond_giant"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Table of sprite animations
    self.animations = {
        ["idle"]               = {"blink_1", 4/1, false, next="blink"},
        ["blink"]         = {"blink", 1/6, false, next="idle"},
        ["talk"]         = {"talk", 1/6, true},
    }
    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["idle"] = {0, 130},
        ["blink"] = {0, 130},
        ["talk"] = {0, 130},
        ["talk_3"] = {0, 130},
        ["huh"] = {0, 130},
        ["lookdown"] = {0, 130},
        ["look_left"] = {0, 130},
    }
end
return actor