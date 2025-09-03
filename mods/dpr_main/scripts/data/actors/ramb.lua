local Ramb, super = Class(Actor, "ramb")

function Ramb:init()
    super.init(self)

    self.name = "Ramb"

    self.width = 25
    self.height = 32

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "world/npcs/ramb"
    self.default = "idle"

    self.parts = {
        ["body"]                 = {"body"},
        ["body_clean"]           = {"body_clean"},

        ["head_annoyed"]         = {"head_annoyed"},
        ["head_happy"]           = {"head_happy"},
        ["head_happy_nostalgic"] = {"head_happy_nostalgic"},
        ["head_nostalgic"]       = {"head_nostalgic"},
        ["head_surprised"]       = {"head_surprised"},
        ["head_turn"]            = {"head_turn"},
        ["head_turn_look"]       = {"head_turn_look"},
        ["head_turn_look_side"]  = {"head_turn_look_side"},
        ["head_turn_subtle"]     = {"head_turn_subtle"},
        ["head_turned"]          = {"head_turned"}
    }

    self.animations = {}

    self.offsets = {}
end

function Ramb:createSprite()
    return RambActor(self)
end

function Ramb:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end
end

return Ramb