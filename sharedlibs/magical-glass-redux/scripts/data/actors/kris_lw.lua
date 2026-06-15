local actor, super = Class("kris_lw", true)

function actor:init()
    super.init(self)

    -- Table of sprite animations
    TableUtils.merge(self.animations, {
        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/6, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/act", 1/15, false},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"pencil_jump_down", 0.2, true},
        ["battle/intro"]        = {"battle/attack", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},
        ["battle/transition_out"] = {"battle/transition_out", 1/15, false},
        ["battle/flee"]         = {"battle/hurt", 1/15},
        
        -- Cutscene animations
        ["jump_ball"]           = {"ball", 1/15, true},
    }, false)
    
    -- Alternate animations to use for Kris knife (false to disable the animation)
    self.animations_knife = {
        -- Battle animations
        ["battle/idle"]         = {"battle_knife/idle", 1/6, true},

        ["battle/attack"]       = {"battle_knife/attack", 1/15, false},

        ["battle/attack_ready"] = {"battle_knife/attackready", 0.2, true},

        ["battle/act_end"]      = {"battle_knife/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle_knife/hurt", 1/15, false, temp=true, duration=0.5},

        ["battle/transition"]   = {"knife_jump_down", 0.2, true},
        ["battle/intro"]        = {"battle_knife/attack", 1/15, false},
        ["battle/victory"]      = {"battle_knife/victory", 1/10, false},
    }

    if Game.chapter == 1 then
        self.animations["battle/transition"] = {"walk/right", 0, true}
    end

    -- Table of sprite offsets (indexed by sprite name)
    TableUtils.merge(self.offsets, {
        -- Movement offsets
        ["walk_blush/down"] = {0, 0},
    
        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-8, -6},
        ["battle/attackready"] = {-8, -6},
        ["battle/act"] = {-6, -6},
        ["battle/actend"] = {-6, -6},
        ["battle/actready"] = {-6, -6},
        ["battle/item"] = {-6, -6},
        ["battle/itemready"] = {-6, -6},
        ["battle/defend"] = {-5, -3},

        ["battle/defeat"] = {-8, -5},
        ["battle/hurt"] = {-5, -6},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-3, 0},
        
        -- Battle offsets (Knife)
        ["battle_knife/idle"] = {-5, -1},

        ["battle_knife/attack"] = {-8, -6},
        ["battle_knife/attackready"] = {-8, -6},
        ["battle_knife/actend"] = {-6, -6},

        ["battle_knife/hurt"] = {-5, -6},

        ["battle_knife/intro"] = {-8, -9},
        ["battle_knife/victory"] = {-3, 0},
        
        -- Cutscene offsets
        ["pose"] = {-4, -2},

        ["ball"] = {1, 8},
        ["landed"] = {-4, -2},

        ["fell"] = {-14, 1},

        ["pencil_jump_down"] = {-19, -5},
        ["knife_jump_down"] = {-19, -5},

        ["hug_left"] = {-4, -1},
        ["hug_right"] = {-2, -1},

        ["peace"] = {0, 0},
        ["rude_gesture"] = {0, 0},

        ["reach"] = {-3, -1},

        ["sit_alt"] = {-3, 0},

        ["t_pose"] = {-4, 0},
    }, false)
end

function actor:getAnimation(anim)
    -- If the light world battle knife flag is set and a knife animation is defined, use it instead
    if Game:getPartyMember("kris"):getFlag("lw_battle_knife", false) and self.animations_knife[anim] ~= nil then
        return self.animations_knife[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end

return actor