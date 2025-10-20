local Shuttah, super = Class(Actor)

function Shuttah:init()
    super.init(self)

    self.name = "Shuttah"

    self.width = 45
    self.height = 67

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
        ["idle"] = {"idle/idle", 1/3, true},
        ["pose"] = {"pose/pose", 1/15, false},
        ["posereturn"] = {"pose_return/pose_return", 1/15, false},
        ["sharpshoot"] = {"sharpshoot/sharpshoot", 1/3, true},
        ["spared"] = {"spare/spare", 1/3, true}
    }
    
    -- WHY DOES IT NEED THE SPRITE PATH INSTEAD OF THE SPRITE NAME????????
    self.offsets = {
        ["idle/idle"] = {0, 0},
        ["pose/pose"] = {-48, -11},
        ["pose_return/pose_return"] = {-48, -11},
        ["sharpshoot/sharpshoot"] = {0, 12},
        ["spare/spare"] = {14, 0}
    }
end

return Shuttah