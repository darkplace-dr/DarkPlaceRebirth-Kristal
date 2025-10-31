local actor, super = Class(Actor, "gouldensam")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Goulden Sam"

    -- Width and height for this actor, used to determine its center
    self.width = 26
    self.height = 44


    self.hitbox = {0, self.height - 10, self.width, 10}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/gouldensam"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "talk_face"

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
    self.animations = {}

    self.talk_sprites = {
        ["talk_face"] = 0.15,
    }
end

return actor