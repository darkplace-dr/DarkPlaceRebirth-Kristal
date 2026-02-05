local Shuttah, super = Class(Actor)

function Shuttah:init()
    super.init(self)

    self.name = "Shuttah"

    self.width = 50
    self.height = 68

    self.hitbox = {12, 49, 40, 20}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "enemies/shuttah"

    self.default = "idle"

    self.voice = nil

    self.portrait_path = nil

    self.portrait_offset = nil

    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        ["idle"] = {"idle", 1/3, true},
        ["hurt"] = {"idle_1", 1, true},
        ["pose"] = {"pose", 1/15, false},
        ["posereturn"] = {"pose_return", 1/15, false},
        ["spared"] = {"spare", 1/3, true}
    }

    -- WHY DOES IT NEED THE SPRITE PATH INSTEAD OF THE SPRITE NAME????????
    self.offsets = {
        ["idle"] = {0, 0},
        ["pose"] = {-48, -11},
        ["pose_return"] = {-48, -11},
        ["spare"] = {14, 0}
    }
end

return Shuttah