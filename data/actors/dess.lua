local actor, super = Class(Actor, "dess")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Dess"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 46

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {2, 33, 18, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/dess"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = "dess"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/dess"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-12, -10}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Battle animations
        ["battle/idle"]          = {"battle/idle", 0.2, true},

        ["battle/attack"]        = {"battle/attack", 1/23, false},
        ["battle/act"]           = {"battle/act", 1/15, false},
        ["battle/spell"]         = {"battle/spell", 1/10, false, next="battle/idle"},
        ["battle/item"]          = {"battle/item", 1/18, false, next="battle/idle"},
        ["battle/spare"]         = {"battle/spell", 1/10, false, next="battle/idle"},

        ["battle/attack_ready"]  = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]     = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]   = {"battle/spellready", 0.2, true},
        ["battle/item_ready"]    = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"]  = {"battle/defend", 1/15, false},

        ["battle/actend"]        = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]          = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]        = {"battle/defeat", 1/15, false},
        ["battle/swooned"]       = {"battle/defeat", 1/15, false},
        ["battle/succumbed"]     = {"battle/defeat", 1/15, false},

		["battle/transition"]    = {"battle/transition", 1/15, false},
        ["battle/intro"]   		 = {"battle/intro", 1/15, false},
        ["battle/victory"]       = {"battle/victory", 1/10, false},

		["battle/snap"]          = {"battle/snap", 2/30, false, next="battle/idle"},
		["battle/spellsuper"]    = {"battle/spellsuper", 2/30, false, next="battle/spellsuperend"},
		["battle/spellsuperend"] = {"battle/spellsuperend", 2/30, true},
        ["battle/tactic_freeze"] = {"battle/tactic_freeze", 1/15, false},
        ["battle/slam"]        = {"battle/slam", 1/23, false},

        -- Cutscene animations
        --["laugh"]               = {"laugh", 4/30, true},

        ["jump_ball"] = {"ball", 1/15, true},

		-- Rhythm Game
        ["rhythm_game/idle"]      = {"rhythm_game/idle", 0, false},
        ["rhythm_game/ready"]     = {"rhythm_game/sing_polite_closed", 0, false},
        ["rhythm_game/play"]      = {"rhythm_game/sing_polite", 0, false},
        ["rhythm_game/play_rude"] = {"rhythm_game/sing_rude", 0, false},
        ["rhythm_game/clap"]      = {"rhythm_game/clap", 0, false},
        ["rhythm_game/clap_wait"] = {"rhythm_game/clap_wait", 0, false},
        ["rhythm_game/cuss"]      = {"rhythm_game/cuss", 0, false},
        ["rhythm_game/shock"]     = {"rhythm_game/shock", 0, false},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/down"] = {-4, 0},
        ["walk/right"] = {-4, 0},
        ["walk/left"] = {-4, 0},
        ["walk/up"] = {-4, 0},

        ["sneak/left"] = {-5, 3},
        ["sneak/right"] = {7, 3},

        -- Battle offsets
        ["battle/idle"] = {-20, 0},

        ["battle/attack"] = {-20, 0},
        ["battle/attackready"] = {-20, 0},
        ["battle/attackready_shake"] = {-20, 0},
        ["battle/act"] = {-20, 0},
        ["battle/actend"] = {-20, 0},
        ["battle/actready"] = {-12, 0},
        ["battle/spell"] = {-20, 0},
        ["battle/spellready"] = {-20, 0},
        ["battle/item"] = {-20, 0},
        ["battle/itemready"] = {-20, 0},
        ["battle/defend"] = {-20, 0},

        ["battle/defeat"] = {-12, 18},
        ["battle/hurt"] = {-20, 0},

        ["battle/transition"] = {-20, 0},
        ["battle/intro"] = {-20, 0},
        ["battle/victory"] = {-20, 0},

        ["battle/snap"] = {-20, 0},
        ["battle/slam"] = {-13, 0},
        ["battle/spellsuper"] = {-19, 0},
        ["battle/spellsuperend"] = {-18, 0},
        ["battle/tactic_freeze"] = {-20, 0},

        ["angreh"] = {-20, -10},
        ["beatbox"] = {-20, -10},
        ["bup"] = {-20, -10},
        ["d_pose"] = {-20, -10},
        ["dab"] = {-20, -10},
        ["oc"] = {-20, -10},
        ["paneton"] = {-20, -10},
        ["reddit_gold"] = {-20, -20},
        ["sonic_adventure"] = {-20, -10},
        ["t_pose"] = {-20, -10},
        ["teehee"] = {-4, 0},

		-- Rhythm Game
        ["rhythm_game/idle"]      = {0, 0},
        ["rhythm_game/ready"]     = {-5, 1},
        ["rhythm_game/play"]      = {-5, 1},
        ["rhythm_game/play_rude"] = {-12, 5},
        ["rhythm_game/clap"]      = {-5, 1},
        ["rhythm_game/clap_wait"] = {-5, 1},
        ["rhythm_game/cuss"]      = {-5, 1},
        ["rhythm_game/shock"]     = {-5, 1},
    }

    self.taunt_sprites = {"reddit_gold", "sonic_adventure", "bup", "beatbox", "angreh", "oc", "paneton", "dab"}

    self.menu_anim = "sonic_adventure"

	self.shiny_id = "dess"
end

return actor
