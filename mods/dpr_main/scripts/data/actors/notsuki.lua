local actor, super = Class(Actor, "notsuki")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Notsuki"

    -- Width and height for this actor, used to determine its center
    self.width = 19
    self.height = 43

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, 23, 17, 20}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "notsuki"

    -- Sound to play when this actor speaks (optional)
    self.voice = "nostuki"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        ["notsuki"] = {"nostuki", 0.33, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["notsuki"] = {0, 0},
    }
end

function actor:onTextSound()
    -- Play the sound at 40% volume, 100% pitch, preventing overlap with the last time.
    Assets.stopAndPlaySound("voice/nostuki", .4, 1)
end

return actor