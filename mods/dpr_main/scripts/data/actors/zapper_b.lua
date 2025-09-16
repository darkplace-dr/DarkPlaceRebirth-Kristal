local actor, super = Class(Actor, "zapper_b")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Zapper"

    -- Width and height for this actor, used to determine its center
    self.width = 49
    self.height = 98

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 0, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "battle/enemies/zapper"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
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
        ["idle"] = {"jump", 1/6, true},
        ["hurt"] = {"hurt", 0.2, true},
        ["spared"] = {"spare", 1/3, true},
        ["cannon"] = {"cannon", 1/3, false},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["jump"] = {0, 0},
        ["hurt"] = {0, 30},
        ["spare"] = {0, 30},
        ["cannon"] = {0, 30},
	}
end

return actor