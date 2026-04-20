local actor, super = Class(Actor, "arlee")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "arlee"

    -- Width and height for this actor, used to determine its center
    self.width = 96
    self.height = 128

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {16, 96, 64, 32}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/arlee"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "talk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "arlee"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
        ["talk"] = 0.15,
        ["talkshy"] = 0.15
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["pose"] = {20, 10},
    }
end

return actor