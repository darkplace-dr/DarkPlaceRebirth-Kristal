local actor, super = Class(Actor, "calypso")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Calypso"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 43

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {5, 33, 13, 10}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/calypso/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "calypso"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/jamm"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-19, -3}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               		= {"slide", 4/30, true},

        --[[-- Battle animations
        ["battle/idle"]         		= {"battle/idle", 0.2, true},

        ["battle/attack"]       		= {"battle/attack", 1/15, false},
        ["battle/act"]          		= {"battle/act", 1/15, false},
        ["battle/spell"]        		= {"battle/act", 1/15, false}, -- no spell animation
        ["battle/item"]         		= {"battle/item", 1/15, false, next="battle/idle"},
        ["battle/spare"]        		= {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] 		= {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    		= {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  		= {"battle/actready", 0.2, true},
        ["battle/item_ready"]   		= {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] 		= {"battle/defend", 1/15, false},

        ["battle/act_end"]      		= {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         		= {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       		= {"battle/defeat", 0.5, true},
        ["battle/swooned"]              = {"battle/swooned", 1/15, false},
        ["battle/succumbed"]            = {"battle/swooned", 1/15, false},

        ["battle/transition"]   		= {"battle/transition_out", 0.2, true},
        ["battle/intro"]        		= {"battle/intro", 1/15, true},
        ["battle/victory"]      		= {"battle/victory", 1/10, false},

		["battle/transition_out"]       = {"battle/transition_out", 1/15, false},]]
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["slide"] = {-2, 0},

        --[[-- Battle offsets
        ["battle/idle"] = {-5, 0},

        ["battle/attack"] = {-5, 1},
        ["battle/attackready"] = {-5, 0},
        ["battle/act"] = {-4, 0},
        ["battle/actend"] = {-4, 0},
        ["battle/actready"] = {-4, 0},
        ["battle/item"] = {-4, 0},
        ["battle/itemready"] = {-4, 0},
        ["battle/defend"] = {-4, 0},
        ["battle/swooned"] = {0, 0},

        ["battle/defeat"] = {-3, 4},
        ["battle/hurt"] = {-5, 0},

        ["battle/transition"] = {-9, 0},
        ["battle/intro"] = {-9, 0},
        ["battle/victory"] = {-10, 0},
        ["battle/transition_out"] = {-10, 0},

        ["battle/tactic_freeze"] = {-5, 0},
        ["battle/tactic_freeze_shiny"] = {-5, 0},]]
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

	self.shiny_id = "calypso"
end

return actor
