local actor, super = Class(Actor, "sans")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "sans."

    -- Width and height for this actor, used to determine its center
    self.width = 25
    self.height = 32

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 16, 25, 16}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/sans"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.month = tonumber(os.date("%m"))
    self.day = tonumber(os.date("%d"))
    if self.month == 10 and self.day == 31 then
        self.default = "sumpkin"
    else
        self.default = "walk"
    end

    -- Sound to play when this actor speaks (optional)
    self.voice = "sans"

    self.font = "sans"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/sans"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {-3, 0}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        ["shrug"] = {"shrug", 1, true},
    }
    

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["shrug"] = {-3, 0},
        ["icecream_1"] = {-2, 0},
        ["icecream_2"] = {-2, 0},
        ["icecream_3"] = {-2, 0},
        ["icecream_4"] = {-2, 0},
        ["icecream_5"] = {-2, 0},
        ["bike"] = {0, -4},
    }

    self.taunt_sprites = {"shrug", "sleeping", "eyes", "bike", "wink"}

    self.voice_timer = 0
end

function actor:onWorldUpdate(chara)
    self.voice_timer = Utils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onTextSound()
    if self.voice_timer == 0 then
        Assets.stopAndPlaySound("voice/sans")
        self.voice_timer = 2
    end
    return true
end

return actor