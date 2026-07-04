local actor, super = Class(Actor, "pink")

function actor:x(sprite)
    if Game.battle then return Game.battle:getPartyBattler("pink").sprite end
    return sprite
end

function actor:onSetSprite(sprite, anim, callback)
    if anim == "battle/hurt" and not self.head then
        
        self.body = Sprite("party/pink/battle/hurt")
        self.body:setOrigin(0.5, 0.25)

        self.body.x = 16
        self.body.y = 9

        Assets.playSound("voice/pink/gasp")


        self.head = Sprite("party/pink/battle/nohead")
        self.head:setOrigin(0.5, 0.25)

        self.head.x = 16
        self.head.y = 9

        Game.stage.timer:tween(1, self.head, { rotation = -6.3}, "in-out-quad", function ()
            self.head.rotation = 0
        end)

        Game.stage.timer:tween(0.4, self.head, { y = -40 }, "out-quad", function ()

            if self.head then Game.stage.timer:tween(0.4, self.head, { y = 9 }, "in-quad") end

        end)

        local usr = self:x(sprite)
        usr.alpha = 0

        sprite.parent:addChild(self.body)
        sprite.parent:addChild(self.head)

    elseif self.head and anim ~= "battle/hurt" then
        self.head:remove()
        self.head = nil

        local usr = self:x(sprite)
        usr.alpha = 1

        self.body:remove()
        self.body = nil
    end
end

function actor:onResetSprite(sprite)

    if self.head then

        local usr = self:x(sprite)
        usr.alpha = 1

        self.head:remove()
        self.head = nil

        self.body:remove()
        self.body = nil
    end

end

function actor:init()
    super.init(self)

    self.name = "Pink"

    self.width = 33
    self.height = 44

    self.hitbox = {0+7, 25+7, 18, 14}

    self.soul_offset = {10+7, 24}

    self.color = {1, 0.5, 0.5}

    self.path = "party/pink"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/pink"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {360 - 18, -97 + 6}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 1/6, true},

        ["battle/attack"]       = {"battle/attack", 1/7.5, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/spell", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 0.2, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},
        ["battle/flee"]       = {"shock_right", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=1},
        ["battle/defeat"]       = {"battle/defeat", 1/6, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},
        ["battle/succumbed"]    = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"angle_right", 0.2, true},
        ["battle/intro"]        = {"angle_right", 1/15, false},
        ["battle/victory"]      = {"ohoho", 0.2, true},
        ["battle/transition_out"] = {"battle/transition_out", 1/15, false},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},

        ["dance"]               = {"dance", 1/6, true},

        ["pirouette"]           = {"pirouette", 4/30, true},

        ["ohoho"]        = {"ohoho", 0.2, true},
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

        ["walk_blush/down"] = {0, 0},

        ["angle_right"] = {0, -1},
        ["angle_left"] = {0, -1},

        ["slide"] = {0, 0},

        ["suprised"] = {-2, -1},

        -- Battle offsets
        ["battle/idle"] = {-5, -1},

        ["battle/attack"] = {-8, -3},
        ["battle/attackready"] = {-8, -3},
        ["battle/act"] = {-6, -6},
        ["battle/actend"] = {-6, -6},
        ["battle/actready"] = {-6, -6},
        ["battle/spellready"] = {-9, -36},
        ["battle/item"] = {-12, -23},
        ["battle/itemready"] = {-6, -6},
        ["battle/defend"] = {-5, -3},

        ["battle/defeat"] = {-8, 12},
        ["battle/hurt"] = {-3, -1},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-3, 0},

        -- Cutscene offsets
        ["pose"] = {-4, -2},

        ["fall"] = {-5, -6},
        ["ball"] = {6, 10},
        ["landed"] = {-4, -2},

        ["fell"] = {-14, 1},

        ["sword_jump_down"] = {-19, -5},
        ["sword_jump_settle"] = {-27, 4},
        ["sword_jump_up"] = {-17, 2},

        ["hug_left"] = {-4, -1},
        ["hug_right"] = {-2, -1},

        ["peace"] = {-8, -4},
        ["rude_gesture"] = {0, 0},

        ["reach"] = {-3, -1},

        ["sit"] = {-3, 0},
        ["sneak/left"] = {-4, 3},
        ["sneak/right"] = {-2, 3},

        --["run/left"] = {0, 0}, -- not existing, might be added in the future(?)
        ["run/right"] = {0, 0},  -- I dunno the offsets and neither where to find them in DR code
        --["run/up"] = {0, 0}, -- not existing, might be added in the future(?)
        ["run/down"] = {0, 0},
    }

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {"ohoho", "peace"}

    self.menu_anim = "peace"
end

return actor
