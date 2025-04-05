local actor, super = Class(Actor, "hero_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "HERO"

    -- Width and height for this actor, used to determine its center
    self.width = 28
    self.height = 36

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {5, 24, 19, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {15, 25}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/hero/light"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "hero"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/hero"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Cutscene animations
        ["sit"] = {"sit", 0.25, true},
    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["slide"] = {0, 0},

        -- Cutscene offsets
        ["fall"] = {-8, -2},

        ["fallen"] = {-8, 16},

        ["sit"] = {-4, -8},

        ["ghostwalk_lf"] = {-4, 3},
        ["ghostwalk_lu"] = {-4, 3},
        ["ghostwalk_rf"] = {-4, 3},
        ["ghostwalk_ru"] = {-4, 3},
    }
	
	self.shiny_id = "hero"
end

return actor