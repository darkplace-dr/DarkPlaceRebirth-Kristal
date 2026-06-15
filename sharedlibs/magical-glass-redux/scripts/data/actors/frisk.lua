local actor, super = Class(Actor, "frisk")

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
    self.color = {0, 1, 0}
    
    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10, 21.5}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/frisk/dark"
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

        ["battle/attack_ready"] = {"battle/attackready", 0.2, false},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, false},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/attack", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"walk/right_1", 1/15, false},
        ["battle/intro"]        = {"battle/attack", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},
        ["battle/transition_out"] = {"battle/transition_out", 1/15, false},
        ["battle/flee"]         = {"battle/hurt", 1/15},

        -- Cutscene animations
        ["jump_ball"]           = {"ball", 1/15, true},
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
        ["walk/left"] = {2.5, 1},
        ["walk/right"] = {-2.5, 1},
        ["walk/up"] = {-0.5, 1},
        ["walk/down"] = {0.5, 1},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {0, 0},
        ["battle/hit"] = {0, 0},
        ["battle/down"] = {0, 0},
        ["battle/spare"] = {0, 0},

        ["battle/idle"] = {0, 0},

        ["battle/attack"] = {2, 0},
        ["battle/attackready"] = {0, 0},
        ["battle/act"] = {0, 0},
        ["battle/actend"] = {0, 0},
        ["battle/actready"] = {0, 0},
        ["battle/item"] = {0, 0},
        ["battle/itemready"] = {0, 0},
        ["battle/defend"] = {0, 0},

        ["battle/defeat"] = {0, 0},
        ["battle/hurt"] = {0, 0},

        ["battle/intro"] = {0, 0},
        ["battle/victory"] = {0, 0},

        -- Cutscene offsets
        ["ball"] = {0, 0},
    }
end

function actor:getOffset(sprite)
    if StringUtils.sub(sprite, 1, 7) == "battle/" then
        local x, y = super.getOffset(self, sprite)
        return x - 9, y - 12
    else
        return super.getOffset(self, sprite)
    end
end

function actor:getVoice()
    if Game.state == "GAMEOVER" then
        return "asgore"
    else
        return super.getVoice(self)
    end
end

return actor