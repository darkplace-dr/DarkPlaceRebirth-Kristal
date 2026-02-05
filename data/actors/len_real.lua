local actor, super = Class(Actor, "len_real")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Len"

    -- Width and height for this actor, used to determine its center
    self.width = 18
    self.height = 31

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 19, 19, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10, 24}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {208/255, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/len/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/len"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["idle"]         = {"battle/real/attackready", 1/6, true},

        ["attack"]       = {"battle/attack", 1/15, false},
        ["act"]          = {"battle/real/act", 1/15, false},
        ["spell"]        = {"battle/real/act", 1/15, false},
        ["item"]         = {"battle/real/item", 1/12, false, next="battle/real/attackready"},
        ["spare"]        = {"battle/act", 1/15, false, next="battle/real/attackready"},

        ["attack_ready"] = {"battle/real/attackready", 0.2, true},
        ["act_ready"]    = {"battle/actready", 0.2, true},
        ["spell_ready"]  = {"battle/actready", 0.2, true},
        ["item_ready"]   = {"battle/itemready", 0.2, true},
        ["defend_ready"] = {"battle/real/defend", 1/15, false},

        ["act_end"]      = {"battle/actend", 1/15, false, next="battle/real/attackready"},

        ["hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["defeat"]       = {"battle/defeat", 1/15, false},
        ["swooned"]      = {"battle/defeat", 1/15, false},

        ["transition"]   = {"sword_jump_down", 0.2, true},
        ["intro"]        = {"battle/attack", 1/15, false},
        ["victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},

        ["pirouette"]           = {"battle/real/pirouette", 4/30, true},
    }

    if Game.chapter == 1 then
        self.animations["battle/transition"] = {"walk/right", 0, true}
    end

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "battle/real/attackready",
        ["walk/right"] = "walk/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {-1, 0},
        ["walk/up"] = {-1, 1},
        ["walk/down"] = {0, 1},

        ["walk_blush/down"] = {0, 1},

        ["slide"] = {0, 1},

        -- Battle offsets
        ["idle"] = {-3, 0},

        ["attack"] = {-1, 0},
        ["attackready"] = {-6, 0},
        ["act"] = {-1, 0},
        ["actend"] = {-1, 0},
        ["actready"] = {-1, 0},
        ["item"] = {-1, -4},
        ["itemready"] = {-1, 0},
        ["defend"] = {-1, 0},

        ["defeat"] = {-2, 6},
        ["hurt"] = {-1, 0},

        ["intro"] = {-1, -15},
        ["victory"] = {0, 1},

        -- Cutscene offsets
        ["pose"] = {-2, 0},

        ["fall"] = {-5, -6},
        ["ball"] = {-2, 5},
        ["landed"] = {-5, -8},

        ["fell"] = {-8, 16},

        ["sword_jump_down"] = {-2, 0},
        ["sword_jump_settle"] = {-27, 4},
        ["sword_jump_up"] = {-17, 2},

        ["hug_left"] = {-3, -1},
        ["hug_right"] = {0, -1},

        ["peace"] = {0, 1},
        ["rude_gesture"] = {0, 1},

        ["reach"] = {-2, 1},

        ["sit"] = {-3, 6},

        ["t_pose"] = {-3, 1},
        ["sneak/left"] = {1, 3},
        ["sneak/right"] = {1, 3},

        --["run/left"] = {0, 0},
        ["run/right"] = {0, 0},
        --["run/up"] = {0, 0},
        ["run/down"] = {-3, -3},
    }

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {"pose", "peace", "t_pose", "sit"}

    self.menu_anim = "pose"
end

function actor:onSpriteInit(sprite)
    sprite:setScaleOrigin(0.5,1)
    sprite:setScale(1.4,1.3)
end

return actor
