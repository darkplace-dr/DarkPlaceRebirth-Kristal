local Winglade, super = Class(Actor)

function Winglade:init()
    super.init(self)

    self.name = "Winglade"

    self.width = 54
    self.height = 58
    self.flip = nil

    self.path = "enemies/winglade"

    self.default = "idle"

    self.voice = nil

    self.portrait_path = nil

    self.portrait_offset = nil

    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        ["hurt"] = {"hurt"},
    }

    self.offsets = {
        ["hurt"] = {0, 0},
    }

    self.parts = {
        ["eye_pupil"] = {"eye_pupil"},
        ["eye_white"] = {"eye_white"},
        ["eye_white_spare"] = {"eye_white_spare"},
        ["halo"] = {"halo"},
        ["black"] = {"black"},
        ["horn"] = {"horn"},
        ["sword"] = {"sword"},
        ["left_wing"] = {"left_wing_animated/left_wing"},
        ["right_wing"] = {"right_wing_animated/right_wing"}
    }
end

function Winglade:createSprite()
    return WingladeActorSprite(self)
end

function Winglade:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end
    -- if anim == 'idle' then
    --     -- Kristal.Console:log('ok bro')
    -- end
    -- For some reason you don't need to set the visibility back to true?????????
    -- I'm so confused
    if anim == 'hurt' then
        sprite:setPartVisible(false)
    end
end

return Winglade