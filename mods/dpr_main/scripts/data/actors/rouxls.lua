local actor, super = Class(Actor, "rouxls")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Rouxls Kaard"

    -- Width and height for this actor, used to determine its center
    self.width = 47
    self.height = 57

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 40, 47, 17}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/rouxls"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "rouxls"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/rouxls"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-8, 0}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
        ["idle"] = 0.2,
        ["lamp"] = 0.2
    }

    -- Table of sprite animations
    self.animations = {}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {}

    self.voice_timer = 0
end

function actor:onWorldUpdate(chara)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onTextSound()
    if self.voice_timer == 0 then
        local snd = Assets.playSound(TableUtils.pick{"voice/rx1_fixed", "voice/rx2_fixed", "voice/rx3_fixed"})
        self.voice_timer = 3
    end
    return true
end


return actor