local actor, super = Class(Actor, "arlee")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "arlee"

    -- Width and height for this actor, used to determine its center
    self.width = 94
    self.height = 137

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {20, 110, 65, 25}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/arlee"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "arlee"
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
		["idle"]         = {"idle", 0.045, true},
        ["fight"]         = {"fight", 0.045, true},
        ["tpose"]         = {"tpose", 0.045, true},
        ["kick"]         = {"kick", 0.045, true},
        ["pose"]         = {"pose", 0.045, true},
	}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["pose"] = {20, 10},
    }
end

return actor