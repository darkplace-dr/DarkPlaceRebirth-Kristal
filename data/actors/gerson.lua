local actor, super = Class(Actor, "gerson")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Gerson"

    -- Width and height for this actor, used to determine its center
    self.width = 62
    self.height = 60

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {30, 48, 15, 12}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {36, 42}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {101/255, 170/255, 38/255}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/gerson/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "gerson"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.1, true},

        ["battle/attack"]       = {"battle/attack", 0, false},
        ["battle/act"]          = {"battle/act", 0.1, true},
        ["battle/spell"]        = {"battle/spell", 0.05, false},
        ["battle/item"]         = {"battle/item", 0.1, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 0.1, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.1, true},
        ["battle/act_ready"]    = {"battle/actready", 0.1, true},
        ["battle/spell_ready"]  = {"battle/spellready", 0, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.1, true},
        ["battle/defend_ready"] = {"battle/defend", 0.05, false},

        ["battle/rude_buster"]  = {"battle/rude_buster", 1/15, false, next="battle/idle"},
        ["battle/act_end"]      = {"battle/act", 0.1, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 0.1, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 0.1, false},

        ["battle/transition"]   = {"battle/victory", 0.1, true},
        ["battle/intro"]        = {"battle/intro", 0.1, true},
        ["battle/victory"]      = {"battle/victory", 0.1, true},

        ["laugh"]           = {"laugh", 0.15, true},
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
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {12, 0},
        ["walk/up"] = {12, 0},
        ["walk/down"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-16, -34},
        ["battle/rude_buster"] = {-8, -40},
        ["battle/spell"] = {-14, -26},
        ["battle/attackready"] = {-16, -34},
        ["battle/act"] = {-10, -22},
        ["battle/actend"] = {-10, -22},
        ["battle/actready"] = {-10, -22},
        ["battle/item"] = {-10, -22},
        ["battle/itemready"] = {-10, -22},
        ["battle/defend"] = {6, -62},

        ["battle/defeat"] = {-8, -5},
        ["battle/hurt"] = {-10, -22},

        ["battle/intro"] = {10, -16},
        ["battle/victory"] = {-10, -22},

        -- Cutscene offsets
        ["laugh"] = {6, 0},
    }
	
	self.shiny_id = "gerson"
end

return actor