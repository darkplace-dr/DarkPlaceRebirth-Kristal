local actor, super = Class(Actor, "hero")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Hero"

    -- Width and height for this actor, used to determine its center
    self.width = 28
    self.height = 36

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {5, 24, 19, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {15, 25}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0.5, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/hero/dark"
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

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/swooned", 1/15, false},
        ["battle/succumbed"]    = {"battle/swooned", 1/15, false},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        --"battle/act"]          = {"battle/act", 1/15, false},
        --["battle/spell"]        = {"battle/spell", 1/15, false},
        --[[["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},]]

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        --["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/spellready", 0.2, true},
        --[[["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},]]

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},

        ["battle/transition"]   = {"battle/attackready", 0.2, true},
        ["battle/intro"]        = {"battle/attack", 1/15, true},
        --["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},
        ["wall_slam"]           = {"wall_slam", 1/10, false},
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
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {3, 0},

        ["battle/attack"] = {-1, -8},
        ["battle/attackready"] = {0, -8},
        ["battle/act"] = {-6, -6},
        ["battle/actend"] = {-6, -6},
        ["battle/actready"] = {-6, -6},
        ["battle/spell"] = {-6, -6},
        ["battle/spellready"] = {-1, -8},
        ["battle/item"] = {-6, -6},
        ["battle/itemready"] = {-6, -6},
        ["battle/defend"] = {-5, -3},

        ["battle/defeat"] = {1, 6},
        ["battle/hurt"] = {3, 0},
        ["battle/swooned"] = {-6, 1},

        ["battle/victory"] = {-3, 0},

        -- Cutscene offsets
        ["ball"] = {1, 8},
        ["landed"] = {-4, -2},

        ["fell"] = {-14, 1},

        ["wall_slam"] = {-1, 0},

        --- Climbing offsets
        ["climb/climb"] = {-0, 4},
        ["climb/charge"] = {-0, 4},
        ["climb/slip_left"] = {-0, 4},
        ["climb/slip_right"] = {-0, 4},
        ["climb/land_left"] = {-0, 4},
        ["climb/land_right"] = {-0, 4},
        ["climb/jump_up"] = {-0, 4},
        ["climb/jump_left"] = {-0, 4},
        ["climb/jump_right"] = {-0, 4},
    }

	self.shiny_id = "hero"
end

--[[function actor:getAnimation(anim)
	if Game.battle and Game.battle.encounter.is_jackenstein and self.animations_jack[anim] ~= nil then
		if anim == "battle/idle" then
			self.animations_jack[anim].duration = TableUtils.pick({40/30, 75/30, 90/30})
		end
        return self.animations_jack[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end]]

return actor
