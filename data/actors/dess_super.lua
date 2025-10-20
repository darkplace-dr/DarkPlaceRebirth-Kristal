local actor, super = Class(Actor, "dess_super")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Super Dess"

    -- Width and height for this actor, used to determine its center
    self.width = 23
    self.height = 46

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {2, 33, 18, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/dess/super"
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

		["battle/transition"]    = {"battle/transition", 1/15, false},
        ["battle/intro"]   		 = {"battle/intro", 1/15, false},
        ["battle/victory"]       = {"battle/victory", 1/10, false},

		["battle/snap"]          = {"battle/snap", 2/30, false, next="battle/idle"},
		["battle/spellsuper"]    = {"battle/spellsuper", 2/30, false, next="battle/spellsuperend"},
		["battle/spellsuperend"] = {"battle/spellsuperend", 2/30, true},

        -- Cutscene animations
        --["laugh"]               = {"laugh", 4/30, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/down"] = {-4, 0},
        ["walk/right"] = {-4, 0},
        ["walk/left"] = {-4, 0},
        ["walk/up"] = {-4, 0},

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
        ["battle/spellsuper"] = {-19, 0},
        ["battle/spellsuperend"] = {-18, 0},
    }

	self.shiny_id = "dess"
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)

    sprite.flame = Assets.getFrames("effects/aura")
    sprite.flameframe = 0

    sprite.flame1alpha = 0
    sprite.flame2alpha = 0
    sprite.flamecontimer = 0
    sprite.specialcontimer = 0
end

function actor:preSpriteDraw(sprite)
    super.preSpriteDraw(sprite)

    sprite.flamecontimer = sprite.flamecontimer + DTMULT
    sprite.specialcontimer = sprite.specialcontimer + DTMULT

    sprite.flameframe = ((sprite.specialcontimer / 4) % 2)

    sprite.flame1alpha = sprite.flamecontimer / 15
    sprite.flame2alpha = sprite.specialcontimer / 15

    if sprite.flame2alpha >= 0.9 then
        sprite.flame2alpha = 0.9
    end
    if sprite.specialcontimer >= 15 then
        sprite.flame2alpha = (1 - (sprite.specialcontimer / 60))
        if sprite.flame2alpha < 0 then
            sprite.flame2alpha = 0
        end
    end
    if sprite.specialcontimer >= 60 then
        sprite.specialcontimer = 12
    end

    love.graphics.setColor(1, 1, 0, (1.4 + math.abs((math.sin((sprite.flamecontimer / 4)) / 2)))/2)
    if not Game.battle or Game.battle and sprite.anim == "walk/right" then
        Draw.draw(sprite.flame[1], 23/2, 46, 0, -1/2, (1.2 + math.abs((math.sin((sprite.specialcontimer / 4)) / 2)))/2, 99/2 + 10, 90)
    else
        Draw.draw(sprite.flame[1], 23/2 + 10, 46, 0, -1/2, (1.2 + math.abs((math.sin((sprite.specialcontimer / 4)) / 2)))/2, 99/2 + 10, 90)
    end
    love.graphics.setColor(0.5, 0.5, 0, (sprite.flame2alpha / 1.4))
    if not Game.battle or Game.battle and sprite.anim == "walk/right" then
        Draw.draw(sprite.flame[2], 23/2, 46, 0, -1/2, 1.4/2, 99/2 + 10, 90)
    else
        Draw.draw(sprite.flame[2], 23/2 + 10, 46, 0, -1/2, 1.4/2, 99/2 + 10, 90)
    end
end

return actor
