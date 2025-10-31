local actor, super = Class(Actor, "jackenstein")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Jackenstein"

    -- Width and height for this actor, used to determine its center
    self.width = 27
    self.height = 45

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 25, 19, 14}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "battle/enemies/jackenstein"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "jack"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["idle"] = {"idle", 0.25, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"] = {0, 0},
    }
    self.voice_timer = 0

    self.parts = {
        ["eyes"] = {"eyes"}
    }

    self.disallow_replacement_texture = true
end

function actor:createSprite()
    return JackensteinActor(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end
	
    if anim == "overworld" or anim == "hurt" then
        sprite:setPartVisible(false)
    end
end

function actor:onWorldUpdate(chara)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onBattleUpdate(battler)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onTextSound()
    if self.voice_timer <= 0 then	
        local high_voice = Game:getFlag("jackensteinHighVoice", false)
        local pitchrandom = (0.75 + MathUtils.random(0.5))
        local soundindex = "voice/jack"
		if high_voice then
			soundindex = "voice/jack_high"
		end

        Assets.stopAndPlaySound(soundindex, 1, pitchrandom)

        self.voice_timer = 3
    end
    return true
end

return actor