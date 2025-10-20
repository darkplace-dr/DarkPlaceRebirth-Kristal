local actor, super = Class(Actor, "jamm_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Jamm"

    -- Width and height for this actor, used to determine its center
    self.width = 19
    self.height = 38

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {4, 28, 13, 10}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/jamm/light"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "jamm"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/jamm"
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

        ["walk_church/left"] = {0, 0},
        ["walk_church/right"] = {0, 0},
        ["walk_church/up"] = {0, 0},
        ["walk_church/down"] = {0, 0},

        ["walk_shadowed/left"] = {0, 0},
        ["walk_shadowed/right"] = {0, 0},
        ["walk_shadowed/up"] = {0, 0},
        ["walk_shadowed/down"] = {0, 0},

        ["slide"] = {0, 0},
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",

        ["walk_church/down"] = "light_church/up",
        ["walk_church/up"] = "light_church/down",
        ["walk_church/left"] = "light_church/left",
        ["walk_church/right"] = "light_church/right",

        ["walk_shadowed/down"] = "walk_shadowed/up",
        ["walk_shadowed/up"] = "walk_shadowed/down",
        ["walk_shadowed/left"] = "walk_shadowed/left",
        ["walk_shadowed/right"] = "walk_shadowed/right",
    }

	self.shiny_id = "jamm"
end

function actor:getDefault()
    if Game:getFlag("dungeonkiller") then
        return "walk_shadowed"
    end
    return self.default
end

return actor