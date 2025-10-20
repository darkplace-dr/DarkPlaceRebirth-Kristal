local actor, super = Class(Actor, "bor")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Bor"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 18

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {3, 9, 17, 9}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 0, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/bor/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "bor"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/bor"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-18,-2}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["fall"]               = {"fall", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/15, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/attack", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/item", 1/15, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/spare", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 1/15, false},
        ["battle/act_ready"]    = {"battle/actready", 1/15, false},
        ["battle/spell_ready"]  = {"battle/attackready", 1/15, false},
        ["battle/item_ready"]   = {"battle/itemready", 1/15, false},
        ["battle/defend_ready"] = {"battle/defend", 0.05, false},

        ["battle/act_end"]      = {"battle/idle", 1/15, false, next="battle/idle"},
        ["battle/spell_end"]      = {"battle/idle", 1/15, false, next="battle/idle"},

        ["battle/rude_buster"]  = {"battle/attackready", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"battle/idle", 0.2, true},
        ["battle/intro"]        = {"battle/intro", 0.05, true},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["jump_ball"]           = {"ball", 1/15, true},
    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",

        ["walk_unhappy/down"] = "walk_unhappy/up",
        ["walk_unhappy/up"] = "walk_unhappy/down",
        ["walk_unhappy/left"] = "walk_unhappy/left",
        ["walk_unhappy/right"] = "walk_unhappy/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["walk_unhappy/down"] = {0, 0},
        ["walk_unhappy/left"] = {0, 0},
        ["walk_unhappy/right"] = {0, 0},
        ["walk_unhappy/up"] = {0, 0},

        ["walk_blush/down"] = {0, 0},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-4, -25},
        ["battle/attackready"] = {-4, -25},
        ["battle/act"] = {-4, -25},
        ["battle/actready"] = {-4, -25},
        ["battle/spell"] = {-5, -5},
        ["battle/spellready"] = {-5, -5},
        ["battle/item"] = {-4, -25},
        ["battle/itemready"] = {-4, -25},
        ["battle/defend"] = {-4, -25},
        ["battle/spare"] = {-4, -25},

        ["battle/defeat"] = {-8, -5},
        ["battle/hurt"] = {-5, 0},

        ["battle/intro"] = {-37, -14},
        ["battle/victory"] = {-37, -14},

        -- Cutscene offsets
        
    }
end

return actor