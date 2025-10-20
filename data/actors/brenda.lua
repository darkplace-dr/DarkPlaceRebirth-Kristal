local actor, super = Class(Actor, "brenda")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Brenda"

    -- Width and height for this actor, used to determine its center
    self.width = 25
    self.height = 50

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {3, 38, 19, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/brenda/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "brenda"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/brenda"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-30, -15}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false, next="battle/idle"},
        ["battle/spell"]        = {"battle/spell", 0.15, false},
        ["battle/item"]         = {"battle/item", 1/15, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.08, false},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.1, false},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/multiflare"]   = {"battle/act", 1/15, false},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},

        ["battle/intro"]        = {"battle/attackready", 0.1, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["dance"]               = {"dance", 0.2, true}
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-9, -1},
        ["battle/attackready"] = {-9, -1},
        ["battle/act"] = {-5, -1},
        ["battle/actready"] = {-5, -1},
        ["battle/spell"] = {-6, -2},
        ["battle/spellready"] = {-6, -2},
        ["battle/item"] = {-5, -4},
        ["battle/itemready"] = {-5, -4},
        ["battle/defend"] = {-12, -1},

        ["battle/defeat"] = {-5, 10},
        ["battle/hurt"] = {-8, -11},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-22, -3},

        -- Cutscene offsets
        ["dance"] = {-5, -1},
        ["dance_up"] = {-5, -1},
        ["dance_down"] = {-5, -1},

        -- Taunt offsets
        ["catgirl"] = {-4, 0}
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    self.taunt_sprites = {"box", "catgirl"}
	
	self.shiny_id = "brenda"
end

return actor