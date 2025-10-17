local actor, super = Class(Actor, "tenna_ec")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "DR:E!Tenna"

    -- Width and height for this actor, used to determine its center
    self.width = 55
    self.height = 76

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 50, 55, 20}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/tenna_ec"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "tenna_ec"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/tenna_ec"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-20, -5}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
        [""] = 0.2
    }

    -- Table of sprite animations
    self.animations = {}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {}
end

return actor