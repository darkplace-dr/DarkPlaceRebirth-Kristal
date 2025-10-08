local actor, super = Class(Actor, "frisk_lw")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Frisk"

    -- Width and height for this actor, used to determine its center
    self.width = 20
    self.height = 30

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, 17.5, 18, 12}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}
    
    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10, 21.5}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/frisk/light"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/6, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/act", 1/15, false},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attack_ready", 1/30, false},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/act_01", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/down", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"walk/right_1", 1/15, false},
        ["battle/intro"]        = {"battle/attack", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    local x, y = 0, 4

    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {2.5, 1},
        ["walk/right"] = {-2.5, 1},
        ["walk/up"] = {-0.5, 1},
        ["walk/down"] = {0.5, 1},

        -- Battle offsets
        ["battle/idle"] = {x, y},
        ["battle/attack_ready"] = {x, y},
        ["battle/hurt"] = {x, y},
        ["battle/down"] = {x, y},
        ["battle/spare"] = {x, y},

        ["battle/idle"] = {x, y},

        ["battle/attack"] = {x, y},
        ["battle/attackready"] = {x, y},
        ["battle/act"] = {x, y},
        ["battle/actend"] = {x, y},
        ["battle/actready"] = {x, y},
        ["battle/item"] = {x, y},
        ["battle/itemready"] = {x, y},
        ["battle/defend"] = {x, y},

        ["battle/defeat"] = {x, y},
        ["battle/hurt"] = {x, y},

        ["battle/intro"] = {x, y},
        ["battle/victory"] = {x, y}
    }
end

function actor:getVoice()
    if Game.state == "GAMEOVER" then
        return "asgore"
    else
        return super.getVoice(self)
    end
end

return actor