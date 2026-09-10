local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Wicabel"

    self.width = 42
    self.height = 60

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/wicabel"
    self.default = "body_1"

    self.talk_sprites = {}

    self.animations = {
        ["hurt"]   = {"body_1", 1, true},
        ["spared"] = {"spare", 1, true},
        ["transition"] = {"body_1", 1, true}
    }

    self.offsets = {
        ["body"] = {1.5, 0},
        ["spare"] = {1.5, 0}
    }

    self.parts = {
        ["head"] = {"body_2"},
        ["chest"] = {"body_3"},
        ["leftarm"] = {"body_4"},
        ["rightarm"] = {"body_5"},
        ["skirt"] = {"body_6"},
        ["leg"] = {"body_7"}
    }
end

function actor:createSprite()
    return WicabelActorSprite(self)
end

return actor