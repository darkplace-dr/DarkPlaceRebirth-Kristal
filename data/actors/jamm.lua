local actor, super = Class(Actor, "jamm")

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
    self.path = "party/jamm/dark"
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
        ["slide"]               		= {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         		= {"battle/idle", 0.2, true},

        ["battle/attack"]       		= {"battle/attack", 1/15, false},
        ["battle/act"]          		= {"battle/act", 1/15, false},
        ["battle/spell"]        		= {"battle/spell", 1/15, false},
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

        ["battle/transition"]   		= {"walk/right", 0.2, true},
        ["battle/intro"]        		= {"battle/attack", 1/15, true},
        ["battle/victory"]      		= {"battle/victory", 1/10, false},

        ["battle/tactic_freeze"] 		= {"battle/tactic_freeze", 1/15, false},
        ["battle/tactic_freeze_shiny"] 	= {"battle/tactic_freeze_shiny", 1/15, false},

		-- Cutscene animations
        ["jump_ball"]           = {"ball", 1/15, true},
		["sit"]               	= {"sit", 4/30, true},

		["dance"]               = {"dance", 1/10, true},

        ["pirouette"]           = {"pirouette", 4/30, true},
    }

    self.animations_dk = {
        -- Movement animations
        ["slide"]               = {"slide_hurt", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle_dungeonkiller/idle", 0.2, true},

        ["battle/attack"]       = {"battle_dungeonkiller/attack", 1/15, false},
        ["battle/act"]          = {"battle_dungeonkiller/act", 1/15, false},
        ["battle/spell"]        = {"battle_dungeonkiller/spell", 1/15, false},
        ["battle/item"]         = {"battle_dungeonkiller/item", 1/15, false, next="battle/idle"},
        ["battle/spare"]        = {"battle_dungeonkiller/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle_dungeonkiller/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle_dungeonkiller/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle_dungeonkiller/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle_dungeonkiller/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle_dungeonkiller/defend", 1/15, false},

        ["battle/act_end"]      = {"battle_dungeonkiller/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle_dungeonkiller/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle_dungeonkiller/defeat", 0.5, true},

        ["battle/transition"]   = {"walk_shadowed/right", 0.2, true},
        ["battle/intro"]        = {"battle_dungeonkiller/attack", 1/15, true},
        ["battle/victory"]      = {"battle_dungeonkiller/victory", 1/10, false},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["walk_serious/left"] = {0, 0},
        ["walk_serious/right"] = {0, 0},
        ["walk_serious/up"] = {0, 0},
        ["walk_serious/down"] = {0, 0},

        ["walk_shadowed/left"] = {0, 0},
        ["walk_shadowed/right"] = {0, 0},
        ["walk_shadowed/up"] = {0, 0},
        ["walk_shadowed/down"] = {0, 0},

        ["slide"] = {0, 0},
        ["slide_hurt"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-9, -3},

        ["battle/attack"] = {-9, -3},
        ["battle/attackready"] = {-9, -3},
        ["battle/act"] = {-9, -3},
        ["battle/actend"] = {-9, -3},
        ["battle/actready"] = {-9, -3},
        ["battle/spell"] = {-9, -3},
        ["battle/item"] = {-9, -3},
        ["battle/itemready"] = {-9, -3},
        ["battle/defend"] = {-9, -3},
        ["battle/swooned"] = {0, 0},

        ["battle/defeat"] = {-8, -3},
        ["battle/hurt"] = {-9, -3},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-9, -3},

        ["battle/tactic_freeze"] = {-9, -3},
        ["battle/tactic_freeze_shiny"] = {-9, -3},

		["sit"] = {4, -8},

		["ball"] = {0, 18},

        ["talk_to_marcy"] = {0, 13},
        ["talk_to_marcy_reach"] = {-7, 13},
        ["talk_to_marcy_relate"] = {-7, 13},

        ["dance"] = {-4, 0},

        ["pirouette"] = {-4, 0},

        ["sneak/left"] = {-6, 3},
        ["sneak/right"] = {2, 3},

        --- Climbing offsets
        ["climb/climb"] = {-4, 8},
        ["climb/charge"] = {-4, 8},
        ["climb/slip_left"] = {-4, 8},
        ["climb/slip_right"] = {-4, 8},
        ["climb/land_left"] = {-4, 8},
        ["climb/land_right"] = {-4, 8},
        ["climb/jump_up"] = {-4, 8},
        ["climb/jump_left"] = {-4, 8},
        ["climb/jump_right"] = {-4, 8},
    }

    self.mirror_sprites = {
        ["walk/down"] = "walk_shadowed/up",
        ["walk/up"] = "walk_shadowed/down",
        ["walk/left"] = "walk_shadowed/left",
        ["walk/right"] = "walk_shadowed/right",

        ["walk_serious/down"] = "walk_shadowed/up",
        ["walk_serious/up"] = "walk_shadowed/down",
        ["walk_serious/left"] = "walk_shadowed/left",
        ["walk_serious/right"] = "walk_shadowed/right",

        ["walk_shadowed/down"] = "walk_shadowed/up",
        ["walk_shadowed/up"] = "walk_shadowed/down",
        ["walk_shadowed/left"] = "walk_shadowed/left",
        ["walk_shadowed/right"] = "walk_shadowed/right",
    }

    self.taunt_sprites = {"box", "bs_win", "maid", "bt"}
    if Game:getFlag("jamm_closure") then
		self.taunt_sprites = {"box", "ghost_bs", "maid", "bt"}
	end

    self.menu_anim = "bs_win"
    if Game:getFlag("jamm_closure") then
		self.menu_anim = "ghost_bs"
	end

	self.shiny_id = "jamm"
end

return actor
