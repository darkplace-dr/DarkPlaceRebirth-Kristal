local actor, super = Class(Actor, "satan")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "satan"

    -- Width and height for this actor, used to determine its center
    self.width = 32
    self.height = 46

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {20, 110, 65, 25}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/satan"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "dess"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/dess"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-12, -10}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {}

    self.offsets = {
        ["walk/down"] = {-4, 0},
        ["walk/right"] = {-4, 0},
        ["walk/left"] = {-4, 0},
        ["walk/up"] = {-4, 0},

    }

    -- Table of sprite offsets (indexed by sprite name)
end

return actor