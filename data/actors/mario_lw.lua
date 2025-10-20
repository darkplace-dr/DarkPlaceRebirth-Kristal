local actor, super = Class(Actor, "mario_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "SMG4 Mario"

    self.walk_anim_speed = 3

    -- Width and height for this actor, used to determine its center
    self.width = 16
    self.height = 32

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, 23, 14, 9}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/mario/light"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "mario"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/mario"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-19,-3}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["slide"] = {6, 2},
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }
	
	self.taunt_sprites = {"pose_ready", "pose_star", "pose_t"}

        -- Walk Speed (optional)
        self.walk_speed_override = 16

    self.menu_anim = "pose_star"
	
	self.shiny_id = "mario"
end

return actor