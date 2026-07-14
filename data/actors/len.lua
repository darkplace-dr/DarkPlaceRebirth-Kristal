local actor, super = Class(Actor, "len")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Len"

    -- Width and height for this actor, used to determine its center
    self.width = 18
    self.height = 31

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 18, 18, 14}

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
    self.can_blush = true

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/6, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/act", 1/15, false},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/pirouette"]    = {"battle/pirouette", 4/30, true},

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"sword_jump_down", 0.2, true},
        ["battle/intro"]        = {"battle/intro", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},
        
        ["pirouette"]           = {"pirouette", 4/30, true},
        ["scream/right"]        = {"scream/right", 1/8, false},
        ["reach"]               = {"reach", 0.1, true},
        ["reveal_forced"]       = {"reveal_forced", 1/6, false},
    }

    -- Table of sprite animations
    self.hoodless_animations = {
        -- Battle animations
        ["battle/idle"]         = {"hoodless/battle/idle", 1/10, true},

        ["battle/attack"]       = {"hoodless/battle/attack", 1/15, false},
        ["battle/act"]          = {"hoodless/battle/act", 1/15, false},
        ["battle/spell"]        = {"hoodless/battle/act", 1/15, false},
        ["battle/item"]         = {"hoodless/battle/item", 1/12, false},
        ["battle/spare"]        = {"hoodless/battle/act", 1/15, false},

        ["battle/pirouette"]    = {"battle/pirouette", 4/30, true},

        ["battle/attack_ready"] = {"hoodless/battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"hoodless/battle/actready", 0.4, true},
        ["battle/spell_ready"]  = {"hoodless/battle/actready", 0.4, true},
        ["battle/item_ready"]   = {"hoodless/battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"hoodless/battle/defend", 1/15, false},

        ["battle/act_end"]      = {"hoodless/battle/actready", 1/15, false, next="battle/act_ready"},

        ["battle/hurt"]         = {"hoodless/battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"hoodless/battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"hoodless/defeat", 1/15, false},

        ["battle/transition"]   = {"hoodless/battle/intro", 0.2, true},
        ["battle/intro"]        = {"hoodless/battle/intro", 1/15, false},
        ["battle/victory"]      = {"hoodless/battle/victory", 1/10, false},
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
        ["walk/right"] = {-1, 0},
        ["walk/up"] = {-1, 1},
        ["walk/down"] = {0, 1},

        ["walk_blush/down"] = {0, 1},

        ["slide"] = {0, 1},

        -- Battle offsets
        ["battle/idle"] = {-3, 0},

        ["battle/attack"] = {-1, 0},
        ["battle/attackready"] = {-6, 0},
        ["battle/act"] = {-1, 0},
        ["battle/actend"] = {-1, 0},
        ["battle/actready"] = {-1, 0},
        ["battle/item"] = {-1, -4},
        ["battle/itemready"] = {-1, 0},
        ["battle/defend"] = {-1, 0},

        ["battle/defeat"] = {-2, 6},
        ["battle/hurt"] = {-1, 0},

        ["battle/intro"] = {-1, -15},
        ["battle/victory"] = {0, 1},

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

    -- Table of sprite offsets (indexed by sprite name)
    self.hoodless_offsets = {
        -- Battle offsets
        ["battle/idle"] = {-3, 40},
    }

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {"pose", "peace", "t_pose", "sit"}

    self.menu_anim = "peace"
    
    self:addExpressionPart("head", "face/len", 0, 0, {layer = 2, default = "head"})
    self:addExpressionPart("face", "face/len/face", 0, 0, {layer = 3, default = "neutral", side_b = {-1, 0}})
    self:addExpressionPart("mouth", "face/len/mouth", 0, 0, {layer = 4, default = "neutral"})

    self.hoodless_expression_parts = {
        ["head"] = self:newExpressionPart("face/len/hoodless", 0, -2, {layer = 2, default = "head"}),
        ["face"] = self:newExpressionPart("face/len/hoodless/face", 0, 0, {layer = 3, default = "neutral", side_b = {-1, 0}}),
        ["mouth"] = self:newExpressionPart("face/len/hoodless/mouth", 0, 0, {layer = 4, default = "neutral"}),
    }
end

function actor:getAnimation(anim)
    local len = Game:getPartyMember("len")
	if len and len:getFlag("hoodless") and self.hoodless_animations[anim] ~= nil then
        return self.hoodless_animations[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end

function actor:getExpressionParts()
    local len = Game:getPartyMember("len")
	if len and len:getFlag("hoodless") then
        return self.hoodless_expression_parts or {}
    else
        return super.getExpressionParts(self)
    end
end

function actor:getOffset(sprite)
    local len = Game:getPartyMember("len")
	if len and len:getFlag("hoodless") and self.hoodless_offsets[sprite] ~= nil then
        return unpack(self.hoodless_offsets[sprite] or { 0, 0 })
    else
        return super.getOffset(self, sprite)
    end
end

function actor:onSpriteInit(sprite)
    sprite:setScaleOrigin(0.5, 1)

    local len = Game:getPartyMember("len")
    if not len or not len:getFlag("honest") then
        sprite:setScale(1.4, 1.4)
    end
end

return actor
