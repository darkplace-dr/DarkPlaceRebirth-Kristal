local actor, super = Class(Actor, "susie")

function actor:init(style)
    super.init(self)

    local susie_style = style or Game:getConfig("susieStyle")

    -- Display name (optional)
    self.name = "Susie"

    -- Width and height for this actor, used to determine its center
    self.width = 25
    self.height = 43

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {3, 31, 19, 14}
    
    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {12.5, 24}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/susie/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    if susie_style == 1 then
        self.default = "walk_bangs"
    elseif Game:getFlag("sus_serious") == true then
        self.default = "walk_bangs_unhappy"
    else
        self.default = "walk"
    end

    -- Sound to play when this actor speaks (optional)
    self.voice = "susie"
    -- Path to this actor's portrait for dialogue (optional)
    if susie_style == 1 then
        self.portrait_path = "face/susie_bangs"
    else
        self.portrait_path = "face/susie"
    end
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-5, 0}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/6, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/spell", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/swooned", 1/15, false},

        ["battle/transition"]   = {self.default.."/right_1", 1/15, false},
        ["battle/intro"]        = {"battle/attack", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        ["battle/rude_buster"]  = {"battle/rudebuster", 1/15, false, next="battle/idle"},
        ["battle/sing"]         = {"battle/sing", 1/5, true},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},

        ["diagonal_kick_right"] = {"diagonal_kick_right", 4/30, false},
        ["diagonal_kick_left"] = {"diagonal_kick_left", 4/30, false},

        ["laugh_right"] = {"laugh_right", 0.2, true},
        ["away_scratch"] = {"away_scratch", 0.2, true},

        -- all animation speeds below are probably incorrect so feel free to fix 'em'
        ["look_back_whisper_look"] = {"look_back_whisper_look", 0.2, true},
        ["look_down_arm_shake"] = {"look_down_arm_shake", 1/6, true},

        ["chuckle"] = {"chuckle", 0.2, true},

        ["clap"] = {"clap", 1/9, true},

        ["halt_serious_right"] = {"halt_serious_right", 1/9, false},

        ["ready_axe"] = {"ready_axe", 12/30, false},

        ["dance"] = {"dance", 1/6, true},

        ["pirouette"] = {"pirouette", 4/30, true},
    }

    -- Alternate animations to use for Susie without a smile
    self.animations_serious = {
        ["battle/idle"]         = {"battle_serious/idle", 0.2, true},

        ["battle/attack"]       = {"battle_serious/attack", 1/15, false},
        ["battle/spell"]        = {"battle_serious/spell", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle_serious/item", 1/12, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle_serious/attackready", 0.2, true},
        ["battle/spell_ready"]  = {"battle_serious/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle_serious/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle_serious/defend", 1/15, false},
    }

    -- Alternate animations to use for Susie with visible eyes
    self.animations_eyes = {
        ["battle/idle"]         = {"battle_eyes/idle", 0.2, true},
        ["battle/idle_serious"] = {"battle_eyes/idle_serious", 0.2, true},

        ["battle/attack"]       = {"battle_eyes/attack", 1/15, false},
        ["battle/attack_serious"] = {"battle_eyes/attack_serious", 1/15, false},
        ["battle/act"]          = {"battle_eyes/act", 1/15, false},
        ["battle/spell"]        = {"battle_eyes/spell", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle_eyes/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle_eyes/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle_eyes/attackready", 0.2, true},
        ["battle/attack_ready_serious"] = {"battle_eyes/attackready_serious", 0.2, true},
        ["battle/act_ready"]    = {"battle_eyes/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle_eyes/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle_eyes/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle_eyes/defend", 1/15, false},

        ["battle/act_end"]      = {"battle_eyes/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle_eyes/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle_eyes/defeat", 1/15, false},

        ["battle/transition"]   = {self.default.."/right_1", 1/15, false},
        ["battle/intro"]        = {"battle_eyes/attack", 1/15, false},
        ["battle/victory"]      = {"battle_eyes/victory", 1/10, false},

        ["battle/rude_buster"]  = {"battle_eyes/rudebuster", 1/15, false, next="battle/idle"},
    }

    -- Alternate animations to use for Susie when she's enraged
    self.animations_rage = {
        ["battle/idle"]         = {"battle_enraged/idle", 0.2, true},

        ["battle/attack"]       = {"battle_enraged/attack", 1/15, false},

        ["battle/attack_ready"] = {"battle_enraged/attackready", 0.2, true},

        ["battle/hurt"]         = {"battle_enraged/hurt", 1/15, false, temp=true, duration=0.5},
    }

    if susie_style == 1 then
        self.animations["battle/transition"] = {"bangs_wall_right", 0, true}
    end

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

        ["walk_bangs/down"] = "walk_bangs/up",
        ["walk_bangs/up"] = "walk_bangs/down",
        ["walk_bangs/left"] = "walk_bangs/left",
        ["walk_bangs/right"] = "walk_bangs/right",

        ["walk_bangs_unhappy/down"] = "walk_bangs_unhappy/up",
        ["walk_bangs_unhappy/up"] = "walk_bangs_unhappy/down",
        ["walk_bangs_unhappy/left"] = "walk_bangs_unhappy/left",
        ["walk_bangs_unhappy/right"] = "walk_bangs_unhappy/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/down"] = {0, 0},
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},

        ["walk_bangs/down"] = {0, -2},
        ["walk_bangs/left"] = {0, -2},
        ["walk_bangs/right"] = {0, -2},
        ["walk_bangs/up"] = {0, -2},

        ["walk_bangs_unhappy/down"] = {0, -2},
        ["walk_bangs_unhappy/left"] = {0, -2},
        ["walk_bangs_unhappy/right"] = {0, -2},
        ["walk_bangs_unhappy/up"] = {0, -2},

        ["walk_unhappy/down"] = {0, 0},
        ["walk_unhappy/left"] = {0, 0},
        ["walk_unhappy/right"] = {0, 0},
        ["walk_unhappy/up"] = {0, -2},

        ["walk_back_arm/left"] = {-3, -2},
        ["walk_back_arm/right"] = {0, -2},

        ["slide"] = {-5, -12},

        -- Battle offsets
        ["battle/idle"] = {-22, -1},
        ["battle/idle_serious"] = {-22, -1},

        ["battle/attack"] = {-26, -25},
        ["battle/attack_serious"] = {-26, -25},
        ["battle/attackready"] = {-26, -25},
        ["battle/attackready_serious"] = {-26, -25},
        ["battle/act"] = {-24, -25},
        ["battle/actend"] = {-24, -25},
        ["battle/actready"] = {-24, -25},
        ["battle/spell"] = {-22, -30},
        ["battle/spellready"] = {-22, -15},
        ["battle/item"] = {-22, -1},
        ["battle/itemready"] = {-22, -1},
        ["battle/defend"] = {-20, -23},
        ["battle/defend_peek"] = {-20, -23},
        ["battle/swooned"] = {0, 0},

        ["battle/defeat"] = {-22, -1},
        ["battle/hurt"] = {-22, -1},

        ["battle/victory"] = {-28, -7},

        ["battle/rudebuster"] = {-44, -33},
        ["battle/sing"] = {-21, -7},

        -- Battle offsets (serious)
        ["battle_serious/idle"] = {-22, -1},

        ["battle_serious/attack"] = {-26, -25},
        ["battle_serious/attackready"] = {-26, -25},
        ["battle_serious/spell"] = {-22, -30},
        ["battle_serious/spellready"] = {-22, -15},
        ["battle_serious/item"] = {-22, -1},
        ["battle_serious/itemready"] = {-22, -1},
        ["battle_serious/defend"] = {-20, -23},

        -- Battle offsets (eyes)
        ["battle_eyes/idle"] = {-22, -1},
        ["battle_eyes/idle_serious"] = {-22, -1},

        ["battle_eyes/attack"] = {-26, -25},
        ["battle_eyes/attack_serious"] = {-26, -25},
        ["battle_eyes/attackready"] = {-26, -25},
        ["battle_eyes/attackready_serious"] = {-26, -25},
        ["battle_eyes/act"] = {-24, -25},
        ["battle_eyes/actend"] = {-24, -25},
        ["battle_eyes/actready"] = {-24, -25},
        ["battle_eyes/spell"] = {-22, -30},
        ["battle_eyes/spellready"] = {-22, -15},
        ["battle_eyes/item"] = {-22, -1},
        ["battle_eyes/itemready"] = {-22, -1},
        ["battle_eyes/defend"] = {-20, -23},

        ["battle_eyes/defeat"] = {-22, -1},
        ["battle_eyes/hurt"] = {-22, -1},

        ["battle_eyes/victory"] = {-28, -7},

        ["battle_eyes/rudebuster"] = {-44, -33},

        -- Battle offsets (enraged)
        ["battle_enraged/idle"] = {-22, -1},
        ["battle_enraged/attack"] = {-26, -25},
        ["battle_enraged/attackready"] = {-26, -25},
        ["battle_enraged/hurt"] = {-22, -1},

        -- Cutscene offsets
        ["pose"] = {-1, -1},
        ["pose_what_the"] = {-1, -1},

        ["fall"] = {0, -4},
        ["ball"] = {1, 7},
        ["landed"] = {-5, -2},

        ["shock_left"] = {0, -4},
        ["shock_right"] = {-16, -4},
        ["shock_down"] = {0, -2},
        ["shock_up"] = {-6, 0},

        ["shock_behind"] = {-15, -3},
        ["shock_down_flip"] = {0, -2},

        ["laugh_left"] = {-8, -2},
        ["laugh_right"] = {-4, -2},

        ["point_laugh_left"] = {-14, 2},
        ["point_laugh_right"] = {0, 2},

        ["point_left"] = {-11, 2},
        ["point_right"] = {0, 2},
        ["point_right_unhappy"] = {0, 2},
        ["point_up"] = {-2, -12},

        ["point_up_turn"] = {-4, -12},

        ["playful_punch"] = {-8, 0},

        ["wall_left"] = {0, -2},
        ["wall_right"] = {0, -2},

        ["bangs_wall_left"] = {0, -2},
        ["bangs_wall_right"] = {0, -2},

        ["exasperated_left"] = {-1, 0},
        ["exasperated_right"] = {-5, 0},
        ["exasperated_stare"] = {-5, 0},

        ["angry_down"] = {-10, 2},
        ["turn_around"] = {-12, 2},

        ["away"] = {-1, -2},
        ["away_turn"] = {-1, -2},
        ["away_hips"] = {-2, -1},
        ["away_hand"] = {-2, -2},
        ["away_scratch"] = {-2, -2},

        ["t_pose"] = {-6, 0},

        ["fell"] = {-18, -2},

        ["kneel_right"] = {-4, -2},
        ["kneel_left"] = {-12, -2},

        ["diagonal_kick_right"] = {-5, -1},
        ["diagonal_kick_left"] = {-3, -1},

        ["ledge"] = {-8, -3},
        ["ledge_b"] = {-8, -3},
        ["ledge_smile"] = {-8, -3},
        ["ledge_smile_b"] = {-8, -3},
        ["ledge_punch_1"] = {-8, -3},
        ["ledge_punch_2"] = {-8, -3},
        ["sneak/left"] = {-6, 5},
        ["sneak/right"] = {-2, 5},

        ["run/left"] = {-6, 0},-- I dunno the offsets and neither where to find them in DR code
        ["run/right"] = {-6, 0},
        ["run/up"] = {-4, 0},
        ["run/down"] = {-4, 0},

        ["run_serious/left"] = {-6, 0}, -- same situation as normal run sprites
        ["run_serious/right"] = {-6, 0},
        ["run_serious/up"] = {-4, 0},
        ["run_serious/down"] = {-4, 0},

        ["ready_axe"] = {-18, -12},

        ["clash_jump"] = {-26, -12}, -- ehh idk placed the numbers randomly here

        ["crouch"] = {-3, 10},

        ["halt_serious_right"] = {-3, -1},

        ["jump"] = {0, -2},

        ["headhand"] = {0, -2},

        ["look_back"] = {-1, 0},
        ["look_back_cross_arms"] = {0, 1},
        ["look_back_right"] = {0, 0},
        ["look_back_whisper_look"] = {0, 3},

        ["look_react"] = {-1, 0},
        ["look_react_right"] = {-1, 0},

        ["up_benddown"] = {0, 8},
        ["up_look_right_full"] = {3, 0},

        ["dance"] = {-3, -1},

        ["pirouette"] = {-3, -1},
    }

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {"pose", "away_hand", "turn_around", "angry_down", "diagonal_kick_left_5", "shock_right"}

    self.menu_anim = "pose"

	self.shiny_id = "susie"
end

function actor:getAnimation(anim)
    -- If the weird route flag is set and an alt animation is defined, use it instead
	if Game:getPartyMember("susie").rage and self.animations_rage[anim] ~= nil then
		return self.animations_rage[anim] or nil
    elseif Game:getPartyMember("susie"):getFlag("serious", false) and self.animations_serious[anim] ~= nil then
        return self.animations_serious[anim] or nil
    elseif Game:getPartyMember("susie"):getFlag("eyes", false) and self.animations_eyes[anim] ~= nil then
        return self.animations_eyes[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end

function actor:onWorldDraw(chara)
    if Kristal.Config["runAnimations"] then
        local player = Game.world.player

        local moving = false
        local c, b = chara.x, chara.y
        if c ~= self.l or b ~= self.ll then
            moving = true
        end

        if Game.world.cutscene and not self.cut then
            self.default = "walk"
            chara:resetSprite()
            self.cut = true
        elseif not Game.world.cutscene then
            if self.cut then self.cut = nil end
            if player.run_timer > 0 and self.default == "walk" and not Game.world.cutscene and moving then
                self.default = "run"
                chara:resetSprite()
            elseif self.default == "run" and (player.run_timer == 0 or moving == false) then
                self.default = "walk"
                chara:resetSprite()
            end
        end
        self.l = chara.x
        self.ll = chara.y
    end
end

return actor
