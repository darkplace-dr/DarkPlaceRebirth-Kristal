local Winglade, super = Class(Actor)

function Winglade:init()
    super.init(self)

    self.name = "Winglade"

    self.width = 61
    self.height = 63

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/winglade"
    self.default = "base"

    self.talk_sprites = {}

    self.animations = {
        ["hurt"] = { "base", 1, false },
        ["transition"] = { "base", 1, false }
    }

    self.offsets = {
        ["base"] = { 0, 0 },
        ["hurt"] = { 0, 0 }
    }

    self.parts = {
        ["eye_pupil"] = { "eye_pupil" },
        ["eye_white"] = { "eye_white" },
        ["eye_pupil_spare"] = { "eye_pupil_spare" },
        ["halo"] = { "halo" },
        ["black"] = { "black" },
        ["top_bit"] = { "top_bit" },
        ["sword"] = { "sword" },
        ["left_wing"] = { "left_wing_animated" },
        ["right_wing"] = { "right_wing_animated" }
    }
end

function Winglade:createSprite()
    return WingladeActorSprite(self)
end

return Winglade