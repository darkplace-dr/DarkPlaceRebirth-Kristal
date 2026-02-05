local actor, super = Class(Actor, "tenna")

function actor:init()
    super.init(self)

    self.name = "Tenna"

    self.width = 58
    self.height = 135
    
    self.hitbox = {0,135/2, 58,135/2}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "world/npcs/tenna"
    self.default = "point_up"

    self.voice = "tenna"
    self.portrait_path = "face/tenna"
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["point_up"]              = {"point_up", 1, true},
        ["point_up_b"]            = {"point_up_b", 1, true},
        ["point_up_twofingers"]   = {"point_up_twofingers", 1, true},

        ["point_left"]            = {"point_left", 1, true},

        ["point_at_screen"]       = {"point_at_screen", 1, true},
        ["point_at_screen_b"]     = {"point_at_screen_b", 1, true},
        ["point_at_screen_c"]     = {"point_at_screen_c", 1, true},

        ["point_droop"]           = {"point_droop", 1, true},

        ["pose"]                  = {"pose", 1, true},
        ["pose_podium"]           = {"pose_podium", 1, true},
        ["pose_headlowered_nose"] = {"pose_headlowered_nose", 1, true},
        ["laugh_pose"]            = {"laugh_pose", 1, true},
        ["laugh_pose_alt"]        = {"laugh_pose_alt", 1, true},
        ["laugh_pose_segmented"]  = {"", 1, true},

        ["tie_adjust_a"]          = {"tie_adjust_a", 1, true},
        ["tie_adjust_b"]          = {"tie_adjust_b", 1, true},
        ["tie_adjust_c"]          = {"tie_adjust_c", 1, true},

        ["grasp"]                 = {"grasp", 0.175, true},
        ["grasp_anim"]            = {"grasp_anim", 0.175, true},
        ["grasp_anim_b"]          = {"grasp_anim_b", 1/10, true},

        ["dance_cane"]            = {"dance_cane/dance_cane", 1/30, true},
        ["dance_cabbage"]         = {"dance_cabbage/dance_cabbage", 1/30, true},

        ["whisper"]               = {"whisper", 1/30, true},
        ["whisper_blush"]         = {"whisper_blush", 1/30, true},

        ["bow"]                   = {"bow", 1/10, true},
        ["bow_slow"]              = {"bow", 1/4, true},
        ["sad"]                   = {"sad", 1, true},
        ["hooray"]                = {"hooray", 1, true},
        ["twirl"]                 = {"twirl", 1/30, true},
        ["listening"]             = {"listening", 1/30, true},
        ["bulletin"]              = {"bulletin", 1/7, true},
        ["laugh"]                 = {"laugh", 0.125, true},
        ["evil"]                  = {"evil", 1, true},

        --battle animations
        ["idle"]                 = {"", 1, true},
        ["attack"]               = {"battle/attack", 1, true},
        ["hurt"]                 = {"battle/hurt", 1, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        --most offsets should be set up like "{ (width - origin_x) - 28, (height - origin_y) - 17}" for accuracy.
        --unless, of course, the sprite matches the exact dimensions of the actor (i.e; "point_up" & "point_up_b")
        
        ["point_up"]                    = {0, 0},
        ["point_up_b"]                  = {0, 0},
        ["point_up_twofingers"]         = {(58-44)-28, (135-124)-17},

        ["point_left"]                  = {(58-70)-28, (135-96)-17},

        ["point_at_screen"]             = {(58-48)-28, (135-114)-17},
        ["point_at_screen_b"]           = {(58-48)-28, (135-114)-17},
        ["point_at_screen_c"]           = {(58-48)-28, (135-114)-17},

        ["point_droop"]                 = {(58-48)-28, (135-91)-17},

        ["pose"]                        = {(58-35)-28, (135-129)-17},
        ["pose_podium"]                 = {(58-77)-28, (135-137)-17},
        ["pose_headlowered_nose"]       = {(58-54)-28, (135-108)-17},
        ["laugh_pose"]                  = {(58-42)-28, (135-92)-17},
        ["laugh_pose_alt"]              = {(58-56)-28, (135-102)-17},

        ["tie_adjust_a"]                = {(58-19)-28, (135-121)-17},
        ["tie_adjust_b"]                = {(58-21)-28, (135-121)-17},
        ["tie_adjust_c"]                = {(58-21)-28, (135-121)-17},

        ["grasp"]                       = {(58-46)-28, (135-119)-17},
        ["grasp_anim"]                  = {(58-46)-28, (135-119)-17},
        ["grasp_anim_b"]                = {(58-46)-28, (135-119)-17},

        ["dance_cane/dance_cane"]       = {(58-55)-28, (135-132)-17},
        ["dance_cabbage/dance_cabbage"] = {(58-47)-28, (135-133)-17},
        
        ["whisper"]                     = {(58-33)-28, (135-99)-17},
        ["whisper_blush"]               = {(58-33)-28, (135-99)-17},

        ["bow"]                         = {(58-49)-28, (135-131)-17},
        ["sad"]                         = {(58-42)-28, (135-106)-17},
        ["hooray"]                      = {(58-55)-28, (135-103)-17},
        ["twirl"]                       = {(58-35)-28, (135-138)-17},
        ["listening"]                   = {(58-35)-28, (135-106)-17},
        ["bulletin"]                    = {(58-43)-28, (135-113)-17},
        ["laugh"]                       = {(58-76)-28, (135-103)-17},
        ["evil"]                        = {(58-37)-28, (135-107)-17},
        ["frightened"]                  = {(58-29)-28, (135-123)-17},
        
        ["battle/attack"]               = {(58-58)-28, (135-114)-17},
        ["battle/hurt"]                 = {(58-31)-28, (135-113)-17},
    }

    self.disallow_replacement_texture = true
	
    self.voice_timer = 0
end

function actor:createSprite()
    return TennaActor(self)
end

function actor:onSet(sprite)
    super.onSet(sprite)
    
    sprite:resetMesh(sprite)
end

function actor:onSetSprite(sprite)
    super.onSetSprite(sprite)
    
    sprite:resetMesh(sprite)
end

function actor:onSetAnimation(sprite, anim, ...)
    super.onSetAnimation(sprite)
    
    sprite:resetMesh(sprite)
end

function actor:onResetSprite(sprite)
    super.onResetSprite(sprite)
    
    sprite:resetMesh(sprite)
end

function actor:onWorldUpdate(chara)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onBattleUpdate(battler)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onTextSound()
    if self.voice_timer == 0 then
        local rand = MathUtils.random(0, 8, 1) + 1
	
        local serious_voice = Game:getFlag("tennaSeriousVoice", 1)
        local pitchrandom = (0.86 + MathUtils.random(0.35)) * serious_voice
        local soundindex = "voice/tenna/tv_voice_short_"..rand

        Assets.stopAndPlaySound(soundindex, 0.7, pitchrandom)

        self.voice_timer = 3
    end
    return true
end

return actor